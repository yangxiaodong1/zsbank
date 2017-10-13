package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class ClientConTract extends XmlSimpFormat {
	public ClientConTract(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ClientConTract.noStd2Std()...");
		
		Document mStdXml = 
			ClientConTractInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out ClientConTract.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ClientConTract.std2NoStd()...");
		
		Document mNoStdXml = 
			ClientConTractOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out ClientConTract.std2NoStd()!");
		return mNoStdXml;
	}
}