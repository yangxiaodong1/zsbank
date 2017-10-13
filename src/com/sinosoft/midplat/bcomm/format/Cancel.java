package com.sinosoft.midplat.bcomm.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Cancel extends XmlSimpFormat {

	// 撤销金额（取银行）
	private String cancelAmt = "";
	// 保单号
	private String contNo = "";

	public Cancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Cancel.noStd2Std()...");

		Element inNoStdRoot = pNoStdXml.getRootElement();
		this.cancelAmt = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Amt")).getText();
		this.contNo = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Idx1")).getText();

		Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);

		// 交通银行传上一步交易的银行流水号，我方从TranLog中查出ProposalPrtNo、ContPrtNo
		Element mRootEle = mStdXml.getRootElement();
		Element mHeadEle = mRootEle.getChild(Head);
		Element mBodyEle = mRootEle.getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where TranCom=" 
			+ mHeadEle.getChildText(TranCom)
			+ " and TranNo='" + mBodyEle.getChildText("OldTranNo") + "' "
			+ " and TranDate=" + mBodyEle.getChildText("OldTranDate");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		if(!mBodyEle.getChildText(ContNo).equals(mSSRS.GetText(1, 2))){
			throw new MidplatException("查询合同号与保单回滚合同号不一致！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		//mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Cancel.std2NoStd()...");

		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(
				pStdXml);

		// 核心返回报文无具体结点，使用银行请求赋值
		Element root = mNoStdXml.getRootElement();
		Element cancelAmtEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Amt");
		if (cancelAmtEle != null) {
			cancelAmtEle.setText(cancelAmt);
		}
		Element contNoEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Idx1");
		if (contNoEle != null) {
			contNoEle.setText(contNo);
		}

		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}