package com.sinosoft.midplat.citic.net;

import java.net.Socket;

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
import com.sinosoft.midplat.net.SocketNetImpl;

/**
 * @Title: com.sinosoft.midplat.citic.net.CiticNetImpl.java
 * @Description: 
 * Copyright: Copyright (c) 2013 
 * Company:�����IT��
 * 
 * @date Aug 19, 2013 8:19:53 PM
 * @version 
 *
 */
public class CiticNetImpl extends SocketNetImpl {

	private Element cTransaction_HeaderEle;

	public CiticNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into CiticNetImpl.receive()...");

		// ������ͷ
		byte[] mHeadBytes = new byte[6];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLen = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLen);
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();

		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		
		
		Element mRootEle = mXmlDoc.getRootElement();

		//���汨��ͷ�����ڷ�������
		cTransaction_HeaderEle = (Element) mRootEle.getChild(
				"Transaction_Header").clone();

		//����������
		
		//add 20150925 PBKINSR-878  ���������ֻ�������Ŀ��ʢ2��������Ӯ�� begin
		//��ȡ�������з�����������
		String saleChannel = cTransaction_HeaderEle.getChildText("BkChnlNo");
		cFuncFlag = cTransaction_HeaderEle.getChildText("BkTxCode");
		String cOutFuncFlag = cFuncFlag;
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "' and @saleChannel='"+saleChannel+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		if(cFuncFlag != null && !"".equals(cFuncFlag.trim())){
			
		}else{
			cFuncFlag = cOutFuncFlag;
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		/**ע�͵�ԭ���Ļ�ȡ��ʽ
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='"+ cTransaction_HeaderEle.getChildText("BkTxCode") + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		**/
		//add 20150925 PBKINSR-878  ���������ֻ�������Ŀ��ʢ2��������Ӯ�� end
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);

		// ���ɱ�׼����ͷ
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		Element mFuncFlagEle = new Element(FuncFlag);
		mFuncFlagEle.setText(cFuncFlag);

		Element mHeadEle = new Element(Head);
		mHeadEle.addContent(mClientIpEle);
		mHeadEle.addContent(cTranComEle);
		mHeadEle.addContent(mFuncFlagEle);

		mRootEle.addContent(mHeadEle);

		cLogger.info("Out CiticNetImpl.receive()!");
		return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CiticNetImpl.send()...");

		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		mRootEle.setName("Transaction");

		Element mBkOthDateEle = new Element("BkOthDate");
		mBkOthDateEle.setText(DateUtil.getCurDate("yyyyMMdd"));
		Element mBkOthSeqEle = new Element("BkOthSeq");
		mBkOthSeqEle.setText(Thread.currentThread().getName());

		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mBkOthRetCodeEle = new Element("BkOthRetCode");
		if (CodeDef.RCode_OK == Integer.parseInt(mHeadEle.getChildText(Flag))) {
			mBkOthRetCodeEle.setText("00000");
		} else {
			mBkOthRetCodeEle.setText("11111");
		}
		Element mBkOthRetMsgEle = new Element("BkOthRetMsg");
		mBkOthRetMsgEle.setText(mHeadEle.getChildText(Desc));

		Element mTran_ResponseEle = new Element("Tran_Response");
		mTran_ResponseEle.addContent(mBkOthDateEle);
		mTran_ResponseEle.addContent(mBkOthSeqEle);
		mTran_ResponseEle.addContent(mBkOthRetCodeEle);
		mTran_ResponseEle.addContent(mBkOthRetMsgEle);

		cTransaction_HeaderEle.addContent(mTran_ResponseEle);
		mRootEle.addContent(0, cTransaction_HeaderEle);
		/* End-��֯���ر���ͷ */

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// ��ӡ��������

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);

		byte[] mHeadBytes = new byte[6];
		// �����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 6, true);//��0
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();

		cLogger.info("Out CiticNetImpl.send()!");
	}
	
}
