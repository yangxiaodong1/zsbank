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
 * @Title: com.sinosoft.midplat.cmb.format.ContConfirmOutXslL12052.java
 * @Description: �����������б��ĸ�ʽת���ļ�������-->���У��������Ӯ1�������
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Sep 9, 2014 5:37:04 PM
 * @version 
 *
 */
public class ContConfirmOutXslL12052 extends XslCache {

	private static ContConfirmOutXslL12052 cThisIns = new ContConfirmOutXslL12052();
	
	private String cPath = "com/sinosoft/midplat/cmb/format/ContConfirmOutL12052.xsl";
	
	private ContConfirmOutXslL12052() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {

		cLogger.info("Into ContConfirmOutXslL12052.load()...");
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
		
		cLogger.info("Out ContConfirmOutXslL12052.load()!");
		
	}
	
	public static ContConfirmOutXslL12052 newInstance() {
		return cThisIns;
	}

}
