package com.sinosoft.midplat.ccb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.ccb.format.ContConfirmOutXsl122035.java
 * @Description: �й���������ʢ��9�Ų�Ʒת��
 * Copyright: Copyright (c) 2013
 * Company:�����IT��
 * 
 * @date Nov 14, 2013 11:00:02 AM
 * @version 
 *
 */
public class ContConfirmOutXsl122035 extends XslCache{

	private static ContConfirmOutXsl122035 cThisIns = new ContConfirmOutXsl122035();
	
	private String cPath = "com/sinosoft/midplat/ccb/format/ContConfirmOut122035.xsl";
	
	private ContConfirmOutXsl122035() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into ContConfirmOutXsl122035.load()...");
		String mFilePath = SysInfo.cBasePath + cPath;
		
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		/**
		 * һ��Ҫ�ڼ���֮ǰ��¼�ļ����ԡ�
		 * �ļ��ļ��ص��ļ���������֮�����ϸ΢��ʱ��
		 * ���ǡ���ڴ�ʱ������ⲿ�޸����ļ���
		 * ��ô��¼�����ݾ������޸ĺ�ģ���������޸Ĳ����Զ������أ�
		 * ���ļ��������÷��ڼ���֮ǰ��������ʱ������ļ������ı䣬
		 * ���ڼ�¼���Ǿɵ����ԣ�ϵͳ������һ��ʱ�䵥Ԫ���¼��أ�
		 * ��������ᵼ��ͬһ�ļ������һ�Σ�����������޸Ķ��������ص�bug��
		 */
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
		
		cLogger.info("Out ContConfirmOutXsl122035.load()!");
		
	}
	
	public static ContConfirmOutXsl122035 newInstance() {
		return cThisIns;
	}

}
