package com.sinosoft.midplat.cib.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class Cancel extends XmlSimpFormat {
    public Cancel(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    private String contNo = "";
    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into Cancel.noStd2Std()...");
        Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);
        Element rootEle = mStdXml.getRootElement();
        contNo = XPath.newInstance("/TranData/Body/ContNo").valueOf(rootEle);
        cLogger.info("Out Cancel.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into Cancel.std2NoStd()...");
        //增加返回保单号信息
        Element rootEle = pStdXml.getRootElement();
        String flag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
        if("0".equals(flag)){
        	Element tBodyEle = new Element(Body);
        	Element tContNo = new Element(ContNo);
        	tContNo.addContent(contNo);
			tBodyEle.addContent(tContNo);
			rootEle.addContent(tBodyEle);
        }
        Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
        
        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }
}