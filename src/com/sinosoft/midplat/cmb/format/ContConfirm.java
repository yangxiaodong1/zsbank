package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class ContConfirm extends XmlSimpFormat {
	
	//�˻���
	Element accNum = new Element("AccountNumber");
	//�˻���
	Element accName = new Element("AcctHolderName");
	
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		
		Document mStdXml = null;
		mStdXml = new NewCont(cThisBusiConf).noStd2Std(pNoStdXml);
		
		//�����˻���Ϣ���ش�������
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		accName.setText(mBodyEle.getChildTextTrim(AccName));
		accNum.setText(mBodyEle.getChildTextTrim(AccNo));
		
		// removed PBKINSR-293 20140321
//		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
//		
//		// ����Ͷ�����Ŵ�TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
//		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
//		//�����˻���Ϣ���ش�������
//		accName = (Element)mBodyEle.getChild("AcctHolderName").detach();
//		accNum = (Element)mBodyEle.getChild("AccountNumber").detach();
//		
//		StringBuffer mSqlStr = new StringBuffer();
//		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo,Makedate,Maketime from TranLog ");
//		mSqlStr.append(" where Rcode = '0' and Funcflag = '1000'");
//		mSqlStr.append("   and ProposalPrtNo = '"+mBodyEle.getChildText("ProposalPrtNo")+"'");
//		mSqlStr.append("   and Makedate ="+ DateUtil.getCur8Date());
//		mSqlStr.append(" order by Maketime desc");
//		
//		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//		if (mSSRS.MaxRow < 1) {
//			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
//		}
//		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");
		
		Document mNoStdXml = null;

		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		if(null == tContPlanCode || "".equals(tContPlanCode)){	// ���ǲ�Ʒ���

			//��ȡ���մ���
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
			if(newTemplate(mainRiskCode)){ // 122035-����ʢ��9����ȫ���գ������ͣ�,L12052-�������Ӯ1�������
				mNoStdXml = ContConfirmOutXsl122035.newInstance().getCache().transform(pStdXml);
			} else { // ��������
				mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			}
			cLogger.info("CMB_�������У�����ContConfirmOutXsl���б���ת������������riskCode=[" + mainRiskCode + "]");
			//PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ����
		}else if("50015".equals(tContPlanCode)){
			// 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�����������������գ������ͣ����
			
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_�������У�����ContConfirmOutXsl50002���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 20150723  ���Ӱ���3����ϲ�Ʒ   begin
		else if("50011".equals(tContPlanCode)){
			// 50011: L12068-����ٰ���3������ա�L12069-����ӳ�������3����ȫ���գ������ͣ����		
			mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_�������У�����ContConfirmOutXsl50011���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 20150723  ���Ӱ���3����ϲ�Ʒ   end
		
		else if("50006".equals(tContPlanCode)){
            // �������Ӯ1��,2014-08-29ͣ��
            
            mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
            cLogger.info("CMB_�������У�����ContConfirmOutXsl50006���б���ת������Ʒ��ϱ���contPlanCode=[" + tContPlanCode + "]");
        }
		
		System.out.println(JdomUtil.toStringFmt(mNoStdXml));
	    
	    // ���Ӷ�̬��ӡ���кŵȲ���
		Element tBasePlanPrintInfosEle = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//BasePlanPrintInfos");
		if(tBasePlanPrintInfosEle!=null){
			//������ӡ�ڵ�
			Element contPrintEle = (Element)tBasePlanPrintInfosEle.getChild("ContPrint").detach();
			//�ֽ��ֵ��ӡ�ڵ�
			Element cashValueEle = (Element)tBasePlanPrintInfosEle.getChild("CashValue").detach();
			if(cashValueEle.getChildren("PrintInfo").size()>0){
				//��ӡ�ֽ��ֵ����
				int contLength = contPrintEle.getChildren("PrintInfo").size();
				//�Թ̶�����Ϊһҳ�����л�ҳ��Ŀǰ�ݶ�66��Ϊһҳ
				for(int i=66-contLength; i>0; i--){
					//����ҳ����66�еģ�������
					Element mPrintInfoEle = new Element("PrintInfo");
					contPrintEle.addContent(mPrintInfoEle);
				}
			}
	
			//����PrintInfo�ڵ㼯�д���
			List<Element> tPrintInfoList = new ArrayList<Element>();
			tPrintInfoList.addAll(contPrintEle.getChildren("PrintInfo"));
			tPrintInfoList.addAll(cashValueEle.getChildren("PrintInfo"));
			for (int i = 0; i < tPrintInfoList.size(); i++) {
				Element tBasePlanPrintInfo = new Element("BasePlanPrintInfo");
				Element tPrintInfoEle = (Element) tPrintInfoList.get(i).detach();
				String info = tPrintInfoEle.getText();
				if(!"".equals(info.trim())){
					//�ǿ���
					//@�������ַ������н���ʱ������˿�ͷ�Ŀո�
					tPrintInfoEle.setText("@"+info);
				}
				tBasePlanPrintInfo.addContent(tPrintInfoEle);
				// �����к�
				Element mInfoIndexEle = new Element("InfoIndex");
				mInfoIndexEle.setText(String.valueOf(i + 1));
				tBasePlanPrintInfo.addContent(mInfoIndexEle);
				tBasePlanPrintInfosEle.addContent(tBasePlanPrintInfo);
			}
	        
			//�ش��˻���Ϣ
			Element ePolicy = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//OLife/Holding/Policy");
			if(ePolicy != null){
				ePolicy.addContent(9,accName);
				ePolicy.addContent(10,accNum);
			}
	        
		}
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
	
		return mNoStdXml;
	}

	/**
	 * �����µĴ�ӡģ��
	 * @param cRiskCode
	 * @return
	 */
	private boolean newTemplate(String cRiskCode){
		//PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ����
		return ("L12074".equals(cRiskCode) || "L12052".equals(cRiskCode));
	}
	
    public static void main(String[] args) throws Exception {
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        
        ContConfirm con = new ContConfirm(null);
        
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
                        new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(con.std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
