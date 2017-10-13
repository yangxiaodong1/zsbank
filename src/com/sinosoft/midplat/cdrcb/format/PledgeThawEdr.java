package com.sinosoft.midplat.cdrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class PledgeThawEdr extends XmlSimpFormat {
	public PledgeThawEdr(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PledgeThawEdr.noStd2Std()...");

		Document mStdXml = PledgeThawEdrInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out PledgeThawEdr.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PledgeThawEdr.std2NoStd()...");

		Document mNoStdXml = PledgeThawEdrOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out PledgeThawEdr.std2NoStd()!");
		return mNoStdXml;
	}
}