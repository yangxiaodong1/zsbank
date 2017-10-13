package com.sinosoft.midplat.citicHZ.format;


import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class MakeLoanQuery extends XmlSimpFormat {
	
	private String policyNo = null;//保单号
	private String appName = null;//投保人姓名
	private String appIdType = null;//投保人证件类型
	private String appIdNo = null;//投保人证件号码
	
	public MakeLoanQuery(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into MakeLoanQuery.noStd2Std()...");
		 
	    Element noStdRoot = pNoStdXml.getRootElement();
	    policyNo = noStdRoot.getChild("Transaction_Body").getChild("PbInsuSlipNo").getText();
	    appName = noStdRoot.getChild("Transaction_Body").getChild("PbInsuName").getText();
	    appIdType = noStdRoot.getChild("Transaction_Body").getChild("LiRcgnIdType").getText();
	    appIdNo = noStdRoot.getChild("Transaction_Body").getChild("LiRcgnId").getText();
		
		Document mStdXml = MakeLoanQueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out MakeLoanQuery.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into MakeLoanQuery.std2NoStd()...");
		
		Document mNoStdXml = MakeLoanQueryOutXsl.newInstance().getCache().transform(pStdXml);
		
	    //保单号
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("PbInsuSlipNo").setText(policyNo);
		//投保人姓名
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("PbInsuName").setText(appName);
		//投保人证件类型
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("LiRcgnIdType").setText(appIdType);
		//投保人证件号码
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("LiRcgnId").setText(appIdNo);
		
		cLogger.info("Out MakeLoanQuery.std2NoStd()!");
		return mNoStdXml;
	}

	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("E:/1386680_218_39_outSvc.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/2.xml")));
        out.write(JdomUtil.toStringFmt(new MakeLoanQuery(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}


