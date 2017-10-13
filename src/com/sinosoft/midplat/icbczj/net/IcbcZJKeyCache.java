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
	//私钥密钥
	private String cPriPath = "key/icbczjkey/private.key";
	//公钥密钥
	private String cPubPath = "key/icbczjkey/public.key";
	
	private IcbcZJKeyCache() {
		load();
		FileCacheManage.newInstance().register(cPriPath, this);
		FileCacheManage.newInstance().register(cPubPath, this);
	}
	
	public void load() {
		cLogger.info("Into IcbcZJKeyCache.load()...");
		//私钥文件
		String mPriFilePath = SysInfo.cHome + cPriPath;
		cLogger.info("Start load " + mPriFilePath + "...");
		//公钥文件
		String mPubFilePath = SysInfo.cHome + cPubPath;
		cLogger.info("Start load " + mPubFilePath + "...");
		
		cPriKeyFile = new File(mPriFilePath);
		cPubKeyFile = new File(mPubFilePath);
		
		/**
		 * 一定要在加载之前记录文件属性。
		 * 文件的加载到文件属性设置之间存在细微的时间差，
		 * 如果恰巧在此时间差内外部修改了文件，
		 * 那么记录的数据就是新修改后的，导致这次修改不会自动被加载；
		 * 将文件属性设置放在加载之前，就算在时间差内文件发生改变，
		 * 由于记录的是旧的属性，系统会在下一个时间单元重新加载，
		 * 这样顶多会导致同一文件多加载一次，但不会出现修改而不被加载的bug。
		 */
		recordStatus();
		
		try {
			//私钥
			InputStream mIsPriKeyFile = new FileInputStream(cPriKeyFile);
    		cPriKey = IOTrans.toBytes(mIsPriKeyFile); 
    		mIsPriKeyFile.close();
	        
	        //公钥
    		InputStream mcPubKeyFile = new FileInputStream(cPubKeyFile);
    		cPubKey = IOTrans.toBytes(mcPubKeyFile); 
    		mcPubKeyFile.close();
			
	        
			
		} catch(Exception ex) {
			cLogger.error("密钥文件有误！", ex);
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
