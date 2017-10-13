package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class CardCheck extends XmlSimpFormat {
	public CardCheck(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CardCheck.noStd2Std()...");
		
		Document mStdXml = 
			CardCheckInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out CardCheck.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CardCheck.std2NoStd()...");
		
		Element mTransactionEle = new Element("Transaction");
		mTransactionEle.addContent(pStdXml.getRootElement().getChild(Head).detach());
		
		cLogger.info("Out CardCheck.std2NoStd()!");
		return new Document(mTransactionEle);
	}
}
