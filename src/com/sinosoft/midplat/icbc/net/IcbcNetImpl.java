package com.sinosoft.midplat.icbc.net;

import java.net.Socket;

import javax.crypto.Cipher;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.icbc.service.KeyChangeRollback;
import com.sinosoft.midplat.net.SocketNetImpl;

public class IcbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	
	public IcbcNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into IcbcNetImp.receive()...");
		
		//��������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		cInsuID = new String(mHeadBytes, 10, 6).trim();
		//����������
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
		cLogger.info("���ܳɹ���");
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//ӳ�佻����,������������
		String SourceType = XPath.newInstance(
		"//SourceType").valueOf(mRootEle);
		XPath mXPath = XPath.newInstance(
		        "business/funcFlag[@outcode='" + cOutFuncFlag + "' and @sourceType='"+SourceType+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if("".equals(cFuncFlag)){
		    //ӳ����淢��Ľ���
		     mXPath = XPath.newInstance(
		            "business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_in.xml");
		
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
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
		
		cLogger.info("Out IcbcNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into IcbcNetImp.send()...");
		
		/*Start-��֯���ر���ͷ*/
		Element mRootEle = pOutNoStd.getRootElement();
		
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mResultCode = new Element("ResultCode");
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
			mResultCode.setText("0000");
		} else if (CodeDef.RCode_RenHe == mFlagInt) {
			mResultCode.setText("1222");
		} else {
			mResultCode.setText("1234");
		}
		
		Element mResultInfoDesc = new Element("ResultInfoDesc");
		mResultInfoDesc.setText(mHeadEle.getChildText(Desc));
		Element mResultInfo = new Element("ResultInfo");
		mResultInfo.addContent(mResultInfoDesc);
		
		Element mTransResult = new Element("TransResult");
		mTransResult.addContent(mResultCode);
		mTransResult.addContent(mResultInfo);
		
		if ("0001".equals(cOutFuncFlag)) {	//��Կ����
			mRootEle.setName("DesKeyNotifyResponse");
			mRootEle.addContent(mTransResult);
		} else {
			if (mRootEle.getChild("TXLifeResponse") == null) {
				// ������ͨϵͳϵͳ�����쳣ʱ�����½ڵ�Ϊ��
	            Element mTXLifeResponse = new Element("TXLifeResponse");
	            mTXLifeResponse.addContent(mTransResult);
	            
	            Element mTransRefGUID = new Element("TransRefGUID");
	            mTXLifeResponse.addContent(mTransRefGUID);
	            
	            Element mTransType = new Element("TransType");
	            mTransType.setText("1013");	// �µ��б�--1013
	            mTXLifeResponse.addContent(mTransType);
	            
	            Element mTransExeDate = new Element("TransExeDate");
	            mTransExeDate.setText(DateUtil.getCur10Date());
	            mTXLifeResponse.addContent(mTransExeDate);
	            
	            Element mTransExeTime = new Element("TransExeTime");
	            mTransExeTime.setText(DateUtil.getCur8Time());
	            mTXLifeResponse.addContent(mTransExeTime);
	            
	            mRootEle.addContent(mTXLifeResponse);
			}else{
				mRootEle.getChild("TXLifeResponse").addContent(0, mTransResult);				
			}
			mRootEle.setName("TXLife");

		}
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
		
		cLogger.info("Out IcbcNetImp.send()!");
	}
	
	/**
	 * ����
	 */
	private byte[] decode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		mCipher.init(Cipher.DECRYPT_MODE, IcbcKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
	
	/**
	 * ����
	 */
	private byte[] encode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		mCipher.init(Cipher.ENCRYPT_MODE, IcbcKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
}