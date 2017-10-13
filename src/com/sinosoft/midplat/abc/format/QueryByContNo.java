package com.sinosoft.midplat.abc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class QueryByContNo extends XmlSimpFormat {
	public QueryByContNo(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into QueryByContNo.noStd2Std()...");

		Document mStdXml = QueryByContNoInXsl.newInstance().getCache()
				.transform(pNoStdXml);

		cLogger.info("Out QueryByContNo.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into QueryByContNo.std2NoStd()...");

		Document mNoStdXml = QueryByContNoOutXsl.newInstance().getCache()
				.transform(pStdXml);

		cLogger.info("Out QueryByContNo.std2NoStd()!");
		return mNoStdXml;
	}
}