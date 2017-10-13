/**
 * 农行日终业务对账
 */

package com.sinosoft.midplat.abc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.abc.AbcConf;

public class AbcBusiBlc extends Balance {
	public AbcBusiBlc() {
		super(AbcConf.newInstance(), 406);
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
		return "B" + mBankEle.getAttributeValue("insu")
				+ mBankEle.getAttributeValue(id)
				+ DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".TXT";
	}

	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into AbcBusiBlc.parse()...");

		String mCharset = cThisBusiConf.getChildText(charset);
		if (null == mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}

		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(
				pBatIs, mCharset));

		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mPremEle);

		String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
		mCountEle.setText(mSubMsgs[4].trim());
		mPremEle.setText(String.valueOf(NumberUtil
				.yuanToFen(mSubMsgs[5].trim())));

		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
			cLogger.info(tLineMsg);

			// 空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}

			String[] tSubMsgs = tLineMsg.split("\\|", -1);

			if (!"01".equals(tSubMsgs[11])) {
				cLogger.warn("非承保保单，直接跳过，继续下一条！");
				continue;
			}

			Element tTranDateEle = new Element(TranDate);
			tTranDateEle.setText(tSubMsgs[0]);

			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[2]);

			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[3] + tSubMsgs[4] + tSubMsgs[5]);

			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[8]);

			Element tPremEle = new Element(Prem);
			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[9]);
			tPremEle.setText(String.valueOf(tPremFen));

			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);

			mBodyEle.addContent(tDetailEle);
		}
		mBufReader.close(); // 关闭流

		cLogger.info("Out AbcBusiBlc.parse()!");
		return mBodyEle;
	}

	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.icbc.bat.AbcBusiBlc.main");
		mLogger.info("程序开始...");

		AbcBusiBlc mBatch = new AbcBusiBlc();

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
