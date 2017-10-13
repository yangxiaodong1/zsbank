package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class CmbPolicyValueQuery extends XmlSimpFormat {

	public CmbPolicyValueQuery(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CmbPolicyValueQuery.noStd2Std()...");

		Document mStdXml = CmbPolicyValueQueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out CmbPolicyValueQuery.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CmbPolicyValueQuery.std2NoStd()...");

		Document mNoStdXml = null;
		mNoStdXml = CmbPolicyValueQueryOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out CmbPolicyValueQuery.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream(
        "D:/工作文档/寿险银保通文档/招商银行/03XML报文实例/675050_3838_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        System.out.println(JdomUtil.toStringFmt(new CmbPolicyValueQuery(null).std2NoStd(doc)));
    }
}
