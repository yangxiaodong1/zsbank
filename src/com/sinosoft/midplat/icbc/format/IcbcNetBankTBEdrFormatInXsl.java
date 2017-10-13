package com.sinosoft.midplat.icbc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.icbc.format.IcbcNetBankTBEdrFormatInXsl.java
 * @Description: ���ع�����������ȷ�Ͻ���ת���ļ�
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Jul 18, 2014 3:53:52 PM
 * @version 
 *
 */
public class IcbcNetBankTBEdrFormatInXsl extends XslCache {

	private static IcbcNetBankTBEdrFormatInXsl cThisIns = new IcbcNetBankTBEdrFormatInXsl();
	
	private String cPath = "com/sinosoft/midplat/icbc/format/IcbcNetBankTBEdrFormatIn.xsl";
							
	private IcbcNetBankTBEdrFormatInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into IcbcNetBankTBEdrFormatInXsl.load()...");
		
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
		
		cLogger.info("Out IcbcNetBankTBEdrFormatInXsl.load()!");
	}
	
	public static IcbcNetBankTBEdrFormatInXsl newInstance() {
		return cThisIns;
	}
}
