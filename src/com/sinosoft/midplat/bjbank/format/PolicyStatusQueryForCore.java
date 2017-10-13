package com.sinosoft.midplat.bjbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PolicyStatusQueryForCore extends XmlSimpFormat {

	public PolicyStatusQueryForCore(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PolicyStatusQueryForCore.noStd2Std()...");

		Document mStdXml = 
		    PolicyStatusQueryForCoreInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out PolicyStatusQueryForCore.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PolicyStatusQueryForCore.std2NoStd()...");

		Document mNoStdXml = 
		    PolicyStatusQueryForCoreOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out PolicyStatusQueryForCore.std2NoStd()!");
		return mNoStdXml;
	}
	
}

