package com.sinosoft.midplat.jsbc.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class JsbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;

	public JsbcNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	private Element tTRANSRNOEle = null;
	public Document receive() throws Exception {
		cLogger.info("Into JsbcNetImpl.receive()...");

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
        
        Element mHeadEle = new Element(Head);
        mHeadEle.addContent(mClientIpEle);
        mHeadEle.addContent(cTranComEle);
        mHeadEle.addContent(mFuncFlagEle);
      
        mRootEle.addContent(mHeadEle);
        
        tTRANSRNOEle = (Element) XPath.newInstance("//MAIN/TRANSRNO").selectSingleNode(mRootEle);
        
        cLogger.info("Out JsbcNetImpl.receive()!");
        return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into JsbcNetImpl.send()...");
		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		

		//��ȡ�����÷����룺�������������룩��	1 �ɹ���0 ʧ�� 
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mResultCode = new Element("RESULTCODE");
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
			mResultCode.setText("1");
		}else {
			mResultCode.setText("0");
		}
		Element mResultInfoDesc = new Element("ERR_INFO");
		mResultInfoDesc.setText(mHeadEle.getChildText(Desc));

		//���ر����Ƿ����main�ڵ�
//		String hasMain = XPath.newInstance(
//                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/mainElement").valueOf(cThisConfRoot);
		//��ȡmain�ڵ�
		Element mMainEle = mRootEle.getChild("MAIN");
		if (mRootEle.getChild("MAIN") == null ) {
		    // ��ϵͳ�����쳣ʱ���ýڵ�Ϊ�ա�
		    mMainEle = new Element("MAIN");
		    mRootEle.addContent(mMainEle);
		    
		}
		mMainEle.addContent(mResultCode);
	    mMainEle.addContent(mResultInfoDesc);
	   //����������ˮ���ֶ�
	    Element mTRANSRNO = new Element("TRANSRNO");
	    mTRANSRNO.setText(tTRANSRNOEle.getText());
	    mMainEle.addContent(mTRANSRNO);
		
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

		cLogger.info("Out JsbcNetImpl.send()!");
	}
}
