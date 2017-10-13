package com.sinosoft.midplat.citic.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContForPhone extends XmlSimpFormat {
	
	public NewContForPhone(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement();
		
		/*
		 * �����ж�����ı��Ľ���У��.
		 * ��Ͷ���ˡ������˹�����ת���Ǳ�׼���ĵ���׼��ʱ���Ҳ�����Ӧֵʱ�ḳĬ��ֵ��OTH��������δת���Ǳ�׼����ǰ���ǿ�У�顣
		 */
		checkInNoStdDoc(pNoStdXml);
		
		//��ȡ���մ���
        String mainRiskCode = XPath.newInstance("/Transaction/Transaction_Body/PbInsuType").valueOf(rootNoStdEle);
        //��ȡ��������
        String bkBrchNo = XPath.newInstance("/Transaction/Transaction_Header/BkBrchNo").valueOf(rootNoStdEle);
        
        if("50015".equals(mainRiskCode)){// �߲�Ʒ���
        	
        	// ������, ��ϲ�Ʒ50002�����ж˴��ݱ�������Ϊ���������Ǻ��Ķ�У����Ϊ��������Ϊ��5�꣨�������ߣ�
			String tPbInsuYearFlag = XPath.newInstance("/Transaction/Transaction_Body/PbInsuYearFlag").valueOf(rootNoStdEle);
			if(null==tPbInsuYearFlag || "".equals(tPbInsuYearFlag)){
				throw new MidplatException("�������󣺱����������Ͳ���Ϊ��!");
			}else if(!"1".equals(tPbInsuYearFlag)){	// 0���޹�,1������,2������,3������,4������,5������,6����ĳȷ������

				throw new MidplatException("�������󣺱����ڼ�ӦΪ����!");
			}
		}
		
		mStdXml = NewContForPhoneInXsl.newInstance().getCache().transform(pNoStdXml);
		cLogger.info("CITIC_�������У�NewContForPhoneInXsl���б���ת��������riskCode=[" + mainRiskCode + "]");
		
		//add 20160718 PBKINSR-1389  ���ż��Ϸ���ר����Ʒ����
		if("0125".equals(bkBrchNo.substring(0,4))|| "0141".equals(bkBrchNo.substring(0,4))||"0142".equals(bkBrchNo.substring(0,4))){//���������Ϊ���ż��Ϸ���ר����Ʒ
        	//ʢ��2��
			if("122012".equals(mainRiskCode)){
        		Element rootEle = mStdXml.getRootElement();
            	Element riskCode = (Element)XPath.newInstance("//Risk/RiskCode").selectSingleNode(rootEle);
            	Element mainRiskCodeIn = (Element)XPath.newInstance("//Risk/MainRiskCode").selectSingleNode(rootEle);
            	riskCode.setText("L12098");//�㽭����ר����Ʒʢ��2��
            	mainRiskCodeIn.setText("L12098");//�㽭����ר����Ʒʢ��2��
        	}
        }  
		
		checkInStdDoc(mStdXml);
		
		cLogger.info("Out NewContForPhone.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.std2NoStd()...");
		
		Document mNoStdXml = null;

        mNoStdXml = NewContForPhoneOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewContForPhone.std2NoStd()!");
		return mNoStdXml;
	}
	
	/**
	 * �����ж�����ı��Ľ���У��
	 * @param cStdXml δ��ת���ɱ�׼���ĸ�ʽ�ı��ģ��������ж˸�ʽ�ı��ģ�
	 * ��ΪNewContIn.xsl�ļ��ж�Ͷ���ˡ������˹���Ϊ�յ����������Ĭ��ֵ�����Ͷ���ˡ������˹����ǿ�У���Ƕ����еķǱ�׼���Ľ���У�顣
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		String retMsg = "";	// ������Ϣ
		Element mBodyEle = cNoStdXml.getRootElement().getChild("Transaction_Body");	// �������н��ױ�����
		// 1. Ͷ���˹�������Ϊ��
		String tAppNationality = mBodyEle.getChildText("PbNationality");	// Ͷ���˹���  
		retMsg = checkNationalityIsEmpty(tAppNationality);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("Ͷ����" + retMsg);	
		}
		
		// 2. �����˹�������Ϊ��
		String tInsuredNationality = mBodyEle.getChildText("LiNationality");	// �����˹���  
		retMsg = checkNationalityIsEmpty(tInsuredNationality);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("������" + retMsg);	
		}
		//�������ͷ�ʽ��Ϊ���ӷ���
		String pbSendMode = mBodyEle.getChildText("PbSendMode");//�������ͷ�ʽ
		retMsg = checkPbSendMode(pbSendMode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException(retMsg);	
		}
		
		//�ɷ��˺Ų���Ϊ��
		String bkAcctNo1 = mBodyEle.getChildText("BkAcctNo1");//�ɷ��˺Ų���Ϊ��
		retMsg = checkBkAcctNo1(bkAcctNo1);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException(retMsg);	
		}
	}
	
	/**
	 * �����ж�����ı��Ľ���У��
	 * @param cStdXml �Ѿ�ת���ɱ�׼���ĸ�ʽ�ı���
	 * @return
	 * @throws Exception
	 */
	private void checkInStdDoc(Document cStdXml) throws Exception {
		
		Element mBodyEle = cStdXml.getRootElement().getChild(Body);
		
		String tempIDTypeEndDate = "";	// ֤����Чֹ��
		String retMsg = "";
		String tempEleCode = "";
		
		tempIDTypeEndDate = mBodyEle.getChild(Appnt).getChildText("IDTypeEndDate");	// IDTypeEndDate--֤����Чֹ��
		// 1. Ͷ����֤����Ч�ڲ���Ϊ��
		if(null == tempIDTypeEndDate || "".equals(tempIDTypeEndDate)){
//			tDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, "Ͷ���˵�֤����Чֹ�ڲ���Ϊ��");
			throw new MidplatException("Ͷ���˵�֤����Чֹ�ڲ���Ϊ��");
		}
		
		// 2. Ͷ�����ʱ�У�飺6λ����
		tempEleCode = mBodyEle.getChild(Appnt).getChildText(ZipCode);	// Ͷ�����ʱ�
		retMsg = checkZipCode(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("Ͷ����" + retMsg);	
		}
		
		// 3. Ͷ����֤������Ϊ�������Զ��˱���ͨ�������˹��˱�
		tempEleCode = mBodyEle.getChild(Appnt).getChildText(IDType);	// Ͷ����֤������  
		retMsg = checkIDType(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("Ͷ����" + retMsg);	
		}
		
		// 4. ������֤����Ч�ڲ���Ϊ��
		tempIDTypeEndDate = mBodyEle.getChild(Insured).getChildText("IDTypeEndDate");	// IDTypeEndDate--֤����Чֹ��
		if(null == tempIDTypeEndDate || "".equals(tempIDTypeEndDate)){
			throw new MidplatException("�����˵�֤����Чֹ�ڲ���Ϊ��");
		}

		// 5. �������ʱ�У�飺6λ����
		tempEleCode = mBodyEle.getChild(Insured).getChildText(ZipCode);	// �������ʱ�
		retMsg = checkZipCode(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("������" + retMsg);
		}
		
		// 6. ������֤������Ϊ�������Զ��˱���ͨ�������˹��˱�
		tempEleCode = mBodyEle.getChild(Insured).getChildText(IDType);	// �������ʱ�   
		retMsg = checkIDType(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("������" + retMsg);	
		}
		
		// 7. ������ְҵ��֪��У��
		String tJobNotice = mBodyEle.getChildText("JobNotice");	// JobNotice
		if(null == tJobNotice || "".equals(tJobNotice)){
			throw new MidplatException("ְҵ��֪���Ϊ��");
		}else if(tJobNotice.equals("Y")){
			throw new MidplatException("���������ھܱ�ְҵ(Σ��ְҵ)");
		}
	}
	
	/**
	 * У��֤�����Ͳ���Ϊ�գ��Ҳ���Ϊ'����'����������������������null
	 * @param cempEleCode
	 * @return
	 */
	private String checkIDType(String cTempEleCode){
		
		if(null == cTempEleCode || "".equals(cTempEleCode)){
			return "֤�����Ͳ���Ϊ��";
		}else if(cTempEleCode.equals("8")){	// 8--֤�����ͣ�����
			return "֤������Ϊ������������Ͷ��";
		}
		return null;
	}
	
	private String checkNationalityIsEmpty(String cNationality){
		if(null == cNationality || "".equals(cNationality)){
			return "��������Ϊ��";
		}
		return null;
	}
	/**
	 * �ʱ�Ϊ6λ���֣��粻�Ƿ�����Ӧ��ʾ����������������null
	 * @param cZipCode
	 * @return
	 */
	private String checkZipCode(String cZipCode){
		
		if(null == cZipCode || "".equals(cZipCode)){
			return "�ʱ಻��Ϊ��";
		}else{
			if(cZipCode.length()!=6 || (!checkNumber(cZipCode))){
				return "�ʱ�ӦΪ6λ����";
			}
			return null;
		}
	}
	/**
	 * �������ͷ���Ϊ���ӷ���
	 * @param pbSendMode
	 * @return
	 */
	private String checkPbSendMode(String pbSendMode){
		if(null == pbSendMode || "".equals(pbSendMode)){
			return "�������ͷ�ʽ����Ϊ��";
		}else{
			if(!"2".equals(pbSendMode)){
				return "�������ͷ�ʽӦΪ���ӷ���";
			}
			return null;
		}
	}
	
	/**
	 * �������ͷ���Ϊ���ӷ���
	 * @param pbSendMode
	 * @return
	 */
	private String checkBkAcctNo1(String bkAcctNo1){
		if(null == bkAcctNo1 || "".equals(bkAcctNo1)){
			return "�ɷ��˺Ų���Ϊ��";
		}
		return null;
	}
	/**
	 * @Description: �ж�������ַ��Ƿ�Ϊ���֣�����Ƿ���true�����򷵻�false����������ַ���Ϊ��Ҳ����false
	 * @param str �����ַ���
	 * @return
	 */
	private boolean checkNumber(String str){
		
			Pattern pattern = Pattern.compile("[0-9]*"); 
			if(!pattern.matcher(str).matches()){
				return false;
			}else{
				return true;
			}
	}
	
    public static void main(String[] args) throws Exception{
    	
        /*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/1_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/
        
    	Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/2_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/2_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
    
}


