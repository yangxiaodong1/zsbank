package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class EdrCancelFormat extends XmlSimpFormat {
	public EdrCancelFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into EdrCancelFormat.noStd2Std()...");
		
		Document mStdXml = 
			EdrCancelFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out EdrCancelFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into EdrCancelFormat.std2NoStd()...");
		
		Document mNoStdXml = 
			EdrCancelFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out EdrCancelFormat.std2NoStd()!");
		return mNoStdXml;
	}
}
