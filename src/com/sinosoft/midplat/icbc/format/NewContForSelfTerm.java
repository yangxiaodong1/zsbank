package com.sinosoft.midplat.icbc.format;

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

public class NewContForSelfTerm extends XmlSimpFormat {
	
	public NewContForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContInXslForSelfTerm.noStd2Std()...");
		
		//��ȡ���մ��룬�˴�Ϊ��δת��Ϊ��׼���ĵ����б���
		Document mStdXml = NewContInXslForSelfTerm.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();

        //У�鱨���ֶ�
        String tranCom = XPath.newInstance("//Head/TranCom").valueOf(stdRootEle);
        String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
        if(errorMsg!=null){
            throw new MidplatException(errorMsg);
        }
        
        //��ȡ�ײʹ���
        String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
        //<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		if("50015".equals(contPlanCode)){
            // �������Ӯ1��
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
            //�������ڼ�����Ϊ��5��
            insuYearFlag.setText("Y");
            insuYear.setText("5");
        }
		
		cLogger.info("Out NewContInXslForSelfTerm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");
		Document mNoStdXml = new NewCont(this.cThisBusiConf).std2NoStd(pStdXml);
		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForSelfTerm(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}