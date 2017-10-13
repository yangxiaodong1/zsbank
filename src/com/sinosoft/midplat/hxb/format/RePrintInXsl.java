package com.sinosoft.midplat.hxb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.hxb.format.RePrintInXsl.java
 * @Description: TODO
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 17, 2014 6:17:59 PM
 * @version 
 *
 */
public class RePrintInXsl extends XslCache{

	private static RePrintInXsl cThisIns = new RePrintInXsl();

	private String cPath = "com/sinosoft/midplat/hxb/format/RePrintIn.xsl";

	private RePrintInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into RePrintInXsl.load()...");

		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath);

		recordStatus();

		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mFilePath + "!");

		// �Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}

		cLogger.info("Out RePrintInXsl.load()!");
	}

	public static RePrintInXsl newInstance() {
		return cThisIns;
	}

}

