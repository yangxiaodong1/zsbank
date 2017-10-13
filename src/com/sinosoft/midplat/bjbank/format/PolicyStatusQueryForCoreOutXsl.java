package com.sinosoft.midplat.bjbank.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class PolicyStatusQueryForCoreOutXsl extends XslCache {
	private static PolicyStatusQueryForCoreOutXsl cThisIns = new PolicyStatusQueryForCoreOutXsl();
	
	private String cPath = "com/sinosoft/midplat/bjbank/format/PolicyStatusQueryForCoreOut.xsl";
	
	private PolicyStatusQueryForCoreOutXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into PolicyStatusQueryForCoreOutXsl.load()...");
		
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
		
		cLogger.info("Out PolicyStatusQueryForCoreOutXsl.load()!");
	}
	
	public static PolicyStatusQueryForCoreOutXsl newInstance() {
		return cThisIns;
	}
}
