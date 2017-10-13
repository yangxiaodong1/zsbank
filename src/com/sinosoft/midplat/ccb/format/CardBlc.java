package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class CardBlc extends XmlSimpFormat {
	public CardBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CardBlc.noStd2Std()...");
		
		Document mStdXml = 
			CardBlcInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out CardBlc.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CardBlc.std2NoStd()...");
		
		Element mTransactionEle = new Element("Transaction");
		mTransactionEle.addContent(pStdXml.getRootElement().getChild(Head).detach());
		
		cLogger.info("Out CardBlc.std2NoStd()!");
		return new Document(mTransactionEle);
	}
}
