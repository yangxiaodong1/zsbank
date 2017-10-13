package com.sinosoft.midplat.cib.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * 
 * @author guoxl
 * @desc 兴业银行银保通新增退保数据回传交易-寿险
 * @dete 2016-06-23 11:08:45
 *
 */

public class SurrenderDataReturn extends XmlSimpFormat {

	public SurrenderDataReturn(Element thisBusiConf) {
		super(thisBusiConf);
	}

	//将银行的报文转换成保险核心的标准报文
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into load SurrenderDataReturn.noStd2Std()...");
		Document document = SurrenderDataReturnInXsl.newInstance().getCache().transform(pNoStdXml);
		cLogger.info("Out load SurrenderDataReturn.noStd2Std()!");
		
		return document;
	}
	
	//将保险核心的报文转换成银行的报文
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into load SurrenderDataReturn.std2NoStd()...");
		
		Document document = SurrenderDataReturnOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out load SurrenderDataReturn.std2NoStd()!");
		
		return document;
	}
	
	
	
}
