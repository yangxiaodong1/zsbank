package com.sinosoft.midplat.cdrcb.bat;



import java.util.Calendar;

import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.NewBalance;
import com.sinosoft.midplat.cdrcb.CdrcbConf;
import com.sinosoft.midplat.common.DateUtil;


/**
 * @Title: com.sinosoft.midplat.cdrcb.bat.PledgeEdrBlc.java
 * @Description: 保单质押贷款
 * Copyright: Copyright (c) 2016
 * Company:安邦保险IT部
 * 
 * @date 20160406
 * @version 
 *
 */
public class PledgeEdrBlc  extends CdrcbBalance{

	public PledgeEdrBlc() {
		super(CdrcbConf.newInstance(), "2809");
		
	}

	/**
	 * 文件名规则：YYYYMMDD_BAODAN_INFO.txt；
	 * 成都农商行质押贷款对账文件，是凌晨5点对前一天的对账文件数据，对账文件名是前一天的日期。
	 */
	protected String getFileName() {
		Calendar c = Calendar.getInstance();
		c.setTime(cTranDate); 
		c.add(Calendar.DATE, -1);
//		cTranDate = c.getTime();
//		System.out.println("cTranDate=============" + DateUtil.getDateStr(cTranDate, "yyyyMMdd"));
		return   DateUtil.getDateStr(c.getTime(), "yyyyMMdd") + "_BAODAN_INFO.txt";
	}

	@Override
    protected Element getHead() {
        Element mHead = super.getHead();
        Calendar c = Calendar.getInstance();
		c.setTime(cTranDate); 
		c.add(Calendar.DATE, -1);
		mHead.getChild(TranDate).setText(DateUtil.getDateStr(c.getTime(), "yyyyMMdd"));
        return setHead(mHead);
    }
	
	public static void main(String[] args) throws Exception {
		
		PledgeEdrBlc blc = new PledgeEdrBlc();
		blc.run();
	}
}

