package com.sinosoft.midplat.cebbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class ProposalStatusQuery extends XmlSimpFormat {

	public ProposalStatusQuery(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ProposalStatusQuery.noStd2Std()...");

		Document mStdXml = 
		    ProposalStatusQueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out ProposalStatusQuery.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ProposalStatusQuery.std2NoStd()...");

		Document mNoStdXml = 
		    ProposalStatusQueryOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out ProposalStatusQuery.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream(
        "D:/工作文档/寿险银保通文档/招商银行/03XML报文实例/675050_3838_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        System.out.println(JdomUtil.toStringFmt(new ProposalStatusQuery(null).std2NoStd(doc)));
    }
}
