package com.sinosoft.midplat.citicHZ.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Calendar;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.citicHZ.CiticHZConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class CiticHzMakeLoanBlc extends Balance {
	public CiticHzMakeLoanBlc() {
		super(CiticHZConf.newInstance(), "1182");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);
		Calendar mCalendar = Calendar.getInstance();
	    mCalendar.setTime(cTranDate);
	    mCalendar.add(Calendar.DATE,-1);
	    mHead.getChild("TranDate").setText(DateUtil.getDateStr(mCalendar.getTime(), "yyyyMMdd"));

		return mHead;
	}
	/**
	 *	�����ļ���������������д+����+�ļ���׺;<BR>
	 *	����������д+����+�ļ���׺; ���磺ABBXJKYYYYMMDD.txt
	 */
	protected String getFileName() {
		Calendar mCalendar = Calendar.getInstance();
        mCalendar.setTime(cTranDate);
        mCalendar.add(Calendar.DATE,-1);
		return "ABBXJK"+DateUtil.getDateStr(mCalendar.getTime(), "yyyyMMdd")+".txt";
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into CiticBusiBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		long mSumPrem = 0;
		int mCount = 0;
		long bankSumPrem = 0;
		int bankCount = 0;
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		String tLineMsgFirst = mBufReader.readLine();//��ȡ����
		if(tLineMsgFirst != null && !"".equals(tLineMsgFirst.trim())){
			String[] tSubMsgs = tLineMsgFirst.split("\\|", -1);
			bankCount = Integer.parseInt(tSubMsgs[0]);//���ж��˱�������ܱ���
			bankSumPrem = NumberUtil.yuanToFen(tSubMsgs[1]);// ���ж��˱�������ܽ��
		}
		
		Element mBodyEle = new Element(Body);
		Element pubContInfo = new Element("PubContInfo");
		Element edorFlag = new Element("EdorFlag");
		edorFlag.setText("8");
		Element ctBlcType = new Element("CTBlcType");
		ctBlcType.setText("0");
		Element wtBlcType = new Element("WTBlcType");
		wtBlcType.setText("0");
		Element mqBlcType = new Element("MQBlcType");
		mqBlcType.setText("0");
		Element xqBlcType = new Element("XQBlcType");
		xqBlcType.setText("0");
		Element caBlcType = new Element("CABlcType");
		caBlcType.setText("0");
		Element zlBlcType = new Element("ZLBlcType");
		zlBlcType.setText("1");
		pubContInfo.addContent(edorFlag);
		pubContInfo.addContent(ctBlcType);
		pubContInfo.addContent(wtBlcType);
		pubContInfo.addContent(mqBlcType);
		pubContInfo.addContent(xqBlcType);
		pubContInfo.addContent(caBlcType);
		pubContInfo.addContent(zlBlcType);
		mBodyEle.addContent(pubContInfo);
		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			// ���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			Element tranNo = new Element("TranNo");
			tranNo.setText(tSubMsgs[0]);
			Element bankCode = new Element("BankCode");
			bankCode.setText("");
			//��ȫ���ͣ��˴���Ҫ�����Э��
			Element edorType = new Element("EdorType");
			edorType.setText("ZL");
			Element edorAppNo = new Element("EdorAppNo");
			Element edorNo = new Element("EdorNo");
			Element edorAppDate = new Element("EdorAppDate");
			edorAppDate.setText(tSubMsgs[2].replaceAll("-",""));
			Element riskCode = new Element("RiskCode");
			Element tranMoney = new Element("TranMoney");
			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[3]);
			tranMoney.setText(String.valueOf(tPremFen));
			Element accNo = new Element("AccNo");
			Element accName = new Element("AccName");
			Element rCode = new Element("RCode");
			rCode.setText("0");
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[1]);

			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tranNo);
			tDetailEle.addContent(bankCode);
			tDetailEle.addContent(edorType);
			tDetailEle.addContent(edorAppNo);	
			tDetailEle.addContent(edorNo);
			tDetailEle.addContent(edorAppDate);
			tDetailEle.addContent(riskCode);
			tDetailEle.addContent(tranMoney);
			tDetailEle.addContent(accNo);
			tDetailEle.addContent(accName);
			tDetailEle.addContent(rCode);
			tDetailEle.addContent(tContNoEle);

			mBodyEle.addContent(tDetailEle);
			
			mCount = mCount + 1;
			mSumPrem += tPremFen;
		}
		
		mBufReader.close();	//�ر���
		
		cLogger.info("Out CiticBusiBlc.parse()!");

		if(bankCount!=mCount || bankSumPrem!=mSumPrem){
			cLogger.info("���д��ݶ����ļ������ܱ�������ϸ������һ��!");
			throw new MidplatException("���д��ݶ����ļ������ܱ�������ϸ������һ��!"); 
		}
		
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.citic.bat.CiticBusiBlc.main");
		mLogger.info("����ʼ...");
		
		CiticHzMakeLoanBlc mBatch = new CiticHzMakeLoanBlc();
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
		
		mLogger.info("�ɹ�������");
	}
	
	
}
