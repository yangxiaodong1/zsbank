package com.sinosoft.midplat.hxb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.hxb.service.HxbNewContBlc.java
 * @Description: TODO
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Apr 23, 2014 11:21:38 AM
 * @version 
 *
 */
public class HxbNewContBlc extends XmlSimpFormat{

	public HxbNewContBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* 
	 * 将非标准的日终对账文件转换为标准的日终对账文件
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.format.XmlSimpFormat#noStd2Std(org.jdom.Document)
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		
		cLogger.info("Into HxBank HxbNewContBlc.noStd2Std()...");
		
		Document mStdXml = HxbNewContBlcInxsl.newInstance().getCache().transform(pNoStdXml);

        cLogger.info("Out HxBank HxbNewContBlc.noStd2Std()...");
        return mStdXml;
		
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/hxb/dz/B1615420140430.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/hxb/dz/v_out.xml")));
		out.write(JdomUtil.toStringFmt(new HxbNewContBlc(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
	
}


