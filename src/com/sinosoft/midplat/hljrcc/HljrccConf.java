package com.sinosoft.midplat.hljrcc;

import java.io.File;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @author ShenQQ
 * @date  Oct 12 2013
 */
public class HljrccConf extends XmlConf {

	private static final HljrccConf cThisIns = new HljrccConf();

	private static final String cPath = "conf/hljrcc.xml";
	
	public HljrccConf(){
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into HljrccConf.load()...");
		
		String mFilePath = SysInfo.cHome + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cConfFile = new File(mFilePath);
		
		recordStatus();
		
		cConfDoc = loadXml(cConfFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//是否输出配置文件
		if (MidplatConf.newInstance().outConf()) {
			cLogger.info(JdomUtil.toString(cConfDoc));
		}
		
		cLogger.info("Out HljrccConf.load()!");
	}
	
	public static HljrccConf newInstance() {
		return cThisIns;
	}

}
