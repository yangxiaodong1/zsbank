package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirmForNetBank extends XmlSimpFormat {
	public ContConfirmForNetBank(Element pThisConf) {
		super(pThisConf);
	}
	
	String TRANSRNO = "";
	String TRANSRDATE = "";
	String INSUID = "";
	String REQSRNO = "";
	Document mStdXml = null; 

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.noStd2Std()...");
		
		TRANSRNO = XPath.newInstance("//TRANSRNO").valueOf(pNoStdXml);
		TRANSRDATE = XPath.newInstance("//TRANSRDATE").valueOf(pNoStdXml);
		INSUID = XPath.newInstance("//INSUID").valueOf(pNoStdXml);
		REQSRNO = XPath.newInstance("//REQSRNO").valueOf(pNoStdXml);
		
		mStdXml = ContConfirmInXslForNetBank.newInstance().getCache().transform(
				pNoStdXml);	
//		//银行编号
//		String trancom = XPath.newInstance("Head/TranCom").valueOf(mStdXml.getRootElement()) ;
		
		//广发传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
//		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
//		StringBuffer mSqlStr = new StringBuffer();
//		mSqlStr.append("select ProposalPrtNo, ContNo from Cont where ");
//		mSqlStr.append("  ContNo='" + mBodyEle.getChildText(ContNo)+"'");
//		mSqlStr.append("  and trandate=" + TRANSRDATE);
//		mSqlStr.append("  and trancom="+trancom);
//		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//		if (1 != mSSRS.MaxRow) {
//			throw new MidplatException("查询上一交易日志失败！");
//		}
//		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
//		
		cLogger.info("Out ContConfirmForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.std2NoStd()...");
//		JdomUtil.print(pStdXml);
		Element headEle = mStdXml.getRootElement().getChild(Head);
		headEle.addContent((Element) pStdXml.getRootElement().getChild(Head).getChild(Flag).clone());
		headEle.addContent((Element) pStdXml.getRootElement().getChild(Head).getChild(Desc).clone());
		
        Document mNoStdXml  = ContConfirmOutXslForNetBank.newInstance().getCache().transform(
        		mStdXml);
        
        
        Element TRANSRNO_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//TRANSRNO");
        if(TRANSRNO_ELE != null){
        	TRANSRNO_ELE.setText(TRANSRNO);
    		
    		Element TRANSRDATE_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//TRANSRDATE");
    		TRANSRDATE_ELE.setText(TRANSRDATE);
    		
    		Element INSUID_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//INSUID");
    		INSUID_ELE.setText(INSUID);
    		
    		Element REQSRNO_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//REQSRNO");
    		REQSRNO_ELE.setText(REQSRNO);
        }
		
		
		cLogger.info("Out ContConfirmForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirmForNetBank(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}