package com.sinosoft.midplat.cmbc.bat;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.cmbc.CmbcConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class CmbcBusiBlc extends ABBalance{

	public CmbcBusiBlc() {
        super(CmbcConf.newInstance(), 3004);
    }

    /* 
     * 保险公司代码(00xx)+文件类型（L资金对帐）+8位交易日期,例：0024L20140809.txt
     * (non-Javadoc)
     * @see com.sinosoft.midplat.bat.ABBalance#getFileName()
     */
	protected String getFileName() {
		
		Element mBankEle = cThisConfRoot.getChild("bank");
		
		StringBuffer strBuff = new StringBuffer(mBankEle.getAttributeValue("insu")).append("L")
			.append(DateUtil.getDateStr(cTranDate, "yyyyMMdd")).append(".txt");
		
    	return  strBuff.toString();
    }
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.cmbc.bat.CmbcPeriodCancelBlc.main");
		mLogger.info("程序开始...");

		CmbcBusiBlc mBatch = new CmbcBusiBlc();

		// 用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);

			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setDate(args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("成功结束！");
	}
}
