package com.sinosoft.midplat.bjrcb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	@SuppressWarnings("unchecked")
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Element noStdRootEle = pNoStdXml.getRootElement();
		String jobNotice = XPath.newInstance("//PolicyInfo/DangerInf").valueOf(noStdRootEle).trim();
		String tCusAnnualIncome = XPath.newInstance("//PolicyHolder/CustomsGeneralInfo/CusAnnualIncome").valueOf(noStdRootEle).trim();
		
		if("Y".equals(jobNotice)){
			throw new MidplatException("����ͨ��������������Σ��ְҵ��֪"); 
		}
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();
		/*
		 * ���ֶΰ���������+�ͻ�����+��ͥ�����룻
		 * ����������ͼ�ͥ�������Ϊ������ƴ�ӽ��Ϊ123.0300009
		 * �����С����ǰ��Ϊ�����룬С������һλ�Ǳ�־λ��0Ϊ����1Ϊũ�壻
		 * �����ַ������һλ9Ϊ�˷�ֹϵͳ�Զ���0ȥ�����������һλ��9�ǹ̶�ֵ������
		 * 123.0300009 ������=123Ԫ��0���򣬼�ͥ������=30000Ԫ
		 * 123.1300009 ������=123Ԫ��1ũ�壬��ͥ������=30000Ԫ
		 * 
		 * Ͷ���˾�ס�أ�
		 * ���У�0Ϊ����1Ϊũ�壻���ģ�1Ϊ����2Ϊũ�壻
		 * ���뵥λ��
		 * ���У�Ԫ�����ģ���
		 */
		if((tCusAnnualIncome!=null) && (!tCusAnnualIncome.equals(""))){
			String []tArray = tCusAnnualIncome.split("\\.");
			
			Element tAppntEle = stdRootEle.getChild(Body).getChild(Appnt);
			// Ͷ����������
			String tSalary = "";
			if((tArray[0]!=null) && (!tArray[0].equals(""))){
				tSalary = String.valueOf(NumberUtil.yuanToFen(tArray[0]));	
			}
			tAppntEle.getChild("Salary").setText(tSalary);
			
			// Ͷ���˾�ס��
			String tLiveZone = "";
			if(tArray[1].substring(0, 1).equals("0")){	// ����
				tLiveZone = "1";	
			}else{	// ũ��
				tLiveZone = "2";
			}
			tAppntEle.getChild("LiveZone").setText(tLiveZone);

			// Ͷ���˼�ͥ������
			String tFamilySalary = tArray[1].substring(1, (tArray[1].length()-1));
			if((tFamilySalary!=null) && (!tFamilySalary.equals(""))){
				tFamilySalary = String.valueOf(NumberUtil.yuanToFen(tFamilySalary));	
			}
			tAppntEle.getChild("FamilySalary").setText(tFamilySalary);
		}
		
		/*
		 * ��ϲ�Ʒ50002(50015)�ı�������Ϊ���������Ǻ��Ķ˶���ı�������Ϊ������122046Ϊ���ݣ�����5��
		 * �����Ͳ�Ʒ���и��죬��Ӯ��Ʒ���ײʹ�����50002���Ϊ50015
		 */
		String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
		if("50015".equals(contPlanCode)){	// ��ϲ�Ʒ50002(50015)
			
			//У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
			Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
			Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
			if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
				//¼��Ĳ�Ϊ������
				throw new MidplatException("���ݴ��󣺸��ײͱ����ڼ�Ϊ������"); 
			}
			//�������ڼ�����Ϊ��5��
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}
		
		//����Ͷ����ְҵ����
		Object appJobCodeEle = XPath.selectSingleNode(stdRootEle, "Body/Appnt/JobCode");
		if(appJobCodeEle !=null){
		    Element temp = (Element)appJobCodeEle;
		    String outCode = temp.getText();
		    temp.setText(NewContJobCode.newInstance().getJobCode(outCode));
		}
		
		//���ñ�����ְҵ����
		Object insuJobCodeEle = XPath.selectSingleNode(stdRootEle, "Body/Insured/JobCode");
		if(insuJobCodeEle !=null){
		    Element temp = (Element)insuJobCodeEle;
		    String outCode = temp.getText();
		    temp.setText(NewContJobCode.newInstance().getJobCode(outCode));
		}
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");

		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/906438_371_1200_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}