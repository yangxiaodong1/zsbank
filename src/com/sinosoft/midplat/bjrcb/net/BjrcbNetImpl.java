/**
 * ����ũ������
 */
package com.sinosoft.midplat.bjrcb.net;

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

public class BjrcbNetImpl extends SocketNetImpl {
	private Element cTransaction_HeaderEle;

	public BjrcbNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into BjrcbNetImpl.receive()...");

		// ������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer
				.parseInt(new String(mHeadBytes, 0, 16).trim());
		cLogger.info("�����ĳ��ȣ�" + mBodyLength);

		// ��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();

		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//���������Head�ڵ㣬���ڷ���ʱʹ��
		cTransaction_HeaderEle = (Element) mRootEle.getChild("Head").clone();

		//��������ԭʼ����
		Element  cTransaction_HeaderEle_Temp = (Element) mRootEle.getChild("Head");
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='"
				+ cTransaction_HeaderEle_Temp.getChildText("TransCode") + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		JdomUtil.print(mXmlDoc);
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);

		// ���ɱ�׼����ͷ
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		Element mFuncFlagEle = new Element(FuncFlag);
		mFuncFlagEle.setText(cFuncFlag);

		cTransaction_HeaderEle_Temp.addContent(mClientIpEle);
		cTransaction_HeaderEle_Temp.addContent(cTranComEle);
		cTransaction_HeaderEle_Temp.addContent(mFuncFlagEle);

		cLogger.info("Out BjrcbNetImpl.receive()!");
		return mXmlDoc;
	}

	@SuppressWarnings("unchecked")
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into BjrcbNetImpl.send()...");

		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		mRootEle.setName("TXLife");

		//��֯ͨ�ô���ͷ
		Element mErrorMsg = new Element("ErrorMsg");
		Element mECount = new Element("ECount");
		Element mEList = new Element("EList");
		Element mErrorCode = new Element("ErrorCode");
		Element mErrorText = new Element("ErrorText");

		mErrorMsg.addContent(mECount);
		mErrorMsg.addContent(mEList);
		mEList.addContent(mErrorCode);
		
		//�ж��Ƿ��ǳɹ�����
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
		    //�ɹ�����
			mErrorCode.setText("OTH0000");
			mECount.setText("1");
		} else if(CodeDef.RCode_RenHe == mFlagInt){
		    //����
		    mErrorCode.setText("OTH9753");
		    mECount.setText("1");
		}else{
		    //ʧ�ܷ���
			mErrorCode.setText("OTH9999");
			mECount.setText("1");
		}
		//���ô�����Ϣ
		mEList.addContent(mErrorText);
		mErrorText.setText(mHeadEle.getChildText(Desc));

		//��װ����ͷ
		mRootEle.addContent(0, mErrorMsg);
		mRootEle.addContent(0, cTransaction_HeaderEle);

		/* End-��֯���ر���ͷ */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);

		byte[] mHeadBytes = new byte[16];
		// �����峤��
		String mLengthStr = String.valueOf(NumberUtil.fillWith0(
				mBodyBytes.length, 16));

		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();

		cLogger.info("Out BjrcbNetImpl.send()!");
	}
}