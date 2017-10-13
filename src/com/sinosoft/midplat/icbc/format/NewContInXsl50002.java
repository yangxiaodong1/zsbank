package com.sinosoft.midplat.icbc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;


/**
 * @Title: com.sinosoft.midplat.icbc.format.NewContInXsl50002.java
 * @Description: 
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jan 6, 2014 10:49:26 AM
 * @version 
 *
 */
public class NewContInXsl50002 extends XslCache{

	private static NewContInXsl50002 cThisIns = new NewContInXsl50002();
	
	private String cPath = "com/sinosoft/midplat/icbc/format/NewContIn50002.xsl";
	
	private NewContInXsl50002() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into NewContInXsl50002.load()...");
		
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
		
		cLogger.info("Out NewContInXsl50002.load()!");
	}
	
	public static NewContInXsl50002 newInstance() {
		return cThisIns;
	}

	
}


