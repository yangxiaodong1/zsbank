package com.sinosoft.midplat.citicHZ.util;

// Demo1.java 报文签名/验签、加解密示例1
// M.L.Y 2013.8

import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.X509Certificate;

import com.lsy.baselib.crypto.algorithm.DESede;
import com.lsy.baselib.crypto.algorithm.RSA;
import com.lsy.baselib.crypto.exception.CipherUtilException;
import com.lsy.baselib.crypto.exception.DESedeException;
import com.lsy.baselib.crypto.exception.PKCS7SignatureException;
import com.lsy.baselib.crypto.exception.RSAException;
import com.lsy.baselib.crypto.protocol.PKCS7Signature;
import com.lsy.baselib.crypto.util.Base64;
import com.lsy.baselib.crypto.util.BytesUtil;
import com.lsy.baselib.crypto.util.CryptUtil;
import com.lsy.baselib.crypto.util.FileUtil;

public class CiticHZKeyUtil
{
	public static byte[] createKey()
	{
		// 调用函数DESede.createKey创建随机密钥，或者自定义一个24字节长度的3DES密钥
		byte[] key = null;
		try
		{
			key = DESede.createKey(DESede.DESEDE_KEY_112_BIT);
		}
		catch (DESedeException e)
		{
			System.out.println("产生随机密钥出错!");
			e.printStackTrace();
			return null;
		}
		System.out.println("------ 产生随机密钥长度:" + key.length);
//		System.out.println("------ 产生随机密钥 hex value:" + BytesUtil.binary2hex(key).toUpperCase());
		return key;
	}

