package com.sinosoft.midplat.citicHZ.net;

import java.io.File;
import java.security.PrivateKey;
import java.security.PublicKey;

import org.apache.log4j.Logger;

import com.sinosoft.midplat.cgb.net.CgbKeyCache;
import com.sinosoft.midplat.citicHZ.util.CiticHZKeyUtil;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.cache.FileCacheManage;
import com.sinosoft.midplat.common.cache.Load;

public class CiticHzKeyCache implements Load {
	private final static Logger cLogger = Logger.getLogger(CgbKeyCache.class);
	
	private static CiticHzKeyCache cThisIns = new CiticHzKeyCache();
	
	private File publicKeyFile = null;
	private File privateKeyFile = null;
	private File privatePwdFile = null;
	
	private long cPublicLastModified;
	private long cPublicLength;
	private long cPrivateLastModified;
	private long cPrivateLength;
	private long cPrivatePwdLastModified;
	private long cPrivatePwdLength;
	
	private PublicKey publicKey = null;
	private PrivateKey privateKey = null;
	
	private String publicKeyPath = "key/citichzkey/ServerA.cer";
	private String privateKeyPath = "key/citichzkey/ServerA.key";
	private String privatePwdPath = "key/citichzkey/ServerA.pwd";
	
	private CiticHzKeyCache() {
		load();
		FileCacheManage.newInstance().register(publicKeyPath, this);
		FileCacheManage.newInstance().register(privateKeyPath, this);
		FileCacheManage.newInstance().register(privatePwdPath, this);
	}
	
	public void load() {
		cLogger.info("Into CiticHzKeyCache.load()...");
		
		String mFilePathPublicKey = SysInfo.cHome + publicKeyPath;
		String mFilePathPrivateKey = SysInfo.cHome + privateKeyPath;
		String mFilePathPrivatePwd = SysInfo.cHome + privatePwdPath;
		cLogger.info("Start load " + mFilePathPublicKey + "...");
		
		publicKeyFile = new File(mFilePathPublicKey);
		privateKeyFile = new File(mFilePathPrivateKey);
		privatePwdFile = new File(mFilePathPrivatePwd);
		
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
			//读取公钥证书
			publicKey = CiticHZKeyUtil.readcerCertiPublicKey(mFilePathPublicKey);
			//读取私钥证书
			privateKey = CiticHZKeyUtil.readcerCertiPrivateKey(mFilePathPrivateKey,mFilePathPrivatePwd);
			
		} catch(Exception ex) {
			cLogger.error("密钥文件有误！", ex);
		}
		
		cLogger.info("Out CiticHzKeyCache.load()!");
	}
	
	

	public PublicKey getPublicKey() {
		return publicKey;
	}

	public void setPublicKey(PublicKey publicKey) {
		this.publicKey = publicKey;
	}

	public PrivateKey getPrivateKey() {
		return privateKey;
	}

	public void setPrivateKey(PrivateKey privateKey) {
		this.privateKey = privateKey;
	}
	
	public static CiticHzKeyCache newInstance() {
		return cThisIns;
	}

	public boolean isChanged() {
		if (publicKeyFile.lastModified()!=cPublicLastModified
			|| publicKeyFile.length()!=cPublicLength || privateKeyFile.lastModified()!=cPublicLastModified
			|| privateKeyFile.length()!=cPublicLength || privatePwdFile.lastModified()!=cPublicLastModified
			|| privatePwdFile.length()!=cPublicLength  ) {
			return true;
		} else {
			return false;
		}
	}
	
	protected final void recordStatus() {
		cPublicLastModified = publicKeyFile.lastModified();
		cPublicLength = publicKeyFile.length();
		cLogger.info("conf file modified at (" + DateUtil.getDateStr(cPublicLastModified, "yyyy-MM-dd HH:mm:ss,SSS") + ") and length=" + cPublicLength + " bytes!");
		cPrivateLastModified = privateKeyFile.lastModified();
		cPrivateLength = privateKeyFile.length();
		cLogger.info("conf file modified at (" + DateUtil.getDateStr(cPrivateLastModified, "yyyy-MM-dd HH:mm:ss,SSS") + ") and length=" + cPrivateLength + " bytes!");
		cPrivatePwdLastModified = privatePwdFile.lastModified();
		cPrivatePwdLength = privatePwdFile.length();
		cLogger.info("conf file modified at (" + DateUtil.getDateStr(cPrivatePwdLastModified, "yyyy-MM-dd HH:mm:ss,SSS") + ") and length=" + cPrivatePwdLength + " bytes!");
	}
}

