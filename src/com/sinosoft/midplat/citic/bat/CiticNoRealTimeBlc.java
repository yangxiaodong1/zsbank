package com.sinosoft.midplat.citic.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.citic.CiticConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.citic.bat.CiticNoRealTimeBlc.java
 * @Description: �����������շ�ʵʱ���Ķ���
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date May 29, 2014 11:18:10 AM
 * @version 
 *
 */
public class CiticNoRealTimeBlc extends Balance {
	
	public CiticNoRealTimeBlc() {
		super(CiticConf.newInstance(), "1106");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	
	/** 
	 * 1��CITIC+���չ�˾����+FSS+8λ���ڣ�yyyymmdd��+REQ.txt
	 * 2���������ٴ��룺161
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("CITIC").append(mBankEle.getAttributeValue("insu"))
				.append("FSS").append(DateUtil.getDateStr(cTranDate, "yyyyMMdd")).append("REQ.txt");
		return strBuff.toString();
	}
	
	/**
	 * ���������ļ�����֯��XML�������ڷ���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into " + this.getClass().getName() + ".parse()...");

		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		
		mBodyEle.addContent(mCountEle);
		int mCount = 0;
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			Element tDetailEle = lineToNode(tLineMsg);
			mBodyEle.addContent(tDetailEle);
			mCount++;
		}
		mCountEle.setText(String.valueOf(mCount));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out " + this.getClass().getName() + ".parse()!");
		return mBodyEle;
	 }
	
	/**
     * �������ļ���ÿ������ת��Ϊ�����е�һ��XML�ڵ�
     * 
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[1]);
		
		Element tNodeNoEle = new Element(NodeNo);
		tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);
		
		Element tTranNoEle = new Element(TranNo);
		tTranNoEle.setText(tSubMsgs[5]);
		
		Element tProposalPrtNoEle = new Element(ProposalPrtNo);
		tProposalPrtNoEle.setText(tSubMsgs[6]);

		Element tAccNoEle = new Element(AccNo);
		tAccNoEle.setText(tSubMsgs[13]);
		
		Element tAppntNameEle = new Element("AppntName");
		tAppntNameEle.setText(tSubMsgs[9]);
		
		/*
		 * ���з�Ͷ����֤�����ͣ�0���֤��1���ա�2����֤��3ʿ��֤��4����֤��5��ʱ���֤��6���ڱ���7 ������8�ٶ�֤��9����֤��
		 */
		Element tAppntIDTypeEle = new Element("AppntIDType");
		tAppntIDTypeEle.setText(idTypeToPGI(tSubMsgs[10]));
		
		Element tAppntIDNoEle = new Element("AppntIDNo");
		tAppntIDNoEle.setText(tSubMsgs[11]);

		/*
		 * Ŀǰ��������ֻ�й������
		 * ����������0���桢1������2������3����Ӫ����4ȫ����5�ֻ����С�
		 * ���sourcetype=0--����,sourcetype=1--����
		 */
		Element tSourTypeEle = new Element("SourceType");
		tSourTypeEle.setText(tSubMsgs[7]);
		
		Element tDetailEle = new Element(Detail);
		tDetailEle.addContent(tTranDateEle);
		tDetailEle.addContent(tNodeNoEle);
		tDetailEle.addContent(tTranNoEle);
		tDetailEle.addContent(tProposalPrtNoEle);
		tDetailEle.addContent(tAccNoEle);
		tDetailEle.addContent(tAppntNameEle);
		tDetailEle.addContent(tAppntIDTypeEle);
		tDetailEle.addContent(tAppntIDNoEle);
		tDetailEle.addContent(tSourTypeEle);
		
		return tDetailEle;
	}
	
	/**
	 * ���е����֤�����Ͷ�Ӧ������
	 * ���֤����תΪ����
	 * ���з�Ͷ����֤�����ͣ�0�������֤���롢1����֤��8(�۰�)����֤��ͨ��֤��a������b���ڲ���I����
	 * 					      
	 * @param idType ���е����֤����
	 * @return 		 �������֤����
	 */
	private String idTypeToPGI(String idType){
		if ("0".equals(idType)) {
		    //���֤
		    return "0";
		}else if("1".equals(idType)) {
		    //����֤
		    return "2";
		}else if("I".equals(idType)) {
		    //����
		    return "1";
		}else if("b".equals(idType)) {
		    //���ڱ�
		    return "5";
		}else{
		    //����
		    return "8";
		}		    

	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CiticNoRealTimeBlc blc = new CiticNoRealTimeBlc();
		blc.run();
	}
	
}
