package com.sinosoft.midplat.citic.format;


import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;

/**
 * @Title: com.sinosoft.midplat.citic.format.Cancel.java
 * @Description: �������е��ճ���ȷ��
 * Copyright: Copyright (c) 2013 
 * Company:�����IT��
 * 
 * @date Aug 15, 2013 5:09:21 PM
 * @version 
 *
 */
public class Cancel extends XmlSimpFormat {

	/**
	 * ��������
	 */
	private String mContNo;
	
	/**
	 * �˱����
	 */
	private String mPrem;
	
	public Cancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/*
	 * ����-->����ͨ
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into Cancel.noStd2Std()...");
		
		Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);
		
		mContNo = "";
		mPrem = "";
		
		//���д�ContNo���ҷ���Cont�в��ProposalPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from Cont where Type=0 and ContNo='" + mBodyEle.getChildText(ContNo) + "'";
		mBodyEle.getChild(ProposalPrtNo).setText(new ExeSQL().getOneValue(mSqlStr));

		mContNo = mBodyEle.getChildText(ContNo);
		mPrem = mBodyEle.getChildText(Prem);
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * ����ͨ-->����
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		Element mBodyEle = mNoStdXml.getRootElement().getChild("Transaction_Body");
		
		Element mPbInsuSlipNoEle = new Element("PbInsuSlipNo");	// ��������
		mPbInsuSlipNoEle.setText(mContNo);
		
		Element mLiLoanValueEle = new Element("LiLoanValue");	// �˱����
		mLiLoanValueEle.setText(mPrem);
		
		mBodyEle.addContent(mPbInsuSlipNoEle);
		mBodyEle.addContent(mLiLoanValueEle);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
	
}


