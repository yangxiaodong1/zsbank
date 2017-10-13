/**
 * 
 */
package com.sinosoft.midplat.cmb.bat;

import org.jdom.Element;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.cmb.bat.packer.CmbXmlRecordPacker;
import com.sinosoft.midplat.common.DateUtil;

/**
 * ��ѯ����״̬�б仯�ı�����������������������
 */
public class CmbQueryPolicyStatus extends UploadFileBatchService {
    
	public CmbQueryPolicyStatus() {
		super(CmbConf.newInstance(), "1011");
	}
	
	@Override
    protected void setBody(Element bodyEle) {
    }

    @Override
    protected void setHead(Element head) {
    }

    /** 
	 * ����ļ���ʽ��
	 * BDZT(4λ)�����չ�˾����(3λ)+ ���ڣ�8λ��yyyymmdd��+01.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		Element mBankEle = thisRootConf.getChild("bank");
        return  "BDZT" + mBankEle.getAttributeValue("insu")+
        	DateUtil.getDateStr(calendar, "yyyyMMdd") + "01.txt";
	}
	
    @Override
    protected RecordPacker getDefaultRecordPacker() {
        //����Ĭ�ϴ����
        return new CmbXmlRecordPacker();
    }

    /**
	 * @param args
	 */
	public static void main(String[] args) {
	    System.out.println(new CmbQueryPolicyStatus().getFtpName());
	}

}
