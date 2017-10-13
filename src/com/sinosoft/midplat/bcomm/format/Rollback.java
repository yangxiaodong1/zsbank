package com.sinosoft.midplat.bcomm.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.bcomm.format.Rollback.java
 * @Description: 自动冲正交易
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Feb 12, 2014 2:04:43 PM
 * @version 
 *
 */
public class Rollback extends XmlSimpFormat{

	public Rollback(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	// 保单号
	private String contNo = "";
	// 撤销金额（取银行）
	private String cancelAmt = "";
	
	/* 
	 * 银行的非标准报文转换为核心的标准报文
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Rollback.noStd2Std()...");
		
		Element inNoStdRoot = pNoStdXml.getRootElement();
		this.cancelAmt = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Amt")).getText();	// 撤销金额（取银行）
		this.contNo = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Idx1")).getText();	// 保单号

		Document mStdXml = RollbackInXsl.newInstance().getCache().transform(pNoStdXml);
		
		// 交通银行传上一步交易的银行流水号，我方从TranLog中查出ProposalPrtNo、ContPrtNo
		Element mRootEle = mStdXml.getRootElement();
		Element mHeadEle = mRootEle.getChild(Head);
		Element mBodyEle = mRootEle.getChild(Body);
		String str = mHeadEle.getChildText(TranCom);
		System.out.println(str);
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
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out Rollback.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * 核心的标准报文转换为银行的非标准报文
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Rollback.std2NoStd()...");
		
		// 冲正返回与当日撤单返回报文相同，重用即可
		Cancel cancel = new Cancel(this.cThisBusiConf);
		
		Document mNoStdXml = cancel.std2NoStd(pStdXml);
		
		// 核心返回报文无具体结点，使用银行请求赋值
		Element root = mNoStdXml.getRootElement();
		
		Element contNoEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Idx1");
		if (contNoEle != null) {
			contNoEle.setText(contNo);
		}
		
		Element cancelAmtEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Amt");
		if (cancelAmtEle != null) {
			cancelAmtEle.setText(cancelAmt);
		}

		cLogger.info("Out Rollback.std2NoStd()!");
		return mNoStdXml;
	}

	public static void main(String[] args){
		
	}
	
}


