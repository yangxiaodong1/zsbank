package com.sinosoft.midplat.cmbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class CmbcNewContBlc extends XmlSimpFormat {

	public CmbcNewContBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* 
	 * 将非标准的日终对账文件转换为标准的日终对账文件
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.format.XmlSimpFormat#noStd2Std(org.jdom.Document)
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into CmbcNewContBlc.noStd2Std()...");
		
		System.out.println("******中间报文*********");
		JdomUtil.print(pNoStdXml);
		Document mStdXml = CmbcNewContBlcInxsl.newInstance().getCache().transform(pNoStdXml);

		System.out.println("******标准报文*********");
		JdomUtil.print(mStdXml);
		
        cLogger.info("Out CmbcNewContBlc.noStd2Std()...");
        return mStdXml;
		
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("d:/0034L20150127.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("d:/0034L20150127_out.xml")));
		out.write(JdomUtil.toStringFmt(new CmbcNewContBlc(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
}
