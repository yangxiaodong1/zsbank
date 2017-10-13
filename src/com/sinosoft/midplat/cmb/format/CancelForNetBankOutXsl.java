package com.sinosoft.midplat.cmb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.cmb.format.CancelForNetBankOutXsl.java
 * @Description: 加载招行网银当日撤单报文格式转换文件，银保通-->核心
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Nov 20, 2014 4:06:05 PM
 * @version 
 *
 */
public class CancelForNetBankOutXsl extends XslCache {

	private static CancelForNetBankOutXsl cThisIns = new CancelForNetBankOutXsl();
	
	private String cPath = "com/sinosoft/midplat/cmb/format/CancelForNetBankOut.xsl";
	
	private CancelForNetBankOutXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into CancelForNetBankOutXsl.load()...");
		
		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		recordStatus();
		
		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//是否输出xsl文件
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("输出xsl异常！", ex);
			}
		}
		
		cLogger.info("Out CancelForNetBankOutXsl.load()!");
	}
	
	public static CancelForNetBankOutXsl newInstance() {
		return cThisIns;
	}

}
