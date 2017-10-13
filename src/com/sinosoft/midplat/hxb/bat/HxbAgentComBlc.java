package com.sinosoft.midplat.hxb.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.hxb.HxbConf;
import com.sinosoft.midplat.hxb.format.HxbConstant;

/**
 * @Title: com.sinosoft.midplat.hxb.bat.HxbAgentComBlc.java
 * @Description: 华夏网点信息更新
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Apr 22, 2014 6:14:26 PM
 * @version 
 *
 */
public class HxbAgentComBlc extends Balance{

	public HxbAgentComBlc() {
		super(HxbConf.newInstance(), 1506);	// 华夏银行网点信息更新
	}

	/* 
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		/*
		 * 文件命名规则：hxb_jgxx+业务日期（8位）+.txt
		 * 例如：hxb_jgxx20140302.txt
		 */
		StringBuffer strBuffer = new StringBuffer();
		String strFile = strBuffer.append("hxb_jgxx").append(DateUtil.get8Date(cTranDate)).append(".txt").toString();
		return strFile;
	}
	
	/* 负责文件格式转换
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		/*
		 * 机构代码|机构简称|机构全称|机构级别|上级机构代码|上级机构简称
		 * 1）各字段以“|”分开，一条记录一行。
		 * 例如：1453|互助路支行|互助路支行|支行|1400|西安分行
		 * 0363|江宁支行|江宁支行|支行|0300|南京分行
		 * 2）机构级别：华夏银行（即总行）、分行、支行
		 * 3）若记录中有字段为空值，则显示为空格，例如总行无上级机构，则该条记录显示为：
		 * 例如：3041000|华夏银行|华夏银行|华夏银行|  |  
		 */
		cLogger.info("Into HxbAgentComBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		Element mBodyEle = new Element(Body);
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			Element mBankCodeEle = new Element(HxbConstant.BankCode);	// 所属机构代码
			mBankCodeEle.setText(tSubMsgs[0]);
			
			Element mBankShortNameEle = new Element(HxbConstant.BankShortName);	// 机构简称
			mBankShortNameEle.setText(tSubMsgs[1]);
			
			Element mBankFullNameEle = new Element(HxbConstant.BankFullName);	// 机构全称
			mBankFullNameEle.setText(tSubMsgs[2]);
			
			Element mBankTypeEle = new Element(HxbConstant.BankType);	// 机构级别
			mBankTypeEle.setText(tSubMsgs[3]);
			
			Element mUpBankCodeEle = new Element(HxbConstant.UpBankCode);	// 上级机构代码
			mUpBankCodeEle.setText(tSubMsgs[4]);
			
			Element mUpBankShotNameEle = new Element(HxbConstant.UpBankShotName);	// 上级机构简称
			mUpBankShotNameEle.setText(tSubMsgs[5]);
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(mBankCodeEle);
			tDetailEle.addContent(mBankShortNameEle);
			tDetailEle.addContent(mBankFullNameEle);
			tDetailEle.addContent(mBankTypeEle);
			tDetailEle.addContent(mUpBankCodeEle);
			tDetailEle.addContent(mUpBankShotNameEle);
			
			mBodyEle.addContent(tDetailEle);
			JdomUtil.print(tDetailEle);//打印每条Detail
		}
		mBufReader.close();	//关闭流
		
		cLogger.info("Out HxbAgentComBlc.parse()!");
		
		return mBodyEle;
	}
	
}
