package com.sinosoft.midplat.hfbank.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class HfbankNetImpl extends SocketNetImpl {

	// ���й̶���ʶ
	private static final String BANK_FLAG = "HFBC";
	// ���뼯
	private static final String GBK_ENCODING = "GBK";
	// ���н��״���
	private String cOutFuncFlag = null;
	
	public HfbankNetImpl(Socket socket, Element thisConfRoot) throws MidplatException {
		super(socket, thisConfRoot);
	}

	/* 
	 * �������е������ģ���ȡ������ת��ΪDocument���������뱾��
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into HfbankNetImpl.receive()...");
		
		/*
		 * ÿ�����ݰ��Ļ�����ʽΪ����ͷ+����+���塣
		 * ��ͷ��HFBC��4�ַ���+�����루4�ַ���������HFBCΪ��ʶ�룬��ͷ��ռλΪ8���ַ���
		 * ������ռλΪ10 �ַ��������Ҷ��룬�󲹡�0���ķ�ʽ��䡣���ĳ�������8λ��ͷ�Լ�10λ�����ĳ��ȣ���������Ϊ����ĳ��ȡ�
		 * ���壺XML���ģ�������ͨ�����Ĵ��䡣
		 */
		
		// �����ͷ
		byte[] mHeadBytes = new byte[18];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);
		cOutFuncFlag =  xmlHead.substring(4, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim());
		cLogger.debug("�����ĳ���[" + mBodyLen + "]--���н�����[" + cOutFuncFlag + "]");
		
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
//		System.out.println(new String (mBodyBytes));
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		Element cTransaction_HeaderEle_Temp = (Element) mRootEle.getChild("Head");
		
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
		
		cTransaction_HeaderEle_Temp.addContent(mClientIpEle);
		cTransaction_HeaderEle_Temp.addContent(cTranComEle);
		cTransaction_HeaderEle_Temp.addContent(mFuncFlagEle);

		return mXmlDoc;
	}
	
	/* 
	 * �������еķǱ�׼���ı����ڱ��أ�����װΪ���Է��͸����ж˸�ʽ�ı���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into HfbankNetImpl.send()...");
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		int cLenStr = Integer.parseInt(String.valueOf(mBodyBytes.length));
		cLogger.info("���ر��ĳ��ȣ�" + cLenStr);
		String mLenStr = NumberUtil.fillWith0(cLenStr, 10);	//�Ҷ��룬��0
		String mHeadBytes = BANK_FLAG + cOutFuncFlag + mLenStr;
		
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out HfbankNetImpl.send()!");
	}
		
}
