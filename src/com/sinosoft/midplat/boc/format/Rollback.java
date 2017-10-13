package com.sinosoft.midplat.boc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class Rollback  extends XmlSimpFormat {
	public Rollback(Element pThisConf) {
		super(pThisConf);
	}
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Rollback.noStd2Std()...");
		
		Document mStdXml = RollbackInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out Rollback.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Rollback.std2NoStd()...");

		Document mNoStdXml = pStdXml;

		cLogger.info("Out Rollback.std2NoStd()!");
		return mNoStdXml;
	}
}
