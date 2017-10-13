package com.sinosoft.midplat.citic.bat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.citic.CiticConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

/**
 * @Title: com.sinosoft.midplat.citic.bat.CiticBusiBlc.java
 * @Description: 中信银行新单日结对账
 * Copyright: Copyright (c) 2013 
 * Company:安邦保险IT部
 * 
 * @date Aug 19, 2013 8:18:55 PM
 * @version 
 *
 */
public class CiticBusiBlc extends Balance {
	public CiticBusiBlc() {
		super(CiticConf.newInstance(), "1105");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	/**
	 *	对账文件名：保险名称缩写+日期+文件后缀;<BR>
	 *	ABRS+YYYYMMDD+.DZ; 例如：ABRS20130819.DZ 
	 */
	protected String getFileName() {
		
		return "ABRS"+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+".DZ";
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into CiticBusiBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mPremEle);
		
		long mSumPrem = 0;
		int mCount = 0;
		long bankSumPrem = 0;
		int bankCount = 0;
		boolean readFirst = true;	
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			if(readFirst){	// 只读首行汇总信息
				bankCount = Integer.parseInt(tSubMsgs[0]);	// 银行对账报文里的总件数
				bankSumPrem = NumberUtil.yuanToFen(tSubMsgs[1]);	// 银行对账报文里的总保费
				readFirst = false;
				continue;
			}
			
			Element tTranDateEle = new Element(TranDate);
			
			String strDate = DateUtil.date10to8(tSubMsgs[0]);	// 将日期格式转换yyyy-MM-dd(yyyy/MM/dd, yyyy.MM.dd) --> yyyyMMdd
			tTranDateEle.setText(strDate);
			
			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[3]+tSubMsgs[4]);
			
			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[2]);
			
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);
			
			
			Element tPremEle = new Element(Prem);
			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
			tPremEle.setText(String.valueOf(tPremFen));

			/*Element tSourTypeEle = new Element("SourceType");
			if("01".equals(tSubMsgs[8])){
			    //柜面
			    tSourTypeEle.setText("0");
			}else{
			    //网银
			    tSourTypeEle.setText("1");
			}*/
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);
//			tDetailEle.addContent(tSourTypeEle);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			mSumPrem += tPremFen;
			JdomUtil.print(tDetailEle);//打印每条Detail
		}
		mCountEle.setText(String.valueOf(bankCount));
		mPremEle.setText(String.valueOf(bankSumPrem));
		mBufReader.close();	//关闭流
		
		cLogger.info("Out CiticBusiBlc.parse()!");
		
		if(bankCount!=mCount || bankSumPrem!=mSumPrem){
			cLogger.info("银行传递报文数据有误，汇总保单件数或者保费总数有误!");
		}
		
		return mBodyEle;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger.getLogger("com.sinosoft.midplat.citic.bat.CiticBusiBlc.main");
		mLogger.info("程序开始...");
		
		CiticBusiBlc mBatch = new CiticBusiBlc();
		//用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);
			
			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。
			 * 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				System.out.println(args[0]);
				mBatch.setDate("-------------"+args[0]);
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}
		
		mBatch.run();
//		String f = mBatch.getFileName();
//		File file = new File("D:/work/YBT/CITIC(中信银行)/test file/dz/"+"ABRS20130819.dz");
//		InputStream in = new FileInputStream(file);
//		Element domEle = mBatch.parse(in);
//		JdomUtil.print(domEle);
		
		mLogger.info("成功结束！");
	}
	
	
}
