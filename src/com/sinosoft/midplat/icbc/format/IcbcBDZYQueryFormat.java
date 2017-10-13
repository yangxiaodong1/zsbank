package com.sinosoft.midplat.icbc.format;

import java.io.FileInputStream;
import java.io.InputStream;
import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class IcbcBDZYQueryFormat extends XmlSimpFormat{
	public IcbcBDZYQueryFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYQueryFormat.noStd2Std()...");
						
		cLogger.info("test1");
		Document mStdXml = 
			IcbcBDZYQueryFormatInXsl.newInstance().getCache().transform(pNoStdXml);		
		cLogger.info("test3");
		cLogger.info("Out IcbcBDZYQueryFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYQueryFormat.std2NoStd()...");
		
		cLogger.info("test2");		
		Document mNoStdXml = IcbcBDZYQueryFormatOutXsl.newInstance().getCache()
				.transform(pStdXml);
				
		cLogger.info("Out IcbcBDZYQueryFormat.std2NoStd()!");
		return mNoStdXml;
	}

	
 
}
