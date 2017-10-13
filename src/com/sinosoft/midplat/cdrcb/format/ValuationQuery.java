package com.sinosoft.midplat.cdrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class ValuationQuery extends XmlSimpFormat {
	public ValuationQuery(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ValuationQuery.noStd2Std()...");

		Document mStdXml = ValuationQueryInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out ValuationQuery.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ValuationQuery.std2NoStd()...");
		
		Document mNoStdXml = ValuationQueryOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out ValuationQuery.std2NoStd()!");
		return mNoStdXml;
	}
}