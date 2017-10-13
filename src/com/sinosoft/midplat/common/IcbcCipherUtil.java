package com.sinosoft.midplat.common;

import java.io.FileInputStream;
import java.io.OutputStream;

import javax.crypto.Cipher;
import javax.crypto.CipherOutputStream;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.Logger;

import com.sinosoft.midplat.icbc.net.IcbcKeyCache;

public class IcbcCipherUtil {
    protected final Logger cLogger = Logger.getLogger(getClass());
    String key = null;
    SecretKeySpec cKey;
    
    public IcbcCipherUtil(String key) {
        this.key = key;
        initKey( );
    }

    public IcbcCipherUtil() {
        
    }

    /**
     * 使用工行密钥解密
     * @param content 需要解密的内容
     * @param tryFlag 是否二次解密
     * @return
     * @throws Exception
     */
    public byte[] decrypt(byte[] content, boolean tryFlag)throws Exception{
        try{
            return decrypt(content);
        }catch(Exception e){
            if(e instanceof javax.crypto.BadPaddingException){
                //检查是否是密钥不匹配引起的解密失败
                if (tryFlag) {
                    cLogger
                            .info("decrypt the file failed, trying with the old key...");
                    String oldKey = getOldKey();
                    cLogger.info("the old key is " + oldKey);
                    // 重新设置密钥
                    setKey(oldKey);
                    return decrypt(content);
                }
            }
            throw e;
        }
    }

    /**
     * 使用工行密钥解密
     * @param content 需要解密的内容
     * @return
     * @throws Exception
     */
    public byte[] decrypt(byte[] content)throws Exception{
        if(cKey==null){
            cKey = IcbcKeyCache.newInstance().getKey();
        }
        Cipher mCipher = Cipher.getInstance("DES");
        mCipher.init(Cipher.DECRYPT_MODE, cKey);
        return mCipher.doFinal(content);
    }
    
    private String getOldKey() throws Exception{
        //读取原密钥
        byte[] oldkey = null;
        FileInputStream mOldFos = null;
        try {
            mOldFos = new FileInputStream(SysInfo.cHome
                    + "key/oldIcbcKey.dat");
            if (mOldFos != null) {
                oldkey = new byte[16];
                IOTrans.readFull(oldkey, mOldFos);
                cLogger.info("读取原密钥成功["+new String(oldkey)+"]");
            }
        } catch (Exception e) {
            cLogger.error("读取原密钥失败!", e);
            throw e;
        } finally {
            if (mOldFos != null) {
                mOldFos.close();
            }
        }
        return new String(oldkey);
    }

    /**
     * 使用工行密钥加密
     * @param content 需要加密的内容
     * @return
     * @throws Exception
     */
    public byte[] encrypt(byte[] content)throws Exception{
        if(cKey==null){
            cKey = IcbcKeyCache.newInstance().getKey();
        }
        Cipher mCipher = Cipher.getInstance("DES");
        mCipher.init(Cipher.ENCRYPT_MODE, cKey);
        return mCipher.doFinal(content);
    }

    /**
     * 使用工行密钥加密,使用流方式
     * @param out 需要加密的输出流
     * @return
     * @throws Exception
     */
    public OutputStream encrypt(OutputStream out)throws Exception{
        if(cKey==null){
            cKey = IcbcKeyCache.newInstance().getKey();
        }
        Cipher mCipher = Cipher.getInstance("DES");
        mCipher.init(Cipher.ENCRYPT_MODE, cKey);
        return new CipherOutputStream(out, mCipher);
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
        initKey( );
    }
    
    private void initKey( ){
        byte[] mKeyHexBytes = key.getBytes();
        byte[] mKeyBytes = new byte[mKeyHexBytes.length / 2];
        for (int i = 0; i < mKeyBytes.length; i++) {
            mKeyBytes[i] = (byte) Integer.parseInt(new String(mKeyHexBytes,
                    i * 2, 2), 16);
        }
        cKey = new SecretKeySpec(mKeyBytes, "DES");
    }
    
    
    
}
