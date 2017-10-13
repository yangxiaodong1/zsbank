package com.sinosoft.midplat.abc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class QueryByID extends XmlSimpFormat {
	public QueryByID(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into QueryByID.noStd2Std()...");

		Document mStdXml = QueryByIDInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out QueryByID.noStd2Std()!");
		return mStdXml;
	}

	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into QueryByID.std2NoStd()...");

		Document mNoStdXml = QueryByIDOutXsl.newInstance().getCache()
				.transform(pStdXml);

		cLogger.info("Out QueryByID.std2NoStd()!");
		return mNoStdXml;
	}
}