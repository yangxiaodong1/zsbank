package com.sinosoft.midplat.icbc.format;

import java.io.FileInputStream;
import java.io.InputStream;
import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class IcbcTBEdrQueryFormat extends XmlSimpFormat{
	public IcbcTBEdrQueryFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcTBEdrQueryFormat.noStd2Std()...");
		
		
		
		Document mStdXml = 
			IcbcTBEdrQueryFormatInXsl.newInstance().getCache().transform(pNoStdXml);

		
		
		cLogger.info("Out IcbcTBEdrQueryFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcTBEdrQueryFormat.std2NoStd()...");
		
		
		
		Document mNoStdXml = IcbcTBEdrQueryFormatOutXsl.newInstance().getCache()
				.transform(pStdXml);
		
		
		
		cLogger.info("Out IcbcTBEdrQueryFormat.std2NoStd()!");
		return mNoStdXml;
	}

	
	
//	private void saveFile(Document pInXmlDoc,String fileName){
//		TestHelp.saveFile(pInXmlDoc, fileName) ;
//	}
//	
//	
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
