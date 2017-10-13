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
 * @Title: com.sinosoft.midplat.cmb.format.ContConfirmOutXsl122012.java
 * @Description: 加载招商银行报文格式转换文件，核心-->银行，安邦盛世2号终身寿险（万能型）
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Sep 5, 2014 2:19:02 PM
 * @version 
 *
 */
public class ContConfirmOutXsl122012 extends XslCache {

	private static ContConfirmOutXsl122012 cThisIns = new ContConfirmOutXsl122012();
	
	private String cPath = "com/sinosoft/midplat/cmb/format/ContConfirmOut122012.xsl";
	
	private ContConfirmOutXsl122012() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {

		cLogger.info("Into ContConfirmOutXsl122012.load()...");
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
		
		cLogger.info("Out ContConfirmOutXsl122012.load()!");
		
	}
	
	public static ContConfirmOutXsl122012 newInstance() {
		return cThisIns;
	}

}
