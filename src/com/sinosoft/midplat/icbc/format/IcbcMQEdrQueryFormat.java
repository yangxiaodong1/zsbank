/**
 * 
 */
package com.sinosoft.midplat.icbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @author ChengNing
 * @date   2013-3-6
 */
public class IcbcMQEdrQueryFormat extends XmlSimpFormat  {

	public IcbcMQEdrQueryFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrQueryFormat.noStd2Std()...");

		Document mStdXml = IcbcMQEdrQueryFormatInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		cLogger.info("Out IcbcMQEdrQueryFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcMQEdrQueryFormat.std2NoStd()...");

		Document mNoStdXml = IcbcMQEdrQueryFormatOutXsl.newInstance().getCache()
				.transform(pStdXml);

		cLogger.info("Out IcbcMQEdrQueryFormat.std2NoStd()!");
		return mNoStdXml;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {

		Document doc = JdomUtil.build(new FileInputStream(
				"D:\\Work\\Dev\\Test\\工行保全\\工行接口报文\\满期查询.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(
						"D:\\Work\\Dev\\Test\\工行保全\\testout\\满期查询to核心.xml")));
		out.write(JdomUtil.toStringFmt(new IcbcMQEdrQueryFormat(null)
				.noStd2Std(doc)));
		out.close();
		System.out.println("**正向测试Done****ok*********");
		
		//=========================================================================

		Document doc1 = JdomUtil.build(new FileInputStream(
				"D:\\Work\\Dev\\Test\\工行保全\\核心接口报文\\保全查询响应.xml"));
		BufferedWriter out1 = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(
						"D:\\Work\\Dev\\Test\\工行保全\\testout\\满期查询to银行.xml")));
		out1.write(JdomUtil.toStringFmt(new IcbcMQEdrQueryFormat(null)
				.std2NoStd(doc1)));
		out1.close();
		System.out.println("**反向测试Done****ok*********");
	}

}
