package com.sinosoft.midplat.cmb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.cmb.format.CancelForNetBank.java
 * @Description: 招行网银当日侧单交易
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Nov 20, 2014 10:15:45 AM
 * @version 
 *
 */
public class CancelForNetBank extends XmlSimpFormat {
	
	public CancelForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	} 
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into CancelForNetBank.noStd2Std()...");
		 
		Document mStdXml = CancelForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		Element BodyEle = mStdXml.getRootElement().getChild(Body);
		Element headEle = mStdXml.getRootElement().getChild(Head);
		Element mProposalPrtNoEle = BodyEle.getChild(ProposalPrtNo);
        String mContNo = BodyEle.getChildText(ContNo);
		
        // 根据保单号找到对应的投保单号，单证号
        StringBuffer mSqlStr = new StringBuffer();
        mSqlStr.append("select otherno, proposalprtno from TranLog ");
        mSqlStr.append(" where Rcode = 0 and Funcflag = 1013");
        mSqlStr.append("   and contno = '" + mContNo + "'");
        mSqlStr.append("   and trancom = " + headEle.getChildText(TranCom));
        mSqlStr.append("   and Makedate =" + DateUtil.getCur8Date());
        mSqlStr.append(" order by Maketime desc");
        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(mSqlStr.toString());
        if (ssrs.MaxRow > 0) {
        	
            mProposalPrtNoEle.setText(ssrs.GetText(1, 2));
        }
	        
        cLogger.info("Out CancelForNetBank.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CancelForNetBank.std2NoStd()...");
		
		Document mNoStdXml = CancelForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out CancelForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
}
