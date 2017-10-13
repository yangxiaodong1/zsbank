package com.sinosoft.midplat.hljrcc.format;


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
 

public class ContConfirm extends XmlSimpFormat {
   
    public ContConfirm(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into ContConfirm.noStd2Std()...");

        Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);

        //用试算号码查询ProposalPrtNo、ContNo、ContPrtNo   
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);
        
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo  from TranLog where Rcode = 0 and Funcflag = 2101 " +
	    		" and tranno = '"+ mBodyEle.getChildText("OrigTranNo")+"' " +
	    		" and proposalprtno = '"+ mBodyEle.getChildText("ProposalPrtNo")+"' " +
	    		" and trandate= "+ DateUtil.getCur8Date());
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("查询上一交易日志失败！");
        }
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.removeChild("OrigTranNo");
		
		
        cLogger.info("Out ContConfirm.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into ContConfirm.Std2StdnoStd()...");

        Document mNoStdXml = null;
        
        Element rootEle = pStdXml.getRootElement();
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		// 50015,由原来50002产品升级为50015
		if("50015".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		}
        
        
        Element mHeadEle = mNoStdXml.getRootElement().getChild(Head);
        if ("0".equals(mHeadEle.getChildText(Flag))) {  //0-交易成功
            List mPRTList = XPath.selectNodes(mNoStdXml.getRootElement(), "//PRINT");
            for (int i = 0; i < mPRTList.size(); i++) {
                Element tPRTEle = (Element) mPRTList.get(i);
                @SuppressWarnings("unchecked")
                //设置每页总行数
                int tSize = tPRTEle.getChildren("PRINT_LINE").size();
                Element lineNumEle = new Element("PRINT_LINE_NUM");
                lineNumEle.setText(tSize+"");
                tPRTEle.addContent(lineNumEle);
            }
            //设置打印页数
            mNoStdXml.getRootElement().getChild(Body).getChild("PRINT_NUM").setText(mPRTList.size()+"");
        }

        cLogger.info("Out ContConfirm.Std2StdnoStd()!");

        return mNoStdXml;
    }

    public static void main(String[] args) throws Exception {

        Document doc = JdomUtil.build(new FileInputStream("d:/23854_39_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/23854_39_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
        
    }
    
}
