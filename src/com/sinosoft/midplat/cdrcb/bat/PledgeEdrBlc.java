package com.sinosoft.midplat.cdrcb.bat;



import java.util.Calendar;

import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.bat.NewBalance;
import com.sinosoft.midplat.cdrcb.CdrcbConf;
import com.sinosoft.midplat.common.DateUtil;


/**
 * @Title: com.sinosoft.midplat.cdrcb.bat.PledgeEdrBlc.java
 * @Description: ������Ѻ����
 * Copyright: Copyright (c) 2016
 * Company:�����IT��
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
	 * �ļ�������YYYYMMDD_BAODAN_INFO.txt��
	 * �ɶ�ũ������Ѻ��������ļ������賿5���ǰһ��Ķ����ļ����ݣ������ļ�����ǰһ������ڡ�
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

