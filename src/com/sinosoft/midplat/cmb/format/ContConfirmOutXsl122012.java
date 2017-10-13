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
 * @Description: �����������б��ĸ�ʽת���ļ�������-->���У�����ʢ��2���������գ������ͣ�
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
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
		
		cLogger.info("Out ContConfirmOutXsl122012.load()!");
		
	}
	
	public static ContConfirmOutXsl122012 newInstance() {
		return cThisIns;
	}

}
