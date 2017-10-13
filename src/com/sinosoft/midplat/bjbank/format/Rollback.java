package com.sinosoft.midplat.bjbank.format;


import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Rollback extends XmlSimpFormat {
	public Rollback(Element pThisConf) {
		super(pThisConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Rollback.noStd2Std()...");

		
		Document mStdXml = RollbackInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		
		Element mRootEle = mStdXml.getRootElement();
		Element mBodyEle = mRootEle.getChild(Body);
		Element mHeadEle = mRootEle.getChild(Head);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where TranNo=" + mBodyEle.getChildText("OldLogNo")
		+ " and TranDate=" + mHeadEle.getChildText(TranDate)
		+ " and TranCom=" + mHeadEle.getChildText(TranCom)
		+ " and FuncFlag=1900";
//        + " and Rcode=0";
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out Rollback.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Rollback.std2NoStd()...");

		Document mNoStdXml = RollbackOutXsl.newInstance().getCache()
				.transform(pStdXml);
		
		cLogger.info("Out Rollback.std2NoStd()!");
		return mNoStdXml;
	}
}