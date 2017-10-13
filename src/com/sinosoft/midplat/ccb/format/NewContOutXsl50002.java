package com.sinosoft.midplat.ccb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.ccb.format.NewContOutXsl50002.java
 * @Description: 核心标准报文转换为非标准报文模板
 * Copyright: Copyright (c) 2013
 * Company:安邦保险IT部
 * 
 * @date Dec 17, 2013 2:52:07 PM
 * @version 
 *
 */
public class NewContOutXsl50002 extends XslCache{

	private static NewContOutXsl50002 cThisIns = new NewContOutXsl50002();
	
	private String cPath = "com/sinosoft/midplat/ccb/format/NewContOut50002.xsl";
	
	private NewContOutXsl50002() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	public void load() {
		cLogger.info("Into NewContOutXsl50002.load()...");
		
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
		
		cLogger.info("Out NewContOutXsl50002.load()!");
		
	}
	
	public static NewContOutXsl50002 newInstance() {
		return cThisIns;
	}

}

