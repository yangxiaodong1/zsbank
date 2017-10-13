package com.sinosoft.midplat.bjrcb.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;

public class BjrcbEdorCTInfoBatch extends UploadFileBatchService {

    public BjrcbEdorCTInfoBatch() {
        super(BjrcbConf.newInstance(), "1207");
    }

    @Override
    protected void setHead(Element head) {
        
    }

    @Override
    protected void setBody(Element mBodyEle) {

    	Element tBusinessTypesEle = new Element("BusinessTypes");
    	// �����˱�
    	Element tCTBusinessType = new Element("BusinessType");
    	tCTBusinessType.setText("CT");
    	// ��ԥ���˱�
    	Element tWTBusinessType = new Element("BusinessType");
    	tWTBusinessType.setText("WT");
    	// ����
    	Element tMQBusinessType = new Element("BusinessType");
    	tMQBusinessType.setText("MQ");
    	
    	tBusinessTypesEle.addContent(tCTBusinessType);
    	tBusinessTypesEle.addContent(tWTBusinessType);
    	tBusinessTypesEle.addContent(tMQBusinessType);

    	Element mEdorCTDateEle = new Element("EdorCTDate");
    	mEdorCTDateEle.setText(DateUtil.getCurDate("yyyyMMdd"));
    	
        mBodyEle.addContent(mEdorCTDateEle);
        mBodyEle.addContent(tBusinessTypesEle);
        
    }

    @Override
    protected String getFileName() {
        return  "BRCB_BDZTTB_L_" + DateUtil.getCurDate("yyyyMMdd") + ".txt";
    }

    @Override
    protected String parse(Document outStdXml) throws Exception{

    	StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("���ķ������˼�¼��"+tDetailList.size());
            /*
             * ���ĸ�ʽ��
             * ��һ�У�����;�ܽ��;����
             * eg��
             * ���У�3|20110506|��ע|
             */
            content.append(tDetailList.size()+"|");
            content.append(DateUtil.getCurDate("yyyyMMdd")+"||");
            for(Element tDetailEle : tDetailList){ 
                // ��ʽ�������ţ�30λ��|����ӡˢ�ţ�30λ��|��ԥ���˱�����(8λ)|����״̬��1λ��|��ע��100λ��|
                // ���з�
                content.append("\n"); 
                //������
                content.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
                //����ӡˢ��
                content.append(tDetailEle.getChildText(XmlTag.ContPrtNo)+"|");
                //ҵ��ȷ������
                content.append(tDetailEle.getChildText("EdorCTDate")+"|");
                //����״̬
                content.append(switchPolState(tDetailEle.getChildText("ContState"))).append("|");
                if("1".equals(tDetailEle.getChildText("LargeAmount"))){
                    //����
                    content.append("DETZ"+tDetailEle.getChildText("ProposalContNo")+"|");
                }else{
                    //����
                    content.append(switchBusinessType(tDetailEle.getChildText("BusinessType"))).append("|");
                }
            }
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ�����ֻ�����м�¼���ļ�:"+getFileName());
            //���У�3|20110506|��ע|
            content.append("0|"+DateUtil.getCurDate("yyyyMMdd")+"||");
        }
        
        return content.toString();
    }
    
	/**
	 * ����״̬ת��
	 * @param polState
	 * @return
	 */
	private String switchPolState(String polState){
		String tempValue = "";
		if("01".equals(polState)){	// ���ڸ���
			tempValue = "E";
		}else if("02".equals(polState)){	// �˱�
			tempValue = "D";
		}else if("WT".equals(polState)){	// ��ԥ���˱�
			tempValue = "9";
		}
		return tempValue;
    }
    
	/**
	 * ҵ������ת��
	 * @param businessType
	 * @return
	 */
	private String switchBusinessType(String businessType){
		String tempValue = "";
		if("MQ".equals(businessType)){	// ���ڸ���
			tempValue = "���ڸ���";
		}else if("CT".equals(businessType)){	// �˱�
			tempValue = "�����˱�";
		}else if("WT".equals(businessType)){	// ��ԥ���˱�
			tempValue = "��ԥ���˱�";
		}
		return tempValue;
    }
}
