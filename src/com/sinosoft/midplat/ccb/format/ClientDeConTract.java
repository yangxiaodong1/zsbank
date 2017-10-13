package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class ClientDeConTract extends XmlSimpFormat {
	public ClientDeConTract(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ClientDeConTract.noStd2Std()...");
		
		Document mStdXml = 
			ClientDeConTractInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out ClientDeConTract.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ClientDeConTract.std2NoStd()...");
		
		Document mNoStdXml = 
			ClientDeConTractOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out ClientDeConTract.std2NoStd()!");
		return mNoStdXml;
	}
}