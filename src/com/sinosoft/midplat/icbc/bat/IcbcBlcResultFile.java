/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * ��ʵʱ�˱�����ļ�������֮����ú��ĵõ����
 * @author ChengNing
 * @date   Apr 2, 2013
 */
public class IcbcBlcResultFile extends UploadFileBatchService  {
	public IcbcBlcResultFile() {
		super(IcbcConf.newInstance(), "123");	// funFlag="123"-��ʵʱ�˱��ϴ�����ļ�
	}
	
	/**
	 * �������Ĵ�����xml���ģ��γɶ����ļ���ʽ
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("���ķ��غ˱������¼��"+tDetailList.size());
            
            String tContPlanCode = "";
            for(Element tDetailEle : tDetailList){ 
            	//������ӵ������ļ�
            	tContPlanCode = tDetailEle.getChildText("ContPlanCode").trim();	// ��ϲ�Ʒ�����ǩ
            	//PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ����
            	if("50002".equals(tContPlanCode) || "50015".equals(tContPlanCode)){	// ��ϲ�Ʒ50002��������ʽ��֯һ����Ϣ��
            		content.append(getLine4ContPlan50002(tDetailEle));
            	}else if("".equals(tContPlanCode) || null==tContPlanCode){	// ����ϲ�Ʒ��������ʽ��֯һ����Ϣ
            		content.append(getLine(tDetailEle));	
            	}
            }
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ����ɿ��ļ�:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * ��֯����ļ��е�����Ϣ
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//�������˽ڵ�
		Element tInsuredEle = tDetailEle.getChild(XmlTag.Insured);
		
		//���ֽڵ�,�����ŵ�һ��
		StringBuffer mainRiskBuffer = new StringBuffer();
		StringBuffer riskBuffer = new StringBuffer();
		List<Element> tRiskEles = tDetailEle.getChildren(XmlTag.Risk);
		//���ѷ�ʽ��3λ��//��������ȡ��
		String payIntv = "";
		for (Element tRiskEle : tRiskEles) {
			StringBuffer lineRisk = new StringBuffer();
			//�ж��Ƿ�����
			if(tRiskEle.getChildText(XmlTag.RiskCode).equals(tRiskEle.getChildText(XmlTag.MainRiskCode))){
				lineRisk = mainRiskBuffer;
				payIntv = tRiskEle.getChildText(XmlTag.PayIntv);
			}
			else{
				lineRisk = riskBuffer;
			}
			// �������ִ��루3λ������һ��Ϊ���գ�����Ϊ������
			lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tRiskEle.getChildText(XmlTag.RiskCode))+"|");
			// �˱�����״̬(2λ)
			lineRisk.append(IcbcCodeMapping.uwResultStateFromPGI(tRiskEle.getChildText("UWResult"))+"|");
			// ������5λ��
			lineRisk.append(tRiskEle.getChildText(XmlTag.Mult) + "|");
			// ���ѣ�12λ��
			lineRisk.append(tRiskEle.getChildText(XmlTag.Prem) + "|");
			// ���12λ��
			lineRisk.append(tRiskEle.getChildText(XmlTag.Amnt) + "|");
			
			// �����ڼ����ͣ�1λ���������ڼ���Ҫת��
			String insuYearFlag = tRiskEle.getChildText(XmlTag.InsuYearFlag);
			String insuYear = tRiskEle.getChildText(XmlTag.InsuYear);
			if("A".equals(insuYearFlag) && "106".equals(insuYear)){
			    //������
			    lineRisk.append( "5|999|");
			}else{
			    lineRisk.append(IcbcCodeMapping.insuYearFlagFromPGI(tRiskEle.getChildText(XmlTag.InsuYearFlag)) + "|");
			    lineRisk.append(tRiskEle.getChildText(XmlTag.InsuYear) + "|");
			}
			
			// �ɷ��������ͣ�1λ����// �ɷ�������Ҫת��
			if("0".equals(tRiskEle.getChildText(XmlTag.PayIntv))){
			    //����
			    lineRisk.append( "5|0|");
			}else{
			    lineRisk.append(IcbcCodeMapping.payEndYearFlagFromPGI(tRiskEle.getChildText(XmlTag.PayEndYearFlag)) + "|");
			    lineRisk.append(tRiskEle.getChildText(XmlTag.PayEndYear) + "|");
			}
			
		}
		
        //�����룬ǰ5λ��ʾ������
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //���չ�˾����(3λ)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //���н�����ˮ��(25λ)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //Ͷ����ӡˢ��(20λ)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//�˱����� (2λ) 
		line.append(IcbcCodeMapping.uwResultFromPGI(tDetailEle.getChildText("UWResult"))+"|");
		//��ע��120λ��
		line.append(tDetailEle.getChildText("ReMark")+"|");
		//�����ܱ��ѣ�12λ��
		line.append(tDetailEle.getChildText(XmlTag.Prem)+"|");
		
		//����������(30λ) 
		line.append(tInsuredEle.getChildText(XmlTag.Name)+"|");
		//������֤�����ͣ�2λ��
		line.append(IcbcCodeMapping.idTypeFromPGI(tInsuredEle.getChildText(XmlTag.IDType))+"|");
		//������֤�����루20λ��
		line.append(tInsuredEle.getChildText(XmlTag.IDNo)+"|");
		//���ѷ�ʽ��3λ��
		line.append(IcbcCodeMapping.payIntvFromPGI(payIntv) +"|");
		//����
		line.append(mainRiskBuffer);
		//������
		line.append(riskBuffer);
		
		/*����ռλ��|*/
		for(int i= 5-tRiskEles.size(); i>0; i--){
		    //���й涨������4�������գ�������������ղ�ס����Ҫ����ȱ�ٵ��ֶ�
		    line.append("|||||||||");
		}
		
		
        // ���з�
        line.append("\n"); 
		return line;
	}

	/**
	 * �����ϲ�Ʒ50002��֯���ر����е�һ������Ϣ
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine4ContPlan50002(Element tDetailEle){
		
		StringBuffer line = new StringBuffer();
		//�������˽ڵ�
		Element tInsuredEle = tDetailEle.getChild(XmlTag.Insured);
		
		//���ֽڵ�,�����ŵ�һ��
		StringBuffer mainRiskBuffer = new StringBuffer();
		StringBuffer riskBuffer = new StringBuffer();
		List<Element> tRiskEles = tDetailEle.getChildren(XmlTag.Risk);
		//�ײʹ���ڵ�
		Element tContPlanCodeEle = tDetailEle.getChild("ContPlanCode");
		String tContPlanCode = tContPlanCodeEle.getText();
		
		//���ѷ�ʽ��3λ��//��������ȡ��
		String payIntv = "";
		
		int riskSize = 0;	// ��¼���ո��������ں������췵�ظ����еĺ˱�����ļ�
		for (Element tRiskEle : tRiskEles) {
			StringBuffer lineRisk = new StringBuffer();
			//�ж��Ƿ�����
			if(tRiskEle.getChildText(XmlTag.RiskCode).equals(tRiskEle.getChildText(XmlTag.MainRiskCode))){
				lineRisk = mainRiskBuffer;
				payIntv = tRiskEle.getChildText(XmlTag.PayIntv);
				
				// �������ִ��루3λ��
//				lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tRiskEle.getChildText(XmlTag.RiskCode))+"|");
				//���ڴ���50015��50012���ֲ�Ʒ���빲�������������Ϊȡ�ײʹ�����ӳ��
				lineRisk.append(IcbcCodeMapping.riskCodeFromPGI(tContPlanCode)+"|");
				// �˱�����״̬(2λ)
				lineRisk.append(IcbcCodeMapping.uwResultStateFromPGI(tRiskEle.getChildText("UWResult"))+"|");
				// ������5λ��, ��ϲ�Ʒ����ȡ��<ContPlanMult>��ǩ
				lineRisk.append(tDetailEle.getChildText("ContPlanMult") + "|");
				// ���ѣ�12λ��,��ϲ�Ʒ����ȡ��<ActPrem>��ǩ
				lineRisk.append(tDetailEle.getChildText("ActPrem") + "|");
				// ���12λ��
				lineRisk.append(tDetailEle.getChildText(XmlTag.Amnt) + "|");
				
				// �����ڼ����ͣ�1λ���������ڼ���Ҫת��,��ϲ�Ʒ�ı�������Ϊ�������˴�д����
				lineRisk.append( "5|999|");
				
//				String insuYearFlag = tRiskEle.getChildText(XmlTag.InsuYearFlag);
//				String insuYear = tRiskEle.getChildText(XmlTag.InsuYear);
//				if("A".equals(insuYearFlag) && "106".equals(insuYear)){
//				    //������
//				    lineRisk.append( "5|999|");
//				}else{
//				    lineRisk.append(IcbcCodeMapping.insuYearFlagFromPGI(tRiskEle.getChildText(XmlTag.InsuYearFlag)) + "|");
//				    lineRisk.append(tRiskEle.getChildText(XmlTag.InsuYear) + "|");
//				}
				
				// �ɷ��������ͣ�1λ����// �ɷ�������Ҫת��
				if("0".equals(tRiskEle.getChildText(XmlTag.PayIntv))){
				    //����
				    lineRisk.append( "5|0|");
				}else{
				    lineRisk.append(IcbcCodeMapping.payEndYearFlagFromPGI(tRiskEle.getChildText(XmlTag.PayEndYearFlag)) + "|");
				    lineRisk.append(tRiskEle.getChildText(XmlTag.PayEndYear) + "|");
				}
				
				riskSize++;	// ͳ�����ո����ݣ�Ϊ������֯���з�ʵʱ�˱�����ļ���׼��
			}
			
		}
		
        //�����룬ǰ5λ��ʾ������
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //���չ�˾����(3λ)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //���н�����ˮ��(25λ)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //Ͷ����ӡˢ��(20λ)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//�˱����� (2λ) 
		line.append(IcbcCodeMapping.uwResultFromPGI(tDetailEle.getChildText("UWResult"))+"|");
		//��ע��120λ��
		line.append(tDetailEle.getChildText("ReMark")+"|");
		//�����ܱ��ѣ�12λ��,��ϲ�Ʒ50002ȡʵ�յ��ܱ��ѣ�ȡ���ֶ�ActPrem
		line.append(tDetailEle.getChildText("ActPrem")+"|");
		
		//����������(30λ) 
		line.append(tInsuredEle.getChildText(XmlTag.Name)+"|");
		//������֤�����ͣ�2λ��
		line.append(IcbcCodeMapping.idTypeFromPGI(tInsuredEle.getChildText(XmlTag.IDType))+"|");
		//������֤�����루20λ��
		line.append(tInsuredEle.getChildText(XmlTag.IDNo)+"|");
		//���ѷ�ʽ��3λ��
		line.append(IcbcCodeMapping.payIntvFromPGI(payIntv) +"|");
		//����
		line.append(mainRiskBuffer);
		//������
		line.append(riskBuffer);
		
		/*����ռλ��|*/
		for(int i= 5-riskSize; i>0; i--){
		    //���й涨������4�������գ�������������ղ�ס����Ҫ����ȱ�ٵ��ֶ�
		    line.append("|||||||||");
		}
		
        // ���з�
        line.append("\n"); 
		return line;
	}
	
	/** 
	 * ����ļ���ʽ��
	 * ENY(3λ)+IAAS(4λ)�����չ�˾����(3λ)+���д��루2λ��+���ڣ�8λ��yyyymmdd��+03.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ENYIAAS" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "03.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
		
	}

	@Override
	protected void setHead(Element head) {
		
	}

	
	@Override
    protected boolean postProcess() throws Exception {

	    OutputStream temp = null;
	    FileInputStream fin = null;
	    String pathName = null;
	    
        try {
            //���ص�ַ
            String path = this.thisBusiConf.getChildTextTrim("localDir");
            pathName = path+File.separator+getFileName();
            cLogger.info("�����ļ���"+pathName+"...");
            
            //���ɵ������ļ�
            fin = new FileInputStream(pathName);
            //���ɵ������ļ�
            temp = new FileOutputStream(pathName+".des");
            //��װ�ɻ�����
            temp = new IcbcCipherUtil().encrypt(temp);
            int len = 0;
            byte[] content = new byte[2046];
            while((len=fin.read(content)) != -1){
                //���ɼ����ļ�
                temp.write(content, 0, len);
            }
            temp.flush();
        } catch (Exception e) {
            cLogger.error("�����ļ�ʧ��!"+pathName, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("�ر��ļ�ʧ��!"+pathName, e);
                }
            }
            if (fin != null) {
                try{
                    fin.close();
                }catch(Exception e){
                    cLogger.error("�ر��ļ�ʧ��!"+pathName+".des", e);
                }
            }
        }
	    return true;
    }

    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcBlcResultFile blc = new IcbcBlcResultFile();
		blc.postProcess();
		
		System.out.println(" ���Ժ�̨ print info : ");
	}

    @Override
    protected String getFtpName() {
        return getFileName()+".des";
    }
	
	


}
