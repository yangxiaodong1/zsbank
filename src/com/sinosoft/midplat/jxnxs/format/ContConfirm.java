package com.sinosoft.midplat.jxnxs.format;

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

public class ContConfirm extends XmlSimpFormat {

	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	private String transrNo = "";
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		
		transrNo = XPath.newInstance("//MAIN/TRANSRNO").valueOf(pNoStdXml.getRootElement());
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0' and Funcflag = '2500' " +
	    		" and ProposalPrtNo = '"+ mBodyEle.getChildText(ProposalPrtNo)+"' " +
	    		" and TranNo=" + mBodyEle.getChildText("OrigTranNo") +
	    		" and Makedate ='" + DateUtil.getCur8Date() + "' " +
	    				"order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
        }
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		//��֤�������д�
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
		//���׳ɹ���־
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		
		if("50015".equals(tContPlanCode)){ 
			// 50015: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			cLogger.info("JXNXS_����ũ���У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("JXNXS_����ũ���У�����ContConfirmOutXsl���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
		}
		
		
		
		//�ڷ�����Ϣ���������н�����ˮ��
		Element rootNoStdEle = mNoStdXml.getRootElement();
		Element transrNoEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//MAIN/TRANSRNO");
		transrNoEle.setText(transrNo);
		
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("E:/work/test/Jxnxs/1.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/work/test/Jxnxs/2.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}
