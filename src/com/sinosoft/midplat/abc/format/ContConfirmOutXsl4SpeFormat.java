package com.sinosoft.midplat.abc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.abc.format.ContConfirmOutXsl4SpeFormat.java
 * @Description: 针对盛世9号，黄金鼎6号的保单打印模板单独设计报文解析文件
 * Copyright: Copyright (c) 2013 
 * Company:安邦保险IT部
 * 
 * @date Sep 12, 2013 9:27:38 AM
 * @version 
 *
 */
public class ContConfirmOutXsl4SpeFormat extends XslCache{

	private static ContConfirmOutXsl4SpeFormat cThisIns = new ContConfirmOutXsl4SpeFormat();
	
	private String cPath = "com/sinosoft/midplat/abc/format/ContConfirmOutXsl4SpeFormat.xsl";
	
	private ContConfirmOutXsl4SpeFormat() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {

		cLogger.info("Into ContConfirmOutXsl4SpeFormat.load()...");
		
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
		
		cLogger.info("Out ContConfirmOutXsl4SpeFormat.load()!");
		
	}
	
	public static ContConfirmOutXsl4SpeFormat newInstance() {
		return cThisIns;
	}

}

