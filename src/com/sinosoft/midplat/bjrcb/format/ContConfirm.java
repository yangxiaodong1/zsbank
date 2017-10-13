package com.sinosoft.midplat.bjrcb.format;

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
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into ContConfirm.noStd2Std()...");
        Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);     
        
        //北京农商行传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
        Element mHead = mStdXml.getRootElement().getChild(Head);
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);
        StringBuffer mSqlStr = new StringBuffer();
        mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ");
        mSqlStr.append("  tranno='" + mBodyEle.getChildText("OldTranNo")+"'");
        mSqlStr.append("  and proposalprtno='" + mBodyEle.getChildText("ProposalPrtNo")+"'");
        mSqlStr.append("  and trancom=" + mHead.getChildText(TranCom));
        mSqlStr.append("  and trandate=" + mHead.getChildText(TranDate));
        mSqlStr.append("  and rcode=0");
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (1 != mSSRS.MaxRow) {
            throw new MidplatException("查询上一交易日志失败！");
        }
        mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
        
        cLogger.info("Out ContConfirm.noStd2Std()!");
        return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");

		Document mNoStdXml = null;
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		
		if("50015".equals(tContPlanCode)){	// 组合产品50002
			
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("BJRCB_北京农商行，ContConfirmOutXsl50002进行报文转换。");
				
		}else{
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("BJRCB_北京农商行，ContConfirmOutXsl进行报文转换。");
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\3347_69_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}