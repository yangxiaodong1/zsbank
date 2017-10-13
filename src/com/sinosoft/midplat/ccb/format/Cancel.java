package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;

public class Cancel extends XmlSimpFormat {
	public Cancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Cancel.noStd2Std()...");
		
		Document mStdXml = 
			CancelInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//建行传ContNo，我方从Cont中查出ProposalPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from Cont where Type=0 and ContNo='" + mBodyEle.getChildText(ContNo) + "'";
		mBodyEle.getChild(ProposalPrtNo).setText(new ExeSQL().getOneValue(mSqlStr));
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = 
			CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}