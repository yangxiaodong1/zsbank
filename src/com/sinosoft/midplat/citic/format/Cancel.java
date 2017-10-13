package com.sinosoft.midplat.citic.format;


import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;

/**
 * @Title: com.sinosoft.midplat.citic.format.Cancel.java
 * @Description: 中信银行单日撤单确认
 * Copyright: Copyright (c) 2013 
 * Company:安邦保险IT部
 * 
 * @date Aug 15, 2013 5:09:21 PM
 * @version 
 *
 */
public class Cancel extends XmlSimpFormat {

	/**
	 * 保单号码
	 */
	private String mContNo;
	
	/**
	 * 退保金额
	 */
	private String mPrem;
	
	public Cancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/*
	 * 银行-->银保通
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into Cancel.noStd2Std()...");
		
		Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);
		
		mContNo = "";
		mPrem = "";
		
		//建行传ContNo，我方从Cont中查出ProposalPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from Cont where Type=0 and ContNo='" + mBodyEle.getChildText(ContNo) + "'";
		mBodyEle.getChild(ProposalPrtNo).setText(new ExeSQL().getOneValue(mSqlStr));

		mContNo = mBodyEle.getChildText(ContNo);
		mPrem = mBodyEle.getChildText(Prem);
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * 银保通-->银行
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		Element mBodyEle = mNoStdXml.getRootElement().getChild("Transaction_Body");
		
		Element mPbInsuSlipNoEle = new Element("PbInsuSlipNo");	// 保单号码
		mPbInsuSlipNoEle.setText(mContNo);
		
		Element mLiLoanValueEle = new Element("LiLoanValue");	// 退保金额
		mLiLoanValueEle.setText(mPrem);
		
		mBodyEle.addContent(mPbInsuSlipNoEle);
		mBodyEle.addContent(mLiLoanValueEle);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
	
}


