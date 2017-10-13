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
 * @Title: com.sinosoft.midplat.cmb.format.ContConfirmOutXsl122009.java
 * @Description: �����������б��ĸ�ʽת���ļ�������-->���У�����ƽ�5����ȫ���գ��ֺ��ͣ�A��
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Sep 5, 2014 4:41:59 PM
 * @version 
 *
 */
public class ContConfirmOutXsl122009 extends XslCache {

	private static ContConfirmOutXsl122009 cThisIns = new ContConfirmOutXsl122009();
	
	private String cPath = "com/sinosoft/midplat/cmb/format/ContConfirmOut122009.xsl";
	
	private ContConfirmOutXsl122009() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {

		cLogger.info("Into ContConfirmOutXsl122009.load()...");
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
		
		cLogger.info("Out ContConfirmOutXsl122009.load()!");
		
	}
	
	public static ContConfirmOutXsl122009 newInstance() {
		return cThisIns;
	}

}
