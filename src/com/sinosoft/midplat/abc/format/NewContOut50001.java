package com.sinosoft.midplat.abc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * @Title: com.sinosoft.midplat.abc.format.NewContOut50001.java
 * @Description: ũ�в�Ʒ��ϣ����ı�׼����-->���зǱ�׼���ģ�ת��ģ�����
 * Copyright: Copyright (c) 2013
 * Company:�����IT��
 * 
 * @date Nov 25, 2013 4:12:05 PM
 * @version 
 *
 */
public class NewContOut50001 extends XslCache{

	private static NewContOut50001 cThisIns = new NewContOut50001();

	private String cPath = "com/sinosoft/midplat/abc/format/NewContOut50001.xsl";
	
	private NewContOut50001() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into NewContOut50001.load()...");

		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath);

		/**
		 * һ��Ҫ�ڼ���֮ǰ��¼�ļ����ԡ� �ļ��ļ��ص��ļ���������֮�����ϸ΢��ʱ�� ���ǡ���ڴ�ʱ������ⲿ�޸����ļ���
		 * ��ô��¼�����ݾ������޸ĺ�ģ���������޸Ĳ����Զ������أ� ���ļ��������÷��ڼ���֮ǰ��������ʱ������ļ������ı䣬
		 * ���ڼ�¼���Ǿɵ����ԣ�ϵͳ������һ��ʱ�䵥Ԫ���¼��أ� ��������ᵼ��ͬһ�ļ������һ�Σ�����������޸Ķ��������ص�bug��
		 */
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

		cLogger.info("Out NewContOut50001.load()!");
	}

	public static NewContOut50001 newInstance() {
		return cThisIns;
	}
}
