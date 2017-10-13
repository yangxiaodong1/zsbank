package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class BatQuery extends XmlSimpFormat {
	public BatQuery(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into BatQuery.noStd2Std()...");

		Document mStdXml = BatQueryInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out BatQuery.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into BatQuery.std2NoStd()...");

		Document mNoStdXml = BatQueryOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out BatQuery.std2NoStd()!");
		return mNoStdXml;
	}
}