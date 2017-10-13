package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.cmb.format.ContConfirmForNetBank.java
 * @Description: ��������ǩ������
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Nov 19, 2014 6:50:25 PM
 * @version 
 *
 */
public class ContConfirmForNetBank extends XmlSimpFormat {

	//�˻���
	Element accNum = new Element("AccountNumber");
	//�˻���
	Element accName = new Element("AcctHolderName");
	
	public ContConfirmForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForNetBank.noStd2Std()...");
		
		Document mStdXml = ContConfirmForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		
		// ����Ͷ�����Ŵ�TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		//�����˻���Ϣ���ش�������
		accName = (Element)mBodyEle.getChild("AcctHolderName").detach();
		accNum = (Element)mBodyEle.getChild("AccountNumber").detach();
		
		// ��������funflag=1012
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo,Makedate,Maketime from TranLog ");
		mSqlStr.append(" where Rcode = '0' and Funcflag = '1012'");
		mSqlStr.append("   and ProposalPrtNo = '"+mBodyEle.getChildText("ProposalPrtNo")+"'");
		mSqlStr.append("   and Makedate ="+ DateUtil.getCur8Date());
		mSqlStr.append(" order by Maketime desc");
		
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (mSSRS.MaxRow < 1) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		cLogger.info("Out ContConfirmForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirmForNetBank.Std2StdnoStd()...");
		//modify 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ begin
		Document mNoStdXml = null;
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		if(tContPlanCode != null && !"".equals(tContPlanCode.trim())){//��Ʒ���
			mNoStdXml = ContConfirmForNetBankContPlanOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_�������У�����ContConfirmForNetBankContPlanOutXsl���б���ת����contPlanCode=[" + tContPlanCode + "]");
		}else{
			mNoStdXml = ContConfirmForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		} 
		//modify 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ end
		Element tHeadEle = pStdXml.getRootElement().getChild(Head);
		int mFlagInt = Integer.parseInt(tHeadEle.getChildText(Flag));
		if(CodeDef.RCode_OK == mFlagInt){// ���׳ɹ�����Body����riskcode
			
			//�ش��˻���Ϣ
			Element ePolicy = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//OLife/Holding/Policy");
			if(ePolicy != null){
				ePolicy.addContent(9,accName);
				ePolicy.addContent(10,accNum);
			}
		}

		cLogger.info("Out ContConfirmForNetBank.Std2StdnoStd()!");
	
		return mNoStdXml;
	}

	
    public static void main(String[] args) throws Exception {
        Document doc = JdomUtil.build(new FileInputStream("d:/L12052_outSvc.xml"));
        
        ContConfirmForNetBank con = new ContConfirmForNetBank(null);
        
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("d:/L12052_out.xml")));
        out.write(JdomUtil.toStringFmt(con.std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
