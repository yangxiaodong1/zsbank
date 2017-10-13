package com.sinosoft.midplat.bjbank.format;

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


public class NewCont extends XmlSimpFormat {
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // �Ǳ�׼����
		
			
//		// ְҵ��֪��:����ְҵ��֪У�飬�����д�"��"����˱���ͨ�����������ߴ�"��"����˱�ͨ����
//		String jobNotice = XPath.newInstance("//OLifEExtension/OccupationIndicator").valueOf(rootNoStdEle);
//		if("Y".equals(jobNotice)){
//			throw new MidplatException("����ͨ����������������ְҵ��֪����");
//		}

		//����ͨУ�飺���ɷ���ʽ���ֶ�ֻ��ѡ������ת�ˣ�
		//1���ֽ�
		//2������ת�ˣ� //Risk[RiskCode=MainRiskCode]/RiskCode
		//���ڱ�����������ֶβ���ֵ����������ֽ����������Բ�����У����
//		String payMode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayMode").valueOf(rootNoStdEle);
//		if("2".equals(payMode)){	
//			// donothing...
//		}else{
//			throw new MidplatException("���ɷ���ʽ���ֶ�ֻ��ѡ������ת��");
//		}
		//����ͨУ�飺���˻��������롰Ͷ����������һ�£�����Ĭ��Ͷ��������Ϊ�˻�����
		//�˻�����
//		String accName = XPath.newInstance("/TranData/LCCont/AccName").valueOf(rootNoStdEle);
//		//Ͷ��������
//		String appntName =  XPath.newInstance("/TranData/LCCont/LCAppnt/AppntName").valueOf(rootNoStdEle);
//		if(appntName != null && !"".equals(appntName.trim()) && accName != null && !"".equals(accName.trim())){
//			if(appntName.equals(accName)){	
//				// donothing...
//			}else{
//				throw new MidplatException("���˻��������롰Ͷ����������һ��");
//			}
//		}else {
//			throw new MidplatException("���˻���������Ͷ����������Ϊ��ֵ");
//		}
		mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		//50002���б���¼��Ϊ��������ͨת��
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(mStdXml.getRootElement());
		//PBKINSR-673 ��������ʢ2��ʢ3��50002��Ʒ����
		if("50015".equals(riskCode)){
			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(mStdXml.getRootElement());
			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
				// ¼��Ĳ�Ϊ������
				throw new MidplatException("���ݴ��󣺸��ײͱ����ڼ�Ϊ������");
			}
			// �����ڼ���Ϊ��5��
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}
		
		//��ȡ���ִ���������˴�Ϊ��δת��Ϊ��׼���ĵ����б���
		
		
		cLogger.info("BJBANK_�������У�����NewContInXsl���б���ת��");
		
		//--------------------------------------------------------�������뱻�����˹�ϵ���⴦�� begin ----------------------------------------
		//�˴���Ҫ���⴦�����ڱ������д����������뱻�����˹�ϵΪ1���ӡ�2��Ů��3ĸ�ӡ�4ĸŮ�������չ�˾��Ӧ�Ĵ���Ϊ01��ĸ��03��Ů���޷�ת��
		//���ԣ�����xsl��������01��ĸ���ڴ˴������⴦��һ��
		Element rootStdEle = mStdXml.getRootElement(); // �Ǳ�׼����
		//�������뱻�����˹�ϵ
		List bnfs =  XPath.selectNodes(rootStdEle, "/TranData/Body/Bnf[RelaToInsured=01]");
		//��������֤������
		String insuredIDType = XPath.newInstance("/TranData/Body/Insured/IDType").valueOf(rootStdEle);
		//������������
		String insuredBirth = XPath.newInstance("/TranData/Body/Insured/Birthday").valueOf(rootStdEle);
			
		//֤������Ϊ���֤
		if("0".equals(insuredIDType)){
			//��������֤����
			String insuredIDNo = XPath.newInstance("/TranData/Body/Insured/IDNo").valueOf(rootStdEle);
			
			if(insuredIDNo != null){
				//���֤����Ϊ15λʱ������ȡ6λ�����֤����Ϊ18λʱ������ȡ8λ
				if(insuredIDNo.length() == 15){
					insuredBirth = "19" + insuredIDNo.substring(6, 12);
				}else {
					insuredBirth = insuredIDNo.substring(6, 14);
				}
			}
			
			//���������մ���
			if(bnfs != null && bnfs.size() > 0){
				for(int i = 0 ; i < bnfs.size() ; i ++ ){
					Element bnf = (Element)bnfs.get(i);
					//������֤������
					String bnfIDType = bnf.getChildText("IDType");
					//������֤����
					String bnfIDNo =  bnf.getChildText("IDNo");
					//�����˳�������
					String bnfBirth = bnf.getChildText("Birthday");
					//֤������Ϊ���֤
					if(bnfIDType != null && "0".equals(bnfIDType)){
						//���֤����Ϊ15λʱ������ȡ6λ�����֤����Ϊ18λʱ������ȡ8λ
						if(bnfIDNo.length() == 15){
							bnfBirth = "19" + bnfIDNo.substring(6, 12);
						}else {
							bnfBirth = bnfIDNo.substring(6, 14);
						}
					}
					
					if(insuredBirth != null && insuredBirth.length() > 0 && bnfBirth != null && bnfBirth.length() > 0){
						if(bnfBirth.compareTo(insuredBirth) > 0){

							//�����˱ȱ�����������С����ϵΪ��Ů
							bnf.getChild("RelaToInsured").setText("03");
						}else {
							//�����˱ȱ�����������󣬹�ϵΪ��ĸ
							bnf.getChild("RelaToInsured").setText("01");
						}
					}
				}
			}
		}
		//--------------------------------------------------------�������뱻�����˹�ϵ���⴦�� end ----------------------------------------
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		//���׳ɹ���־
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		
		
//		String tContPlanCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		// MODIFY 20140319 PBKINSR-311 ��ͬģ���ӡ�����ֵ�����
		//PBKINSR-673 ��������ʢ2��ʢ3��50002��Ʒ����
		if("50015".equals(tContPlanCode)){	
		    // 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
			mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}
		
		
		
		//��̬���������ֶ�
		if (tFlag.equals("0")){
		    //�ɹ����صı���
			Element printEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print");
			Element print1Ele  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print/Print1");
		    // �������������к�
			List<Element> page1PrintList = print1Ele.getChildren("Page1Print");
			// �����к�
            Element mRowNumEle1 = new Element("Page1Count");
            
            mRowNumEle1.setText(page1PrintList.size() + "");
            printEle.addContent(mRowNumEle1);
            
            // �������������к�
            Element print2Ele  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print/Print2");
            // �����к�
            Element mRowNumEle2 = new Element("Page2Count");
            if(print2Ele != null){
            	List<Element> page2PrintList = print2Ele.getChildren("Page2Print");
                mRowNumEle2.setText(page2PrintList.size() + "");
            }
            else {
            	mRowNumEle2.setText("0");
            }
			
            printEle.addContent(mRowNumEle2);
		}
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("e:/13966_99_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("e:/13966_99_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}