package com.sinosoft.midplat.cdrcb.format;

//import java.util.List;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

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
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//����һ����ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
//		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo,Makedate,Maketime from TranLog where Rcode = '0' and Funcflag = '2801' and ProposalPrtNo = '"+ mBodyEle.getChildText("ProposalPrtNo")+"' and Makedate ='"
				+ DateUtil.getCur8Date() + "' order by Maketime desc";
		
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (mSSRS.MaxRow <1) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mBodyEle.getChildText("ContPrtNo"));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		// ��ȡ��Ʒ��ϴ���
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		
		if("50015".equals(tContPlanCode)){ 
		    // 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048(L12081)-����������������գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_�ɶ�ũ�����У�����ContConfirmOutXsl50002���б���ת��");
		}
		//add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ50012 ����  begin
		else if("50012".equals(tContPlanCode)){
		    //50012��ϲ�Ʒ������L12070������ٰ���5������� ��L12071������ӳ�������5����ȫ���գ������ͣ�
			mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_�ɶ�ũ�����У�����ContConfirmOutXsl50012���б���ת��");
		}
		//add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ����    end
		else{
			
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CDRCB_�ɶ�ũ�����У�����ContConfirmOutXsl���б���ת��");
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
