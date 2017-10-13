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
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {

	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
//		Element rootNoStdEle = pNoStdXml.getRootElement(); // �Ǳ�׼����
		
		// ��ϢУ��
//		infoCheck(rootNoStdEle);
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		JdomUtil.print(pNoStdXml);
		
		Element rootStdEle = mStdXml.getRootElement();
		//50002���б���¼��Ϊ��������ͨת��
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootStdEle);
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


		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	/**
	 * �����еı��Ľ��л�������У��
	 * @param tRootNoStdEle
	 * @throws Exception
	 */
	private void infoCheck(Element tRootNoStdEle) throws Exception{
		
		//���������Ƿ����Σ��ְҵ���������Y�ǣ�������ͨУ�鲻ͨ����
		String jobNotice = XPath.newInstance("/INSU/BBR/BBR_METIERDANGERINF").valueOf(tRootNoStdEle);
		if("Y".equals(jobNotice)){
			throw new MidplatException("����ͨ���������������д���Σ��ְҵ");
		}
		//���������Ƿ����ؼ����������Y�ǣ�������ͨУ�鲻ͨ����
		String healthNotice = XPath.newInstance("/INSU/BBR/BBR_HEALTHINF").valueOf(tRootNoStdEle);
		if("Y".equals(healthNotice)){
			throw new MidplatException("����ͨ�����������������ؼ�");
		}
		healthNotice = XPath.newInstance("/HEALTH_NOTICE/NOTICE_ITEM").valueOf(tRootNoStdEle);
		//������֪
		if("Y".equals(healthNotice)){
			throw new MidplatException("����ͨ�������н�����֪");
		}
		String tPhone = XPath.newInstance("/INSU/TBR/TBR_TEL").valueOf(tRootNoStdEle);
		if(tPhone.length()>18){
			throw new MidplatException("����ͨ������Ͷ���˵绰���Ȳ��ܳ���18λ");
		}
		
		tPhone = XPath.newInstance("/INSU/BBR/BBR_TEL").valueOf(tRootNoStdEle);
		if(tPhone.length()>18){
			throw new MidplatException("����ͨ�����������˵绰���Ȳ��ܳ���18λ");
		}
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/636314_106_3000_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/636314_106_3000_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
