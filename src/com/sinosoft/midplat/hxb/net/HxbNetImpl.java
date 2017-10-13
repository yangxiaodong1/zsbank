package com.sinosoft.midplat.hxb.net;

import java.io.UnsupportedEncodingException;
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


/**
 * @Title: com.sinosoft.midplat.hxb.net.HxbNetImpl.java
 * @Description: ����������������ģ����ͱ��չ�˾��Ӧ����
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 1, 2014 3:24:05 PM
 * @version 
 *
 */
public class HxbNetImpl extends SocketNetImpl {

	
	// ���й̶���ʶ
	private static final String BANK_FLAG = "NCLF";
	// ��10�����������չ�˾���͵�����
	private static final String SEND_FLAG = "10";
	// ��20�������չ�˾�����з��͵�����
	private static final String RECE_FLAG = "20";
	
	// ���н��״���
	private String cOutFuncFlag = null;
	
	// ���뼯
	private static final String GBK_ENCODING = "GBK";
	
	public HxbNetImpl(Socket socket, Element thisConfRoot)throws MidplatException {
		super(socket, thisConfRoot);
	}
	
	/* 
	 * �������е������ģ���ȡ������ת��ΪDocument���������뱾��
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into HxbNetImpl.receive()...");
		
		/*
		 * ������Ͷ�����ȣ�16
		 * ��ͷ+����/���ձ�־+������+����
		 * 
		 * ��ͷ������=4,�̶�Ϊ��NCLF����
		 * ����/���ձ�־������=2����10�����������չ�˾���͵����ݣ���20�������չ�˾�����з��͵����ݣ�
		 * �����룺����=2
		 * ������ ����=8������ֵ��16 + �����峤����������룬�Ҳ��ո�(Ӣ�Ŀո�)��ʽ��䡣
		 */
		
		// �����ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// �������б��ı��룺GBK
		cOutFuncFlag =  xmlHead.substring(6, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim())-16;
		cLogger.debug("�����ĳ���[" + mBodyLen + "]--���н�����[" + cOutFuncFlag + "]");
		
		
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//����������
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
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

		return mXmlDoc;
	}
	
	/* 
	 * �������еķǱ�׼���ı����ڱ��أ�����װΪ���Է��͸����ж˸�ʽ�ı���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into HxbNetImpl.send()...");
		
		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		
		Element mOKFLAGEle = new Element("OKFLAG");
		Element mFAILDETAILEle = new Element("FAILDETAIL");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// ���׳ɹ�

			mOKFLAGEle.setText("1");
		} else {	// ����ʧ��
			mOKFLAGEle.setText("0");
			mFAILDETAILEle.setText(mHeadEle.getChildText(Desc));
			if (mRootEle.getChild("MAIN") == null) {	// �����׳��쳣--����ͨ
				
				mRootEle.setName("RETURN");
				Element mMAINEle = new Element("MAIN");
				mRootEle.addContent(mMAINEle);
			}
			mRootEle.getChild("MAIN").addContent(mFAILDETAILEle);
		}

		/*
		 * �ⲿ�ִ�����ڸ��Եı���ת�����߼�����һЩ����Ϊ���շǱ�׼������ҲҪ���ֽ������ͣ��������ֶȸ�ϸ
		 */
		
//		if(cFuncFlag.equals("1501") || cFuncFlag.equals("1502") || cFuncFlag.equals("1504")){
//			/*
//			 * ���۳ɹ���ʧ�ܣ��ҽ�����Ͷ��-1501���б�-1502���ش�-1504����� Ͷ�����ţ�APP
//			 */
//			mRootEle.getChild("MAIN").getChild("APP").setText(text);
//		}else if(cFuncFlag.equals("1503")){
//			/*
//			 * ���۳ɹ���ʧ�ܣ��ҽ����ǳ���-1503,����ǩ���ֵ��
//			 * ���յ��ţ�INSURNO��Ͷ�����ţ�APPLYNO
//			 */
//			mRootEle.getChild("MAIN").getChild("INSURNO").setText(text);
//			mRootEle.getChild("MAIN").getChild("APPLYNO").setText(text);
//		}
		
		mRootEle.getChild("MAIN").addContent(mOKFLAGEle);
		
		/* End-��֯���ر���ͷ */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// ��ӡ��������
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		
		// ���ĳ���
		int cLenStr = Integer.parseInt(String.valueOf(mBodyBytes.length));
		cLogger.info("���ر��ĳ��ȣ�" + cLenStr);
		cLenStr = cLenStr + 16;
		String mLenStr = NumberUtil.fillWith_(cLenStr, 8, false);	//����룬�Ҳ��ո�
		
		/*
		 * ������Ͷ�����ȣ�16
		 * ��ͷ+����/���ձ�־+������+����
		 * 
		 * ��ͷ������=4,�̶�Ϊ��NCLF����
		 * ����/���ձ�־������=2����10�����������չ�˾���͵����ݣ���20�������չ�˾�����з��͵����ݣ�
		 * �����룺����=2
		 * ������ ����=8������ֵ��16 + �����峤����������룬�Ҳ��ո�(Ӣ�Ŀո�)��ʽ��䡣
		 */
		String mHeadBytes = BANK_FLAG + RECE_FLAG + cOutFuncFlag + mLenStr;
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out HxbNetImpl.send()!");
	}
	
	
	public static void main(String[] args) throws UnsupportedEncodingException{
		
		String str = "NCLF10v1726     ";
		byte[] mHeadBytes = new byte[16];
		mHeadBytes = str.getBytes();
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// �������б��ı��룺GBK
		String cOutFuncFlag =  xmlHead.substring(6, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim());
		System.out.println("�����ĳ���[" + mBodyLen + "]--���н�����[" + cOutFuncFlag + "]");
		
	}
}
