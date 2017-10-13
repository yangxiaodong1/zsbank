package com.sinosoft.midplat.cmb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class RePrint extends XmlSimpFormat {

    public RePrint(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into RePrint.noStd2Std()...");

        Document mStdXml = RePrintInXsl.newInstance().getCache().transform(
                pNoStdXml);

        cLogger.info("Out RePrint.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into RePrint.std2NoStd()...");

        Document mNoStdXml = null;
        mNoStdXml = new ContConfirm(cThisBusiConf).std2NoStd(pStdXml);

        cLogger.info("Out RePrint.std2NoStd()!");

        return mNoStdXml;
    }
}
