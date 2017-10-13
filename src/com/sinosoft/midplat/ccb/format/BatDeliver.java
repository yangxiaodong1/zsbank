package com.sinosoft.midplat.ccb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class BatDeliver extends XmlSimpFormat {
	public BatDeliver(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into BatDeliver.noStd2Std()...");

		Document mStdXml = BatDeliverInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out BatDeliver.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into BatDeliver.std2NoStd()...");

		Element mTransactionEle = new Element("Transaction");
		mTransactionEle.addContent(pStdXml.getRootElement().getChild(Head)
				.detach());

		cLogger.info("Out BatDeliver.std2NoStd()!");
		return new Document(mTransactionEle);
	}
}