package com.sinosoft.midplat.hxb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

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

public class ContConfirm extends XmlSimpFormat{

	private String appNo = "";	// ���ع����е�Ͷ������
	
	public ContConfirm(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);	
		
		//���б��
		String trancom = XPath.newInstance("Head/TranCom").valueOf(mStdXml.getRootElement()) ;
		//�������У��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ");
		mSqlStr.append("  proposalprtno='" + mBodyEle.getChildTextTrim(ProposalPrtNo)+"'");
		mSqlStr.append("  and OtherNo='" + mBodyEle.getChildTextTrim(ContPrtNo)+"'");
		mSqlStr.append("  and trandate=" + DateUtil.getCur8Date());
		mSqlStr.append("  and rcode=0 and Funcflag = '1501'");
		mSqlStr.append("  and trancom="+trancom);
		mSqlStr.append(" order by Maketime desc");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (mSSRS.MaxRow < 1) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		appNo = mBodyEle.getChildTextTrim(ProposalPrtNo);
		
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
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			// 50015: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_�������У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add 20150807 ���Ӱ���3�źͰ���5��  begin
		else if("50011".equals(tContPlanCode)){ 
			// 50011: L12068-����ٰ���3������ա�L12069-����ӳ�������3����ȫ���գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_�������У�����ContConfirmOutXsl50011���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else if("50012".equals(tContPlanCode)){ 
			// 50012: L12070-����ٰ���5������ա�L12071-����ӳ�������5����ȫ���գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_�������У�����ContConfirmOutXsl50012���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		
		//add 20150807 ���Ӱ���3�źͰ���5��  end
		else{
			//�����ֳ���
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("hxb_�������У�����ContConfirmOutXsl���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
		}		
		
		Element mainEle = mNoStdXml.getRootElement().getChild("MAIN");
		
		Element mHeadEle = pStdXml.getRootElement().getChild(Head);
		
		if(String.valueOf(CodeDef.RCode_ERROR).equals(mHeadEle.getChildText(Flag))){	//1-����ʧ��
			if(appNo==null || appNo.equals("")){	// Ͷ�����Ų�����
				// do nothing...����ط������׳��쳣����Ȼ�����ش��������߼�ʱ������appNoΪ�����쳣�����������ش��޷�ִ��
			}else{
				Element appNoEle = new Element("APP");
				appNoEle.setText(appNo);
				mainEle.addContent(appNoEle);	
			}
		}
	
		if (String.valueOf(CodeDef.RCode_OK).equals(mHeadEle.getChildText(Flag))) {  //0-���׳ɹ�
			
			// ���������
			List mPAGE_LISTList = XPath.selectNodes(mainEle, "//FILE_LIST/PAGE_LIST");
			for (int i = 0; i < mPAGE_LISTList.size(); i++) {
				
				Element mmPAGE_LISTListEle = (Element) mPAGE_LISTList.get(i);
                List mBKDETAILList = XPath.selectNodes(mmPAGE_LISTListEle, "Detail/BKDETAIL");
                mmPAGE_LISTListEle.getChild("DETAIL_COUNT").setText(String.valueOf(mBKDETAILList.size()));
			}
		}
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/����/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
	
}
