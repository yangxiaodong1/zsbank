package com.sinosoft.midplat.hfbank.bat;


import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.hfbank.HfbankConf;


/**
 * @Title: com.sinosoft.midplat.hfbank.bat.HfbankBusiBlc.java
 * @Description: ����������ն���
 * Copyright: Copyright (c) 2016
 * Company:�����IT��
 * 
 * @date 20160325
 * @version 
 *
 */
public class HfbankBusiBlc  extends ABBalance{

	public HfbankBusiBlc() {
		super(HfbankConf.newInstance(), 3506);
	}

	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return  mBankEle.getAttributeValue("insu") + DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"01.txt";
	}
	
	
	    
}

