package com.sinosoft.midplat.jxnxs.format;

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
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	private String transrNo = "";
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // �Ǳ�׼����
		
//		//50002���б���¼��Ϊ��������ͨת��
//		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootNoStdEle);
//		if("122046".equals(riskCode)){
//			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(rootNoStdEle);
//			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(rootNoStdEle);
//			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
//				// ¼��Ĳ�Ϊ������
//				throw new MidplatException("���ݴ��󣺸��ײͱ����ڼ�Ϊ������");
//			}
//			// �����ڼ���Ϊ��5��
//			insuYearFlag.setText("Y");
//			insuYear.setText("5");
//		}
//		//���������Ƿ����Σ��ְҵ���������Y�ǣ�������ͨУ�鲻ͨ����
//		String jobNotice = XPath.newInstance("/INSU/BBR/BBR_METIERDANGERINF").valueOf(rootNoStdEle);
//		if("Y".equals(jobNotice)){
//			throw new MidplatException("����ͨ���������������д���Σ��ְҵ");
//		}
//		//���������Ƿ����ؼ����������Y�ǣ�������ͨУ�鲻ͨ����
//		String healthNotice = XPath.newInstance("/INSU/BBR/BBR_HEALTHINF").valueOf(rootNoStdEle);
//		if("Y".equals(healthNotice)){
//			throw new MidplatException("����ͨ�����������������ؼ�");
//		}
		String healthNotice = XPath.newInstance("//HEALTH_NOTICE/NOTICE_ITEM").valueOf(rootNoStdEle);
		//������֪
		if("Y".equals(healthNotice)){
			throw new MidplatException("����ͨ�������н�����֪��");
		}
		//��������ְҵΪ���������������
		String jobCode = XPath.newInstance("//BBR/BBR_WORKCODE").valueOf(rootNoStdEle);
		if("8000010".equals(jobCode)) {
			throw new MidplatException("����ͨ��������������ְҵΪ�������������������");
		}
		
		transrNo = XPath.newInstance("//MAIN/TRANSRNO").valueOf(rootNoStdEle);
		cLogger.info("��ˮ��Ϊ��"+transrNo);
		mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		//50002���б���¼��Ϊ��������ͨת��
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(mStdXml.getRootElement());
		//PBKINSR-636 ����ũ�����������µ�ʢ2���µ�ʢ3����5��50002����
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
			
			//���ӽɷ�����У��
			Element payEndYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayEndYearFlag").selectSingleNode(mStdXml.getRootElement());
			Element payEndYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayEndYear").selectSingleNode(mStdXml.getRootElement());
			if (!"Y".equals(payEndYearFlag.getText()) || !"1000".equals(payEndYear.getText())) {
				// ¼��Ĳ�Ϊ����
				throw new MidplatException("���ݴ��󣺸��ײͽɷ�����Ϊ����");
			}
		}
		
		cLogger.info("JXNXS_����ũ���У�����NewContInXsl���б���ת��");
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		
		mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		Element rootNoStdEle = mNoStdXml.getRootElement();
		//�ڷ�����Ϣ���������н�����ˮ��
		Element transrNoEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//MAIN/TRANSRNO");
		transrNoEle.setText(transrNo);
		
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