package com.sinosoft.midplat.jsbc.format;

import org.jdom.Document;
import org.jdom.Element;


import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class RePrint extends XmlSimpFormat{

	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		Document mStdXml = 
			RePrintInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//江苏银行传投保单号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0'");
		mSqlStr.append(" and Funcflag = 3301");
		mSqlStr.append(" and TranDate=" + DateUtil.getCur8Date());
		mSqlStr.append(" and ProposalPrtNo = '"+ mBodyEle.getChildText("ProposalPrtNo")+"' ");
			
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//重打和新单返回报文基本完全一样，所以直接调用
		Document mNoStdXml = new ContConfirm(cThisBusiConf).std2NoStd(pStdXml);
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}

}
