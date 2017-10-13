package com.sinosoft.midplat.cmbc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class CancelForSelfTermInXsl extends XslCache {

	private static CancelForSelfTermInXsl cThisIns = new CancelForSelfTermInXsl();

	private String cPath = "com/sinosoft/midplat/cmbc/format/CancelForSelfTermIn.xsl";

	private CancelForSelfTermInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into CancelForSelfTermInXsl.load()...");

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

		cLogger.info("Out CancelForSelfTermInXsl.load()!");
	}

	public static CancelForSelfTermInXsl newInstance() {
		return cThisIns;
	}

}