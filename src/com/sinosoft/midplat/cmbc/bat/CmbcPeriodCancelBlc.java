package com.sinosoft.midplat.cmbc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.cmbc.CmbcConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class CmbcPeriodCancelBlc extends Balance {
	public CmbcPeriodCancelBlc() {
		super(CmbcConf.newInstance(), 3013);
	}

	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(
				outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	
	protected String getFileName() {
		
		Element mBankEle = cThisConfRoot.getChild("bank");
		return  mBankEle.getAttributeValue("insu") +"HC"+ DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
		
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into CmbcPeriodCancelBlc.parse()...");

		String mCharset = cThisBusiConf.getChildText(charset);
		if (null == mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(
				pBatIs, mCharset));

		Element mBodyEle = new Element(Body);
		Element pubContInfo = new Element("PubContInfo");
		Element edorFlag = new Element("EdorFlag");
		edorFlag.setText("8");
		Element ctBlcType = new Element("CTBlcType");
		ctBlcType.setText("0");
		Element wtBlcType = new Element("WTBlcType");
		wtBlcType.setText("1");
		Element mqBlcType = new Element("MQBlcType");
		mqBlcType.setText("0");
		Element xqBlcType = new Element("XQBlcType");
		xqBlcType.setText("0");
		Element caBlcType = new Element("CABlcType");
		caBlcType.setText("0");
		pubContInfo.addContent(edorFlag);
		pubContInfo.addContent(ctBlcType);
		pubContInfo.addContent(wtBlcType);
		pubContInfo.addContent(mqBlcType);
		pubContInfo.addContent(xqBlcType);
		pubContInfo.addContent(caBlcType);
		mBodyEle.addContent(pubContInfo);
		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			// 空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			Element tranNo = new Element("TranNo");
			tranNo.setText(tSubMsgs[2]);
			Element bankCode = new Element("BankCode");
			bankCode.setText("");
			Element edorType = new Element("EdorType");
			edorType.setText("WT");
			Element edorAppNo = new Element("EdorAppNo");
			Element edorNo = new Element("EdorNo");
			Element edorAppDate = new Element("EdorAppDate");
			edorAppDate.setText(tSubMsgs[0]);
			Element riskCode = new Element("RiskCode");
			Element tranMoney = new Element("TranMoney");
			Element accNo = new Element("AccNo");
			Element accName = new Element("AccName");
			Element rCode = new Element("RCode");
			rCode.setText("0");
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[1]);

			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tranNo);
			tDetailEle.addContent(bankCode);
			tDetailEle.addContent(edorType);
			tDetailEle.addContent(edorAppNo);	
			tDetailEle.addContent(edorNo);
			tDetailEle.addContent(edorAppDate);
			tDetailEle.addContent(riskCode);
			tDetailEle.addContent(tranMoney);
			tDetailEle.addContent(accNo);
			tDetailEle.addContent(accName);
			tDetailEle.addContent(rCode);
			tDetailEle.addContent(tContNoEle);

			mBodyEle.addContent(tDetailEle);
		}
		mBufReader.close(); // 关闭流

		cLogger.info("Out CmbcPeriodCancelBlc.parse()!");
		return mBodyEle;
		
	}
    
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.cmbc.bat.CmbcPeriodCancelBlc.main");
		mLogger.info("程序开始...");

		CmbcPeriodCancelBlc mBatch = new CmbcPeriodCancelBlc();

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

