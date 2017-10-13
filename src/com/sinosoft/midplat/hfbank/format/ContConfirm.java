package com.sinosoft.midplat.hfbank.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
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
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0' and FuncFlag = '3500' and ContNo = '"
			+ mBodyEle.getChildText(ContNo) + "' " 
			+ " and ProposalPrtNo = '"+mBodyEle.getChildText(ProposalPrtNo)+"'"
			+ " and Makedate ='" + DateUtil.getCur8Date() + "' order by Maketime desc";
		
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");
		Document mNoStdXml = null;
		
		mNoStdXml = ContConfirmOutXsl50015.newInstance().getCache().transform(pStdXml);
		
//		Element rootEle = pStdXml.getRootElement();
//		// ��ȡ��Ʒ��ϴ���
//		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
//		
//		if(null == tContPlanCode || "".equals(tContPlanCode)){	// ���ǲ�Ʒ��ϵķ��ر���
//			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
//			cLogger.info("hfbank_������У�ContConfirmOutXsl���б���ת��(�ǲ�Ʒ���)����Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
//		}else if("50015".equals(tContPlanCode)){
//			mNoStdXml = ContConfirmOutXsl50015.newInstance().getCache().transform(pStdXml);
//			cLogger.info("hfbank_������У�����ContConfirmOutXsl50015���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
//		}
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		
	}
}
