package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class IcbcXQEdrFormat extends XmlSimpFormat {
	public IcbcXQEdrFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcXQEdrFormat.noStd2Std()...");

		Document mStdXml = IcbcXQEdrFormatInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		cLogger.info("Out IcbcXQEdrFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcXQEdrFormat.std2NoStd()...");

		Document mNoStdXml = IcbcXQEdrFormatOutXsl.newInstance().getCache()
				.transform(pStdXml);

		cLogger.info("Out IcbcXQEdrFormat.std2NoStd()!");
		return mNoStdXml;
	}
}
