package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class GreenLight extends XmlSimpFormat{
	private Element cTransaction_BodyEle;
	
	public GreenLight(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into GreenLight.noStd2Std()...");
		
		Document mStdXml = 
			GreenLightInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cTransaction_BodyEle = 
			(Element) pNoStdXml.getRootElement().getChild("Transaction_Body").clone();
		
		cLogger.info("Out GreenLight.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into GreenLight.std2NoStd()...");
		
		Element mTransactionEle = new Element("Transaction");
		mTransactionEle.addContent(pStdXml.getRootElement().getChild(Head).detach());
		mTransactionEle.addContent(cTransaction_BodyEle);
		
		cLogger.info("Out GreenLight.std2NoStd()!");
		return new Document(mTransactionEle);
	}
}
