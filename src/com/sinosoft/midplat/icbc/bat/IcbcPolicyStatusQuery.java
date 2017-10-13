/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.XmlTag;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.icbc.IcbcConf;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * ��ѯ����״̬�б仯�ı��������޹�������������
 */
public class IcbcPolicyStatusQuery extends UploadFileBatchService  {
	public IcbcPolicyStatusQuery() {
		super(IcbcConf.newInstance(), "125");
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
        //��������
        List<Element> tDetailList = XPath.selectNodes(outStdXml.getRootElement(), "//Body/Detail");
        cLogger.debug("���ķ��غ˱������¼��"+tDetailList.size());
        //���չ�˾����(3λ)
        String insuId = thisRootConf.getChild("bank").getAttributeValue("insu");
        
        String tempPro = "";
        for(Element tDetailEle : tDetailList){ 
            //��������
            content.append(tDetailEle.getChildText("EdorCTDate")+"|");
            //ҵ������
            content.append(getBusinessType(tDetailEle.getChildText("BusinessType"))+"|");
            //ҵ��������
            content.append(tDetailEle.getChildText("EdorCTDate")+"|");
            //���չ�˾����(3λ)
            content.append(insuId+"|");
            //�����룬ǰ5λ��ʾ������
            content.append(tDetailEle.getChildText(XmlTag.NodeNo).substring(0, 5)+"|");
            //Ͷ����ӡˢ��(20λ)
            
            tempPro = getProByContNO(tDetailEle.getChildText(XmlTag.ContNo));
            if(StringUtils.isEmpty(tempPro)){	// û�в�ѯ����Ӧ�����ݣ�˵���ǹ�����ĵ��ӣ���ԭ�߼�
            
            	content.append(tDetailEle.getChildText(XmlTag.ProposalPrtNo)+"|");
            }else{	// ��ѯ��Ͷ�����ţ�˵��������or�����նˣ����ò�ѯ�������ݡ�
            	content.append(tempPro+"|");
            }
            
            //�����ţ�30λ��
            content.append(tDetailEle.getChildText(XmlTag.ContNo)+"|");
            //�ͻ�����
            content.append(tDetailEle.getChildText("AppntName")+"|");
            //�ͻ�֤������
            content.append(getIdType(tDetailEle.getChildText("AppntIDType"))+"|");
            //�ͻ�֤����
            content.append(tDetailEle.getChildText("AppntIDNo")+"|");
            //��������״̬
            content.append(getContState(tDetailEle.getChildText("ContState"))+"|");
            //����������
            content.append(tDetailEle.getChildText("ContEndDate")+"|");
            //���
            content.append(tDetailEle.getChildText("EdorCTPrem")+"|");
            //����ռλ��
            content.append("|||");

            // ���з�
            content.append("\n"); 
        }
        
        return content.toString();
	}
	
	/**
	 * ��Թ��������������նˣ�ͨ�������Ż�ȡ���е�Ͷ�����š�
	 * (����ϵͳ�Լ���һ����������������ն�����Ͷ�����ŵ��㷨�����㷨�뱣�չ�˾��Ͷ�������㷨��һ����������Ҫ����ӳ��ת��)
	 * @param cContNo
	 * @return
	 */
	private String getProByContNO(String cContNo){
		
		StringBuffer mSqlStr = new StringBuffer();
		String tProposalprtno = "";
        mSqlStr.append("select l.proposalprtno from tranlog l where l.contno='")
//				.append(cContNo).append("' and (l.funcflag='131' or l.funcflag='141' or l.funcflag='151')");
        //�㽭�����ֻ��������õ������������������˴�����Ҫ�����ֻ�����
        		.append(cContNo).append("' and (l.funcflag='131' or l.funcflag='141')");
        
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        try{
        
        	if(mSSRS.MaxRow==0){
            	throw new MidplatException("δ��ѯ��������Ӧ�ı������ݣ�������='" + cContNo +"' ");
            }else if(mSSRS.MaxRow!=1){
            	throw new MidplatException("��ѯ���Ĺ�����Ӧ�ı������ݲ�Ψһ��������='" + cContNo +"' ");
            }else{
            	tProposalprtno = mSSRS.GetText(1, 1);
            }
        	
        }catch(Exception exp){
        	cLogger.info(exp.getMessage());
        }
        
        return tProposalprtno; 
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
        return  "ENYIAAS" + mBankEle.getAttributeValue("insu")+ "_" +mBankEle.getAttributeValue("id")+ "_"+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "_UPDATESTATUS.txt";
	}
	
