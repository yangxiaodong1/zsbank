package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.icbc.format.IcbcNetBankTBEdrQueryFormat.java
 * @Description: 
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 18, 2014 11:11:31 AM
 * @version 
 *
 */
public class IcbcNetBankTBEdrQueryFormat extends XmlSimpFormat{

	public IcbcNetBankTBEdrQueryFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcNetBankTBEdrQueryFormat.noStd2Std()...");
		
		Document mStdXml = IcbcNetBankTBEdrQueryFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out IcbcNetBankTBEdrQueryFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcNetBankTBEdrQueryFormat.std2NoStd()...");
		
		Document mNoStdXml = IcbcNetBankTBEdrQueryFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out IcbcNetBankTBEdrQueryFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	
//	public static void main(String args[]) throws Exception{
//		String icbcInputFilePath  = "E:\\ab-life\\test\\ICBC\\TB\\TBQUERY\\icbc_tb_query_input(fc=1021).xml";	
//		InputStream pInputStream = new FileInputStream(icbcInputFilePath);
//		byte[] mBodyBytes = IOTrans.toBytes(pInputStream);
//		Document mXmlDoc = JdomUtil.build(mBodyBytes);
//		
//		IcbcTBEdrQueryFormat format = new IcbcTBEdrQueryFormat(mXmlDoc.getRootElement());//创建时传递任何的一个Element都没有关系
//		
//		format.saveFile(format.noStd2Std(mXmlDoc) , "转换后核心报文.xml") ;
//		
//	}
}
