package com.sinosoft.midplat.abc.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class AbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	
	public AbcNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into AbcNetImpl.receive()...");
		
		//������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
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
		
		cLogger.info("Out AbcNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into AbcNetImpl.send()...");
		/*Start-��֯���ر���ͷ*/
		//�����ˮ��	
		String cFlag = "";
		// MODIFY 2013-09-34 PBKINSR-167_����ũ������ͨ�����²�Ʒ	----BEGIN----
		try{
			
			// ���صı���pOutNoStdΪ���еķǱ�׼����
			cFlag = pOutNoStd.getRootElement().getChild("RetData").getChildText("Flag");
			System.out.println("cFlag"+cFlag);
			System.out.println("cOutFuncFlag"+cOutFuncFlag);
			if(cFlag.equals("1")&&cOutFuncFlag.equals("01")){//1 ����ɹ�     01�������㽻��
				pOutNoStd.getRootElement().getChild("Base").getChild("ReqsrNo").setText(Thread.currentThread().getName());
			}
			/* End-��֯���ر���ͷ */
		}catch(Exception exp){

			/*
			 * ���ص�pOutNoStd����Ϊ����ϵͳ�ı�׼���ģ�
			 * ������ͨϵͳУ������׳��쳣��ƽ̨��������ƽ��쳣��Ϣ��װΪ���ĵı�׼���ĸ�ʽ��
			 * �����ڴ��轫��׼����ת��Ϊ���еķǱ�׼���ĸ�ʽ���������ж˽��ͱ���չʾ��Ϣ��
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// ��׼�����У����ر�ʶFlag=1Ϊʧ��

				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild("Head").getChild("Desc").setName("Mesg");
				pOutNoStd.getRootElement().setName("Ret");
				pOutNoStd.getRootElement().getChild(Head).setName("RetData");
			}
		}		
		// MODIFY 2013-09-34 PBKINSR-167_����ũ������ͨ�����²�Ʒ	-----END-----
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		byte[] mHeadBytes = new byte[6];
		//�����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length);
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out AbcNetImpl.send()!");
	}
	
}

