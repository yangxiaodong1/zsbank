package com.sinosoft.midplat.bjrcb.format;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.bjrcb.format.NoRealTimeUWResult.java
 * @Description: 北京农商非实时核保结果文件转换
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 12, 2014 3:44:37 PM
 * @version 
 *
 */
public class NoRealTimeUWResult extends XmlSimpFormat {

	public NoRealTimeUWResult(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document std2NoStd(Document pNoStdXml) throws Exception {
		cLogger.info("Into Bjrcb NoRealTimeUWResult.std2NoStd()...");
		
		Document mStdXml = NoRealTimeUWResultOutXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out Bjrcb NoRealTimeUWResult.std2NoStd()!");
		return mStdXml;
	} 
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:/bjrcb_fss_outSvc.xml"));
        JdomUtil.print(new NoRealTimeUWResult(null).std2NoStd(doc));
        System.out.println("******ok*********");
    }

}
