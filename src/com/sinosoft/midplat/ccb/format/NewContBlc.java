package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContBlc extends XmlSimpFormat {
	public NewContBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContBlc.noStd2Std()...");
		
		Document mStdXml = 
			NewContBlcInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out NewContBlc.noStd2Std()!");
		return mStdXml;
	}
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContBlc.std2NoStd()...");
		
		Element mTransactionEle = new Element("Transaction");
		mTransactionEle.addContent(pStdXml.getRootElement().getChild(Head).detach());
		
		cLogger.info("Out NewContBlc.std2NoStd()!");
		return new Document(mTransactionEle);
	}
}