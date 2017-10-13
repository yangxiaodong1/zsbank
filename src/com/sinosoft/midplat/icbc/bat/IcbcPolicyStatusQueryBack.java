/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IcbcCipherUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.icbc.IcbcCodeMapping;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * <p>����״̬�������</p>
 * NRT = Not-Real-Time
 * @author liying
 * @date  2015-05-11
 */
/**
 * @author liying
 * @date   2015-05-11
 */
public class IcbcPolicyStatusQueryBack extends Balance  {
	
	private static final String BLC_FILE_TAG = "ENY";

	public IcbcPolicyStatusQueryBack() {
		super(IcbcConf.newInstance(), "127");
	}

	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}

	/** 
	 * �����ļ���ʽ��
	 * ENY+���չ�˾����+ENYIAAS���չ�˾����_���д���_��������_UPDATESTATUS_back.txt.des
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu") + "_" +
		mBankEle.getAttributeValue(id)+"_" +DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"_UPDATESTATUS_back.txt.des";
	}

	protected String getBackupFileName() {
	    Element mBankEle = cThisConfRoot.getChild("bank");
	    return BLC_FILE_TAG + mBankEle.getAttributeValue("insu")+ BLC_FILE_TAG + "IAAS" + mBankEle.getAttributeValue("insu")+ "_" +
	    mBankEle.getAttributeValue(id) +"_" +DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"_UPDATESTATUS_back.txt";
	}
	
	/**
	 * ���������ļ�����֯��XML�������ڷ���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into " + this.getClass().getName() + ".parse()...");
		InputStream fInput = null;
		try{
		    //�����ļ�
		    byte[] content = this.decrypt(pBatIs);
		    
		    //���������ļ�
		    this.saveFile(content, getBackupFileName());
		    
		    //�½���
		    fInput = new ByteArrayInputStream(content);
		}catch(Exception e){
		    cLogger.error("�����ļ�ʧ��" + getFileName(), e);
		    throw new Exception ("�����ļ�ʧ��"+ getFileName(),e);
		}finally{
		    if(pBatIs!=null){
		        pBatIs.close();
		    }
		}
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		BufferedReader mBufReader = new BufferedReader(
				new InputStreamReader(fInput, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		//Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		//mBodyEle.addContent(mPremEle);
		long mSumPrem = 0;
		int mCount = 0;
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			Element tDetailEle = lineToNode(tLineMsg);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			//mSumPrem += tPremFen;
		}
		mCountEle.setText(String.valueOf(mCount));
		//mPremEle.setText(String.valueOf(mSumPrem));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out " + this.getClass().getName() + ".parse()!");
		return mBodyEle;
	}
	
	private byte[] decrypt(InputStream pBatIs)
            throws Exception {
        ByteArrayOutputStream fileBaos = new ByteArrayOutputStream();
        // ��ȡ�ļ�
        byte[] b = new byte[2048];
        int length = -1;
        while ((length = pBatIs.read(b)) != -1) {
            fileBaos.write(b, 0, length);
        }
        fileBaos.flush();

        // �����ļ�
        byte[] content = fileBaos.toByteArray();
        content = new IcbcCipherUtil().decrypt(content, true);

        return content;
    }
	
	private void saveFile(byte[] content, String fileName){
        //����Կд����Կ�ļ�
        FileOutputStream temp = null;
        try {
            String path = this.cThisBusiConf.getChildTextTrim("localDir");
            String pathName = path+File.separator+fileName;
            cLogger.info("�����ļ���"+pathName+"...");
            temp = new FileOutputStream(pathName);
            temp.write(content);
            temp.flush();
        } catch (Exception e) {
            cLogger.error("�����ļ�ʧ��!"+fileName, e);
        } finally {
            if (temp != null) {
                try{
                    temp.close();
                }catch(Exception e){
                    cLogger.error("�ر��ļ�ʧ��!"+fileName, e);
                }
            }
        }
	}
	
	/**
     * �������ļ���ÿ������ת��Ϊ�����е�һ��XML�ڵ�
     * 
     * ��ǰ����0|�ɹ�ʧ�ܱ�־1|�����ļ���2|ʧ��ԭ��3|��������4|ҵ������5|	ҵ��������6|���չ�˾����7|���е�����8|Ͷ������9|������ͬ��10|
     * �ͻ�����11|�ͻ�֤������12|�ͻ�֤������13|��������״̬14|������������15|�����ֶ�1|�����ֶ�2|�����ֶ�3|�����ֶ�4|
     * 
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tDetailEle = new Element(Detail);
		
		//������
		Element tContNo = new Element(ContNo);
		tContNo.setText(tSubMsgs[10]);
		tDetailEle.addContent(tContNo);
		//<!-- Ͷ��������-->
		Element tAppntName = new Element("AppntName");
		tAppntName.setText(tSubMsgs[11]);
		tDetailEle.addContent(tAppntName);
		//<!-- Ͷ����֤������-->
		Element tAppntIDType = new Element("AppntIDType");
		tAppntIDType.setText(IcbcCodeMapping.idTypeToPGI(tSubMsgs[12]));
		tDetailEle.addContent(tAppntIDType);
		//<!-- Ͷ����֤����-->
		Element tAppntIDNo = new Element("AppntIDNo");
		tAppntIDNo.setText(tSubMsgs[13]);
		tDetailEle.addContent(tAppntIDNo);
		//<!-- ҵ������ -->
		Element tBusinessType = new Element("BusinessType");
		tBusinessType.setText(getBusinessType(tSubMsgs[5]));
		tDetailEle.addContent(tBusinessType);
		//<!-- ҵ����֣�-->
		
		
		//<!-- ���ж˴������-->
		Element tHandleInfo = new Element("HandleInfo");
		//<!-- �������ڣ�yyyymmdd��-->
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[6]);
		tHandleInfo.addContent(tTranDateEle);
		
		//<!--���ж���ˮ��-->
		Element tTranNoEle = new Element("TranNo");
		tTranNoEle.setText("");
		tHandleInfo.addContent(tTranNoEle);
		
		//<!-- �Ƿ�ɹ���0�ɹ� 1ʧ�ܣ�-->
		Element tResultFlagEle = new Element("ResultFlag");
		tResultFlagEle.setText(tSubMsgs[1]);
		tHandleInfo.addContent(tResultFlagEle);
		
		//<!-- ������-->
		
		//<!-- ��������-->
		Element tResultMsgEle = new Element("ResultMsg");
		tResultMsgEle.setText(tSubMsgs[3]);
		tHandleInfo.addContent(tResultMsgEle);
		
		//<!-- ��ע-->
		
		tDetailEle.addContent(tHandleInfo);
		
		
		return tDetailEle;
	}
	/**
	 * ҵ������ӳ�䣨����--���ģ���
	 * </br>���ģ�RENEW-���ڣ�CLAIM-���⣻AA�������ӱ��UP����׷�ӱ��ѡ�ZP����׷�ӱ���(˫�ʻ�)��CT�˱���WT��ԥ���˱���MQ���ڸ���
	 * </br>���У�001���ڸ�����002��ԥ�ڳ�����003�˱���004���ڽ��ѣ�005׷��Ͷ����099������ֹ
	 * @param type 
	 * @return
	 */
	private String getBusinessType( String type) {
	    if("004".equals(type)){
	        //RENEW-����--->004���ڽ���
	        return "RENEW";
	    }else if("099".equals(type)){
	        //CLAIM-����--->099������ֹ
	        return "CLAIM";
	    }else if("005".equals(type)){
	        //AA�������ӱ���--->005׷��Ͷ��
	        return "AA";
        }else if("003".equals(type)){
            //CT�˱�--->003�˱�
            return "CT";
        }else if("002".equals(type)){
            //WT��ԥ���˱�--->002��ԥ�ڳ���
            return "WT";
        }else if("001".equals(type)){
            //MQ���ڸ���--->001���ڸ���
            return "MQ";
        }
	    return "";
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcPolicyStatusQueryBack blc = new IcbcPolicyStatusQueryBack();
		blc.run();
	}

}
