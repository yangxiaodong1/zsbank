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
	
	private String policyNo = null;//������
	private String appName = null;//Ͷ��������
	private String appIdType = null;//Ͷ����֤������
	private String appIdNo = null;//Ͷ����֤������
	
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
		
	    //������
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("PbInsuSlipNo").setText(policyNo);
		//Ͷ��������
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("PbInsuName").setText(appName);
		//Ͷ����֤������
		mNoStdXml.getRootElement().getChild("Transaction_Body").getChild("LiRcgnIdType").setText(appIdType);
		//Ͷ����֤������
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


