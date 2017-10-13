package com.sinosoft.midplat.hbyh.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.hbyh.HbyhConf;


public class HbyhBusiBlc extends Balance {

	public HbyhBusiBlc() {
		super(HbyhConf.newInstance(), "3104");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	
	/**
	 *�����ļ�����HEBB+����+01.txt�����磺HEBB2015030101.txt��
	 *���ں�����λ�̶�Ϊ"01"�����µ��������͡�
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return  mBankEle.getAttributeValue(id)
		        + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.txt";
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into HbyhBusiBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null == mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mPremEle);
		
		long mSumPrem = 0;
		int mCount = 0;
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			
			cLogger.info(tLineMsg);
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			/*
			 * ���б�ţ�����16�����������ڣ�YYYYMMDD���������ţ�5λ��������ţ�5λ�������ʽ����루�̶�0001��+�µ��б�������ˮ�ţ�20λ���������ţ�20λ������12λ����С���㣬��ԪΪ��λ��2λС����������������2λ��
			 * ���磺16|20121201|00200|00082|0001|41128299|130000045001|50000.00|01|
			 * ע�ͣ�
			 * ��1��	ÿ���ֶ�ͨ����|�����зָ�����������ݿ��ļ���ʽ�����ݸ�ʽ��������ͨ���ָ����ָ
			 * ��2��	ÿ�н����лس�����unix������
			 * ��3��	Ͷ�������ļ��������ֵ��01�������������棩��02�����������������ֻ����У���06���������ģ���
			 * ��4��	ֻ���ɳɹ��Ľ�����ϸ��
			 */
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			Element tTranDateEle = new Element(TranDate);
			tTranDateEle.setText(tSubMsgs[1]);
			
			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[2] + tSubMsgs[3]);
			
			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[5]);
			
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);
			
			Element tPremEle = new Element(Prem);
//			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
//			tPremEle.setText(String.valueOf(tPremFen));
			//�������ȷ�ϸ����֡�
			long tPremFen = Long.parseLong(tSubMsgs[7]);
			tPremEle.setText(tSubMsgs[7]);

			//�ӱ�����Ŀǰֻ�й���
			Element tSourTypeEle = new Element("SourceType");
			tSourTypeEle.setText("0");
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);
			tDetailEle.addContent(tSourTypeEle);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			mSumPrem += tPremFen;
			JdomUtil.print(tDetailEle);//��ӡÿ��Detail
		}
		
		mCountEle.setText(String.valueOf(mCount));
		mPremEle.setText(String.valueOf(mSumPrem));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out HbyhBusiBlc.parse()!");
		return mBodyEle;
	}

}