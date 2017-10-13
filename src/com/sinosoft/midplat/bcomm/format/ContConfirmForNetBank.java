package com.sinosoft.midplat.bcomm.format;

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

	private String mKr_TrType = "4";	// 付费方式,默认为：4=借记卡
	private String cProposalPrtNo = "";
	public ContConfirmForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();
		
		mKr_TrType = ((Element) XPath.selectSingleNode(noStdRoot,"K_TrList/KR_TrType")).getTextTrim();
		/*
		 * 1. 付费方式校验，不允许现金缴费。
		 * 字典说明：
		 * 0=现金,1=一本通,2=存折,3=准贷记卡（保留，暂不支持）,4=借记卡,5=个人支票（保留，暂不支持）,
		 * 7=贷记凭证（保留，暂不支持）,9=挂账付费（保留，暂不支持）,D=单位支票（保留，暂不支持）
		 */
		if ("0".equals(mKr_TrType)) {
			throw new MidplatException("不支持现金缴费，请选择其他付费方式");
		}
		
		Document mStdXml = ContConfirmForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		Element mHead = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		cProposalPrtNo = mBodyEle.getChildText(ProposalPrtNo);
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ContNo,Bak5 from TranLog where ");
        mSqlStr.append("  ProposalPrtNo='" + mBodyEle.getChildText(ProposalPrtNo)+"'");
        mSqlStr.append("  and trancom=" + mHead.getChildText(TranCom));
        mSqlStr.append("  and trandate=" + mHead.getChildText(TranDate));
        mSqlStr.append("  and rcode=0 order by Maketime desc");
        
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (mSSRS.MaxRow <1) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 2));//重新赋值核心的投保单号
		
		cLogger.info("Out ContConfirmForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.Std2StdnoStd()...");

		Document noStdXml = ContConfirmForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		Element mRootEle = noStdXml.getRootElement();
		Element trTypeEle = (Element) XPath.selectSingleNode(mRootEle,"K_TrList/KR_TrType");
		if (trTypeEle != null) {
			trTypeEle.setText(mKr_TrType);
		}
		mRootEle.getChild("K_TrList").getChild("KR_Idx").setText(cProposalPrtNo);//将银行传的投保单号返回去
		cLogger.info("Out ContConfirmForNetBank.Std2StdnoStd()!");

		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		
		Document doc = JdomUtil.build(new FileInputStream("D:/test/BCOMM/报文示例life/bcomm_life_hexin_1_rtn.xml"));

		ContConfirmForNetBank con = new ContConfirmForNetBank(null);
		// con.noStd2Std(in);

		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/test/BCOMM/bcomm_life_cb002out.xml")));
		out.write(JdomUtil.toStringFmt(con.std2NoStd(doc)));
		out.close();
		System.out.println("******ok*********");
	}
}
