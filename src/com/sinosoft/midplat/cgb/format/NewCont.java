package com.sinosoft.midplat.cgb.format;

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

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisConf) {  // ����������
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Document mStdXml = NewContInXsl.newInstance().getCache().transform(
				pNoStdXml);             //yxd�����д��ݹ����ı���ת��Ϊ������Ҫ�ı��ĸ�ʽ��NewContInXsl����û��getCache����transform ����ѽ��
        //�ײʹ���,��50002����Ϊ50015
        String riskCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());//yxd NewContln.xml��ContPlan/ContPlanCode·������Ĳ�Ʒ��ϱ���ֵ
        if("50015".equals(riskCode)){ //yxd���50015��������մ�����ͬ��ִ���������
            //������Ӯ�ײ�
            //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());//yxd��ñ������������־Ԫ��
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());//yxd ������������ Ԫ��
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){ //yxd ����������������־ֵ������A�����������䲻����106 ִ���������
                //¼��Ĳ�Ϊ������
               throw new MidplatException("���ײͱ����ڼ�Ϊ������"); //yxd �������������׳��쳣�����ײͱ������Ϊ������
            }
            //�������ڼ�����Ϊ��5��
            insuYearFlag.setText("Y"); //yxd ���ñ������������־λ�ꡮY��
            insuYear.setText("5"); //yxd �������ڼ�����Ϊ5�꣬ �� ¼�벻Ϊ��������������������
        }
		cLogger.info("Out NewCont.noStd2Std()!"); //yxd������仰��Ϊ��־
		return mStdXml; //yxd���ظ�ʽ���ı��� ���ɻ������ǽ���������������ֱ�ӷ��������û�����ְ����ݸ����ı��չ�˾
	}

	public Document std2NoStd(Document pStdXml) throws Exception {//yxd 
		cLogger.info("Into NewCont.std2NoStd()...");

		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(
				pStdXml);//yxd ת����Ӧ���ĵĸ�ʽ����װ��������Ҫ����

		cLogger.info("Out NewCont.std2NoStd()!");//�����־
		return mNoStdXml;//yxd ����Ӧ����
	}
	
	 public static void main(String[] args) throws Exception{
	     Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\����\\abc.xml"));//�������ϵ�abc.xml�ĵ� ��װΪ��֪���ļ��ĸ�ʽ����������
	        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
         out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));//yxd ��ת���õĸ�ʽ����д�뵽����abc_out.xml��
         out.close();
         System.out.println("******ok*********");
     }
}