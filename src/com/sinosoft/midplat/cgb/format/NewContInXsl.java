package com.sinosoft.midplat.cgb.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class NewContInXsl extends XslCache {
	private static NewContInXsl cThisIns = new NewContInXsl();//yxd ����һ��NewContInXsl����  �Լ�����������Լ��д����Լ��Ķ����𣿣�

	private String cPath = "com/sinosoft/midplat/cgb/format/NewContIn.xsl"; //yxd NewContIn.xsl�ļ���·��

	private NewContInXsl() {  //NewContInXsl��Ĺ��췽��
		load();// yxd ����
		FileCacheManage.newInstance().register(cPath, this);// yxd �������ȥ�����ע�᲻֪����ʲô��˼����
	}

	public void load() { //�������������ɶ���� ����load�������ǲ�֪��
		cLogger.info("Into NewContInXsl.load()...");//yxd ��־�������NewContInXsl ���еļ��ط���

		String mFilePath = SysInfo.cBasePath + cPath; //yxd SysInfo.cBasePath����������ȥ��֪�����·����ʲô
		cLogger.info("Start load " + mFilePath + "...");//yxd ��ӡ������ƴ�Ӻõ�·��

		cXslFile = new File(mFilePath); //yxd ����һ���ļ������� ����mFilePath ���·��

		recordStatus(); //���ü�¼״̬��������������֪�������ɶ��˼

		cXslTrsf = loadXsl(cXslFile);//yxd ����������
		cLogger.info("End load " + mFilePath + "!");

		// �Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) { //������Ľӿ���� �����xsl�ľ�ִ�������
			try {
				cLogger.info(
						JdomUtil.toString(
								JdomUtil.build(new FileInputStream(cXslFile)), "")); //yxd���cXslFile �ļ�������������ʲô���ĸ�ʽ������ɶ
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex); //����������ʱ�� ���������Ϣ
			}
		}

		cLogger.info("Out NewContInXsl.load()!");//yxd �����־
	}

	public static NewContInXsl newInstance() {  //��һ�������Ǹ���ģ����� ��̬����
		return cThisIns;
	}
}
