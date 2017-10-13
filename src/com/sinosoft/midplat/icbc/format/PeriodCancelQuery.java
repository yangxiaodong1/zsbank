package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PeriodCancelQuery extends XmlSimpFormat{
	public PeriodCancelQuery(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQuery.noStd2Std()...");
		
		Document mStdXml = 
			PeriodCancelQueryInXsl.newInstance().getCache().transform(pNoStdXml);

		cLogger.info("Out PeriodCancelQuery.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQuery.std2NoStd()...");

		Document mNoStdXml = PeriodCancelQueryOutXsl.newInstance().getCache()
				.transform(pStdXml);

		cLogger.info("Out PeriodCancelQuery.std2NoStd()!");
		return mNoStdXml;
	}

}