	@Override
	protected void setBody(Element bodyEle) {
        Element mBusinessTypes = new Element("BusinessTypes");
        //RENEW-����
        Element mBusinessType = new Element("BusinessType");
        mBusinessType.setText("RENEW");
        mBusinessTypes.addContent(mBusinessType);

        //CLAIM-����
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CLAIM");
        mBusinessTypes.addContent(mBusinessType);

        //AA�������ӱ���
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("AA");
        mBusinessTypes.addContent(mBusinessType);

        //UP����׷�ӱ���
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("UP");
        mBusinessTypes.addContent(mBusinessType);

        //ZP����׷�ӱ���(˫�ʻ�)
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("ZP");
        mBusinessTypes.addContent(mBusinessType);

        //CT�˱�
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("CT");
        mBusinessTypes.addContent(mBusinessType);

        //WT��ԥ���˱�
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("WT");
        mBusinessTypes.addContent(mBusinessType);

        //MQ���ڸ���
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("MQ");
        mBusinessTypes.addContent(mBusinessType);

        
       //XTЭ���˱�
        mBusinessType = new Element("BusinessType");
        mBusinessType.setText("XT");
        mBusinessTypes.addContent(mBusinessType);
        bodyEle.addContent(mBusinessTypes);
        
        //��ѯ����
        Element mEdorCTDate = new Element("EdorCTDate");
        mEdorCTDate.setText(DateUtil.getDateStr(calendar, "yyyyMMdd"));
        bodyEle.addContent(mEdorCTDate);
	}

