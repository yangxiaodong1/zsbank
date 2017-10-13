package com.sinosoft.midplat.bjrcb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NoRealTimeBlc extends XmlSimpFormat {

	public NoRealTimeBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	/* 
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.format.XmlSimpFormat#noStd2Std(org.jdom.Document)
	 * 将非实时对账报文按格式转换为核心需要的标准报文
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into Bjrcb NoRealTimeBlc.noStd2Std()...");
		
		Document mStdXml = NoRealTimeBlcInXsl.newInstance().getCache().transform(pNoStdXml); 
		
		cLogger.info("Out Bjrcb NoRealTimeBlc.noStd2Std()!");
		return mStdXml;
	}
	
	public static void main(String[] args) throws Exception{
		Document doc = JdomUtil.build(new FileInputStream("D:/bjrcb_norela_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream("D:/bjrcb_norelastd_in.xml")));
		out.write(JdomUtil.toStringFmt(new NoRealTimeBlc(null).noStd2Std(doc)));
		out.close();
		System.out.println("******ok*********");
    }
}
