package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CgbTKQueryFormat extends XmlSimpFormat {
	
	private String policyNo = null;//保单号
	private String appName = null;//投保人姓名
	private String appIdType = null;//投保人证件类型
	private String appIdNo = null;//投保人证件号码
	
	
	public CgbTKQueryFormat(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CgbTKQueryFormat.noStd2Std()...");
		
		Element noStdRoot = pNoStdXml.getRootElement();
	    policyNo = noStdRoot.getChild("Body").getChild("ContNo").getText();
	    
		Document mStdXml = CgbTKQueryFormatInXsl.newInstance().getCache().transform(pNoStdXml);	
		//由于银行无法传递网点代码，经过业务和行方确认，取出单网点
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo,NodeNo from TranLog where TranCom = 22 and Funcflag = '2208' and Rcode = '0' " +
	    		" and ContNo = '"+ policyNo+"' " +
	    		" order by Maketime desc");
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (0 >= mSSRS.MaxRow) {
	       throw new MidplatException("查询保单信息失败！");
        }
        Element mHeadEle = mStdXml.getRootElement().getChild(Head);
        mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1,2));
        //写死操作员代码
        mHeadEle.getChild(TellerNo).setText("sys");
		
		
		cLogger.info("Out CgbTKQueryFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CgbTKQueryFormat.std2NoStd()...");

        
        Document  mNoStdXml = CgbTKQueryFormatOutXsl.newInstance().getCache().transform(pStdXml);
        
        //保单号
		mNoStdXml.getRootElement().getChild("Body").getChild("ContNo").setText(policyNo);
		//投保人姓名
		mNoStdXml.getRootElement().getChild("Body").getChild("AppntName").setText(appName);
		//投保人证件类型
		mNoStdXml.getRootElement().getChild("Body").getChild("AppntIDType").setText(appIdType);
		//投保人证件号码
		mNoStdXml.getRootElement().getChild("Body").getChild("AppntIDNo").setText(appIdNo);
        
		cLogger.info("Out CgbTKQueryFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
