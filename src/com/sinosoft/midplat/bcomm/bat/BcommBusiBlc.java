package com.sinosoft.midplat.bcomm.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.bcomm.BcommConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.bcomm.bat.BcommBusiBlc.java
 * @Description: 日终对账交易
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Feb 8, 2014 2:30:36 PM
 * @version 
 *
 */
public class BcommBusiBlc extends Balance {

	public BcommBusiBlc() {
		super(BcommConf.newInstance(), 1406);	// FunFlag=1406-日终对账
	}

	protected Element getHead() {
		
        Element mHead = super.getHead();

        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);

        return mHead;
    }
	
	/* 
	 * FIXME 待确认后调整，需确认“银行分行号”和“保险公司编码”
	 */
	protected String getFileName() {
		/**
		 * 总对总对账，文件命名规则: 银行分行号（6位）”_“保险公司编码（10位）”_“YYYYMMDD（8位）”
		 */
		Element mBankEle = cThisConfRoot.getChild("bank");

		return mBankEle.getAttributeValue("id") + "_" + mBankEle.getAttributeValue("insu") + "_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd");
	}
	
	/* 
	 * 将银行端发送非标准对账文件转化为核心端标准对账文件
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into BcommBusiBlc.parse()...");
		
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
		
		long mSumPrem = 0;	// 总保费--明细记录里的保费累加值
		int mCount = 0;	// 总份数--明细记录里的件数累加值
		long bankInsuSumPrem = 0;	// 总承保笔数
		int bankInsuCount = 0;	// 总承保金额
		boolean readFirst = true;	
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info("读取对账文件的一行内容：" + tLineMsg);
			
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			
			if(readFirst){	// 只读首行汇总信息
				/*
				 * 字符型采用左对齐右补空格；笔数采用右对齐左补0；金额采用右对齐左补0，以分为单位，没有小数点
				 * 
				 * 首行汇总信息格式：
				 * 银行代码(字符10位，交通银行固定为“10”，左对齐右补空格)
				 * +银行分行代码(字符10位,左对齐右补空格)
				 * +保险分公司编码(字符10位,左对齐右补空格)
				 * +交易日期(字符8位，YYYYMMDD)
				 * +交易时间(字符6位，HHMMSS)
				 * +当前对帐日期(字符8位，YYYYMMDD)
				 * +总承保笔数(数字10位，右对齐左补0)
				 * +总承保金额(数字15位，右对齐左补0以分为单位，无小数)
				 * +总撤销笔数(数字10位，右对齐左补0)
				 * +总撤销金额(数字15位，右对齐左补0以分为单位，无小数)
				 * 
				 */
				bankInsuCount = Integer.parseInt(tLineMsg.substring(52, 62));	// 总承保笔数
				bankInsuSumPrem = Long.parseLong(tLineMsg.substring(62, 77));	// 总承保金额
				readFirst = false;
				continue;
			}else{	// 读取一条对账明细记录(非首行记录)
				
				/*
				 * 交易日期	Char(8)	非空	YYYYMMDD
				 * 交易时间	Char(6)	非空	HHMMSS
				 * 银行流水号	Char(20)	非空	左对齐右补空格
				 * 交易金额	Dec(15,0)	非空	右对齐左补0,以分为单位，无小数
				 * 交易状态	Char(1)	非空	0-正常,1-冲正/撤销
				 * 投保人姓名	Char(20)	非空	左对齐右补空格
				 */
				// 交易状态：0-正常，1-冲正/撤销
				String flag = tLineMsg.substring(49,50).trim();
				if("0".equals(flag)){	// 0=正常承保的保单

					// 交易日期
					Element tTranDateEle = new Element(TranDate);
					tTranDateEle.setText(tLineMsg.substring(0, 8).trim());
					
					// 交易流水号
					Element tTranNoEle = new Element(TranNo);
					tTranNoEle.setText(tLineMsg.substring(14, 34).trim());
					
					// 保费
					Element tPremEle = new Element(Prem);
					String tPremFen = String.valueOf(Integer.parseInt(tLineMsg.substring(34, 49).trim()));
					tPremEle.setText(tPremFen);
					
					// 网点编号
					Element tNodeNoEle = new Element(NodeNo);
					
					// 合同号
					Element tContNoEle = new Element(ContNo);
					
					// 需根据传递的流水号获取地区及网点代码，从成功的承保记录(funcflag=1)中查询
					String sqlStr = "select NodeNo, contno from TranLog where TranCom='"
							+ cThisConfRoot.getChildText(TranCom)
							+ "' and TranNo='"
							+ tTranNoEle.getTextTrim()
							+ "' and TranDate="
							+ tTranDateEle.getTextTrim() 
							+ " and Rcode=0 ";
					SSRS results = new ExeSQL().execSQL(sqlStr);
					if (results.MaxRow != 1) {
						cLogger.error("交行对账：查询交易日志失败，流水号[" + tTranNoEle.getTextTrim() + "]");
					} else {
						
						tNodeNoEle.setText(results.GetText(1, 1));
						tContNoEle.setText(results.GetText(1, 2));
					}
					
					Element tDetailEle = new Element(Detail);
					tDetailEle.addContent(tTranDateEle);
					tDetailEle.addContent(tNodeNoEle);
					tDetailEle.addContent(tTranNoEle);
					tDetailEle.addContent(tContNoEle);
					tDetailEle.addContent(tPremEle);
					
					mCount++;
					mSumPrem += Long.parseLong(tPremFen);
					JdomUtil.print(tDetailEle);//打印每条Detail
					mBodyEle.addContent(tDetailEle);
				}
				
			}
			
		}
		mCountEle.setText(String.valueOf(bankInsuCount));
		mPremEle.setText(String.valueOf(bankInsuSumPrem));
		mBufReader.close();	//关闭流
		
		cLogger.info("Out BcommBusiBlc.parse()!");
		
		if(bankInsuCount!=mCount || bankInsuSumPrem!=mSumPrem){
			cLogger.info("银行传递报文数据有误，汇总保单件数或者保费总数有误!");
		}
		
		return mBodyEle;
	}
	
	
	public static void main(String[] args){
		String tLineMsg = "10        11        111       201402262020202014022600000000020000000020000000000000003000000005000000";
		
		int bankInsuCount = Integer.parseInt(tLineMsg.substring(52, 62));	// 总承保笔数
		int bankInsuSumPrem = Integer.parseInt(tLineMsg.substring(62, 77));	// 总承保金额
		
		BcommBusiBlc mBatch = new BcommBusiBlc();
		mBatch.run();
		
	}
	
}



