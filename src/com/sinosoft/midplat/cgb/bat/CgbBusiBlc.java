package com.sinosoft.midplat.cgb.bat;

import java.util.Calendar;

import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.cgb.CgbConf;
import com.sinosoft.midplat.common.DateUtil;

public class CgbBusiBlc extends ABBalance {

    public CgbBusiBlc() {
        super(CgbConf.newInstance(), 2206);
    }

    protected String getFileName() {
        Element mBankEle = cThisConfRoot.getChild("bank");
        Calendar mCalendar = Calendar.getInstance();
	    mCalendar.setTime(cTranDate);
	    mCalendar.add(Calendar.DATE,-1);
        return  mBankEle.getAttributeValue("insu") 
                + mBankEle.getAttributeValue(id)
                + DateUtil.getDateStr(mCalendar.getTime(), "yyyyMMdd") + "01.txt";
    }
    
    
	protected Element getHead() {
		Element mHead = super.getHead();

//		Element mBankCode = new Element("BankCode");
//		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
//		mHead.addContent(mBankCode);
		Calendar mCalendar = Calendar.getInstance();
	    mCalendar.setTime(cTranDate);
	    mCalendar.add(Calendar.DATE,-1);
	    mHead.getChild("TranDate").setText(DateUtil.getDateStr(mCalendar.getTime(), "yyyyMMdd"));

		return mHead;
	}
    
    public static void main(String[] Str) throws Exception {
    	
    	CgbBusiBlc blc = new CgbBusiBlc();
    	
    	blc.run();
    }
}
