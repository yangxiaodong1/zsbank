package com.sinosoft.midplat.icbczj.net;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import java.io.FileReader;



import org.apache.log4j.Logger;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;

import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.cache.FileCacheManage;
import com.sinosoft.midplat.common.cache.Load;

public class IcbcZJKeyCache implements Load {
	private final static Logger cLogger = Logger.getLogger(IcbcZJKeyCache.class);
	
	private static IcbcZJKeyCache cThisIns = new IcbcZJKeyCache();
	
	private long cPriLastModified;
	private long cPubLastModified;
	private long cPriLength;
	private long cPubLength;
	
	private File cPriKeyFile = null;
	private File cPubKeyFile = null;
	
	private byte[] cPriKey = null;
	private byte[] cPubKey = null;
	//˽Կ��Կ
	private String cPriPath = "key/icbczjkey/private.key";
	//��Կ��Կ
	private String cPubPath = "key/icbczjkey/public.key";
	
	private IcbcZJKeyCache() {
		load();
		FileCacheManage.newInstance().register(cPriPath, this);
		FileCacheManage.newInstance().register(cPubPath, this);
	}
	
	public void load() {
		cLogger.info("Into IcbcZJKeyCache.load()...");
		//˽Կ�ļ�
		String mPriFilePath = SysInfo.cHome + cPriPath;
		cLogger.info("Start load " + mPriFilePath + "...");
		//��Կ�ļ�
		String mPubFilePath = SysInfo.cHome + cPubPath;
		cLogger.info("Start load " + mPubFilePath + "...");
		
		cPriKeyFile = new File(mPriFilePath);
		cPubKeyFile = new File(mPubFilePath);
		
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
		
		try {
			//˽Կ
			InputStream mIsPriKeyFile = new FileInputStream(cPriKeyFile);
    		cPriKey = IOTrans.toBytes(mIsPriKeyFile); 
    		mIsPriKeyFile.close();
	        
	        //��Կ
    		InputStream mcPubKeyFile = new FileInputStream(cPubKeyFile);
    		cPubKey = IOTrans.toBytes(mcPubKeyFile); 
    		mcPubKeyFile.close();
			
	        
			
		} catch(Exception ex) {
			cLogger.error("��Կ�ļ�����", ex);
		}
		
		cLogger.info("Out IcbcZJKeyCache.load()!");
	}
	
	public byte[] getPriKey() {
		return cPriKey;
	}
	
	public byte[] getPubKey() {
		return cPubKey;
	}
	
	public static IcbcZJKeyCache newInstance() {
		return cThisIns;
	}

	public boolean isChanged() {
		if (cPriKeyFile.lastModified()!=cPriLastModified
			|| cPriKeyFile.length()!=cPriLength ||cPubKeyFile.lastModified()!=cPubLastModified
			|| cPubKeyFile.length()!=cPubLength) {
			return true;
		} else {
			return false;
		}
	}
	
	protected final void recordStatus() {
		cPriLastModified = cPriKeyFile.lastModified();
		cPubLastModified = cPubKeyFile.lastModified();
		cPriLength = cPriKeyFile.length();
		cPubLength = cPubKeyFile.length();
		cLogger.info("conf file modified at (" + DateUtil.getDateStr(cPriLastModified, "yyyy-MM-dd HH:mm:ss,SSS") + ") and length=" + cPriLength + " bytes!");
	}
}
