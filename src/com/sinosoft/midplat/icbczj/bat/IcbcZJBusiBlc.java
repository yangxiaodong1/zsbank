/**
 * 
 */
package com.sinosoft.midplat.icbczj.bat;

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

import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

import com.sinosoft.midplat.icbczj.IcbcZJCodeMapping;
import com.sinosoft.midplat.icbczj.IcbcZJConf;

/**
 * �㽭����ר����Ʒ����˾Ͷ�������ļ�������֮����ú��ĵõ����
 * @author liying
 * @date   20150805
 */
public class IcbcZJBusiBlc extends UploadFileBatchService  {
	public IcbcZJBusiBlc() {
		super(IcbcZJConf.newInstance(), "183");	// funFlag="3403"-��˾Ͷ�������ļ�
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
            if(tDetailList.size() == 0) {
            	//�������л�����Ϣ
                String count = "0";
                String sumPrem = "0";
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem) + "|" + "\n");
            }else {
            	//�������л�����Ϣ
                String count = XPath.newInstance("//Body/Count").valueOf(outStdXml.getRootElement());
                String sumPrem = XPath.newInstance("//Body/SumPrem").valueOf(outStdXml.getRootElement());
                content.append(count+ "|" + NumberUtil.fenToYuan(sumPrem) + "|" + "\n");
            }
            

            for(Element tDetailEle : tDetailList){ 
            	content.append(getLine(tDetailEle));
            }
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ����ɿ��ļ�:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * ��֯����ļ��е�����Ϣ
	 * ���չ�˾���̶�044�����������ڣ�YYYYMMDD���������ţ�5λ��������ţ�5λ�������ʽ����루�̶�0001��+Ӧ�������н�����ˮ�ţ�30λ��+���ղ�Ʒ����(3λ)�������ţ�30λ��+�����˺ţ�20λ������12λ����С���㣩
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//���б�ţ��̶�01��
//		line.append("01"+"|"); 
		line.append("044"+"|"); 
		//�������ڣ�YYYYMMDD��
		line.append(tDetailEle.getChildText(XmlTag.TranDate)+"|");
        //�����룬ǰ5λ��ʾ������
//		line.append(tDetailEle.getChildText("AreaCode").substring(0, 5)+"|");
		line.append(tDetailEle.getChildText("AreaCode")+"|");
		//����ţ�5λ��
		line.append(tDetailEle.getChildText("BankCode")+"|");
		//���ʽ����루�̶�0001��
		line.append("0001"+"|"); 
        //Ӧ�������н�����ˮ�ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //���ղ�Ʒ����(3λ)
		line.append(IcbcZJCodeMapping.riskCodeFromPGI(tDetailEle.getChildText(XmlTag.RiskCode))+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//�����˺ţ�20λ��
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//��12λ����С���㣩
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("Prem"))+"|");
		
		
        // ���з�
        line.append("\n"); 
		return line;
	}

	
	/** 
	 * ����ļ���ʽ��
	 * ICBCZJ+���չ�˾����+���д��루01��+����+TOUBAO.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "TOUBAO.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //��ѯ����
        Element mPolApplyDate = new Element("PolApplyDate");
        mPolApplyDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mPolApplyDate);
	}


    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		IcbcZJBusiBlc blc = new IcbcZJBusiBlc();
//		blc.postProcess();
		blc.run();
		System.out.println(" ���Ժ�̨ print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}



}
