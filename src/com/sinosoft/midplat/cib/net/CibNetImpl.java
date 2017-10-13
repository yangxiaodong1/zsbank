package com.sinosoft.midplat.cib.net;

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

public class CibNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private String cOutFlag = null;
	private String reFlag = null;
	
	public CibNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into CibNetImp.receive()...");
		
		//������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		//���չ�˾����4λ
		cInsuID = new String(mHeadBytes, 0, 4).trim();
		//����/���ձ�־2λ
		reFlag = new  String(mHeadBytes, 4, 2).trim();
		//������2λ
		cOutFuncFlag = new  String(mHeadBytes, 6, 2).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		//���ĳ��ȣ����� = 16 + �����峤����������룬�Ҳ��ո�(Ӣ�Ŀո�)��ʽ��䡣
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim())-16;		
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		
		
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		/**
		 * ������ҵ���нӿ������ȷ�Ͻ��������������ֶα�ǩ��һ�£���Ҫ�ֱ���
		 */
		//��ȡ��������
		String tCHNL_CODE = XPath.newInstance("//MAIN/CHANNEL").valueOf(mRootEle);
		//����������
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @channel='"+tCHNL_CODE+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		if("".equals(cFuncFlag)){
			tCHNL_CODE = XPath.newInstance("//MAIN/TEMP").valueOf(mRootEle);	
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @channel='"+tCHNL_CODE+"']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);			
		}
		if("".equals(cFuncFlag)){//���û��ƥ�䵽�����ն˵ľ�Ĭ��Ϊ������ͨ����
		    //ӳ����淢��Ľ���
		    mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
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
		
		cLogger.info("Out CibNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CibNetImp.send()...");
		
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
				cOutFlag = "0";
				
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setName("OKFLAG");
				
				/*
				 * ����ʧ��ʱ����ǩ�����֣�FAILDETAIL�������ش򣩣�REJECTNO�����㣬ǩ�������ղ൥��
				 */
				pOutNoStd.getRootElement().getChild(Head).getChild(Desc).setName("FAILDETAIL");
				Element tREJECTNOEle = new Element("REJECTNO");
				tREJECTNOEle.setText(pOutNoStd.getRootElement().getChild(Head).getChildText("FAILDETAIL"));
				pOutNoStd.getRootElement().getChild(Head).addContent(tREJECTNOEle);
				
				pOutNoStd.getRootElement().getChild(Head).setName("MAIN");
			}
		}
		
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		byte[] mHeadBytes = new byte[16];
		
		//��˾����
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, 4);
		//����/���ձ�־
		reFlag = "20";
		byte[] mReFlagBytes = reFlag.getBytes();
		System.arraycopy(mReFlagBytes, 0, mHeadBytes, 4, 2);
		//������2λ
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6, mFuncFlagBytes.length);
		
		//�����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length + 16);
		mLengthStr = NumberUtil.fillStrWith_(mLengthStr, 8, false);//����룬�Ҳ��ո�8λ
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out CibNetImp.send()!");
	}
	

}