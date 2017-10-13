package com.sinosoft.midplat.drcbank.bat;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.drcbank.DrcbConf;

/**
 * @Title: com.sinosoft.midplat.drcbank.bat.DrcbBusiBlc.java
 * @Description: 东莞农商日终对账
 * Copyright: Copyright (c) 2015
 * Company:安邦保险IT部
 * 
 * @date Jan 20, 2015 10:38:56 AM
 * @version 
 *
 */
public class DrcbBusiBlc  extends ABBalance{

	public DrcbBusiBlc() {
		super(DrcbConf.newInstance(), 2904);
	}

	protected String getFileName() {
		return  "DRCB" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.txt";
	}
	    
}

