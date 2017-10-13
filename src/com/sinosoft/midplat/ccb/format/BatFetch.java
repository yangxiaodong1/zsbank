package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class BatFetch extends XmlSimpFormat {
	private Element cBkFileName = null;

	public BatFetch(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into BatFetch.noStd2Std()...");

		cBkFileName = (Element) pNoStdXml.getRootElement().getChild(
				"Transaction_Body").getChild("BkFileName").clone();

		Document mStdXml = BatFetchInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out BatFetch.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into BatFetch.std2NoStd()...");

		Document mNoStdXml = BatFetchOutXsl.newInstance().getCache().transform(
				pStdXml);

		mNoStdXml.getRootElement().getChild("Transaction_Body").addContent(0,
				cBkFileName);

		cLogger.info("Out BatFetch.std2NoStd()!");
		return mNoStdXml;
	}
}