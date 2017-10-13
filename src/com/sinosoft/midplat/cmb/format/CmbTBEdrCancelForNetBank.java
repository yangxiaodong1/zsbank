package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class CmbTBEdrCancelForNetBank extends XmlSimpFormat {

	public CmbTBEdrCancelForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CmbTBEdrCancelForNetBank.noStd2Std()...");

		Document mStdXml = CmbTBEdrCancelForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out CmbTBEdrCancelForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CmbTBEdrCancelForNetBank.std2NoStd()...");

		Document mNoStdXml = null;
		mNoStdXml = CmbTBEdrCancelForNetBankOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out CmbTBEdrCancelForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
}

