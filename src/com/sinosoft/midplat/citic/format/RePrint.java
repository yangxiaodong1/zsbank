package com.sinosoft.midplat.citic.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;

/**
 * @Title: com.sinosoft.midplat.citic.format.RePrint.java
 * @Description: 中信银行保单重打
 * Copyright: Copyright (c) 2013 
 * Company:安邦保险IT部
 * 
 * @date Aug 16, 2013 1:31:15 PM
 * @version 
 *
 */
public class RePrint extends XmlSimpFormat {

	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		
		Document mStdXml =RePrintInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//建行传ContNo，我方从Cont中查出ProposalPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from Cont where Type=0 and ContNo='" + mBodyEle.getChildText(ContNo) + "'";
		mBodyEle.getChild(ProposalPrtNo).setText(new ExeSQL().getOneValue(mSqlStr));
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//重打和新单返回报文基本完全一样，所以直接调用
		ContConfirm mContConfirm = new ContConfirm(cThisBusiConf);
		Document mNoStdXml = mContConfirm.std2NoStd(pStdXml);
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}

}
