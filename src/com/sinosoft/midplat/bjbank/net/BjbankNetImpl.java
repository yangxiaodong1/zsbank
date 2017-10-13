package com.sinosoft.midplat.bjbank.net;

import java.net.Socket;

import javax.crypto.Cipher;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;


import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.bjbank.service.KeyChangeRollback;
import com.sinosoft.midplat.net.SocketNetImpl;

public class BjbankNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private Document pNoStdXml = null;
	private String cOutFlag = null;
	
	public BjbankNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into BjbankNetImp.receive()...");
		
		//������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		cInsuID = new String(mHeadBytes, 10, 6).trim();
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		cLogger.info("��ʼ����...");
		try{
		    mBodyBytes = decode(mBodyBytes);
		}catch(Exception e){
		    if(e instanceof javax.crypto.BadPaddingException){
		        //��Կ��ƥ������Ľ����쳣
		        cLogger.info("����ʧ�ܣ����Իָ���Կ...");
		        new KeyChangeRollback().service(null);
		    }
	        throw e;
		}
		cLogger.info("���ܳɹ���" );
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		//�������з������ģ��Ա���Ӧʱ����Ӧ����������
		this.pNoStdXml = mXmlDoc;
		Element mRootEle = mXmlDoc.getRootElement();
		//���������Լȡ����ȷ�Ͻ���ʱ����������������ͬ����Ҫ���⴦��һ��
		if("02".equals(cOutFuncFlag)){
			String confirmFlag = XPath.newInstance("/TranData/LCCont/ConfirmFlag").valueOf(pNoStdXml.getRootElement());
			cOutFuncFlag = cOutFuncFlag + confirmFlag;
		}
		
		//����������
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
		//���ɱ�׼����ͷ
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		Element mFuncFlagEle = new Element(FuncFlag);
		mFuncFlagEle.setText(cFuncFlag);
		
		Element mHeadEle = new Element(Head);
		mHeadEle.addContent(mClientIpEle);
		mHeadEle.addContent(cTranComEle);
		mHeadEle.addContent(mFuncFlagEle);
      
		mRootEle.addContent(mHeadEle);
		
		cLogger.info("Out BjbankNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into BjbankNetImp.send()...");
		
		/* �������ͨϵͳ�쳣  */
		
		try{
			cOutFlag = pOutNoStd.getRootElement().getChild("RetData").getChildText("Flag");
		}catch(Exception exp){
			/*
			 * ���ص�pOutNoStd����Ϊ����ϵͳ�ı�׼���ģ�
			 * ������ͨϵͳУ������׳��쳣��ƽ̨��������ƽ��쳣��Ϣ��װΪ���ĵı�׼���ĸ�ʽ��
			 * �����ڴ��轫��׼����ת��Ϊ���еķǱ�׼���ĸ�ʽ���������ж˽��ͱ���չʾ��Ϣ��
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// ��׼�����У����ر�ʶFlag=1Ϊʧ��
				cOutFlag = "0";
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild(Head).setName("RetData");
			}
		}
		/*Start-��֯���ر���ͷ*/
		Element mRootEle = pOutNoStd.getRootElement();//������Ӧ����
		Element iRootEle = pNoStdXml.getRootElement();//����������
		Element iBaseInfoEle = iRootEle.getChild("BaseInfo");
		//����������Ӧ�����е�BaseInfo�ڵ�����
		Element mBaseInfo = new Element("BaseInfo");
        
		//<!-- ���н������� -->
		Element bankDate = new Element("BankDate");
		bankDate.setText(iBaseInfoEle.getChildText("BankDate"));
		mBaseInfo.addContent(bankDate);
		
		//<!-- ���д��� -->
		Element bankCode = new Element("BankCode");
		bankCode.setText(iBaseInfoEle.getChildText("BankCode"));
		mBaseInfo.addContent(bankCode);
		
		//<!-- �������� -->
		Element zoneNo = new Element("ZoneNo");
		zoneNo.setText(iBaseInfoEle.getChildText("ZoneNo"));
		mBaseInfo.addContent(zoneNo);
		
		//<!-- ������� -->
		Element brNo = new Element("BrNo");
		brNo.setText(iBaseInfoEle.getChildText("BrNo"));
		mBaseInfo.addContent(brNo);
		//<!-- ��Ա���� -->
		Element tellerNo = new Element("TellerNo");
		tellerNo.setText(iBaseInfoEle.getChildText("TellerNo"));
		mBaseInfo.addContent(tellerNo);
		//<!-- ������ˮ�� -->
		Element transrNo = new Element("TransrNo");
		transrNo.setText(iBaseInfoEle.getChildText("TransrNo"));
		mBaseInfo.addContent(transrNo);
		//<!-- �����־) -->
		Element functionFlag = new Element("FunctionFlag");
		functionFlag.setText(iBaseInfoEle.getChildText("FunctionFlag"));
		mBaseInfo.addContent(functionFlag);
		//<!-- ���չ�˾���� -->
		Element insuID = new Element("InsuID");
		insuID.setText(iBaseInfoEle.getChildText("InsuID"));
		mBaseInfo.addContent(insuID);
		mRootEle.addContent(mBaseInfo);
		/*End-��֯���ر���ͷ*/
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		cLogger.info("��ʼ����...");
		mBodyBytes = encode(mBodyBytes);
		cLogger.info("���ܳɹ���");
		
		byte[] mHeadBytes = new byte[16];
		//�����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith_(mLengthStr, 6, false);//����룬�Ҳ��ո�6λ
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		
		//���״���
		//����Լȷ��������Լȡ������Ҫ���⴦��һ��
		if("021".equals(cOutFuncFlag) || "020".equals(cOutFuncFlag)){
			cOutFuncFlag = "02";
		}
		cOutFuncFlag = NumberUtil.fillStrWith_(cOutFuncFlag, 4, false);//����룬�Ҳ��ո�4λ
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6, mFuncFlagBytes.length);
		//��˾����
		cInsuID = NumberUtil.fillStrWith_(cInsuID, 6, false);//����룬�Ҳ��ո�6λ
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 10, mInsuIDBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out BjbankNetImp.send()!");
	}
	
	/**
	 * ����
	 */
	private byte[] decode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		
		mCipher.init(Cipher.DECRYPT_MODE, BjbankKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
	
	/**
	 * ����
	 */
	private byte[] encode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		//������Կ�ɹ������е���Ӧ�����þ���Կ���ܴ���
		if("10".equals(cOutFuncFlag) && "1".equals(cOutFlag)){
			cLogger.info("��������ʱ���ܿ�ʼ");
			mCipher.init(Cipher.ENCRYPT_MODE, new BjbankOldKeyCache().getKey());
			cLogger.info("��������ʱ���ܽ���");
		}else {
			mCipher.init(Cipher.ENCRYPT_MODE, BjbankKeyCache.newInstance().getKey());
		}
		return mCipher.doFinal(pBytes);
		//modify
//		byte[] oBytes = mCipher.doFinal(pBytes);
//		if("10".equals(cOutFuncFlag) && "1".equals(cOutFlag)){
//			String hexString = bytesToHexString(oBytes);
//			cLogger.info("����������Կ���½��׷���16���Ʊ���");
//			cLogger.info(hexString);
//		}
//		return oBytes;
	}
	 /**
	  * ����ת����ʮ�������ַ���
	  * @param byte[]
	  * @return HexString
	  */
	 public static final String bytesToHexString(byte[] bArray) {
	  StringBuffer sb = new StringBuffer(bArray.length);
	  String sTemp;
	  for (int i = 0; i < bArray.length; i++) {
	   sTemp = Integer.toHexString(0xFF & bArray[i]);
	   if (sTemp.length() < 2)
	    sb.append(0);
	   sb.append(sTemp.toUpperCase());
	  }
	  return sb.toString();
	 }
}