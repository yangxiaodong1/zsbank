package com.sinosoft.midplat.bcomm.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.bcomm.BcommConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.bcomm.bat.BcommBusiBlc.java
 * @Description: ���ն��˽���
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Feb 8, 2014 2:30:36 PM
 * @version 
 *
 */
public class BcommBusiBlc extends Balance {

	public BcommBusiBlc() {
		super(BcommConf.newInstance(), 1406);	// FunFlag=1406-���ն���
	}

	protected Element getHead() {
		
        Element mHead = super.getHead();

        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);

        return mHead;
    }
	
	/* 
	 * FIXME ��ȷ�Ϻ��������ȷ�ϡ����з��кš��͡����չ�˾���롱
	 */
	protected String getFileName() {
		/**
		 * �ܶ��ܶ��ˣ��ļ���������: ���з��кţ�6λ����_�����չ�˾���루10λ����_��YYYYMMDD��8λ����
		 */
		Element mBankEle = cThisConfRoot.getChild("bank");

		return mBankEle.getAttributeValue("id") + "_" + mBankEle.getAttributeValue("insu") + "_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd");
	}
	
	/* 
	 * �����ж˷��ͷǱ�׼�����ļ�ת��Ϊ���Ķ˱�׼�����ļ�
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into BcommBusiBlc.parse()...");
		
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
		
		long mSumPrem = 0;	// �ܱ���--��ϸ��¼��ı����ۼ�ֵ
		int mCount = 0;	// �ܷ���--��ϸ��¼��ļ����ۼ�ֵ
		long bankInsuSumPrem = 0;	// �ܳб�����
		int bankInsuCount = 0;	// �ܳб����
		boolean readFirst = true;	
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info("��ȡ�����ļ���һ�����ݣ�" + tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			
			if(readFirst){	// ֻ�����л�����Ϣ
				/*
				 * �ַ��Ͳ���������Ҳ��ո񣻱��������Ҷ�����0���������Ҷ�����0���Է�Ϊ��λ��û��С����
				 * 
				 * ���л�����Ϣ��ʽ��
				 * ���д���(�ַ�10λ����ͨ���й̶�Ϊ��10����������Ҳ��ո�)
				 * +���з��д���(�ַ�10λ,������Ҳ��ո�)
				 * +���շֹ�˾����(�ַ�10λ,������Ҳ��ո�)
				 * +��������(�ַ�8λ��YYYYMMDD)
				 * +����ʱ��(�ַ�6λ��HHMMSS)
				 * +��ǰ��������(�ַ�8λ��YYYYMMDD)
				 * +�ܳб�����(����10λ���Ҷ�����0)
				 * +�ܳб����(����15λ���Ҷ�����0�Է�Ϊ��λ����С��)
				 * +�ܳ�������(����10λ���Ҷ�����0)
				 * +�ܳ������(����15λ���Ҷ�����0�Է�Ϊ��λ����С��)
				 * 
				 */
				bankInsuCount = Integer.parseInt(tLineMsg.substring(52, 62));	// �ܳб�����
				bankInsuSumPrem = Long.parseLong(tLineMsg.substring(62, 77));	// �ܳб����
				readFirst = false;
				continue;
			}else{	// ��ȡһ��������ϸ��¼(�����м�¼)
				
				/*
				 * ��������	Char(8)	�ǿ�	YYYYMMDD
				 * ����ʱ��	Char(6)	�ǿ�	HHMMSS
				 * ������ˮ��	Char(20)	�ǿ�	������Ҳ��ո�
				 * ���׽��	Dec(15,0)	�ǿ�	�Ҷ�����0,�Է�Ϊ��λ����С��
				 * ����״̬	Char(1)	�ǿ�	0-����,1-����/����
				 * Ͷ��������	Char(20)	�ǿ�	������Ҳ��ո�
				 */
				// ����״̬��0-������1-����/����
				String flag = tLineMsg.substring(49,50).trim();
				if("0".equals(flag)){	// 0=�����б��ı���

					// ��������
					Element tTranDateEle = new Element(TranDate);
					tTranDateEle.setText(tLineMsg.substring(0, 8).trim());
					
					// ������ˮ��
					Element tTranNoEle = new Element(TranNo);
					tTranNoEle.setText(tLineMsg.substring(14, 34).trim());
					
					// ����
					Element tPremEle = new Element(Prem);
					String tPremFen = String.valueOf(Integer.parseInt(tLineMsg.substring(34, 49).trim()));
					tPremEle.setText(tPremFen);
					
					// ������
					Element tNodeNoEle = new Element(NodeNo);
					
					// ��ͬ��
					Element tContNoEle = new Element(ContNo);
					
					// ����ݴ��ݵ���ˮ�Ż�ȡ������������룬�ӳɹ��ĳб���¼(funcflag=1)�в�ѯ
					String sqlStr = "select NodeNo, contno from TranLog where TranCom='"
							+ cThisConfRoot.getChildText(TranCom)
							+ "' and TranNo='"
							+ tTranNoEle.getTextTrim()
							+ "' and TranDate="
							+ tTranDateEle.getTextTrim() 
							+ " and Rcode=0 ";
					SSRS results = new ExeSQL().execSQL(sqlStr);
					if (results.MaxRow != 1) {
						cLogger.error("���ж��ˣ���ѯ������־ʧ�ܣ���ˮ��[" + tTranNoEle.getTextTrim() + "]");
					} else {
						
						tNodeNoEle.setText(results.GetText(1, 1));
						tContNoEle.setText(results.GetText(1, 2));
					}
					
					Element tDetailEle = new Element(Detail);
					tDetailEle.addContent(tTranDateEle);
					tDetailEle.addContent(tNodeNoEle);
					tDetailEle.addContent(tTranNoEle);
					tDetailEle.addContent(tContNoEle);
					tDetailEle.addContent(tPremEle);
					
					mCount++;
					mSumPrem += Long.parseLong(tPremFen);
					JdomUtil.print(tDetailEle);//��ӡÿ��Detail
					mBodyEle.addContent(tDetailEle);
				}
				
			}
			
		}
		mCountEle.setText(String.valueOf(bankInsuCount));
		mPremEle.setText(String.valueOf(bankInsuSumPrem));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out BcommBusiBlc.parse()!");
		
		if(bankInsuCount!=mCount || bankInsuSumPrem!=mSumPrem){
			cLogger.info("���д��ݱ����������󣬻��ܱ����������߱�����������!");
		}
		
		return mBodyEle;
	}
	
	
	public static void main(String[] args){
		String tLineMsg = "10        11        111       201402262020202014022600000000020000000020000000000000003000000005000000";
		
		int bankInsuCount = Integer.parseInt(tLineMsg.substring(52, 62));	// �ܳб�����
		int bankInsuSumPrem = Integer.parseInt(tLineMsg.substring(62, 77));	// �ܳб����
		
		BcommBusiBlc mBatch = new BcommBusiBlc();
		mBatch.run();
		
	}
	
}



