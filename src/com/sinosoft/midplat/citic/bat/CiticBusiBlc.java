package com.sinosoft.midplat.citic.bat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.citic.CiticConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

/**
 * @Title: com.sinosoft.midplat.citic.bat.CiticBusiBlc.java
 * @Description: ���������µ��ս����
 * Copyright: Copyright (c) 2013 
 * Company:�����IT��
 * 
 * @date Aug 19, 2013 8:18:55 PM
 * @version 
 *
 */
public class CiticBusiBlc extends Balance {
	public CiticBusiBlc() {
		super(CiticConf.newInstance(), "1105");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	/**
	 *	�����ļ���������������д+����+�ļ���׺;<BR>
	 *	ABRS+YYYYMMDD+.DZ; ���磺ABRS20130819.DZ 
	 */
	protected String getFileName() {
		
		return "ABRS"+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+".DZ";
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into CiticBusiBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
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
		long bankSumPrem = 0;
		int bankCount = 0;
		boolean readFirst = true;	
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			if(readFirst){	// ֻ�����л�����Ϣ
				bankCount = Integer.parseInt(tSubMsgs[0]);	// ���ж��˱�������ܼ���
				bankSumPrem = NumberUtil.yuanToFen(tSubMsgs[1]);	// ���ж��˱�������ܱ���
				readFirst = false;
				continue;
			}
			
			Element tTranDateEle = new Element(TranDate);
			
			String strDate = DateUtil.date10to8(tSubMsgs[0]);	// �����ڸ�ʽת��yyyy-MM-dd(yyyy/MM/dd, yyyy.MM.dd) --> yyyyMMdd
			tTranDateEle.setText(strDate);
			
			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[3]+tSubMsgs[4]);
			
			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[2]);
			
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);
			
			
			Element tPremEle = new Element(Prem);
			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
			tPremEle.setText(String.valueOf(tPremFen));

			/*Element tSourTypeEle = new Element("SourceType");
			if("01".equals(tSubMsgs[8])){
			    //����
			    tSourTypeEle.setText("0");
			}else{
			    //����
			    tSourTypeEle.setText("1");
			}*/
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);
//			tDetailEle.addContent(tSourTypeEle);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			mSumPrem += tPremFen;
			JdomUtil.print(tDetailEle);//��ӡÿ��Detail
		}
		mCountEle.setText(String.valueOf(bankCount));
		mPremEle.setText(String.valueOf(bankSumPrem));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out CiticBusiBlc.parse()!");
		
		if(bankCount!=mCount || bankSumPrem!=mSumPrem){
			cLogger.info("���д��ݱ����������󣬻��ܱ����������߱�����������!");
		}
		
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.citic.bat.CiticBusiBlc.main");
		mLogger.info("����ʼ...");
		
		CiticBusiBlc mBatch = new CiticBusiBlc();
		//���ڲ����ˣ����ò���������
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);
			
			/**
			 * �ϸ�����У���������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
			 * 4λ��-2λ��-2λ�ա�
			 * 4λ�꣺4λ[0-9]�����֡�
			 * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
			 * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
			 * 
			 * ������У���������ʽ��\\d{4}\\d{2}\\d{2}��
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				System.out.println(args[0]);
				mBatch.setDate("-------------"+args[0]);
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}
		
		mBatch.run();
//		String f = mBatch.getFileName();
//		File file = new File("D:/work/YBT/CITIC(��������)/test file/dz/"+"ABRS20130819.dz");
//		InputStream in = new FileInputStream(file);
//		Element domEle = mBatch.parse(in);
//		JdomUtil.print(domEle);
		
		mLogger.info("�ɹ�������");
	}
	
	
}
