/**
 * 
 */
package com.sinosoft.midplat.icbczj.bat;

import java.lang.reflect.Constructor;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;

import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

import com.sinosoft.midplat.icbczj.IcbcZJCodeMapping;
import com.sinosoft.midplat.icbczj.IcbcZJConf;
import com.sinosoft.midplat.service.Service;

/**
 * �㽭����ר����Ʒ��֧�����˽��ף�����֮������ո��õ����
 * @author liying
 * @date   20150810
 */
public class IcbcZJPayForBlc extends UploadFileBatchService  {
	public IcbcZJPayForBlc() {
		super(IcbcZJConf.newInstance(), "185");	// funFlag="3405"-֧�����˽���
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
        StringBuffer content2 = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            
            int count = 0;
            long sumPrem = 0;
            
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");   
            if(tDetailList.size() == 0) {
            	//�������л�����Ϣ
                count = 0;
                sumPrem = 0;
            }else {
            	 //�������л�����Ϣ
                count = count + Integer.parseInt(XPath.newInstance("//Body/Count").valueOf(outStdXml.getRootElement()));
                sumPrem = sumPrem + Long.parseLong((XPath.newInstance("//Body/SumPrem").valueOf(outStdXml.getRootElement())));
            }
            cLogger.debug("���ķ��غ˱������¼��"+tDetailList.size());
            
            //��������������֣�����Ҫ�ٴ��������ϵͳ���в�ѯ
            String riskCodes = IcbcZJCodeMapping.riskCode_add();
            String[] riskCodeStr = riskCodes.split(",");
            if(riskCodeStr != null && riskCodeStr.length>0){
            	for(int i=0;i<riskCodeStr.length;i++){
            		
            		// ��ȡ���������
                    String tServiceClassName = thisBusiConf.getChildText("service");
                    if (tServiceClassName == null && "".equals(tServiceClassName)){
                        throw new Exception("�ý���û������service");
                    }
                    cLogger.debug("ҵ����ģ�飺"+tServiceClassName);
                    // ��ʼ������
                    Constructor tServiceConstructor = Class.forName(tServiceClassName)
                            .getConstructor(new Class[] { org.jdom.Element.class });
                    Service service = (Service) tServiceConstructor
                            .newInstance(new Object[] { thisBusiConf });
                    //��֯������
                    Element tTranData = new Element("TranData");
                    Element tHeadEle = getHead();
                    setHead(tHeadEle);
                    tTranData.addContent(tHeadEle);
                    // ������
                    Element tBodyEle = getBody();
                    tBodyEle.getChild("RiskCode").setText(riskCodeStr[i]);
                    tTranData.addContent(tBodyEle);
                                   
                    Document tOutStdXml = service.service(new Document(tTranData));
                    List<Element> tDetailList2 = XPath.selectNodes(tOutStdXml.getRootElement(), "//Body/Detail");   
                    if(tDetailList2.size() == 0) {
                    	//�������л�����Ϣ
                        count = count + 0;
                        sumPrem = sumPrem + 0;
                    }else {
                    	 //�������л�����Ϣ
                        count = count + Integer.parseInt(XPath.newInstance("//Body/Count").valueOf(tOutStdXml.getRootElement()));
                        sumPrem = sumPrem + Long.parseLong((XPath.newInstance("//Body/SumPrem").valueOf(tOutStdXml.getRootElement())));
                        
                        for(Element tDetailEle : tDetailList2){ 
                        	content2.append(getLine(tDetailEle));
                        }
                    }  
            	}
            } 
            if(tDetailList.size() == 0) {
            	//�������л�����Ϣ
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem+"") + "|" + "\n");
            }else {
            	 //�������л�����Ϣ
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem+"") + "|" + "\n");
            }
            
            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));
            }
            if(content2 != null && !"".equals(content2.toString())){
            	 content.append(content2);
            }
           
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ����ɿ��ļ�:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * ��֯����ļ��е�����Ϣ
	 * ���б�ţ��̶�01���������������ڣ�YYYYMMDD���������ţ�30λ��+���ղ�Ʒ����(3λ)�������ţ�30λ��+�������˺ţ�20λ��+��12λ����С���㣩
	 * +�������ڣ�YYYYMMDD��+�ɹ�ʧ�ܱ�־��1λ��+ʧ��ԭ��200λ��+�������ͣ�2λ��+�������˱�־(1λ)
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//���б�ţ��̶�01��
		line.append("044"+"|"); 
		//�������ڣ�YYYYMMDD��
		line.append(tDetailEle.getChildText("ApplyTranDate")+"|");
		//������
		line.append(tDetailEle.getChildText("FormNumber")+"|");
        //���ղ�Ʒ����(3λ)
		line.append(IcbcZJCodeMapping.riskCodeFromPGI(tDetailEle.getChildText(XmlTag.RiskCode))+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//�����˺ţ�20λ��
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//��12λ����С���㣩
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("Prem"))+"|");
		//�������ڣ�YYYYMMDD��
		line.append(tDetailEle.getChildText("AccDate")+"|");
		//�ɹ�ʧ�ܱ�־��1λ��
		line.append(tDetailEle.getChildText("ResultFlag")+"|");
		//ʧ��ԭ��200λ��
		line.append(tDetailEle.getChildText("ResultMsg")+"|");
		//�������ͣ�2λ��
		line.append(IcbcZJCodeMapping.tranTypeFromPGI(tDetailEle.getChildText("BusinessType"))+"|");
		//�������˱�־(1λ)�������˱�־ָ����˺ź��ٴ��������ˣ�0�� 1�ǣ��ո����ֲ��������˴����̶�ֵ����
		line.append(tDetailEle.getChildText("AccFlag")+"|"); 
		line.append("|"); 
		line.append("|"); 
        // ���з�
        line.append("\n"); 
		return line;
	}

	
	/** 
	 * ����ļ���ʽ��
	 * ICBCZJ+���չ�˾����(3λ)+���д���(01)+YYYYMMDD+PAY.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "PAY.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //��ѯ����
        Element mAccDate = new Element("AccDate");
        mAccDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mAccDate);
        
        //�㽭����ר����Ʒ���ִ���
        Element mRiskCode = new Element("RiskCode");
        mRiskCode.setText(IcbcZJCodeMapping.riskCodes());
        bodyEle.addContent(mRiskCode);
       
	}


    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcZJPayForBlc blc = new IcbcZJPayForBlc();
//		blc.postProcess();
		blc.run();
//		Calendar calendar = Calendar.getInstance();
//		calendar.add(Calendar.DAY_OF_MONTH, -1);
//		System.out.println(DateUtil.getDateStr(calendar, "yyyyMMdd"));
		
		System.out.println(" ���Ժ�̨ print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
//		calendar.add(Calendar.DAY_OF_MONTH, -1);
//
//		Element mTranNo = head.getChild("TranNo");
//        mTranNo.setText(getFileName());
//        
//        Element mTranDate = head.getChild("TranDate");
//        mTranDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
	}

}
