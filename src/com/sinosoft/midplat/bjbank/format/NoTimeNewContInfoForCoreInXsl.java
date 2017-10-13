package com.sinosoft.midplat.bjbank.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NoTimeNewContInfoForCoreInXsl extends XslCache {
	private static NoTimeNewContInfoForCoreInXsl cThisIns = new NoTimeNewContInfoForCoreInXsl();
	
	private String cPath = "com/sinosoft/midplat/bjbank/format/NoTimeNewContInfoForCoreIn.xsl";
	
	private NoTimeNewContInfoForCoreInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into NoTimeNewContInfoForCoreInXsl.load()...");
		
		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		recordStatus();
		
		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//�Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(
						JdomUtil.toString(
								JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}
		
		cLogger.info("Out NoTimeNewContInfoForCoreInXsl.load()!");
	}
	
	public static NoTimeNewContInfoForCoreInXsl newInstance() {
		return cThisIns;
	}
}


