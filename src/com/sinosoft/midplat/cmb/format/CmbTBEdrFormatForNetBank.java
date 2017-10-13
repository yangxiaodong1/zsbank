package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CmbTBEdrFormatForNetBank extends XmlSimpFormat {
	public CmbTBEdrFormatForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CmbTBEdrFormatForNetBank.noStd2Std()...");

		Document mStdXml = CmbTBEdrFormatForNetBankInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		
		
		cLogger.info("Out CmbTBEdrFormatForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into CmbTBEdrFormatForNetBank.std2NoStd()...");

		Document mNoStdXml = null;
		mNoStdXml = CmbTBEdrFormatForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out CmbTBEdrFormatForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args) throws Exception {
		
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/1_in.xml"));
//		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/11_out.xml")));
//		out.write(JdomUtil.toStringFmt(new IcbcTBEdrFormat(null).noStd2Std(doc)));
		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new CmbTBEdrFormatForNetBank(null).std2NoStd(doc)));
		
		out.close();
		System.out.println("******ok*********");
	}
	
}


