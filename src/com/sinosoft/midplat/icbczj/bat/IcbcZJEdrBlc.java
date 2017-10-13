/**
 * ���չ�˾���б�ȫ���ˣ��㽭����ר����Ʒ��
 * 	�����ı�ȫҵ���У�
 * 	01��ԥ���˱���02���ڸ�����03���
 */

package com.sinosoft.midplat.icbczj.bat;

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
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcZJEdrBlc extends UploadFileBatchService {

	public IcbcZJEdrBlc() {
		super(IcbcZJConf.newInstance(), "184");
	}
	
	/** 
	 * �ļ����ƣ�
	 * ICBCZJ+���չ�˾����(3λ)+���д���(01)+YYYYMMDD+BAOQUAN.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "ICBCZJ" + mBankEle.getAttributeValue("insu")+ mBankEle.getAttributeValue("id")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "BAOQUAN.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        //��ѯ����
        Element mEdorAppDate = new Element("EdorAppDate");
        mEdorAppDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mEdorAppDate);
        
        //��ȫ����
        Element mEdorTypes = new Element("EdorTypes");
        //���˱�ȫ
        Element mEdorType1 = new Element("EdorType");
        mEdorType1.setText("WT");
        mEdorTypes.addContent(mEdorType1);
//        //���ڱ�ȫ
//        Element mEdorType2 = new Element("EdorType");
//        mEdorType2.setText("MQ");
//        mEdorTypes.addContent(mEdorType2);
        
        bodyEle.addContent(mEdorTypes);
	}
	
	
	
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
	 * ҵ������(2λ)+������ˮ��(8λ)+���д���(2λ) +������(5λ)+�����(5λ)+����(3λ)+�����־(2λ) +
	 * ������(30λ)+������(30λ)+��ȡ�˻�(19λ)+�˻�����(20λ)+��������(8λ)+��12λ����С���㣩+�������ͣ�2λ��
	 * @param tDetailEle
	 * @return
	 */
	private StringBuffer getLine(Element tDetailEle){
		StringBuffer line = new StringBuffer();
		//ҵ������(2λ)��ҵ�����ͣ�07��ԥ�ڳ�����09 ���ڸ��� 
		line.append(IcbcZJCodeMapping.edorTypeFromPGI(tDetailEle.getChildText("EdorType"))+"|"); 
		//Ӧ�������н�����ˮ�ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.TranNo)+"|");
		//���չ�˾����(2λ) 
		line.append("044"+"|");
		//�����룬ǰ5λ��ʾ������
		line.append(tDetailEle.getChildText("AreaCode")+"|");
		//����ţ�5λ��
		line.append(tDetailEle.getChildText("BankCode")+"|");
		//��������(3λ)��0-����;1-����;2-����;3-����Ӫ��;5-�ֻ�����; 6-ҵ������;7- ������۷����ն�;8-�����ն�;10-����Ӫ����������֮�⣬��˾�밴�����ֵ䴦��
		line.append(IcbcZJCodeMapping.sourceTypeFromPGI(tDetailEle.getChildText("SourceType"))+"|"); 
		//�����־���ɹ�01
		line.append("01"+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
		//�����ţ�30λ��
		line.append(tDetailEle.getChildText("EdorNo")+"|");
		//��ȡ�˻�(19λ)
		line.append(tDetailEle.getChildText("AccNo")+"|");
		//�˻�����(20λ)
		line.append(tDetailEle.getChildText("AccName")+"|");
		//�������ڣ�YYYYMMDD��
		line.append(tDetailEle.getChildText("EdorAppDate")+"|");
		//��12λ����С���㣩
		line.append(NumberUtil.fenToYuan(tDetailEle.getChildText("TranMoney"))+"|");
		//���ղ�Ʒ����(3λ)
		String sqlStr = "select BAK1 from cont where TranCom='1' and contno = '"+tDetailEle.getChildText(XmlTag.ContNo)+"'";
		SSRS results = new ExeSQL().execSQL(sqlStr);
		if (results.MaxRow < 1) {
			line.append("|");
		} else {		
			line.append(IcbcZJCodeMapping.riskCodeFromPGI(results.GetText(1, 1))+"|");
		}
		/**
		//��������(2λ)��01��ԥ���˱���02���ڸ�����03�� 
		line.append(IcbcZJCodeMapping.tranType1FromPGI(tDetailEle.getChildText("EdorType"))+"|"); 
		**/
		//������
		line.append("0.00|");		
		
        // ���з�
        line.append("\n"); 
		return line;
	}
	
	public static void main(String[] args) throws Exception {
		IcbcZJEdrBlc blc = new IcbcZJEdrBlc();
//		blc.postProcess();
		blc.run();
		System.out.println(" ���Ժ�̨ print info : ");
	}

	@Override
	protected void setHead(Element head) {
		// TODO Auto-generated method stub
		
	}
}