	/**
	 * DESedeCipher加密
	 * @param clearText 明文
	 * @param key
	 * @return
	 */
	public static byte[] DESedeCipher(byte[] clearText, byte[] key)
	{
		byte[] iv = {(byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00,
				(byte) 0x00};

		long beginTime = System.currentTimeMillis();
		//密文
		byte[] cipherText = null;
		try
		{
			cipherText = DESede.encrypt(clearText, key, iv);
		}
		catch (DESedeException e)
		{
			System.out.println("DESede加密出错!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ DESede加密耗时(ms):" + (endTime - beginTime));

		return cipherText;
	}

	/**
	 * DESedeClear 解密
	 * @param cipherText 密文
	 * @param key
	 * @return
	 */
	public static byte[] DESedeClear(byte[] cipherText, byte[] key)
	{
		byte[] iv = {(byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00,
				(byte) 0x00};

		long beginTime = System.currentTimeMillis();
		//明文
		byte[] clearText = null;
		try
		{
			clearText = DESede.decrypt(cipherText, key, iv);
		}
		catch (DESedeException e)
		{
			System.out.println("DESede解密出错!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ DESede解密耗时(ms):" + (endTime - beginTime));

		return clearText;
	}

	/**
	 * createX509Certificate
	 * 产生X509证书
	 * @param cer证书文件名
	 * @return
	 */
	public static X509Certificate createX509Certificate(String certifiName)
	{
		byte[] base64EncodedCert = null;
		try
		{
			base64EncodedCert = FileUtil.read4file(certifiName);
//			System.out.println("------ base64EncodedCert=" + new String(base64EncodedCert));
		}
		catch (Exception e1)
		{
			System.out.println("读证书" + certifiName + "出错!");
			e1.printStackTrace();
			return null;
		}

		X509Certificate signerCertificate = null;
		try
		{
			signerCertificate = CryptUtil.generateX509Certificate(Base64.decode(base64EncodedCert));
//			System.out.println("------ signerCertificate=" + signerCertificate);
		}
		catch (Exception e)
		{
			System.out.println("generateX509Certificate出错!");
			e.printStackTrace();
			return null;
		}
		return signerCertificate;
	}

	/**
	 * 读取cer证书公钥 readcerCertiPublicKey
	 * @param cer证书文件名
	 * @return
	 */
	public static PublicKey readcerCertiPublicKey(String cerCertifiName)
	{
		X509Certificate signerCertificate = null;

		signerCertificate = createX509Certificate(cerCertifiName);

		PublicKey pubKey = signerCertificate.getPublicKey();
//		System.out.println("------ pubKey=" + pubKey);
		return pubKey;
	}

	/**
	 * 读取证书私钥 readcerCertiPrivateKey
	 * @param 私钥文件名 privateKeyName
	 * @param 私钥加密密码文件名 sKeycipherName
	 * @return
	 */
	public static PrivateKey readcerCertiPrivateKey(String privateKeyName, String sKeycipherName)
	{
		char[] keyPassword = null;
		PrivateKey signerPrivatekey = null;
		X509Certificate signerCertificate = null;

		// 从证书中读取私钥

		// 获取私钥密码
		try
		{
			keyPassword = new String(FileUtil.read4file(sKeycipherName)).toCharArray();
			System.out.println("------ keyPassword=" + new String(keyPassword));
		}
		catch (Exception e3)
		{
			System.out.println("读" + sKeycipherName + "出错!");
			e3.printStackTrace();
			return null;
		}

		// 读取私钥
		byte[] base64EncodedPrivatekey = null;
		try
		{
			base64EncodedPrivatekey = FileUtil.read4file(privateKeyName);
//			System.out.println("------ base64EncodedPrivatekey=" + new String(base64EncodedPrivatekey));
		}
		catch (Exception e2)
		{
			System.out.println("读" + privateKeyName + "出错!");
			e2.printStackTrace();
			return null;
		}

		try
		{
			signerPrivatekey = CryptUtil.decryptPrivateKey(Base64.decode(base64EncodedPrivatekey), keyPassword);
//			System.out.println("------ signerPrivatekey=" + signerPrivatekey);
		}
		catch (CipherUtilException e1)
		{
			System.out.println("decryptPrivateKey出错!");
			e1.printStackTrace();
			return null;
		}

		// 清除私钥解密密码
		for (int i = 0; i < keyPassword.length; i++)
			keyPassword[0] = 0;

		return signerPrivatekey;
	}

	/**
	 * 证书公钥加密 cerPublicKeyCrypt
	 * @param 明文 clearText
	 * @param 对方cer证书文件名 certifiName
	 * @return
	 */
	public static byte[] cerPublicKeyCrypt(byte[] clearText, String certifiName)
	{
		//密文
		byte[] cipherText = null;
		long beginTime = System.currentTimeMillis();
		PublicKey pubKey = readcerCertiPublicKey(certifiName);

		try
		{
			cipherText = RSA.encrypt(clearText, pubKey.getEncoded());
		}
		catch (RSAException e)
		{
			System.out.println("RSA.encrypt出错!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ 证书公钥加密耗时(ms):" + (endTime - beginTime));
		return cipherText;
	}

	/**
	 * 证书私钥解密 cerPrivateKeyClear
	 * @param 密文 cipherText
	 * @param 私钥文件名 privateKeyName
	 * @param 私钥加密密码文件名 sKeycipherName
	 * @return
	 */
	public static byte[] cerPrivateKeyClear(byte[] cipherText, String privateKeyName, String sKeycipherName)
	{
		//明文
		byte[] clearText = null;
		long beginTime = System.currentTimeMillis();
		PrivateKey privKey = readcerCertiPrivateKey(privateKeyName, sKeycipherName);

		try
		{
			clearText = RSA.decrypt(cipherText, privKey.getEncoded());
		}
		catch (RSAException e)
		{
			System.out.println("RSA.decrypt出错!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ 证书私钥解密耗时(ms):" + (endTime - beginTime));
		System.out.println(new String(clearText));
		return clearText;
	}

	/**
	 * 发送方对报文生成私钥签名 createPrivateKeySignForSend
	 * @param 报文明文  clearText
	 * @param 发送方私钥加密密码文件名 sKeycipherNameForSend
	 * @param 发送方私钥文件名 privateKeyNameForSend
	 * @param 发送方cer证书文件名 cerNameForSend
	 * @return
	 */
	public static String createPrivateKeySignForSend(byte[] clearText, String sKeycipherNameForSend, String privateKeyNameForSend, String cerNameForSend)	{
		long beginTime = System.currentTimeMillis();
		PrivateKey privKey = readcerCertiPrivateKey(privateKeyNameForSend, sKeycipherNameForSend);

		X509Certificate signerCertificate = createX509Certificate(cerNameForSend);
		byte[] signature = null;
		try
		{
			signature = PKCS7Signature.sign(clearText, privKey, signerCertificate, null, false);
//			System.out.println("------ signature(长度=" + signature.length + ")=" + new String(signature));
		}
		catch (PKCS7SignatureException e)
		{
			System.out.println("PKCS7Signature.sign出错!");
			e.printStackTrace();
			return null;
		}
		String b64StrSignature = new String(Base64.encode(signature));
//		System.out.println("------ 签名结果(base64,长度=" + b64StrSignature.length() + "):" + b64StrSignature);

		long endTime = System.currentTimeMillis();
		System.out.println("------ 发送方对报文生成私钥签名耗时(ms):" + (endTime - beginTime));
		return b64StrSignature;
	}

	/**
	 * 接收方验证报文签名 verfiSignForReceive
	 * @param 报文明文 clearText
	 * @param b64Str签名 b64StrSign
	 * @param 发送方cer证书文件名 cerNameForSend
	 * @return
	 */
	public static boolean verfiSignForReceive(byte[] clearText, String b64StrSign, String cerNameForSend)
	{
		long beginTime = System.currentTimeMillis();
		PublicKey pubKey = readcerCertiPublicKey(cerNameForSend);
//		System.out.println("------ pubKey=" + pubKey);

		boolean reslut = PKCS7Signature.verifyDetachedSignature(clearText, Base64.decode(b64StrSign.getBytes()), pubKey);
		System.out.println("------ 验签结果=" + reslut);

		long endTime = System.currentTimeMillis();
		System.out.println("------ 接收方验证报文签名耗时(ms):" + (endTime - beginTime));
		return reslut;
	}

	public static byte[] LinkByteArrays(byte[] arr1, byte[] arr2)
	{
		int n1 = arr1.length;
		int n2 = arr2.length;
		byte[] newArr = new byte[n1 + n2];
		System.arraycopy(arr1, 0, newArr, 0, n1);
		System.arraycopy(arr2, 0, newArr, n1, n2);
		return newArr;
	}

	public static byte[] LinkByteArrays(byte[] arr1, byte[] arr2, byte[] arr3)
	{
		int n1 = arr1.length;
		int n2 = arr2.length;
		int n3 = arr3.length;
		byte[] newArr = new byte[n1 + n2 + n3];
		System.arraycopy(arr1, 0, newArr, 0, n1);
		System.arraycopy(arr2, 0, newArr, n1, n2);
		System.arraycopy(arr3, 0, newArr, n1 + n2, n3);
		return newArr;
	}

	public static byte[] LinkByteArrays(byte[] arr1, byte[] arr2, byte[] arr3, byte[] arr4)
	{
		int n1 = arr1.length;
		int n2 = arr2.length;
		int n3 = arr3.length;
		int n4 = arr4.length;
		byte[] newArr = new byte[n1 + n2 + n3 + n4];
		System.arraycopy(arr1, 0, newArr, 0, n1);
		System.arraycopy(arr2, 0, newArr, n1, n2);
		System.arraycopy(arr3, 0, newArr, n1 + n2, n3);
		System.arraycopy(arr4, 0, newArr, n1 + n2 + n3, n4);
		return newArr;
	}

	/**
	 * 发送方报文签名再加密 sendsignEncyptRe
	 * @param 报文明文 crearText
	 * @param 发送方私钥加密密码文件名 sKeycipherNameForSend
	 * @param 发送方私钥文件名 privateKeyNameForSend
	 * @param 发送方cer证书文件名 cerNameForSend
	 * @param 接收方cer证书文件名 cerNameForReceive
	 * @param 会话密钥明文 sessionKeyCleText
	 * @return
	 */
	public static byte[] sendsignEncyptRe(byte[] clearText, String sKeycipherNameForSend, String privateKeyNameForSend, String cerNameForSend,
			String cerNameForReceive, byte[] sessionKeyCleText)
	{
		long beginTime = System.currentTimeMillis();
		String b64Str签名 = createPrivateKeySignForSend(clearText, sKeycipherNameForSend, privateKeyNameForSend, cerNameForSend);
		//签名串
		byte[] signStr = ("<signature>" + b64Str签名 + "</signature>").getBytes();
		//待加密数据
		byte[] clearData = LinkByteArrays(signStr, clearText);
		
		byte[] cipherData = DESedeCipher(clearData,sessionKeyCleText);
		//密文数据
//		byte[] cipherData = DESedeCipher(Base64.decode(clearData), sessionKeyCleText);//cyxts
		//会话密钥密文
		byte[] sessionKeyCip = cerPublicKeyCrypt(sessionKeyCleText, cerNameForReceive);
		//报文体
		byte[] sendStr = LinkByteArrays("<sessionkey>".getBytes(), Base64.encode(sessionKeyCip), "</sessionkey>".getBytes(), cipherData);
		long endTime = System.currentTimeMillis();
		System.out.println("------ 发送方报文签名再加密耗时(ms):" + (endTime - beginTime));
		return sendStr;
	}

	/**
	 * 接收方报文解密再验签 clearSignForReceive
	 * @param secMsg
	 * @param 发送方cer证书文件名 cerNameForSend
	 * @param 接收方cer证书文件名 cerNameForReceive
	 * @param 接收方私钥文件名 privateKeyNameForReve
	 * @param 接收方私钥加密密码文件名 sKeycipherNameForRece
	 * @return
	 */
	public static boolean clearSignForReceive(SecMsg secMsg, String cerNameForSend, String cerNameForReceive, String privateKeyNameForReve,
			String sKeycipherNameForRece)
	{
		long beginTime = System.currentTimeMillis();
		//报文密文
		byte[] msgCipher = secMsg.getSecMsgChper();
		String sMsg = new String(msgCipher);
		String sKey = null;
		String openTag = "<sessionkey>";
		String closeTag = "</sessionkey>";
		//密文数据
		byte[] chperData = null;

		int start = sMsg.indexOf(openTag);
		if (start != -1)
		{
			int end = sMsg.indexOf(closeTag, start + openTag.length());
			if (end != -1)
			{
				sKey = sMsg.substring(start + openTag.length(), end);
				chperData = new byte[msgCipher.length - end - closeTag.length()];
				System.arraycopy(msgCipher, end + closeTag.length(), chperData, 0, msgCipher.length - end - closeTag.length());
				System.out.println("------ sKey=" + sKey);
//				System.out.println("------ 密文数据=" + new String(chperData));
			}
			else
			{
				System.out.println("找不到标签" + closeTag);
				return false;
			}
		}
		else
		{
			System.out.println("找不到标签" + openTag);
			return false;
		}
		//会话密钥明文
		byte[] sessionKeyClear = cerPrivateKeyClear(Base64.decode(sKey.getBytes()), privateKeyNameForReve, sKeycipherNameForRece);
		secMsg.setSessionKey(sessionKeyClear);

		String h = "";
		for(int i = 0; i < sessionKeyClear.length; i++){
			String tmp = Integer.toHexString(sessionKeyClear[i] & 0xFF);
			if(tmp.length() == 1)
				tmp = "0" + tmp;
			h = h+" " + tmp;
		}
		System.out.println(h);
		//解密后数据
		byte[] clearData = DESedeClear(chperData, sessionKeyClear);

		String sData = new String(clearData);
		String sSign = null;
		String openTag2 = "<signature>";
		String closeTag2 = "</signature>";
		//解密后报文
		byte[] msgClear = null;
//        System.out.println("解密后数据========"+sData);
		int start2 = sData.indexOf(openTag2);
		if (start2 != -1)
		{
			int end2 = sData.indexOf(closeTag2, start2 + openTag2.length());
			if (end2 != -1)
			{
				sSign = sData.substring(start2 + openTag2.length(), end2);
				msgClear = new byte[clearData.length - end2 - closeTag2.length()];
				System.arraycopy(clearData, end2 + closeTag2.length(), msgClear, 0, clearData.length - end2 - closeTag2.length());
				secMsg.setSecMsgClear(msgClear);
//				System.out.println("解密后报文======："+new String(msgClear));
			}
			else
			{
				System.out.println("找不到标签" + closeTag2);
				return false;
			}
		}
		else
		{
			System.out.println("找不到标签" + openTag2);
			return false;
		}

		boolean result = verfiSignForReceive(msgClear, sSign, cerNameForSend);
		System.out.println("------ 验签结果 = " + result);

		long endTime = System.currentTimeMillis();
		System.out.println("------ 接收方报文解密再验签耗时(ms):" + (endTime - beginTime));

		return result;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		// A -> B 发送请求，新产生随机会话密钥：
		String 请求报文 = 	"<?xml version=\"1.0\" encoding=\"GBK\"?>"
				+ "<Transaction><Transaction_Header><LiBankID>CITIC</LiBankID><PbInsuId/><BkPlatSeqNo>20160606010835040136</BkPlatSeqNo>"
				+ "<BkTxCode>BDZY01</BkTxCode><BkChnlNo>1</BkChnlNo><BkBrchNo>0108733101</BkBrchNo><BkTellerNo>liulx</BkTellerNo>"
				+ "<BkPlatDate>20160606</BkPlatDate><BkPlatTime>172136</BkPlatTime></Transaction_Header><Transaction_Body><PbInsuSlipNo>130004861708</PbInsuSlipNo>"
				+ "<PbInsuName></PbInsuName><LiRcgnIdType>A</LiRcgnIdType><LiRcgnId>330106196901121123</LiRcgnId></Transaction_Body></Transaction>";
//		String 请求报文 = "<msg>A to B发送请求</msg>";
		byte[] 会话密钥明文 = createKey();
		byte[] msgSend = sendsignEncyptRe(请求报文.getBytes(), "E:/citic/CNCB.pwd", "E:/citic/CNCB.key", "E:/citic/CNCB.cer", "E:/citic/ServerA.cer", 会话密钥明文);

		System.out.println("====== msgSend(长度:" + msgSend.length + ")=[" + new String(msgSend) + "]");
		System.out.println("********************************************************************************");

		// B 收到请求报文：
		SecMsg secMsgB1 = new SecMsg();
		secMsgB1.setSecMsgChper(msgSend);
		boolean result = clearSignForReceive(secMsgB1, "E:/citic/CNCB.cer", "E:/citic/ServerA.cer", "E:/citic/ServerA.key", "E:/citic/ServerA.pwd");
		
		byte[] msgRecv = secMsgB1.getSecMsgClear();
		System.out.println("====== msgRecv(长度:" + msgRecv.length + ")=[" + new String(msgRecv) + "]");
		if (请求报文.equals(new String(msgRecv))) System.out.println("====== 接收请求报文解密后与发送的请求报文相同");

		System.out.println("################################################################################");

		// B -> A 发送回应，使用请求中的会话密钥：
		String 回应报文 = "<msg>B to A回应Ok</msg>";
		byte[] msgSend2 = sendsignEncyptRe(回应报文.getBytes(), "E:/citic/ServerA.pwd", "E:/citic/ServerA.key", "E:/citic/ServerA.cer", "E:/citic/CNCB.cer",
				secMsgB1.getSessionKey());

		System.out.println("====== msgSend2(长度:" + msgSend2.length + ")=[" + new String(msgSend2) + "]");
		System.out.println("********************************************************************************");

		// A 收到回应报文：
		SecMsg secMsgA1 = new SecMsg();
		secMsgA1.setSecMsgChper(msgSend2);
		result = clearSignForReceive(secMsgA1, "E:/citic/ServerA.cer", "E:/citic/CNCB.cer", "E:/citic/CNCB.key", "E:/citic/CNCB.pwd");	
		byte[] msgRecv2 = secMsgA1.getSecMsgClear();
		System.out.println("====== msgRecv2(长度:" + msgRecv2.length + ")=[" + new String(msgRecv2) + "]");
		if (回应报文.equals(new String(msgRecv2))) System.out.println("====== 接收回应报文解密后与发送的回应报文相同");

		System.exit(0);

	}

}
