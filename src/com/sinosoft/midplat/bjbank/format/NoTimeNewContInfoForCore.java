package com.sinosoft.midplat.bjbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NoTimeNewContInfoForCore extends XmlSimpFormat {

	public NoTimeNewContInfoForCore(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NoTimeNewContInfoForCore.noStd2Std()...");

		Document mStdXml = NoTimeNewContInfoForCoreInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out NoTimeNewContInfoForCore.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NoTimeNewContInfoForCore.std2NoStd()...");

		Document mNoStdXml = NoTimeNewContInfoForCoreOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NoTimeNewContInfoForCore.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("e:/2710706_37_24_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("e:/a_out.xml")));
        out.write(JdomUtil.toStringFmt(new NoTimeNewContInfoForCore(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}


