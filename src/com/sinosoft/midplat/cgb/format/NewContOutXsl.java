package com.sinosoft.midplat.cgb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NewContOutXsl extends XslCache {
	private static NewContOutXsl cThisIns = new NewContOutXsl(); //yxd  NewContOutXslde �ľ�̬����ΪʲôҪ����д��ʲô�ô���������

	private String cPath = "com/sinosoft/midplat/cgb/format/NewContOut.xsl";//yxd   NewContOut.xsl  �ļ�������·��

	private NewContOutXsl() {    //NewContOutXsl ��Ĺ��캯�� 
		load();             //yxd����NewContOut.xsl �ļ���Ҫ����Ӧ�� ���ĵĸ�ʽ����NewContOut.xsl�е㿴����ѽ
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into NewContOutXsl.load()...");

		String mFilePath = SysInfo.cBasePath + cPath; // yxd ƴ��·��
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath); //�������mFilePath·�����ļ�����

		recordStatus();

		cXslTrsf = loadXsl(cXslFile); 
		cLogger.info("End load " + mFilePath + "!");

		// �Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(
						JdomUtil.toString(
								JdomUtil.build(new FileInputStream(cXslFile)), ""));//yxd�϶�ת��ʲô �Ķ�������
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}

		cLogger.info("Out NewContOutXsl.load()!");
	}

	public static NewContOutXsl newInstance() {
		return cThisIns;
	}
}