	@Override
	protected void setHead(Element head) {
	    //ȫ���ļ����治��
	    head.getChild("TranNo").setText(getFileName().substring(14));
	}

	
	@Override
    protected boolean postProcess() throws Exception {

	    OutputStream temp = null;
	    FileInputStream fin = null;
	    //�����ļ�
	    String unEncodedFile = null;
	    //�����ļ�
	    String encodedFile = null;
	    
        try {
            //���ص�ַ
            String path = this.thisBusiConf.getChildTextTrim("localDir");
            unEncodedFile = path+File.separator+getFileName();
            encodedFile = path+File.separator+getFtpName();
            
            cLogger.info("�����ļ���"+unEncodedFile+"...");
            
            //���ɵ������ļ�
            fin = new FileInputStream(unEncodedFile);
            //���ɵ������ļ�
            temp = new FileOutputStream(encodedFile);
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
            cLogger.error("�����ļ�ʧ��!"+unEncodedFile, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("�ر��ļ�ʧ��!"+encodedFile, e);
                }
            }
            if (fin != null) {
                try{
                    fin.close();
                }catch(Exception e){
                    cLogger.error("�ر��ļ�ʧ��!"+unEncodedFile, e);
                }
            }
        }
	    return true;
    }

    /**
	 * @param args
     * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
	    new IcbcPolicyStatusQuery().postProcess();
	    System.out.println("ooooooooo");
	}
    
	@Override
	protected String getFtpName() {
	    // TODO Auto-generated method stub
	    return getFileName().replaceFirst("txt", "des");
	}

	/**
	 * ҵ������ӳ�䣨����--���У���
	 * </br>���ģ�RENEW-���ڣ�CLAIM-���⣻AA�������ӱ��UP����׷�ӱ��ѡ�ZP����׷�ӱ���(˫�ʻ�)��CT�˱���WT��ԥ���˱���MQ���ڸ���
	 * </br>���У�001���ڸ�����002��ԥ�ڳ�����003�˱���004���ڽ��ѣ�005׷��Ͷ����099������ֹ
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("RENEW".equals(type)){
	        //RENEW-����--->004���ڽ���
	        return "004";
	    }else if("CLAIM".equals(type)){
	        //CLAIM-����--->099������ֹ
	        return "099";
	    }else if("AA".equals(type)){
	        //AA�������ӱ���--->005׷��Ͷ��
	        return "005";
        }else if("UP".equals(type)){
            //UP����׷�ӱ���--->005׷��Ͷ��
            return "005";
        }else if("ZP".equals(type)){
            //ZP����׷�ӱ���(˫�ʻ�)--->005׷��Ͷ��
            return "005";
        }else if("CT".equals(type)){
            //CT�˱�--->003�˱�
            return "003";
        }else if("WT".equals(type)){
            //WT��ԥ���˱�--->002��ԥ�ڳ���
            return "002";
        }else if("MQ".equals(type)){
            //MQ���ڸ���--->001���ڸ���
            return "001";
        }else if("XT".equals(type)){
            //XTЭ���˱�������㽭����ר����Ʒ�����⴦��--->002��ԥ�ڳ���
        	//���ں�����Ըý��׵�sql��ѯ�������ƣ�����˴��ɺ���ת������Ļ����Ķ��ϴ�����������������Э���˱�״̬ʱ������ͨ�������Ҫ�����޸�
            return "002";
        }
	    return "";
	}
	
	/**
	 * ӳ��֤�����ͣ�����--���У�
	 * </br> ���ģ�0-�������֤;1-����;2-����֤;3-����;4-����֤��;5-���ڲ�;8-����;9-�쳣���֤
	 * </br> ���У�0-���֤;1-����;2-����֤;3-ʿ��֤;4-�۰�̨ͨ��֤;5-��ʱ���֤;6-���ڱ�;9-����֤;12-����˾���֤
	 * @param type
	 * @return
	 */
	private String getIdType( String type) {
	    if("0".equals(type)){
            //0-�������֤--->0-���֤
            return "0";
        }else if("1".equals(type)){
            //1-����--->1-����
            return "1";
        }else if("2".equals(type)){
            //2-����֤--->2-����֤
            return "2";
        }else if("5".equals(type)){
            //5-���ڲ�--->6-���ڱ�
            return "6";
        }
        return "";
	}
	
	/**
	 * ����״̬ӳ�䣨����--���У�
	 * </br>���ģ� 00��Ч,01������ֹ,02�˱���ֹ,03��Լ��ֹ,04������ֹ,05�Ե���ֹ,06������ֹ,07ʧ����ֹ,08������ֹ,WT��ԥ���˱���ֹ
	 * </br>���У� 12-������Ч 14-��ԥ���˱���������ֹ 20-�˱���ֹ 21-������ֹ 23-���ڸ�����ֹ
	 * @param type
	 * @return
	 */
	private String getContState( String type) {
	    if("00".equals(type)){
            //00��Ч-->12-������Ч
            return "12";
        }else if("01".equals(type)){
	        //01������ֹ-->23-���ڸ�����ֹ
	        return "23";
	    }else if("02".equals(type)){
	        //02�˱���ֹ-->20-�˱���ֹ
            return "20";
        }else if("04".equals(type)){
            //04������ֹ-->21-������ֹ
            return "21";
        }else if("WT".equals(type)){
            //WT��ԥ���˱���ֹ-->14-��ԥ���˱���������ֹ
            return "14";
        }else if("XT".equals(type)){
            //XTЭ���˱�-->14-��ԥ���˱���������ֹ
        	//���ں�����Ըý��׵�sql��ѯ�������ƣ�����˴��ɺ���ת������Ļ����Ķ��ϴ�����������������Э���˱�״̬ʱ������ͨ�������Ҫ�����޸�
            return "14";
        }
        return "";
	}

}
