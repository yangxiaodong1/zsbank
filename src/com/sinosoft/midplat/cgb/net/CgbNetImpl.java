package com.sinosoft.midplat.cgb.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.cgb.service.KeyChangeRollback;
import com.sinosoft.midplat.common.CgbCipherUtil;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class CgbNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String isEncrypt = null;

	public CgbNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into CgbNetImpl.receive()...");

		// ������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		
		cLogger.info("����ͷ��" + new String(mHeadBytes, 0, 16).trim());
		cOutFuncFlag = new String(mHeadBytes, 4, 4).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());
		cLogger.info("�����ĳ��ȣ�" + mBodyLength);

		// ��������
		byte[] mBodyBytes = new byte[mBodyLength];

		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		//���зǹ������������ӽ��ܴ���
		isEncrypt = XPath.newInstance(
	                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/isEncrypt").valueOf(cThisConfRoot);
		if(isEncrypt != null && "false".equals(isEncrypt)){			
			cLogger.info("�ǹ����������������ܴ���");
		}
		else {
			cLogger.info("��ʼ����...");
	        try{
	            //�˴�������ν���
	            mBodyBytes = new CgbCipherUtil().decrypt(mBodyBytes,false);
	        }catch(Exception e){
	            if(e instanceof javax.crypto.BadPaddingException){
	                //��Կ��ƥ������Ľ����쳣
	                cLogger.info("����ʧ�ܣ����Իָ���Կ...");
	                new KeyChangeRollback(cThisConfRoot).service(null);
	            }
	            throw e;
	        }
	        cLogger.info("���ܳɹ���");
		}
		
        Document mXmlDoc = JdomUtil.build(mBodyBytes);
        Element mRootEle = mXmlDoc.getRootElement();
        
        //����������    
        XPath mXPath = XPath.newInstance(
                "business/funcFlag[@outcode='" + cOutFuncFlag + "']");	 
        cFuncFlag = mXPath.valueOf(cThisConfRoot);
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
        
        Element mHeadEle = null;
        if("3040".equals(cOutFuncFlag) || "3042".equals(cOutFuncFlag) || "3044".equals(cOutFuncFlag)){
        	mHeadEle = mRootEle.getChild(Head);
        	mHeadEle.addContent(mClientIpEle);
            mHeadEle.addContent(cTranComEle);
            mHeadEle.addContent(mFuncFlagEle);          
        }else{
        	mHeadEle = new Element(Head);
        	mHeadEle.addContent(mClientIpEle);
            mHeadEle.addContent(cTranComEle);
            mHeadEle.addContent(mFuncFlagEle);
          
            mRootEle.addContent(mHeadEle);
        }        
       
        
        cLogger.info("Out CgbNetImpl.receive()!");
        return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CgbNetImpl.send()...");
		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		

		//��ȡ�����÷�����
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mResultCode = new Element("RESULTCODE");
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
			mResultCode.setText("00000000");
		}else {
			mResultCode.setText("11111111");
		}
		Element mResultInfoDesc = new Element("ERR_INFO");
		mResultInfoDesc.setText(mHeadEle.getChildText(Desc));

		//���ر����Ƿ����main�ڵ�
		String hasMain = XPath.newInstance(
                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/mainElement").valueOf(cThisConfRoot);
		//��ȡmain�ڵ�
		Element mMainEle = mRootEle.getChild("MAIN");
		if (mRootEle.getChild("MAIN") == null && !"false".equals(hasMain)) {
			if("TIKUAN".equals(hasMain)){
				mMainEle = new Element("Head");
			    mRootEle.addContent(mMainEle);
			}else{
				// ��ϵͳ�����쳣ʱ���ýڵ�Ϊ�ա����Ҹý��ױ���Ӧ����main�ڵ�
			    mMainEle = new Element("MAIN");
			    mRootEle.addContent(mMainEle);
			}		    
		}
		if(mMainEle!=null){
		    //���ر����д���main�ڵ�
		    //�������롢������ӵ�main�ڵ�
		    mMainEle.addContent(mResultCode);
		    mMainEle.addContent(mResultInfoDesc);
		}else{
		    //���ر����в�����main�ڵ㣬������Կ����
		    mRootEle.addContent(mResultCode);
		    mRootEle.addContent(mResultInfoDesc);
		}
		
	    // ���÷��ر���root�ڵ�tag
        XPath mXPath = XPath.newInstance(
                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/reRootTab");
        String reRootTab = mXPath.valueOf(cThisConfRoot);
        mRootEle.setName(reRootTab);
        
        StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
            .append('_').append(NoFactory.nextAppNo())
            .append('_').append(cFuncFlag)
            .append("_out.xml");
        SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
        cLogger.info("���汨����ϣ�"+mSaveName);

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		//�ǹ��������������ӽ��ܴ���
		if(isEncrypt != null && "false".equals(isEncrypt)){			
			cLogger.info("�ǹ����������������ܴ���");
		}else {
			cLogger.info("��ʼ����...");
	        try{
	            mBodyBytes = new CgbCipherUtil().encrypt(mBodyBytes);
	        }catch(Exception e){
	            cLogger.error("����ʧ��...",e);
	            throw e;
	        }
			cLogger.info("���ܳɹ���");
		}	
		
		byte[] mHeadBytes = new byte[16];
		//��ͷ
		byte[] mInsuIDBytes = "INSU".getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);
		
		// ��ȡ���ؽ�����
        mXPath = XPath.newInstance(
                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/reFuncFlag");
        String reFuncFlag = mXPath.valueOf(cThisConfRoot);
		byte[] mSdRvFlagBytes = reFuncFlag.getBytes();
		System.arraycopy(mSdRvFlagBytes, 0, mHeadBytes, 4, mSdRvFlagBytes.length);
		
		//������
		String mLengthStr = String.valueOf(NumberUtil.fillStrWith0(String.valueOf(mBodyBytes.length), 8));
		cLogger.info("���ذ����ȣ�" + mLengthStr);
		cLogger.info("���ؽ����룺" + new String(mSdRvFlagBytes));
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();

		cLogger.info("Out CgbNetImpl.send()!");
	}
}
