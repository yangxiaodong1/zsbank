package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class CmbWTEdrCancelForNetBank extends XmlSimpFormat {

	public CmbWTEdrCancelForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CmbWTEdrCancelForNetBank.noStd2Std()...");

		Document mStdXml = CmbWTEdrCancelForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out CmbWTEdrCancelForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CmbWTEdrCancelForNetBank.std2NoStd()...");

		Document mNoStdXml = null;
		mNoStdXml = CmbWTEdrCancelForNetBankOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out CmbWTEdrCancelForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
}

