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
 * 查询当天状态有变化的保单（仅限招行所出保单）
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
	 * 结果文件格式：
	 * BDZT(4位)＋保险公司代码(3位)+ 日期（8位，yyyymmdd）+01.txt
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
        //设置默认打包器
        return new CmbXmlRecordPacker();
    }

    /**
	 * @param args
	 */
	public static void main(String[] args) {
	    System.out.println(new CmbQueryPolicyStatus().getFtpName());
	}

}
