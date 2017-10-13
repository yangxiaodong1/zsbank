package com.sinosoft.midplat.citicHZ.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.citicHZ.util.CiticHZKeyUtil;
import com.sinosoft.midplat.citicHZ.util.SecMsg;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

/**
 * @Title: com.sinosoft.midplat.citicHZ.net.CiticHZNetImpl.java
 * @Description: 
 * Copyright: Copyright (c) 2016
 * Company:�����IT�� 
 *
 */
public class CiticHZNetImpl extends SocketNetImpl {

	private Element cTransaction_HeaderEle;
	
//	private SecMsg secMsgB1 = null;
	
	private SecMsg secMsgB1 = null;

	public CiticHZNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into CiticHZNetImpl.receive()...");
		
		// ������ͷ
		byte[] mHeadBytes = new byte[6];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLen = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLen);
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		//��ȡ��ǩ��ǩ����,�˴θ��������ṩ����֤��ʽ������֤
		//ʹ�����з��ṩ�ļӽ���ǩ�����߽��������Ļ�ȡ������Ϣ		
		secMsgB1 = new SecMsg();
		secMsgB1.setSecMsgChper(mBodyBytes);
		
		String cerpath = SysInfo.cHome+"key/citichzkey/";
		boolean result = CiticHZKeyUtil.clearSignForReceive(secMsgB1,cerpath+"CNCB.cer", cerpath+"ServerA.cer", cerpath+"ServerA.key", cerpath+"ServerA.pwd");
		if (!result){
			throw new MidplatException("��֤���������ĺ�ǩ������");
		}
		byte[] msgRecv = secMsgB1.getSecMsgClear();
		
		System.out.println("==1==== msgRecv(����:" + msgRecv.length + ")=[" + new String(msgRecv,"GBK") + "]");

		//���ı������ݱ�����
		Document mXmlDoc = JdomUtil.build(msgRecv);	
		Element mRootEle = mXmlDoc.getRootElement();

		//���汨��ͷ�����ڷ�������
		cTransaction_HeaderEle = (Element) mRootEle.getChild("Transaction_Header").clone();

		//����������
		//��ȡ�������з�����������
		String saleChannel = cTransaction_HeaderEle.getChildText("BkChnlNo");
		cFuncFlag = cTransaction_HeaderEle.getChildText("BkTxCode");
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "' and @saleChannel='"+saleChannel+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
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

		cLogger.info("Out CiticHZNetImpl.receive()!");
		return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CiticHZNetImpl.send()...");

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

		if(cTransaction_HeaderEle != null){
			cTransaction_HeaderEle.addContent(mTran_ResponseEle);
			mRootEle.addContent(0, cTransaction_HeaderEle);
		}else{
			Element mTran_Header = new Element("Transaction_Header");
			mTran_Header.addContent(mTran_ResponseEle);
			mRootEle.addContent(0, mTran_Header);
		}		
		/* End-��֯���ر���ͷ */

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// ��ӡ��������

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		String resStr = new String(mBodyBytes,"GBK").replaceAll("\r\n","");
		resStr = resStr.replaceAll("<PbInsuExp />","<PbInsuExp></PbInsuExp>");
		resStr = resStr.replaceAll("<Pbmaxamt />","<Pbmaxamt></Pbmaxamt>");
		mBodyBytes = resStr.getBytes("GBK");
        System.out.println("mBodyBytes====222====="+new String(mBodyBytes));
		byte[] mHeadBytes = new byte[6];
		//������ǩ���ݣ����������ṩ�ķ�������ǩ��
		String cerpath = SysInfo.cHome+"key/citichzkey/";
		byte[] msgSend2 = CiticHZKeyUtil.sendsignEncyptRe(mBodyBytes, cerpath+"ServerA.pwd", cerpath+"ServerA.key", cerpath+"ServerA.cer", cerpath+"CNCB.cer",
				secMsgB1.getSessionKey());
		// �����峤��
		String mLengthStr = String.valueOf(msgSend2.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 6, true);//��0
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		cSocket.getOutputStream().write(mHeadBytes); // ���ͱ���ͷ
		cSocket.getOutputStream().write(msgSend2); // ���ͱ�����
		cSocket.shutdownOutput();

		cLogger.info("Out CiticHZNetImpl.send()!");
	}
	
}
