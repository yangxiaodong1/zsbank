package com.sinosoft.midplat.bjrcb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.bjrcb.format.NoRealTimeUWResultOutXsl.java
 * @Description: 加载北京农商非实时核保结果转换格式
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 12, 2014 3:48:52 PM
 * @version 
 *
 */
public class NoRealTimeUWResultOutXsl extends XslCache {

private static NoRealTimeUWResultOutXsl cThisIns = new NoRealTimeUWResultOutXsl();
	
	private String cPath = "com/sinosoft/midplat/bjrcb/format/NoRealTimeUWResultOut.xsl";
	
	private NoRealTimeUWResultOutXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	public void load() {

		cLogger.info("Into Bjrcb NoRealTimeUWResultOutXsl.load()...");
		
		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		/**
		 * 一定要在加载之前记录文件属性。
		 * 文件的加载到文件属性设置之间存在细微的时间差，
		 * 如果恰巧在此时间差内外部修改了文件，
		 * 那么记录的数据就是新修改后的，导致这次修改不会自动被加载；
		 * 将文件属性设置放在加载之前，就算在时间差内文件发生改变，
		 * 由于记录的是旧的属性，系统会在下一个时间单元重新加载，
		 * 这样顶多会导致同一文件多加载一次，但不会出现修改而不被加载的bug。
		 */
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
		
		cLogger.info("Out Bjrcb NoRealTimeUWResultOutXsl.load()!");
	}

	public static NoRealTimeUWResultOutXsl newInstance() {
		return cThisIns;
	}
}
