package com.sinosoft.midplat.ccb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class EdorCTInfo extends XmlSimpFormat {
	public EdorCTInfo(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into EdorCTInfo.noStd2Std()...");
		
		Document mStdXml = 
			EdorCTInfoInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out EdorCTInfo.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into EdorCTInfo.std2NoStd()...");
		
		Document mNoStdXml = 
			EdorCTInfoOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out EdorCTInfo.std2NoStd()!");
		return mNoStdXml;
	}
	
	 public static void main(String[] args) throws Exception {
	        
        Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/ccb/dat/out_std.xml"));
    
	    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/dat/out_nostd.xml")));
	    out.write(JdomUtil.toStringFmt(new EdorCTInfo(null).std2NoStd(doc)));
	    out.close();
	    System.out.println("******ok*********");
    }
}

