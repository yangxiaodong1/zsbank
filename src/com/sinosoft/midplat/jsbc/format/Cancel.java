package com.sinosoft.midplat.jsbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Cancel extends XmlSimpFormat {
    public Cancel(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into Cancel.noStd2Std()...");

        Document mStdXml = CancelInXsl.newInstance().getCache().transform(
                pNoStdXml);
        
        
		
        cLogger.info("Out Cancel.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into Cancel.std2NoStd()...");

        Document mNoStdXml = null;

        mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);

        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }
}
