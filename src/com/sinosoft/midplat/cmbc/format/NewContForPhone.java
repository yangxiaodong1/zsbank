package com.sinosoft.midplat.cmbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContForPhone extends XmlSimpFormat {
	public NewContForPhone(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.noStd2Std()...");
		
		Document mStdXml = NewContForPhoneInXsl.newInstance().getCache().transform(pNoStdXml);
		
//		JdomUtil.print(pNoStdXml);
		
		Element rootStdEle = mStdXml.getRootElement();
		//50002���б���¼��Ϊ��������ͨת��
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootStdEle);

		
		//Ӧ����Ҫ��,����ͨ���� Ͷ����������ǿյ�У��
		//У�鱨���ֶ�
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(rootStdEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		//PBKINSR-682 ��������ʢ2��ʢ3��50002��Ʒ����
		if("50015".equals(riskCode)){
			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(rootStdEle);
			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(rootStdEle);
			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
				// ¼��Ĳ�Ϊ������
				throw new MidplatException("���ݴ��󣺸��ײͱ����ڼ�Ϊ������");
			}
			// �����ڼ���Ϊ��5��
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}
		/**
		 * �޸���������Ͷ���˼��������˵�ַ���̶��绰���⣺�ѵ�ַ�еġ�-��ͳһ�滻�ո񣻵绰�еġ�-��ͳһȥ��
		 */
		 //���������ĵ�ַ���滻��-��Ϊ�ո�

        List<Element> addressList = XPath.selectNodes(rootStdEle, "//Address");

        if (addressList != null) {

            for (Element valueEle : addressList) {

                String valueRep = valueEle.getText().replaceAll("-", " ");

                valueEle.setText(valueRep);

            }

        }
      //���������ĵ绰��ȥ����-��

        List<Element> phoneList = XPath.selectNodes(rootStdEle, "//Phone");

        if (phoneList != null) {

            for (Element valueEle : phoneList) {

                String valueRep = valueEle.getText().replaceAll("-", "");

                valueEle.setText(valueRep);

            }

        }


		cLogger.info("Out NewContForPhone.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.std2NoStd()...");
		
		Document mNoStdXml = NewContForPhoneOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewContForPhone.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/636314_106_3000_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/636314_106_3000_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForPhone(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
