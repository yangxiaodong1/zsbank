package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Query extends XmlSimpFormat {

	public Query(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Query.noStd2Std()...");

		Document mStdXml = QueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		cLogger.info("Out Query.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Query.std2NoStd()...");

		String  contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		
		if(null == contPlanCode || "".equals(contPlanCode)){	// �߷ǲ�Ʒ���
			mNoStdXml = QueryOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_�������У�QueryOutXsl���б���ת��");
		}else{	 
			// �߲�Ʒ���
			cLogger.info("CMB_�������У�����QueryOutXslForPlan���б���ת������Ʒ��ϱ���contPlanCode=[" + contPlanCode + "]");
			if("50002".equals(contPlanCode)){
                // �������Ӯ1����ȫ����

                //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǵ��ײͱȽ�����
                Element insuYearFlag = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(pStdXml.getRootElement());
                Element insuYear = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(pStdXml.getRootElement());

                //�������ڼ�����Ϊ������
                insuYearFlag.setText("Y");
                insuYear.setText("100");
            }
            
        	mNoStdXml = QueryOutXslForPlan.newInstance().getCache().transform(pStdXml);
		}

		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream(
        "D:/�����ĵ�/��������ͨ�ĵ�/��������/03XML����ʵ��/675050_3838_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        System.out.println(JdomUtil.toStringFmt(new Query(null).std2NoStd(doc)));
    }
}
