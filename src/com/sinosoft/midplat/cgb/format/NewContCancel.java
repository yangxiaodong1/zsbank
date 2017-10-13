package com.sinosoft.midplat.cgb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContCancel extends XmlSimpFormat {
    public NewContCancel(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into NewContCancel.noStd2Std()...");

        Document mStdXml = NewContCancelInXsl.newInstance().getCache().transform(
                pNoStdXml);

        cLogger.info("Out NewContCancel.noStd2Std()!");
        return mStdXml;
    }

}
