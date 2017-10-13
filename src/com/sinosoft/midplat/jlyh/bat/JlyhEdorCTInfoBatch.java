package com.sinosoft.midplat.jlyh.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.jlyh.JlyhConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.XmlTag;

/**
 * 
* @����: [JlyhEdorCTInfoBatch]
* @����: ����ΰ  ab037259ChangHongwei@ab-insurance.com
* @����: Jul 25, 2014 3:21:51 PM
* <p>��Ȩ����:(C)1998-2014 AB.COM</p>
 */
public class JlyhEdorCTInfoBatch extends UploadFileBatchService {

    public JlyhEdorCTInfoBatch() {
        super(JlyhConf.newInstance(), "1805");
    }

    @Override
    protected void setHead(Element head) {
        // TODO Auto-generated method stub
        
    }

    @Override
    protected void setBody(Element mBodyEle) {
        // TODO Auto-generated method stub
    	Element mBusinessTypes = new Element("BusinessTypes");
    	
        Element mBusinessType = new Element("BusinessType");
        //CT�˱�
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CT");
        mBusinessTypes.addContent(mBusinessType);

        //WT��ԥ���˱�
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("WT");
        mBusinessTypes.addContent(mBusinessType);

        mBodyEle.addContent(mBusinessTypes);
        
    	// �˱���Ϣ��������
        Element mEdorCTDateEle = new Element("EdorCTDate");
        mEdorCTDateEle.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        mBodyEle.addContent(mEdorCTDateEle);
        
    }

    @Override
    protected String getFileName() {
    	// �ļ������� WAVER+��˾����(4λ)+���д���(4λ)+YYYYMMDD
    	Element mBankEle = thisRootConf.getChild("bank");
        return  "WAVER" + mBankEle.getAttributeValue("insu")
        		+ mBankEle.getAttributeValue("id")
        		+ DateUtil.getDateStr(calendar, "yyyyMMdd");
    }

    @Override
    protected String parse(Document outStdXml) throws Exception{
        // TODO Auto-generated method stub
    	//��˾����
    	String insuId = thisRootConf.getChild("bank").getAttributeValue("insu");
    	//���д���
        String bankId = thisRootConf.getChild("bank").getAttributeValue("id");
        
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("���ķ������˼�¼��"+tDetailList.size());
            
            //�ļ�ͷ ��ʽ����˾����|���д���|�˱��ܱ���|�˱��ܽ��
            content.append(insuId+"|");
            content.append(bankId+"|");
            content.append(tDetailList.size()+"|");
            long mSumPrem = 0;
            for(Element tDetailEle : tDetailList){ 
            	long tPremFen = Long.parseLong(tDetailEle.getChildText("EdorCTPrem"));
            	mSumPrem += tPremFen;
            }
            content.append(NumberUtil.fenToYuan(mSumPrem));
            
            for(Element tDetailEle : tDetailList){ 
                // ��ʽ����Ʒ����|Ͷ����֤������|Ͷ��������|����������|������|ǩ������|
            	//      �˱�����|�˱����|�˱�����
                // ���з�
                content.append("\n"); 
                //��Ʒ����
                content.append(tranRiskcode(tDetailEle.getChildText("RiskCode"))+"|");
                //Ͷ����֤������
                content.append(tDetailEle.getChildText("AppntIDNo")+"|");
                //Ͷ��������
                content.append(tDetailEle.getChildText("AppntName")+"|");
                //����������
                content.append(tDetailEle.getChildText("InsuredName")+"|");
                //������
                content.append(tDetailEle.getChildText("ContNo")+"|");
                //ǩ������
                content.append(tDetailEle.getChildText("SignDate")+"|");
                //�˱�����
                content.append(tDetailEle.getChildText("EdorCTDate")+"|");
                //�˱����
                content.append(NumberUtil.fenToYuan(tDetailEle.getChildText("EdorCTPrem"))+"|");
                //�˱�����
                content.append(getBusinessType(tDetailEle.getChildText("BusinessType")));
            }
        }else{
            cLogger.warn("���ķ��ش����ģ�����ֻ�����м�¼���ļ�:"+getFileName());
            //����ԥ�ڳ������ݣ���Ҳ������ֻ���ļ�ͷ�Ķ����ļ����˱��ܱ������˱��ܽ���Ϊ0,  ʾ�� 0001|jlyh|0|0.00
            content.append(insuId+"|");
            content.append(bankId+"|");
            content.append("0|0.00");
        }
        
        return content.toString();
    }

    /**
	 * ҵ������ӳ�䣨����--�������У���
	 * </br>���ģ�	CT�˱���WT��ԥ���˱�
	 * </br>�������У�8�˱���3��ԥ�ڳ���
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("CT".equals(type)){
            //CT�˱�---8�˱�
            return "8";
        }else if("WT".equals(type)){
            //WT��ԥ���˱�--->3��ԥ�ڳ���
            return "3";
        }
	    return "";
	}
	
	/**
	 * ��Ʒ����ת�����������Ͳ�Ʒ�������죬
	 * @param tRiskCode
	 * @return
	 */
	private String tranRiskcode(String cRiskCode){
		
		String riskCode = cRiskCode;
		
		if("122046".equals(cRiskCode)){
    		riskCode = "50002";
    	}else if("L12079".equals(cRiskCode)  || "122012".equals(riskCode) ){
    		// ����ʢ��2���������գ������ͣ����Ĳ�Ʒ���������122012��ΪL12079
    		riskCode = "122012";
    	/* ʢ��3�Ų�Ʒ������start */
    	//}else if("L12078".equals(cRiskCode)  || "122010".equals(riskCode)){
    	}else if("L12100".equals(cRiskCode) || "L12078".equals(cRiskCode) || "122010".equals(riskCode)){
    	/* ʢ��3�Ų�Ʒ������end */
    		// ����ʢ��3���������գ������ͣ����Ĳ�Ʒ���������122010��ΪL12078
    		riskCode = "122010";    		
    	}else if("L12087".equals(cRiskCode)){
    		// ����5��
    		riskCode = "L12087";    		
    	}
		return riskCode;
	}
	
}
