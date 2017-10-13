package com.sinosoft.midplat.drcbank.bat;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.drcbank.DrcbConf;

/**
 * @Title: com.sinosoft.midplat.drcbank.bat.DrcbBusiBlc.java
 * @Description: ��ݸũ�����ն���
 * Copyright: Copyright (c) 2015
 * Company:�����IT��
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

