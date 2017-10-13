package com.sinosoft.midplat.jxnxs.net;

import java.net.Socket;

import javax.crypto.Cipher;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;


import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.bjbank.service.KeyChangeRollback;
import com.sinosoft.midplat.net.SocketNetImpl;

public class JxnxsNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private String cOutFlag = null;
	private String reFlag = null;
	
	public JxnxsNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into JxnxsNetImpl.receive()...");
		
		//������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		//���չ�˾����4λ
		cInsuID = new String(mHeadBytes, 0, 4).trim();
		//����/���ձ�־1λ��1����2��Ӧ��
		reFlag = new  String(mHeadBytes, 4, 1).trim();
		//������3λ
		cOutFuncFlag = new  String(mHeadBytes, 5, 3).trim();
		cLogger.info("���״��룺" + reFlag + cOutFuncFlag);
		//���ĳ��ȣ������峤�������Ҷ��롢�󲹡�0���ķ�ʽ��䡣
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());		
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		
		
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		//����ũ���в���"GB2312"����
		Document mXmlDoc = JdomUtil.build(mBodyBytes,"GB2312");
		Element mRootEle = mXmlDoc.getRootElement();
		
		
		//����������
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + reFlag + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
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
		
		cLogger.info("Out JxnxsNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into JxnxsNetImpl.send()...");
		
		/* �������ͨϵͳ�쳣  */
		
		try{
			cOutFlag = pOutNoStd.getRootElement().getChild("MAIN").getChildText("OKFLAG");
		}catch(Exception exp){
			/*
			 * ���ص�pOutNoStd����Ϊ����ϵͳ�ı�׼���ģ�
			 * ������ͨϵͳУ������׳��쳣��ƽ̨��������ƽ��쳣��Ϣ��װΪ���ĵı�׼���ĸ�ʽ��
			 * �����ڴ��轫��׼����ת��Ϊ���еķǱ�׼���ĸ�ʽ���������ж˽��ͱ���չʾ��Ϣ��
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// ��׼�����У����ر�ʶFlag=1Ϊʧ�ܣ�����1 �ɹ���0 ʧ��
				cOutFlag = "1111";
				
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("1111");
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setName("RESULTCODE");
				pOutNoStd.getRootElement().getChild(Head).getChild(Desc).setName("ERR_INFO");
				pOutNoStd.getRootElement().getChild(Head).setName("MAIN");
				if("021".equals(cOutFuncFlag)){//�˱�
					pOutNoStd.getRootElement().setName("INSUREQRET");
				}else if ("022".equals(cOutFuncFlag)){//�ɷ�
					pOutNoStd.getRootElement().setName("RETURN");
				}else if("002".equals(cOutFuncFlag)){//���ճ���
					pOutNoStd.getRootElement().setName("FEETRANSCANCRET");
				}
				
			}
		}
		
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		//����ũ���в��á�GB2312��
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd,"GB2312");
		
		byte[] mHeadBytes = new byte[16];
		
		//��˾����
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, 4);
		//����/���ձ�־
		reFlag = "2";
		byte[] mReFlagBytes = reFlag.getBytes();
		System.arraycopy(mReFlagBytes, 0, mHeadBytes, 4, 1);
		//������3λ
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 5, mFuncFlagBytes.length);
		
		//�����峤��
		String mLengthStr = NumberUtil.fillWith0(mBodyBytes.length, 8);//�����Ҷ��롢�󲹡�0���ķ�ʽ���
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out JxnxsNetImpl.send()!");
	}
	

}