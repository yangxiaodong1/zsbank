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
 * 招行产品净值回传交易（仅限招行所有产品）
 */
public class CmbProductNetQuery extends UploadFileBatchService {
    
	public CmbProductNetQuery() {
		super(CmbConf.newInstance(), "1022");
	}
	
	@Override
    protected void setBody(Element bodyEle) {
    }

    @Override
    protected void setHead(Element head) {
    }

    /** 
	 * 结果文件格式：
	 * 文件名规则：INS +日期 + 序号.txt  如: INS2015010101.txt 
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
        return  "INS" + 
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
	    System.out.println(new CmbProductNetQuery().getFtpName());
	}

}
