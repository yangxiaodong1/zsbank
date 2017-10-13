package com.sinosoft.midplat.hrbcb.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.hrbcb.HrbcbConf;

/**
 * ��ȡ���������б���״̬�������
 * @author 
 *
 */
public class HrbQueryPolicyStatus extends UploadFileBatchService {
    
	public HrbQueryPolicyStatus() {
		super(HrbcbConf.newInstance(), "2605");
	}
	
	/**
	 * �������Ĵ�����xml���ģ��γɽ���ļ�
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
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();		
		//�������� YYYYMMDD����ǰ����
		line.append(DateUtil.getCur8Date()+"|");
		//ҵ������ 001���ڸ�����002��ԥ�ڳ�����003�˱���004���ڽ��ѣ� 099������ֹ��999 ������Ŀ
		String businessType = tDetailEle.getChildText("BusinessType");
        if("CT".equals(businessType)){//�˱�
			line.append("003|");
		}else if("WT".equals(businessType)){//����
			line.append("002|");
		}else if("MQ".equals(businessType)){//���ڸ���
			line.append("001|");
		}else if("CLAIM".equals(businessType)){//����
			line.append("099|");
		}else if("RENEW".equals(businessType)){//���ڽ���
			line.append("004|");
		}else{//������Ŀ
			line.append("999|");
		}
		//ҵ�������� YYYYMMDD������״̬�������
		String contState = tDetailEle.getChildText("ContState");
		if("00".equals(contState)){
			line.append(tDetailEle.getChildText(XmlTag.SignDate)+"|");
		}else{
			line.append(tDetailEle.getChildText("EdorCTDate")+"|");
		}
		//���д���
		line.append("26"+"|");
        //���������루����������û�е����룩
		line.append(tDetailEle.getChildText(XmlTag.NodeNo)+"|");
        //Ͷ����ӡˢ��(20λ)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//Ͷ��������
		line.append(tDetailEle.getChildText("AppntName")+"|");
		//Ͷ����֤������
		line.append(tDetailEle.getChildText("AppntIDType")+"|");
		//Ͷ����֤������
		line.append(tDetailEle.getChildText("AppntIDNo")+"|");
		//��������״̬
		if("00".equals(contState)||"01".equals(contState) || "02".equals(contState) || "04".equals(contState) ){
			line.append(tDetailEle.getChildText("ContState")+"|");
		}else if("WT".equals(contState)){
			line.append("03|");
		}else{
			line.append("08|");
		}
		//�������µ�������
		line.append(tDetailEle.getChildText("ContEndDate")+"|");
		//�����ֶ�1
		line.append(""+"|");
		//�����ֶ�2
		line.append(""+"|");
		//�����ֶ�3
		line.append(""+"|");
		//�����ֶ�4
		line.append(""+"|");
        // ���з�
        line.append("\n"); 
		return line;
	}
	
	/** 
	 * ����ļ���ʽ��
	 * HRBB(4λ)+���ڣ�8λ��yyyymmdd��+UPDATESTATUS.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
        return  "HRBB" + DateUtil.getDateStr(calendar, "yyyyMMdd") + "UPDATESTATUS.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
		
	}

	@Override
	protected void setHead(Element head) {
		
	}

    /**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		HrbQueryPolicyStatus blc = new HrbQueryPolicyStatus();
		blc.run();
		
		System.out.println(" ���Ժ�̨ print info : ");
	}

    @Override
    protected String getFtpName() {
        return getFileName();
    }
	
}

