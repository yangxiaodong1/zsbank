package com.sinosoft.midplat.drcbank.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

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
		
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0' and Funcflag = '2900' " +
	    		" and ProposalPrtNo = '"+ mBodyEle.getChildText(ProposalPrtNo)+"' " +
	    		" and TranNo = '"+ mBodyEle.getChildText("OrigTranNo")+"' " +
//	    		" and OtherNo= '"+ mBodyEle.getChildText(ContPrtNo)+"' " +
	    		" and Makedate ='" + DateUtil.getCur8Date() + "' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
        }
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
//		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		mBodyEle.removeChild("OrigTranNo");
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		
		// ��ȡ��Ʒ��ϴ���
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		
		if(null == tContPlanCode || "".equals(tContPlanCode)){	// ���ǲ�Ʒ��ϵķ��ر���
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("DRCBANK_��ݸũ���У�ContConfirmOutXsl���б���ת��(�ǲ�Ʒ���)����Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else if("50015".equals(tContPlanCode)){	// �ǲ�Ʒ��Ϸ��صı���,��Ʒ�Ѵ�50002����Ϊ50015

			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("DRCBANK_��ݸũ���У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		
		//Ŀǰֻ��50002��Ʒ
//		else{
//			//�����ֳ���
//			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
//			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
//			cLogger.info("DRCBANK_��ݸũ���У�����ContConfirmOutXsl���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
//		}
		
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		
	}
}
