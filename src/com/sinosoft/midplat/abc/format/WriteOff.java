package com.sinosoft.midplat.abc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class WriteOff extends XmlSimpFormat {
	public WriteOff(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into WriteOff.noStd2Std()...");

		Document mStdXml = WriteOffInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out WriteOff.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into WriteOff.std2NoStd()...");

		Document mNoStdXml = WriteOffOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out WriteOff.std2NoStd()!");
		return mNoStdXml;
	}
}