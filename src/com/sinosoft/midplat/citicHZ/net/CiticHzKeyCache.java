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
			//��ȡ��Կ֤��
			publicKey = CiticHZKeyUtil.readcerCertiPublicKey(mFilePathPublicKey);
			//��ȡ˽Կ֤��
			privateKey = CiticHZKeyUtil.readcerCertiPrivateKey(mFilePathPrivateKey,mFilePathPrivatePwd);
			
		} catch(Exception ex) {
			cLogger.error("��Կ�ļ�����", ex);
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

