package com.sinosoft.midplat.cib.format;

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

public class NewContForSelfTerm extends XmlSimpFormat {
	
	public NewContForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForSelfTerm.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // �Ǳ�׼����
		
		// ��ϢУ��
		infoCheck(rootNoStdEle);
		
		mStdXml = NewContForSelfTermInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootStdEle = mStdXml.getRootElement();
		//50002���б���¼��Ϊ��������ͨת��
		// ������Ӯ�ײͣ�������50002����Ϊ50015
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootStdEle);
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
		
		cLogger.info("CIB_��ҵ���У�����NewContForSelfTermInXsl���б���ת��");
		cLogger.info("Out NewContForSelfTerm.noStd2Std()!");
		return mStdXml;
	}
	
	/**
	 * �����еı��Ľ��л�������У��
	 * @param tRootNoStdEle
	 * @throws Exception
	 */
	private void infoCheck(Element tRootNoStdEle) throws Exception{
		
		//Ͷ���������벻��Ϊ��
		String tbr_revenue = XPath.newInstance("/INSU/TBR/TBR_REVENUE").valueOf(tRootNoStdEle);
		if(tbr_revenue != null && !"".equals(tbr_revenue.trim())){	
		}else{
		    throw new MidplatException("Ͷ���������벻��Ϊ�գ�");
		}
		//�������ͷ�ʽӦΪ���ӱ���
		String sendMethod = XPath.newInstance("/INSU/MAIN/SENDMETHOD").valueOf(tRootNoStdEle);
		if(sendMethod != null && !"".equals(sendMethod.trim())){	
			if(!"5".equals(sendMethod.trim())){
				throw new MidplatException("�������ͷ�ʽӦΪ���ӱ�����");
			}
		}else{
		    throw new MidplatException("�������ͷ�ʽ����Ϊ�գ�");
		}
		
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
		cLogger.info("Into NewContForSelfTerm.std2NoStd()...");
		Document mNoStdXml = null;
//		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-626 ��ҵ��������ͨ�����²�Ʒ��ʢ��3�ţ�
		//Ŀǰ��ҵ����ֻ��50002һ����Ʒ����������������Ʒʱ�����ж�
		// ������Ӯ��Ʒ������������50002����Ϊ50015
//		mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
//		if("50015".equals(tContPlanCode)){ 
		mNoStdXml = NewContForSelfTermOutXsl50002.newInstance().getCache().transform(pStdXml);
//		}else {
//			mNoStdXml = NewContForSelfTermOutXsl.newInstance().getCache().transform(pStdXml);
//		}
		//PBKINSR-626 ��ҵ��������ͨ�����²�Ʒ��ʢ��3�ţ�
		cLogger.info("Out NewContForSelfTerm.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/652406_710_0_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/dd_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
