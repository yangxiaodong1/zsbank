package com.sinosoft.midplat.hxb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.lis.db.HxbankInfoDB;
import com.sinosoft.lis.db.HxbankManagerDB;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat{

	private String appNo = "";	// ���ع����е�Ͷ������
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.format.XmlSimpFormat#noStd2Std(org.jdom.Document)
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		String tBankCode = "";	// ���л�����
		String tBankMgrNo = "";	// ����������Ա����
		String tTranCom = "";	// ���б���
		
		checkInNoStdDoc(pNoStdXml);
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();
		Element tBodyEle = stdRootEle.getChild(Body);
		
		//�ײʹ���
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
		if("50015".equals(tContPlanCode)){
		    //������Ӯ�ײ�,�ײʹ�����50002����Ϊ50015
		    //У�鱣���ڼ��Ƿ�¼����ȷ������Ӧ�ú���ϵͳУ�飬���Ǹ��ײͱȽ�����
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
		    if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
		        //¼��Ĳ�Ϊ������
		       throw new MidplatException("���ײͱ����ڼ�Ϊ������"); 
		    }
		    //�������ڼ�����Ϊ��5��
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		    
		}
		
		appNo = tBodyEle.getChildTextTrim(ProposalPrtNo);
		tBankMgrNo = tBodyEle.getChildText("SellerNo");
		tTranCom = stdRootEle.getChild(Head).getChildTextTrim(TranCom);
		tBankCode = XPath.newInstance("//MAIN/BRNO").valueOf(pNoStdXml.getRootElement());		
		
		HxbankInfoDB tHxbankInfoDB = new HxbankInfoDB();
		tHxbankInfoDB.setBankCode(tBankCode);
		tHxbankInfoDB.setTranCom(tTranCom);
		tHxbankInfoDB.getInfo();
		if(null != tHxbankInfoDB){
			tBodyEle.getChild(AgentComName).setText(tHxbankInfoDB.getBankFullName());	// ������������ȫ��
		}
		HxbankManagerDB tHxbankManagerDB = new HxbankManagerDB();
		tHxbankManagerDB.setBankCode(tBankCode);
		tHxbankManagerDB.setTranCom(tTranCom);
		tHxbankManagerDB.setManagerCode(tBankMgrNo);
		tHxbankManagerDB.getInfo();
		if(null != tHxbankManagerDB){
			tBodyEle.getChild("TellerCertiCode").setText(tHxbankManagerDB.getManagerCertifNo());	// ��������������Ա�ʸ�֤��
			tBodyEle.getChild("TellerName").setText(tHxbankManagerDB.getManagerName());	// ��������������Ա����
		}

		cLogger.info("Out NewCont.noStd2Std()...");
		return mStdXml;
	}
	
	
	/**
	 * �����ж�����ı��Ľ���У��
	 * @param cStdXml δ��ת���ɱ�׼���ĸ�ʽ�ı��ģ��������ж˸�ʽ�ı��ģ�
	 * ��ΪNewContIn.xsl�ļ��ж�Ͷ���ˡ������˹���Ϊ�յ����������Ĭ��ֵ�����Ͷ���ˡ������˹����ǿ�У���Ƕ����еķǱ�׼���Ľ���У�顣
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		Element noStdRoot = cNoStdXml.getRootElement();
		
		/*
		 * ���ֽ�ɷ�ʱ���в���д�ɷ��˻������������Ƚ��׽ɷ���ʽ.
		 * 
		 * 1. ����ͨУ�鲻���ֽ�ɷѡ� ���ж˽ɷ���ʽ:C�ֽ�Tת��
		 * 2. ����ͨ������֤Ͷ���˺����п��˻���������ͬһ��
		 */
		String tPayMode = XPath.newInstance("//MAIN/PAYMODE").valueOf(noStdRoot);
		if(tPayMode.equals("C")){
			throw new MidplatException("����ͨ������֧���ֽ�ɷѡ�");
		}
		
		// Ͷ��������
		String appName = XPath.newInstance("//TBR/TBR_NAME").valueOf(noStdRoot).trim();
		// �ɷ��˻�����
		String accName = XPath.newInstance("//MAIN/PAYNAME").valueOf(noStdRoot).trim();
		if(!appName.equals(accName)){
			throw new MidplatException("Ͷ������ɷ��˻���������ͬһ�ˡ�");
		}
		
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document noStdXml = null;
		//�ײʹ���
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		if("50015".equals(tContPlanCode)){
			// ������Ӯ�ײ�,��50002����Ϊ50015
			noStdXml = NewContOut50002Xsl.newInstance().getCache().transform(pStdXml);
		}
		//add 20150807 ���Ӱ���3�źͰ���5�Ų�Ʒ��֧����  begin
		else if("50011".equals(tContPlanCode)){//����3��
			noStdXml = NewContOut50011Xsl.newInstance().getCache().transform(pStdXml);
		}else if("50012".equals(tContPlanCode)){//����5��
			noStdXml = NewContOut50012Xsl.newInstance().getCache().transform(pStdXml);
		}
		//add 20150807 ���Ӱ���3�źͰ���5�Ų�Ʒ��֧����  end
		else{
			noStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}

		Element mainEle = noStdXml.getRootElement().getChild("MAIN");
			
		// ����״̬: 1 �ɹ���0 ʧ�ܣ����۳ɹ�ʧ�ܶ�д����ֶ�
		if(appNo==null || appNo.equals("")){	// Ͷ�����Ų�����
			throw new MidplatException("δ��ȡ��Ͷ��������Ϣ");
		}else{
			Element appNoEle = new Element("APP");
			appNoEle.setText(appNo);
			mainEle.addContent(appNoEle);
		}

		cLogger.info("Out NewCont.std2NoStd()...");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/hxb/122010_1501_in.xml"));
//		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/hxb/122010_1501_out.xml")));
//		out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));

		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/hxb/10033_3_0_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/hxb/10033_3_0_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
		out.close();
		System.out.println("******ok*********");
	}

}
