package com.sinosoft.midplat.abc.format;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.abc.format.ContConfirmInXsl;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	public ContConfirm(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(
				pNoStdXml);		
		
		//农行传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
			
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));	
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");

		Document mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(
				pStdXml);
		Element mMessages=mNoStdXml.getRootElement().getChild("Messages");
		Element mPrnts=mNoStdXml.getRootElement().getChild("Prnts");
		if(mMessages!=null){
			cLogger.info("给Messages下的count赋值");
			List mMessageList=mMessages.getChildren("Message");
			Element mCount=mMessages.getChild("Count");
			cLogger.info("Count====="+String.valueOf(mMessageList.size()));
			mCount.setText(String.valueOf(mMessageList.size()));
		}
		if(mPrnts!=null){
			cLogger.info("给Prnts下的count赋值");
			List mPrntList=mPrnts.getChildren("Prnt");
			cLogger.info("Count====="+String.valueOf(mPrntList.size()));
			Element mCount=mPrnts.getChild("Count");
			cLogger.info("Count object==="+mCount);
			mCount.setText(String.valueOf(mPrntList.size()));
		}
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
}