package com.sinosoft.midplat.cmb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class SummaryNewContBlc extends XmlSimpFormat {
    public SummaryNewContBlc(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into SummaryNewContBlc.noStd2Std()...");

        Document mStdXml = SummaryNewContBlcInXsl.newInstance().getCache().transform(
                pNoStdXml);

        cLogger.info("Out SummaryNewContBlc.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into SummaryNewContBlc.std2NoStd()...");

        Document mNoStdXml = new Cancel(this.cThisBusiConf).std2NoStd(pStdXml);

        cLogger.info("Out SummaryNewContBlc.std2NoStd()!");
        return mNoStdXml;
    }
}