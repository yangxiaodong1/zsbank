package com.sinosoft.midplat.cdrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class PledgeFrozenEdr extends XmlSimpFormat {
	public PledgeFrozenEdr(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PledgeFrozenEdr.noStd2Std()...");

		Document mStdXml = PledgeFrozenEdrInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out PledgeFrozenEdr.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PledgeFrozenEdr.std2NoStd()...");

		Document mNoStdXml = PledgeFrozenEdrOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out PledgeFrozenEdr.std2NoStd()!");
		return mNoStdXml;
	}
}