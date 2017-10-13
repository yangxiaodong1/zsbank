package com.sinosoft.midplat.icbczj.net;

import java.net.Socket;
import java.util.Date;
import java.util.Map;

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
import com.sinosoft.midplat.icbczj.rsa.RSACoder;
import com.sinosoft.midplat.net.SocketNetImpl;

public class IcbcZJNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
//	private String cInsuID = null;
	
	public IcbcZJNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into IcbcZJNetImpl.receive()...");
		
		//������ͷ
		byte[] mHeadBytes = new byte[10];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 10).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		
		
		
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		JdomUtil.print(mXmlDoc);
		
		cLogger.info("��ʼ����...");
		///**��ע����Ŀǰ�ӽ���������
		try{
		    if( !decode(mXmlDoc, mBodyBytes) ){
		    	throw new Exception("����ǩ����֤ʧ�ܣ�");
		    }
		    
		}catch(Exception e){
//		    if(e instanceof javax.crypto.BadPaddingException){
//		        //��Կ��ƥ������Ľ����쳣
//		        cLogger.info("����ʧ�ܣ����Իָ���Կ...");
//		        new KeyChangeRollback().service(null);
//		    }
	        throw e;
		}
		//**/
		cLogger.info("���ܳɹ���");
		
		Element mRootEle = mXmlDoc.getRootElement();
		cOutFuncFlag = XPath.newInstance("//txcode").valueOf(mRootEle);
		cLogger.info("���״��룺" + cOutFuncFlag);
		
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
		
		cLogger.info("Out IcbcZJNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into IcbcZJNetImpl.send()...");
		
		/*Start-��֯���ر���ͷ*/
		Element mRootEle = pOutNoStd.getRootElement();
		
		
		Element mPub = mRootEle.getChild("pub");
		
		if (mPub == null) {
			// ������ͨϵͳϵͳ�����쳣ʱ�����½ڵ�Ϊ��
			mPub = new Element("pub");
			
    		
		}
		
		Element mHeadEle =  mRootEle.getChild(Head);
 		Element mResultCode = new Element("retcode");
        int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
 		if (CodeDef.RCode_OK == mFlagInt) {
 			mResultCode.setText("00000");
 		} else {
 			mResultCode.setText("B0002");
 		}
 		mPub.addContent(mResultCode);
		
		Element mretmsg = new Element("retmsg");
		mretmsg.setText(mHeadEle.getChildText("Desc"));
		mPub.addContent(mretmsg);
		
		Element mcmpdate = new Element("cmpdate");
		mcmpdate.setText(DateUtil.get8Date(new Date()) + "");
        mPub.addContent(mcmpdate);
         
        Element mcmptime = new Element("cmptime");
        mcmptime.setText(DateUtil.get6Time(new Date()) + "");
        mPub.addContent(mcmptime);
        
        Element mcmptxsno = new Element("cmptxsno");
        mcmptxsno.setText(DateUtil.get8Date(new Date()) + Thread.currentThread().getName());
        mPub.addContent(mcmptxsno);
         
        mRootEle.addContent(0,mPub);
		mRootEle.setName("package");
		
		mRootEle.removeContent(mRootEle.getChild("Head"));
		/*End-��֯���ر���ͷ*/
		
		cLogger.info("��ʼ����...");
		pOutNoStd = encode(pOutNoStd);
		cLogger.info("���ܳɹ���");
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
		.append('_').append(NoFactory.nextAppNo())
		.append('_').append(cFuncFlag)
		.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		byte[] mHeadBytes = new byte[10];
		//�����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 10, true);//��0
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out IcbcZJNetImpl.send()!");
	}
	
	/**
	 * ��֤����ǩ��
	 */
	private boolean decode(Document mXmlDoc ,byte[] mBodyBytes) throws Exception {
		Element mRootEle = mXmlDoc.getRootElement();
		
//		Map<String, Object> keyMap = RSACoder.genKeyPair();  
		byte[] publicKey = IcbcZJKeyCache.newInstance().getPubKey();  
//		byte[] privateKey = IcbcZJKeyCache.newInstance().getPriKey();  

		//��ȡ�㽭��������ǩ����Ϣ
        String sign = XPath.newInstance("//signature").valueOf(mRootEle);
        
        mRootEle.removeChild("signature");
        String data = new String(mBodyBytes);
		data = data.substring(data.indexOf("<package>")+9).trim();
		int end = data.indexOf("<signature>");

		data = data.substring(0,end);
//        byte[] encodedData = RSACoder.encryptByPrivateKey(data.getBytes(), privateKey);

		
        System.out.println("ǩ��:\r" + data);  
        boolean status = RSACoder.verify(data.getBytes(), publicKey, sign);  
		
		return status;
	}
	
	/**
	 * ��������ǩ��
	 */
	private Document encode(Document mXmlDoc) throws Exception {
		Element mRootEle = mXmlDoc.getRootElement();
		String data = JdomUtil.toString(mXmlDoc);
		data = data.substring(data.indexOf("<package>")+9).trim();
		data = data.substring(0,data.length()-"</package>".length());
		//��˽�ܼ���
//		Map<String, Object> keyMap = RSACoder.genKeyPair();  
		byte[] privateKey = IcbcZJKeyCache.newInstance().getPriKey();
//		byte[] encodedData = RSACoder.encryptByPrivateKey(data.getBytes(), privateKey); 
		System.out.println("��ǩ�������ݣ�");
		System.out.println(data);
		String sign = RSACoder.sign(data.getBytes(), privateKey);
		System.out.println("��ǩ�������ݣ�");
		System.out.println(sign);
		Element signatureEle  = new Element("signature");
		signatureEle.setText(sign);
		mRootEle.addContent(signatureEle);
		
		return mXmlDoc;
		
	}
}