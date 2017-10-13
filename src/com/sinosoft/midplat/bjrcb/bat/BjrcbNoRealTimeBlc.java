package com.sinosoft.midplat.bjrcb.bat;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.packer.FixedDelimiterPacker;
import com.sinosoft.midplat.bat.packer.RecordPacker;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.bjrcb.bat.BjrcbNoRealTimeBlc.java
 * @Description: 北京农商行非实时日终对账
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 12, 2014 9:47:56 AM
 * @version 
 *
 */
public class BjrcbNoRealTimeBlc extends ABBalance {

	public BjrcbNoRealTimeBlc() {
		super(BjrcbConf.newInstance(), "1209");	// 非实时日终对账funFlag='1209'
	}

	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 * 非实时日终对账文件名格式：BRCB_HANDTB_H_日期.txt
	 */
	@Override
	protected String getFileName() {
		return  "BRCB_HANDTB_H_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
	}
	
    /* (non-Javadoc)
     * @see com.sinosoft.midplat.bat.ABBalance#getDefaultRecordPacker()
     * 北京农商行的非实时对账分隔符为：";"，不是默认的："|"，固此处需覆写。
     */
    protected RecordPacker getDefaultRecordPacker(){
        return new FixedDelimiterPacker("\\;",';');
    }

	public static void main(String[] args) throws Exception{
		BjrcbNoRealTimeBlc blc = new BjrcbNoRealTimeBlc();
		blc.run();
		System.out.println("******ok*********");
    }
}
