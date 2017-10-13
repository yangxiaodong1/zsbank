package com.sinosoft.midplat.ccb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/*
	 *	���зǱ�׼����ת��Ϊ���ı�׼����  
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		String mPayMode = XPath.newInstance("/Transaction/Transaction_Body/BkPayMode").valueOf(pNoStdXml.getRootElement());
		
		if("1".equals(mPayMode)){
			/*
			 * ����ͨ���������Ķ˼�¼�Ľɷѷ�ʽΪA�����д��ۣ������Բ��ô��ݽɷѷ�ʽ�����ģ�������ͨ��֧���ֽ�ɷѡ�
			 * 1=�ֽ�,2=�۴���,3=������,9=�Թ�����
			 */
			throw new MidplatException("����ͨ������֧���ֽ�ɷѣ�");
		}
		Document mStdXml =  ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//���д���һ����ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
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
	
	/* 
	 * ���ı�׼����ת��Ϊ���зǱ�׼����
	 */
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		
		// ��ȡ��Ʒ��ϴ���
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
			
		if("50002".equals(tContPlanCode)){ 
		    // 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CCB_�������У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else if("50006".equals(tContPlanCode)){ 
		    // 50006: ������Ӯ1������ռƻ�,2014-08-29ͣ��
		    mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CCB_�������У�����ContConfirmOutXsl50006���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}else{
		    //�����ֳ���
		    // ��ȡ���յ�riskcode
		    String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
		    if(newTemplate(mainRiskCode)){ // 122035-����ʢ��9����ȫ���գ������ͣ�,L12052-�������Ӯ1�������
		        
		        mNoStdXml = ContConfirmOutXsl122035.newInstance().getCache().transform(pStdXml);
		        cLogger.info("CCB_�������У�����ContConfirmOutXsl122035���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
		    }else{ // ���������ߴ�ͳģ�����xml�ļ�ת��
		        
		        mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		        cLogger.info("CCB_�������У�����ContConfirmOutXsl���б���ת������Ʒ����riskCode=[" + mainRiskCode + "]");
		    }
		}
		
		List<Element> mDetail_list = mNoStdXml.getRootElement().getChild("Transaction_Body").getChildren("Detail_List");
		for (Element e : mDetail_list) {
			Element tDetail = e.getChild(Detail);
			Element tBkRecNum = e.getChild("BkRecNum");
			List<Element> tBkDetail1 = tDetail.getChildren("BkDetail1");
			tBkRecNum.setText(String.valueOf(tBkDetail1.size()));
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	/**
	 * �����µĴ�ӡģ��
	 * @param cRiskCode
	 * @return
	 */
	private boolean newTemplate(String cRiskCode){
		
		return ("122035".equals(cRiskCode) || "L12052".equals(cRiskCode));
	}
	public static void main(String[] args) throws Exception{

    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/ccb/2.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/22.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/

    	Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
