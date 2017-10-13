package com.sinosoft.midplat.abc.format;

import java.util.Calendar;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class AutoWriteOff extends XmlSimpFormat {
	public AutoWriteOff(Element pThisConf) {
		super(pThisConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into AutoWriteOff.noStd2Std()...");

		Document mStdXml = AutoWriteOffInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		
		JdomUtil.print(pNoStdXml);
		
		//农行传保单号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);		
		Element mConfirmInfo = pNoStdXml.getRootElement().getChild("ConfirmInfo");
		
		//校验系统中是否有相同保单正在处理，尚未返回
		int tLockTime = 300;	//默认超时设置为5分钟(300s)；如果未配置锁定时间，则使用该值。
		try {
			tLockTime = Integer.parseInt(cThisBusiConf.getChildText(locktime));
		} catch (Exception ex) {	//使用默认值
			cLogger.debug("未配置锁定时间，或配置有误，使用默认值(s)："+tLockTime, ex);
		}
		Calendar tCurCalendar = Calendar.getInstance();
		tCurCalendar.add(Calendar.SECOND, -tLockTime);
		
		System.out.println("ConfirmInfo.getChildText(OldTranNo) = " + mConfirmInfo.getChildText("OldTranNo"));
		
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where FuncFlag = '400' and ContNo =  '"+mBodyEle.getChildText("ContNo")+"' ";
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where ContNo in (select ContNo from TranLog where TranNo = '"+mConfirmInfo.getChildText("OldTranNo")+"') and MakeDate= '"+DateUtil.get8Date(tCurCalendar)+"' and FuncFlag in('400','401')";
			mSSRS = new ExeSQL().execSQL(mSqlStr);
			if (1 != mSSRS.MaxRow) {
				throw new MidplatException("查询上一交易日志失败！");
			}
		}
		
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));	
		
		cLogger.info("Out AutoWriteOff.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into AutoWriteOff.std2NoStd()...");

		Document mNoStdXml = AutoWriteOffOutXsl.newInstance().getCache()
				.transform(pStdXml);
		
		cLogger.info("Out AutoWriteOff.std2NoStd()!");
		return mNoStdXml;
	}
}