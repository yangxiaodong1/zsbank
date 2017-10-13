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
 * <p>
 * 客户服务联动
 * </p>
 * 
 * @author ChengNing
 * @date Mar 15, 2013
 */
public class CustomerServiceFormat extends XmlSimpFormat {
	
	public CustomerServiceFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {	
		cLogger.info("Into "+ this.getClass().getName() + ".noStd2Std()...");
		Document mStdXml = CustomerServiceFormatInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		cLogger.info("Out " + this.getClass().getName() + ".noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into "+ this.getClass().getName() +".std2NoStd()...");
		
		Document mNoStdXml = CustomerServiceFormatOutXsl.newInstance()
				.getCache().transform(pStdXml);

		cLogger.info("Out "+ this.getClass().getName() +".std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args)throws Exception{

		CustomerServiceFormat formater = new CustomerServiceFormat(null);
		/*Document doc = JdomUtil.build(new FileInputStream(
				"D:\\Work\\Dev\\Test\\95588\\工行接口报文\\in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(
						"D:\\Work\\Dev\\Test\\95588\\testout\\to客服.xml")));
		out.write(JdomUtil.toStringFmt(formater.noStd2Std(doc)));
		out.close();
		System.out.println("**正向测试Done****ok*********");*/
		
		//=========================================================================

		Document doc1 = JdomUtil.build(new FileInputStream(
				"C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
		BufferedWriter out1 = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(
						"C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
		out1.write(JdomUtil.toStringFmt(formater.std2NoStd(doc1)));
		out1.close();
		System.out.println("**反向测试Done****ok*********");
	
	}
}