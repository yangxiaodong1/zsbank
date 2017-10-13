package com.sinosoft.midplat.citicHZ.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class MakeLoanConfirm extends XmlSimpFormat {
	
	public MakeLoanConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into MakeLoanConfirm.noStd2Std()...");
		
		Document mStdXml = MakeLoanConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out MakeLoanConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into MakeLoanConfirm.std2NoStd()...");
		
		Document mNoStdXml = MakeLoanConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out MakeLoanConfirm.std2NoStd()!");
		return mNoStdXml;
	}

}

