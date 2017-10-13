package com.sinosoft.midplat.bcomm.net;

import java.net.Socket;

import org.apache.commons.lang.StringUtils;
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
 * @Title: com.sinosoft.midplat.bcomm.net.BcommNetImpl.java
 * @Description: ����������������ģ����ͱ��չ�˾��Ӧ����
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Feb 7, 2014 9:51:00 AM
 * @version 
 *
 */
public class BcommNetImpl extends SocketNetImpl{
	
	// ����
	private static final int PACKAGE_LEN = 8;
	
	// ���й̶���ʶ
	private static final String BANK_FLAG = "BANK&&COMM";
	
	// ���뼯
	private static final String ENCODING = "GBK";
	
	private String K_TRLIST = "K_TrList";
	
	// ���н��״���
	private String bankOutCode;

	public BcommNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	/* 
	 * �������ж˱���
	 */
	public Document receive() throws Exception {
		cLogger.info("Into BcommNetImpl.receive()...");

		/*
		 * ������ͷ: ����ͷ����=24
		 * ���ܱ�־��1�ֽڣ�+ ���ױ�ʶ��10�ֽڣ�+ �����루5�ֽڣ�+ ���ĳ���8�ֽڣ�
		 * ���ܱ�־��1�����ܣ�0�������ܡ�
		 * ���ױ�ʶ��ĿǰԼ��ΪBANK&&COMM, �ұ���Ϊ��д��ĸ��
		 */ 
		byte[] mHeadBytes = new byte[24];	
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, ENCODING);	// ��ͨ���б��ı��룺GBK
		int mBodyLen = Integer.parseInt(xmlHead.substring(16).trim());
		bankOutCode = xmlHead.substring(11, 16).trim();
		cLogger.debug("�����ĳ���[" + mBodyLen + "]--���н�����[" + bankOutCode + "]");
		
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();

		/*
		 * ���������룬����ӳ����������Ľ����룬���ӳ�䲻������ӳ�����Ľ�����
		 */
		String tChanNo =  XPath.newInstance("//K_TrList/ChanNo").valueOf(mRootEle);	// ���н�������
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "' and @chanNo='"+tChanNo+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if(StringUtils.isEmpty(cFuncFlag)){
		    //ӳ����淢��Ľ���
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
		/*XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);*/
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
		
		cLogger.info("Out BcommNetImpl.receive()!");
		return mXmlDoc;
	}

	/* 
	 * ���ͱ��ĸ�����
	 */
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into BcommNetImpl.send()...");

		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));

		Element mResultCode = new Element("K_RetCode");
		Element mResultMsg = new Element("K_RetMsg");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// ���׳ɹ�

			mResultCode.setText("1");
			mResultMsg.setText(mHeadEle.getChildText(Desc));
		} else {	// ����ʧ��
			mResultCode.setText("0");
			mResultMsg.setText(mHeadEle.getChildText(Desc));
			if (mRootEle.getChild(K_TRLIST) == null) {	// �����׳��쳣--����ͨ
				
				mRootEle.setName("RMBP");
			}
		}
		
		mRootEle.addContent(0, mResultCode);
		mRootEle.addContent(1, mResultMsg);
		
		/*
		 * ���ӹ�����ǩ�����չ�˾�������ڡ�ʱ�䡢��ˮ��
		 */
		Element mK_TrList = mRootEle.getChild(K_TRLIST);
		if(null == mK_TrList){
			mK_TrList = new Element(K_TRLIST);
			mRootEle.addContent(2, mK_TrList);
		}
		Element mKR_EntTrDate = new Element("KR_EntTrDate");
		mKR_EntTrDate.setText(DateUtil.getCurDate("yyyyMMdd"));
		
		Element mKR_EntTrTime = new Element("KR_EntTrTime");
		mKR_EntTrTime.setText(String.valueOf(DateUtil.getCur6Time()));
		
		Element mKR_EntSeq = new Element("KR_EntSeq");
		mKR_EntSeq.setText(Thread.currentThread().getName());
		
		mK_TrList.addContent(mKR_EntTrDate);	// ���չ�˾��������
		mK_TrList.addContent(mKR_EntTrTime);	// ���չ�˾����ʱ��
		mK_TrList.addContent(mKR_EntSeq);	// ���չ�˾������ˮ��

		/* End-��֯���ر���ͷ */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// ��ӡ��������

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, ENCODING);
		// ���ĳ���
		String mLenStr = String.valueOf(mBodyBytes.length);
		mLenStr = NumberUtil.fillStrWith0(mLenStr, PACKAGE_LEN, true);	//��0
		cLogger.info("���ر��ĳ��ȣ�" + mLenStr);
		/*
		 * ���ܱ�־��1�ֽڣ�+ ���ױ�ʶ��10�ֽڣ�+ �����루5�ֽڣ�+ ���ĳ���8�ֽڣ�
		 * 0-������,1-����
		 */
		String mHeadBytes = 0 + BANK_FLAG + bankOutCode + mLenStr;
		
		cSocket.getOutputStream().write(mHeadBytes.getBytes(ENCODING)); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();

		cLogger.info("Out BcommNetImpl.send()!");
	}
}
