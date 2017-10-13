package com.sinosoft.midplat.cib.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirmForSelfTerm extends XmlSimpFormat {

	public ContConfirmForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForSelfTerm.noStd2Std()...");

		Document mStdXml = ContConfirmForSelfTermInXsl.newInstance().getCache().transform(pNoStdXml);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0' and Funcflag = '2305' " +
	    		" and ProposalPrtNo = '"+ mBodyEle.getChildText(ProposalPrtNo)+"' " +
	    		" and  TranNo=" + mBodyEle.getChildText("OrigTranNo") +
	    		" and Makedate ='" + DateUtil.getCur8Date() + "' " +
	    				"order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
        }
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
//		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		mBodyEle.removeChild("OrigTranNo");
		
		cLogger.info("Out ContConfirmForSelfTerm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirmForSelfTerm.Std2StdnoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		JdomUtil.print(pStdXml);
		// ��ȡ��Ʒ��ϴ���
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		//���׳ɹ���־
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		//PBKINSR-626 ��ҵ��������ͨ�����²�Ʒ��ʢ��3�ţ�
//		if("50015".equals(tContPlanCode)){ 
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			// 50015: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����
			mNoStdXml = ContConfirmForSelfTermOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CIB_��ҵ���У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
//		}
//		else{
//			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
//			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
//			cLogger.info("CIB_��ҵ���У�����ContConfirmOutXsl���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
//		}
		//�����ֳ�����Ŀǰ��ҵ���н���50002��Ʒ�������²�Ʒ������Ӵ���
//		mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		//PBKINSR-626 ��ҵ��������ͨ�����²�Ʒ��ʢ��3�ţ�
//		cLogger.info("CIB_��ҵ���У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		
		cLogger.info("Out ContConfirmForSelfTerm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("d:/652628_870_47_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/dd.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}
