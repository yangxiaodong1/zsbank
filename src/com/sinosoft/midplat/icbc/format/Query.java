package com.sinosoft.midplat.icbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Query extends XmlSimpFormat {
    String sourceType="";
    
	public Query(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Query.noStd2Std()...");
		//��������
		sourceType = XPath.newInstance("//SourceType").valueOf(pNoStdXml.getRootElement());
		
		Document mStdXml = 
			QueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out Query.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Query.std2NoStd()...");
		Document mNoStdXml = null;
		if("8".equals(sourceType)){
		    //�����ն�����
		    mNoStdXml = QueryOutXsl.newInstance().getCache().transform(pStdXml);
		}else{
		    //��������
		    //��ѯ���µ����ر��Ļ�����ȫһ��������ֱ�ӵ���
		    mNoStdXml = new NewCont(cThisBusiConf).std2NoStd(pStdXml);

		    Element mTranDataEle = pStdXml.getRootElement();
		    String mFlagStr = mTranDataEle.getChild(Head).getChildText(Flag);
		    if (CodeDef.RCode_OK == Integer.parseInt(mFlagStr)) {
		        String tPath = "/TXLife/TXLifeResponse/OLifE/Holding/Policy/PaymentAmt";
		        Element tPaymentAmt = (Element) XPath.selectSingleNode(mNoStdXml, tPath);
		        tPaymentAmt.setText(
		                NumberUtil.fenToYuan(tPaymentAmt.getText()));
		    }
		}
		
		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
	    Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new Query(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}