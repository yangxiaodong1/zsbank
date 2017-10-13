package com.sinosoft.midplat.cmbc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**   
 * @Title: ContConfirmForNetBankInXsl.java 
 * @Package com.sinosoft.midplat.cmbc.format 
 * @Description: ����������������ǩ������xslת���ļ��� 
 * @date Oct 9, 2015 11:12:35 AM 
 * @version V1.0   
 */

public class ContConfirmForNetBankInXsl extends XslCache {

	private static ContConfirmForNetBankInXsl cThisIns = new ContConfirmForNetBankInXsl();
	
	private String cPath = "com/sinosoft/midplat/cmbc/format/ContConfirmForNetBankIn.xsl";
	
	private ContConfirmForNetBankInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into ContConfirmForNetBankInXsl.load()...");
		
		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		recordStatus();
		
		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//�Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}
		
		cLogger.info("Out ContConfirmForNetBankInXsl.load()!");
	}
	
	public static ContConfirmForNetBankInXsl newInstance() {
		return cThisIns;
	}

}
