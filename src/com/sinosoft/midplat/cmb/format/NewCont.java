package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.text.DecimalFormat;

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
 
		//ת����׼����
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//��ȡ�ײʹ���
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());
		
        //���ײͳ���
        //PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ����
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
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		//�ײʹ���
		String  contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if(!"".equals(contPlanCode)){
		    //���ײͳ���
			mNoStdXml = NewContOutXslForPlan.newInstance().getCache().transform(pStdXml);
		}else{	
		    //�����ֳ���
		    mNoStdXml= NewContOutXsl.newInstance().getCache().transform(pStdXml);
        }

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/����/abc.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/cmb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/cmb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
		
		
		System.out.println("******ok*********");
    }
}