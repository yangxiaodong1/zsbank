package com.sinosoft.midplat.bjbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PolicyAssetChangeSyncForCore extends XmlSimpFormat {

	public PolicyAssetChangeSyncForCore(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PolicyAssetChangeSyncForCore.noStd2Std()...");

		Document mStdXml = 
		    PolicyAssetChangeSyncForCoreInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out PolicyAssetChangeSyncForCore.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PolicyAssetChangeSyncForCore.std2NoStd()...");

		Document mNoStdXml = 
		    PolicyAssetChangeSyncForCoreOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out PolicyAssetChangeSyncForCore.std2NoStd()!");
		return mNoStdXml;
	}
	
}

