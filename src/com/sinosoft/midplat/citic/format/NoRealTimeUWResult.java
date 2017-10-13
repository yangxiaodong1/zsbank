package com.sinosoft.midplat.citic.format;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.citic.format.NoRealTimeUWResult.java
 * @Description: 中信银行非实时核保结果文件格式转换
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date May 29, 2014 5:06:50 PM
 * @version 
 *
 */
public class NoRealTimeUWResult extends XmlSimpFormat {

	public NoRealTimeUWResult(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document std2NoStd(Document pNoStdXml) throws Exception {
		cLogger.info("Into NoRealTimeUWResult.std2NoStd()...");
		
		Document mStdXml = NoRealTimeUWResultOutXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out NoRealTimeUWResult.std2NoStd()!");
		return mStdXml;
	} 
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:\\citic_fss_outSvc.xml"));
        JdomUtil.print(new NoRealTimeUWResult(null).std2NoStd(doc));
        System.out.println("******ok*********");
    }

}
