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
 * @Title: com.sinosoft.midplat.cmb.format.NewContOutXslForPlan.java
 * @Description: 
 * Copyright: Copyright (c) 2013
 * Company:安邦保险IT部
 * 
 * @date Oct 28, 2013 4:46:44 PM
 * @version 
 *
 */
public class NewContOutXslForPlan extends XslCache{

	private static NewContOutXslForPlan cThisIns = new NewContOutXslForPlan();
	
	private String cPath = "com/sinosoft/midplat/cmb/format/NewContOutForPlan.xsl";
	
	private NewContOutXslForPlan() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	public void load() {
		cLogger.info("Into NewContOutForPlan.load()...");
		
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
		
		cLogger.info("Out NewContOutForPlan.load()!");
		
	}
	
	public static NewContOutXslForPlan newInstance() {
		return cThisIns;
	}

}

