package com.sinosoft.midplat.citic.format;

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

public class ContConfirmForNetBank extends XmlSimpFormat {

	public ContConfirmForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.std2NoStd()...");
		
		Document mStdXml = ContConfirmForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//中信银行传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirmForNetBank.noStd2Std()!");
		return mStdXml;
	}
	
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		//获取产品组合代码
        String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());

		mNoStdXml = ContConfirmForNetBankOutXsl.newInstance().getCache().transform(pStdXml);		
		
		cLogger.info("Out ContConfirmForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
    public static void main(String[] args) throws Exception{


    	Document doc = JdomUtil.build(new FileInputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirmForNetBank(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
