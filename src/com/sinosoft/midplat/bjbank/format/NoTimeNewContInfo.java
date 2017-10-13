package com.sinosoft.midplat.bjbank.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class NoTimeNewContInfo extends XmlSimpFormat {

	public NoTimeNewContInfo(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NoTimeNewContInfo.noStd2Std()...");

		Document mStdXml = NoTimeNewContInfoInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out NoTimeNewContInfo.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NoTimeNewContInfo.std2NoStd()...");

		Document mNoStdXml = NoTimeNewContInfoOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NoTimeNewContInfo.std2NoStd()!");
		return mNoStdXml;
	}
	
}

