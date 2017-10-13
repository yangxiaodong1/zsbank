package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class IcbcSelfTermTBEdrQueryFormat  extends XmlSimpFormat{

	public IcbcSelfTermTBEdrQueryFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcSelfTermTBEdrQueryFormat.noStd2Std()...");
		
		Document mStdXml = IcbcSelfTermTBEdrQueryFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out IcbcSelfTermTBEdrQueryFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcSelfTermTBEdrQueryFormat.std2NoStd()...");
		
		Document mNoStdXml = IcbcSelfTermTBEdrQueryFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out IcbcSelfTermTBEdrQueryFormat.std2NoStd()!");
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
