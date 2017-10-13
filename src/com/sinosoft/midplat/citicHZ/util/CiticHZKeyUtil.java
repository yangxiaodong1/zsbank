package com.sinosoft.midplat.citicHZ.util;

// Demo1.java ����ǩ��/��ǩ���ӽ���ʾ��1
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
		// ���ú���DESede.createKey���������Կ�������Զ���һ��24�ֽڳ��ȵ�3DES��Կ
		byte[] key = null;
		try
		{
			key = DESede.createKey(DESede.DESEDE_KEY_112_BIT);
		}
		catch (DESedeException e)
		{
			System.out.println("���������Կ����!");
			e.printStackTrace();
			return null;
		}
		System.out.println("------ ���������Կ����:" + key.length);
//		System.out.println("------ ���������Կ hex value:" + BytesUtil.binary2hex(key).toUpperCase());
		return key;
	}

	/**
	 * DESedeCipher����
	 * @param clearText ����
	 * @param key
	 * @return
	 */
	public static byte[] DESedeCipher(byte[] clearText, byte[] key)
	{
		byte[] iv = {(byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00,
				(byte) 0x00};

		long beginTime = System.currentTimeMillis();
		//����
		byte[] cipherText = null;
		try
		{
			cipherText = DESede.encrypt(clearText, key, iv);
		}
		catch (DESedeException e)
		{
			System.out.println("DESede���ܳ���!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ DESede���ܺ�ʱ(ms):" + (endTime - beginTime));

		return cipherText;
	}

	/**
	 * DESedeClear ����
	 * @param cipherText ����
	 * @param key
	 * @return
	 */
	public static byte[] DESedeClear(byte[] cipherText, byte[] key)
	{
		byte[] iv = {(byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x00,
				(byte) 0x00};

		long beginTime = System.currentTimeMillis();
		//����
		byte[] clearText = null;
		try
		{
			clearText = DESede.decrypt(cipherText, key, iv);
		}
		catch (DESedeException e)
		{
			System.out.println("DESede���ܳ���!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ DESede���ܺ�ʱ(ms):" + (endTime - beginTime));

		return clearText;
	}

	/**
	 * createX509Certificate
	 * ����X509֤��
	 * @param cer֤���ļ���
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
			System.out.println("��֤��" + certifiName + "����!");
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
			System.out.println("generateX509Certificate����!");
			e.printStackTrace();
			return null;
		}
		return signerCertificate;
	}

	/**
	 * ��ȡcer֤�鹫Կ readcerCertiPublicKey
	 * @param cer֤���ļ���
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
	 * ��ȡ֤��˽Կ readcerCertiPrivateKey
	 * @param ˽Կ�ļ��� privateKeyName
	 * @param ˽Կ���������ļ��� sKeycipherName
	 * @return
	 */
	public static PrivateKey readcerCertiPrivateKey(String privateKeyName, String sKeycipherName)
	{
		char[] keyPassword = null;
		PrivateKey signerPrivatekey = null;
		X509Certificate signerCertificate = null;

		// ��֤���ж�ȡ˽Կ

		// ��ȡ˽Կ����
		try
		{
			keyPassword = new String(FileUtil.read4file(sKeycipherName)).toCharArray();
			System.out.println("------ keyPassword=" + new String(keyPassword));
		}
		catch (Exception e3)
		{
			System.out.println("��" + sKeycipherName + "����!");
			e3.printStackTrace();
			return null;
		}

		// ��ȡ˽Կ
		byte[] base64EncodedPrivatekey = null;
		try
		{
			base64EncodedPrivatekey = FileUtil.read4file(privateKeyName);
//			System.out.println("------ base64EncodedPrivatekey=" + new String(base64EncodedPrivatekey));
		}
		catch (Exception e2)
		{
			System.out.println("��" + privateKeyName + "����!");
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
			System.out.println("decryptPrivateKey����!");
			e1.printStackTrace();
			return null;
		}

		// ���˽Կ��������
		for (int i = 0; i < keyPassword.length; i++)
			keyPassword[0] = 0;

		return signerPrivatekey;
	}

	/**
	 * ֤�鹫Կ���� cerPublicKeyCrypt
	 * @param ���� clearText
	 * @param �Է�cer֤���ļ��� certifiName
	 * @return
	 */
	public static byte[] cerPublicKeyCrypt(byte[] clearText, String certifiName)
	{
		//����
		byte[] cipherText = null;
		long beginTime = System.currentTimeMillis();
		PublicKey pubKey = readcerCertiPublicKey(certifiName);

		try
		{
			cipherText = RSA.encrypt(clearText, pubKey.getEncoded());
		}
		catch (RSAException e)
		{
			System.out.println("RSA.encrypt����!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ ֤�鹫Կ���ܺ�ʱ(ms):" + (endTime - beginTime));
		return cipherText;
	}

	/**
	 * ֤��˽Կ���� cerPrivateKeyClear
	 * @param ���� cipherText
	 * @param ˽Կ�ļ��� privateKeyName
	 * @param ˽Կ���������ļ��� sKeycipherName
	 * @return
	 */
	public static byte[] cerPrivateKeyClear(byte[] cipherText, String privateKeyName, String sKeycipherName)
	{
		//����
		byte[] clearText = null;
		long beginTime = System.currentTimeMillis();
		PrivateKey privKey = readcerCertiPrivateKey(privateKeyName, sKeycipherName);

		try
		{
			clearText = RSA.decrypt(cipherText, privKey.getEncoded());
		}
		catch (RSAException e)
		{
			System.out.println("RSA.decrypt����!");
			e.printStackTrace();
			return null;
		}
		long endTime = System.currentTimeMillis();
		System.out.println("------ ֤��˽Կ���ܺ�ʱ(ms):" + (endTime - beginTime));
		System.out.println(new String(clearText));
		return clearText;
	}

	/**
	 * ���ͷ��Ա�������˽Կǩ�� createPrivateKeySignForSend
	 * @param ��������  clearText
	 * @param ���ͷ�˽Կ���������ļ��� sKeycipherNameForSend
	 * @param ���ͷ�˽Կ�ļ��� privateKeyNameForSend
	 * @param ���ͷ�cer֤���ļ��� cerNameForSend
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
//			System.out.println("------ signature(����=" + signature.length + ")=" + new String(signature));
		}
		catch (PKCS7SignatureException e)
		{
			System.out.println("PKCS7Signature.sign����!");
			e.printStackTrace();
			return null;
		}
		String b64StrSignature = new String(Base64.encode(signature));
//		System.out.println("------ ǩ�����(base64,����=" + b64StrSignature.length() + "):" + b64StrSignature);

		long endTime = System.currentTimeMillis();
		System.out.println("------ ���ͷ��Ա�������˽Կǩ����ʱ(ms):" + (endTime - beginTime));
		return b64StrSignature;
	}

	/**
	 * ���շ���֤����ǩ�� verfiSignForReceive
	 * @param �������� clearText
	 * @param b64Strǩ�� b64StrSign
	 * @param ���ͷ�cer֤���ļ��� cerNameForSend
	 * @return
	 */
	public static boolean verfiSignForReceive(byte[] clearText, String b64StrSign, String cerNameForSend)
	{
		long beginTime = System.currentTimeMillis();
		PublicKey pubKey = readcerCertiPublicKey(cerNameForSend);
//		System.out.println("------ pubKey=" + pubKey);

		boolean reslut = PKCS7Signature.verifyDetachedSignature(clearText, Base64.decode(b64StrSign.getBytes()), pubKey);
		System.out.println("------ ��ǩ���=" + reslut);

		long endTime = System.currentTimeMillis();
		System.out.println("------ ���շ���֤����ǩ����ʱ(ms):" + (endTime - beginTime));
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
	 * ���ͷ�����ǩ���ټ��� sendsignEncyptRe
	 * @param �������� crearText
	 * @param ���ͷ�˽Կ���������ļ��� sKeycipherNameForSend
	 * @param ���ͷ�˽Կ�ļ��� privateKeyNameForSend
	 * @param ���ͷ�cer֤���ļ��� cerNameForSend
	 * @param ���շ�cer֤���ļ��� cerNameForReceive
	 * @param �Ự��Կ���� sessionKeyCleText
	 * @return
	 */
	public static byte[] sendsignEncyptRe(byte[] clearText, String sKeycipherNameForSend, String privateKeyNameForSend, String cerNameForSend,
			String cerNameForReceive, byte[] sessionKeyCleText)
	{
		long beginTime = System.currentTimeMillis();
		String b64Strǩ�� = createPrivateKeySignForSend(clearText, sKeycipherNameForSend, privateKeyNameForSend, cerNameForSend);
		//ǩ����
		byte[] signStr = ("<signature>" + b64Strǩ�� + "</signature>").getBytes();
		//����������
		byte[] clearData = LinkByteArrays(signStr, clearText);
		
		byte[] cipherData = DESedeCipher(clearData,sessionKeyCleText);
		//��������
//		byte[] cipherData = DESedeCipher(Base64.decode(clearData), sessionKeyCleText);//cyxts
		//�Ự��Կ����
		byte[] sessionKeyCip = cerPublicKeyCrypt(sessionKeyCleText, cerNameForReceive);
		//������
		byte[] sendStr = LinkByteArrays("<sessionkey>".getBytes(), Base64.encode(sessionKeyCip), "</sessionkey>".getBytes(), cipherData);
		long endTime = System.currentTimeMillis();
		System.out.println("------ ���ͷ�����ǩ���ټ��ܺ�ʱ(ms):" + (endTime - beginTime));
		return sendStr;
	}

	/**
	 * ���շ����Ľ�������ǩ clearSignForReceive
	 * @param secMsg
	 * @param ���ͷ�cer֤���ļ��� cerNameForSend
	 * @param ���շ�cer֤���ļ��� cerNameForReceive
	 * @param ���շ�˽Կ�ļ��� privateKeyNameForReve
	 * @param ���շ�˽Կ���������ļ��� sKeycipherNameForRece
	 * @return
	 */
	public static boolean clearSignForReceive(SecMsg secMsg, String cerNameForSend, String cerNameForReceive, String privateKeyNameForReve,
			String sKeycipherNameForRece)
	{
		long beginTime = System.currentTimeMillis();
		//��������
		byte[] msgCipher = secMsg.getSecMsgChper();
		String sMsg = new String(msgCipher);
		String sKey = null;
		String openTag = "<sessionkey>";
		String closeTag = "</sessionkey>";
		//��������
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
//				System.out.println("------ ��������=" + new String(chperData));
			}
			else
			{
				System.out.println("�Ҳ�����ǩ" + closeTag);
				return false;
			}
		}
		else
		{
			System.out.println("�Ҳ�����ǩ" + openTag);
			return false;
		}
		//�Ự��Կ����
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
		//���ܺ�����
		byte[] clearData = DESedeClear(chperData, sessionKeyClear);

		String sData = new String(clearData);
		String sSign = null;
		String openTag2 = "<signature>";
		String closeTag2 = "</signature>";
		//���ܺ���
		byte[] msgClear = null;
//        System.out.println("���ܺ�����========"+sData);
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
//				System.out.println("���ܺ���======��"+new String(msgClear));
			}
			else
			{
				System.out.println("�Ҳ�����ǩ" + closeTag2);
				return false;
			}
		}
		else
		{
			System.out.println("�Ҳ�����ǩ" + openTag2);
			return false;
		}

		boolean result = verfiSignForReceive(msgClear, sSign, cerNameForSend);
		System.out.println("------ ��ǩ��� = " + result);

		long endTime = System.currentTimeMillis();
		System.out.println("------ ���շ����Ľ�������ǩ��ʱ(ms):" + (endTime - beginTime));

		return result;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		// A -> B ���������²�������Ự��Կ��
		String ������ = 	"<?xml version=\"1.0\" encoding=\"GBK\"?>"
				+ "<Transaction><Transaction_Header><LiBankID>CITIC</LiBankID><PbInsuId/><BkPlatSeqNo>20160606010835040136</BkPlatSeqNo>"
				+ "<BkTxCode>BDZY01</BkTxCode><BkChnlNo>1</BkChnlNo><BkBrchNo>0108733101</BkBrchNo><BkTellerNo>liulx</BkTellerNo>"
				+ "<BkPlatDate>20160606</BkPlatDate><BkPlatTime>172136</BkPlatTime></Transaction_Header><Transaction_Body><PbInsuSlipNo>130004861708</PbInsuSlipNo>"
				+ "<PbInsuName></PbInsuName><LiRcgnIdType>A</LiRcgnIdType><LiRcgnId>330106196901121123</LiRcgnId></Transaction_Body></Transaction>";
//		String ������ = "<msg>A to B��������</msg>";
		byte[] �Ự��Կ���� = createKey();
		byte[] msgSend = sendsignEncyptRe(������.getBytes(), "E:/citic/CNCB.pwd", "E:/citic/CNCB.key", "E:/citic/CNCB.cer", "E:/citic/ServerA.cer", �Ự��Կ����);

		System.out.println("====== msgSend(����:" + msgSend.length + ")=[" + new String(msgSend) + "]");
		System.out.println("********************************************************************************");

		// B �յ������ģ�
		SecMsg secMsgB1 = new SecMsg();
		secMsgB1.setSecMsgChper(msgSend);
		boolean result = clearSignForReceive(secMsgB1, "E:/citic/CNCB.cer", "E:/citic/ServerA.cer", "E:/citic/ServerA.key", "E:/citic/ServerA.pwd");
		
		byte[] msgRecv = secMsgB1.getSecMsgClear();
		System.out.println("====== msgRecv(����:" + msgRecv.length + ")=[" + new String(msgRecv) + "]");
		if (������.equals(new String(msgRecv))) System.out.println("====== ���������Ľ��ܺ��뷢�͵���������ͬ");

		System.out.println("################################################################################");

		// B -> A ���ͻ�Ӧ��ʹ�������еĻỰ��Կ��
		String ��Ӧ���� = "<msg>B to A��ӦOk</msg>";
		byte[] msgSend2 = sendsignEncyptRe(��Ӧ����.getBytes(), "E:/citic/ServerA.pwd", "E:/citic/ServerA.key", "E:/citic/ServerA.cer", "E:/citic/CNCB.cer",
				secMsgB1.getSessionKey());

		System.out.println("====== msgSend2(����:" + msgSend2.length + ")=[" + new String(msgSend2) + "]");
		System.out.println("********************************************************************************");

		// A �յ���Ӧ���ģ�
		SecMsg secMsgA1 = new SecMsg();
		secMsgA1.setSecMsgChper(msgSend2);
		result = clearSignForReceive(secMsgA1, "E:/citic/ServerA.cer", "E:/citic/CNCB.cer", "E:/citic/CNCB.key", "E:/citic/CNCB.pwd");	
		byte[] msgRecv2 = secMsgA1.getSecMsgClear();
		System.out.println("====== msgRecv2(����:" + msgRecv2.length + ")=[" + new String(msgRecv2) + "]");
		if (��Ӧ����.equals(new String(msgRecv2))) System.out.println("====== ���ջ�Ӧ���Ľ��ܺ��뷢�͵Ļ�Ӧ������ͬ");

		System.exit(0);

	}

}
