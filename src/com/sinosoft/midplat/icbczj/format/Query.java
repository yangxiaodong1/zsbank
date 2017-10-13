package com.sinosoft.midplat.icbczj.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.xpath.XPath;

import org.jdom.Document;
import org.jdom.Element;



import com.sinosoft.midplat.common.JdomUtil;

import com.sinosoft.midplat.format.XmlSimpFormat;


public class Query extends XmlSimpFormat {
    String tranNo="";
    
	public Query(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Query.noStd2Std()...");
		
		tranNo = XPath.newInstance("//transrefguid").valueOf(pNoStdXml);
		Document mStdXml = 
			QueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out Query.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Query.std2NoStd()...");
		Document  mNoStdXml = QueryOutXsl.newInstance().getCache().transform(pStdXml);;
		
		Element tranNoEle = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//transrefguid");
		tranNoEle.setText(tranNo);
		
		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
	    Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\×ÀÃæ\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\×ÀÃæ\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new Query(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}