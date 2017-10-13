package com.sinosoft.midplat.cmb.bat;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.cmb.service.CmbBalance;
import com.sinosoft.midplat.exception.MidplatException;

public class CmbReContBlc extends CmbBalance {
    
	public CmbReContBlc() {
		super(CmbConf.newInstance(), "1025");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();
		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);
		return mHead;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.cmbc.bat.CmbReContBlc.main");
		mLogger.info("程序开始...");

		CmbReContBlc mBatch = new CmbReContBlc();
		
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
				Element headEle = mBatch.getHead();
				headEle.setAttribute("TranDate",args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}
		mBatch.run();
		if(mBatch.cResultMsg != null && !"".equals(mBatch.cResultMsg.trim())){
			
		}else{
			mBatch.cResultMsg = "补对账完成，请查看日志信息！";
		}
		
		mLogger.info("成功结束！");
	}

	@Override
	protected String getFileName() {	
		// TODO Auto-generated method stub
		return "1";
	}

}

