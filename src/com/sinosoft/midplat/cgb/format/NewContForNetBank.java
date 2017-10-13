package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContForNetBank extends XmlSimpFormat {
	public NewContForNetBank(Element pThisConf) {
		super(pThisConf);
	}

	String TRANSRNO = "";
	String TRANSRDATE = "";
	String INSUID = "";
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.noStd2Std()...");

		TRANSRNO = XPath.newInstance("//TRANSRNO").valueOf(pNoStdXml);
		TRANSRDATE = XPath.newInstance("//TRANSRDATE").valueOf(pNoStdXml);
		INSUID = XPath.newInstance("//INSUID").valueOf(pNoStdXml);
		
		//������
		String zoneno = XPath.newInstance("//ZONENO").valueOf(pNoStdXml);
		//���ִ���
		String mainRiskCode = XPath.newInstance("//PRODUCTS/PRODUCT/PRODUCTID").valueOf(pNoStdXml);
		//��ȡ���ִ���
        if("L12079".equals(mainRiskCode) && !"139000".equals(zoneno)){
        	throw new MidplatException("�ݲ�֧�ִ�ҵ��"); 
        }
		
        String payacc = XPath.newInstance("//MAIN/PAYACC").valueOf(pNoStdXml);
        
		Document mStdXml = NewContInXslForNetBank.newInstance().getCache().transform(
				pNoStdXml);
		
		//�����E����ר����Ʒ��������´�����Ͷ������Ϣ��ֵ����������
		if("L12079".equals(mainRiskCode) && "139000".equals(zoneno)){
        	
			Element appEle = mStdXml.getRootElement().getChild("Body").getChild("Appnt");
			
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Name").setText(appEle.getChild("Name").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Sex").setText(appEle.getChild("Sex").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Birthday").setText(appEle.getChild("Birthday").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("IDType").setText(appEle.getChild("IDType").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("IDNo").setText(appEle.getChild("IDNo").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("IDTypeStartDate").setText(appEle.getChild("IDTypeStartDate").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("IDTypeEndDate").setText(appEle.getChild("IDTypeEndDate").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("JobCode").setText(appEle.getChild("JobCode").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Stature").setText(appEle.getChild("Stature").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Nationality").setText(appEle.getChild("Nationality").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Weight").setText(appEle.getChild("Weight").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("MaritalStatus").setText(appEle.getChild("MaritalStatus").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Address").setText(appEle.getChild("Address").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("ZipCode").setText(appEle.getChild("ZipCode").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Mobile").setText(appEle.getChild("Mobile").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Phone").setText(appEle.getChild("Phone").getText());
			mStdXml.getRootElement().getChild("Body").getChild("Insured").getChild("Email").setText(appEle.getChild("Email").getText());			
			//���¸�ֵ�˻����˺�
			//�˻�
			mStdXml.getRootElement().getChild("Body").getChild("AccName").setText(appEle.getChild("Name").getText());
			//�˺�
			mStdXml.getRootElement().getChild("Body").getChild("AccNo").setText(payacc);		
        }
		
		
		//У�鱨���ֶ�
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(mStdXml);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		
        //�ײʹ���,��50002����Ϊ50015
        String riskCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());
        if("50015".equals(riskCode)){
            //������Ӯ�ײ�
            //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
                //¼��Ĳ�Ϊ������
               throw new MidplatException("���ײͱ����ڼ�Ϊ������"); 
            }
            //�������ڼ�����Ϊ��5��
            insuYearFlag.setText("Y");
            insuYear.setText("5");
        }
        
		cLogger.info("Out NewContForNetBank.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");

		Document mNoStdXml = NewContOutXslForNetBank.newInstance().getCache().transform(
				pStdXml);
		
		Element TRANSRNO_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//TRANSRNO");
		if(TRANSRNO_ELE != null){
			TRANSRNO_ELE.setText(TRANSRNO);
			
			Element TRANSRDATE_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//TRANSRDATE");
			TRANSRDATE_ELE.setText(TRANSRDATE);
			
			Element INSUID_ELE = (Element) XPath.selectSingleNode(mNoStdXml, "//INSUID");
			INSUID_ELE.setText(INSUID);
		}
		
		
		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
	 public static void main(String[] args) throws Exception{
	     Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
	        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
         out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).noStd2Std(doc)));
         out.close();
         System.out.println("******ok*********");
     }
}