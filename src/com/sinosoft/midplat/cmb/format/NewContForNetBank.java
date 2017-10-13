package com.sinosoft.midplat.cmb.format;

import java.io.FileInputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.cmb.format.NewContForNetBank.java
 * @Description: ���������µ����㽻��
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Nov 17, 2014 1:59:36 PM
 * @version 
 *
 */
public class NewContForNetBank extends XmlSimpFormat {

	public NewContForNetBank(Element thisBusiConf) {
		super(thisBusiConf);
	}
	private String mult = "";
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
 
		//ת����׼����
		Document mStdXml = NewContForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		//modify liying begin
		//Ͷ�������������㷵��ʱ��ʱΪ�գ���Ҫ����������ȡֵ
		Element rootNoStdEle = mStdXml.getRootElement(); // ��׼����
		mult = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/Mult").valueOf(rootNoStdEle);
		//modify liying end
		
		//modify liying begin �޸�122035��Ʒ����������
		String riskCode = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootNoStdEle);
		//<!-- PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ���� -->
		if("L12074".equals(riskCode)){
			List risks =  XPath.selectNodes(rootNoStdEle, "/TranData/Body/Risk");
			if(risks != null && risks.size() >1){
				// ����������֧�ָ�����
				throw new MidplatException("����ʢ��9����ȫ���գ������ͣ������������ݲ����۸����գ�");
			}
		}
		//modify liying end 
		//modify 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ begin
		//��ȡ�ײʹ���
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());	
        //���ײͳ���
        if("50015".equals(planCode)){
            // �������Ӯ1����ȫ����
            //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǵ��ײͱȽ�����
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
                //¼��Ĳ�Ϊ������
                throw new MidplatException("�������󣺱����ڼ�ӦΪ����!"); 
            }
            //�������ڼ�����Ϊ��5��
            insuYearFlag.setText("Y");
            insuYear.setText("5");
        }
        //modify 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ end
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		//modify liying begin
		//�ж�Ͷ�����������ķ����Ƿ�Ϊ0������ǣ������������ȡֵ
		Element rootNoStdEle = pStdXml.getRootElement(); // ��׼����
		String stdMult = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/Mult").valueOf(rootNoStdEle);
		if(stdMult == null || "0".equals(stdMult)){
			Element multEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//TranData/Body/Risk[RiskCode=MainRiskCode]/Mult");
			multEle.setText(mult);
		}
		//modify liying end
		//�ײʹ���
		String  contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if(!"".equals(contPlanCode)){
		    //���ײͳ���
			mNoStdXml = NewContForNetBankOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{	
		    //�����ֳ���
			mNoStdXml =  NewContForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
        }
		

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/����/abc.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/cmb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/cmb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).std2NoStd(doc)));*/
		
		System.out.println("******ok*********");
    }

}
