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
 * @Title: com.sinosoft.midplat.hxb.bat.HxbAgentBlc.java
 * @Description: 华夏银行客户经理信息更新
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Apr 22, 2014 5:37:56 PM
 * @version 
 *
 */
public class HxbManagerBlc extends Balance{

	public HxbManagerBlc() {
		super(HxbConf.newInstance(), 1507);	// 华夏银行客户经理信息更新
	}
	
	/* 
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		/*
		 * 文件命名规则：hxb_khjl +业务日期（8位）+.txt
		 * 例如: hxb_khjl20140302.txt
		 */
		StringBuffer strBuffer = new StringBuffer();
		String strFile = strBuffer.append("hxb_khjl").append(DateUtil.get8Date(cTranDate)).append(".txt").toString();
		return strFile;
	}
	
	/* 负责文件格式转换
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		/*
		 * 文件内容格式：所属机构代码|客户经理代码|客户经理姓名|客户经理资格证书号|资格证书有效期
		 * 1)各字段以“|”分开，一条记录一行。
		 * 例如：0264|4181|李四|20060911010090000820|2015102
		 * 0264|4182|张三|20060911010090000821|20161021
		 * 2) 若记录中有字段为空值，则显示为空格
		 * 0261|4066|周妍|  |20160121
		 */
		cLogger.info("Into HxbManagerBlc.parse()...");
		
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
			
			Element mManagerCodeEle = new Element(HxbConstant.ManagerCode);	// 客户经理代码
			mManagerCodeEle.setText(tSubMsgs[1]);
			
			Element mManagerNameEle = new Element(HxbConstant.ManagerName);	// 客户经理姓名
			mManagerNameEle.setText(tSubMsgs[2]);
			
			Element mManagerCertifNoEle = new Element(HxbConstant.ManagerCertifNo);	// 客户经理资格证书号
			mManagerCertifNoEle.setText(tSubMsgs[3]);
			
			Element mEndDateEle = new Element(HxbConstant.CertifEndDate);	// 资格证书有效期
			mEndDateEle.setText(tSubMsgs[4]);
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(mBankCodeEle);
			tDetailEle.addContent(mManagerCodeEle);
			tDetailEle.addContent(mManagerNameEle);
			tDetailEle.addContent(mManagerCertifNoEle);
			tDetailEle.addContent(mEndDateEle);
			
			mBodyEle.addContent(tDetailEle);
			JdomUtil.print(tDetailEle);//打印每条Detail
		}
		mBufReader.close();	//关闭流
		
		cLogger.info("Out HxbManagerBlc.parse()!");
		
		return mBodyEle;
	}
	
	
}


