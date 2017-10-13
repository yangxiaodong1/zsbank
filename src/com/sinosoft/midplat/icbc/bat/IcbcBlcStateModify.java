/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * �˹��˱�״̬���֪ͨ
 * @author ChengNing
 * @date   Apr 2, 2013
 */
public class IcbcBlcStateModify extends UploadFileBatchService  {
	public IcbcBlcStateModify() {
		super(IcbcConf.newInstance(), "124");
	}

	/**
	 * �ļ����
	 * ������(5��) | ���չ�˾����(3λ) |  ���н�����ˮ��(25λ) |  Ͷ����ӡˢ��(20λ) |  Ͷ��������(30λ) | ����״̬��2λ�� | ��ע��120λ��|
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#parse(org.jdom.Document)
	 */
	@Override
	protected String parse(Document outStdXml) throws Exception {
        StringBuffer content = new StringBuffer();
        Element tFlag  = (Element) XPath.selectSingleNode(outStdXml.getRootElement(), "//Head/Flag");
        if ( tFlag!=null && tFlag.getValue().equals("0")){
            //��������
            List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
            
            cLogger.debug("���ķ���״̬�����¼��"+tDetailList.size());

            for(Element tDetailEle : tDetailList){ 
            	//������ӵ������ļ�
            	content.append(getLine(tDetailEle));
            }
        }else{
            //������
            cLogger.warn("���ķ��ش����ģ����ɿ��ļ�:"+getFileName());
        }
        
        return content.toString();
	}
	
	/**
	 * ��֯�����ļ��е�����Ϣ
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
        //�����룬ǰ5λ��ʾ������
		line.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
        //���չ�˾����(3λ)
		line.append(thisRootConf.getChild("bank").getAttributeValue("insu")+"|");
        //���н�����ˮ��(25λ)
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
        //Ͷ����ӡˢ��(20λ)
		line.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
		//Ͷ��������(30λ)
		line.append(tDetailEle.getChildText("AppntName")+"|");
		//����״̬��2λ��
		line.append(IcbcCodeMapping.processStateFromPGI(tDetailEle.getChildText("Progress"))+"|");
		//��ע��120λ��
		line.append(tDetailEle.getChildText("ReMark")+"|");
		
        // ���з�
        line.append("\n"); 
		return line;
	}

	/** 
	 * ���״̬�ļ�����
	 * TOICBC�����չ�˾���루3λ��+���д��루2λ��+���ڣ�8λ��+05.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.UploadFileBatchService#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "TOICBC" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "05.txt";
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
	public static void main(String[] args) {
		IcbcBlcStateModify blc = new IcbcBlcStateModify();
		blc.run();

	}

}
