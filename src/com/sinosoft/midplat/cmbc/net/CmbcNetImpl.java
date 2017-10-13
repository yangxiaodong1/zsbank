package com.sinosoft.midplat.cmbc.net;

import java.io.UnsupportedEncodingException;
import java.net.Socket;

import org.apache.commons.lang.StringUtils;
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

public class CmbcNetImpl extends SocketNetImpl{

	// ���й̶���ʶ
	private static final String BANK_FLAG = "INSU";
	// ���н��״���
	private String cOutFuncFlag = null;
	
	// ���뼯
	private static final String GBK_ENCODING = "GBK";
	
	private Element cTRANSRDATEEle = null;	// ��������
	private Element cTRANSRTIMEEle = null;	// ����ʱ��
	private Element cBANK_CODEEle = null;	// ���д���
	private Element cTRANSRNOEle = null;	// ������ˮ��
	
	public CmbcNetImpl(Socket socket, Element thisConfRoot) throws MidplatException {
		super(socket, thisConfRoot);
	}
	
	/* 
	 * �������е������ģ���ȡ������ת��ΪDocument���������뱾��
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into CmbcNetImpl.receive()...");
		
		/*
		 * ������Ͷ�����ȣ�21
		 * ��ͷ����ʶ��(INSU _4λ)+������(9λ)+������ĳ���(8λ������ʱ8λʱ��ǰ�油��)
		 * 
		 * ��ͷ������=4,�̶�Ϊ��INSU����
		 */
		
		// �����ͷ
		byte[] mHeadBytes = new byte[21];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// �������б��ı��룺GBK
		cOutFuncFlag =  xmlHead.substring(4, 13);
		int mBodyLen = Integer.parseInt(xmlHead.substring(13).trim()); // ���ĳ��Ȳ�������ͷ����
		cLogger.debug("�����ĳ���[" + mBodyLen + "]--���н�����[" + cOutFuncFlag + "]");
		
		
		// ��������
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//����������
		/*XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);*/
		
		//ӳ�佻����,������������
		String tCHNL_CODE = XPath.newInstance("//MAIN/CHNL_CODE").valueOf(mRootEle);
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @CHNL_CODE='"+tCHNL_CODE+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if("".equals(cFuncFlag)){	// ���û��ƥ�䵽�����ľ�Ĭ��Ϊ������ͨ����
		    //ӳ����淢��Ľ���
		     mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
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
		
		/*
		 * ȡ�����б����еĲ��ֽڵ㣬���ڷ��ر���ʱʹ��
		 */
		Element cTempEle = null;
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRDATE");
		cTRANSRDATEEle = (Element)cTempEle.clone();
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRTIME");
		cTRANSRTIMEEle = (Element)cTempEle.clone();
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/BANK_CODE");
		if(cTempEle != null){
			cBANK_CODEEle = (Element)cTempEle.clone();
		}
			
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRNO");
		cTRANSRNOEle = (Element)cTempEle.clone();

		cLogger.info("out CmbcNetImpl.receive()...");
		return mXmlDoc;
	}
	
	
	/* 
	 * �������еķǱ�׼���ı����ڱ��أ�����װΪ���Է��͸����ж˸�ʽ�ı���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into CmbcNetImpl.send()...");
		
		/* Start-��֯���ر���ͷ */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		
		Element mOKFLAGEle = new Element("RESULTCODE");	// 0=ʧ��,1=�ɹ�
		Element mFAILDETAILEle = new Element("ERR_INFO");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// ���׳ɹ�

			mOKFLAGEle.setText("1");
			
			mRootEle.getChild("MAIN").addContent(cTRANSRDATEEle.detach());	// ��������
			mRootEle.getChild("MAIN").addContent(cTRANSRTIMEEle.detach());	// ����ʱ��
			if(cBANK_CODEEle != null){
				mRootEle.getChild("MAIN").addContent(cBANK_CODEEle.detach());	// ���д���
			}
			mRootEle.getChild("MAIN").addContent(cTRANSRNOEle.detach());	// ������ˮ��
			
		} else {	// ����ʧ��
			mOKFLAGEle.setText("0");
			
			if (mRootEle.getChild("MAIN") == null) {	// �����׳��쳣--����ͨ
				
				/*
				 * �������㡢ǩ�����ش�ķ��ظ���ǩ��������ͬ�ġ����ղ൥���ر��ĸ���ǩ�������������ײ�ͬ����Ҫע��
				 */
				if(cFuncFlag.equals("3002")){	// ���ղ൥���ס�
					mRootEle.setName("FEETRANSCANCRET");
				}else{
					mRootEle.setName("RETURN");
				}
					
				Element mMAINEle = new Element("MAIN");
				mRootEle.addContent(mMAINEle);			
			}
		}
		mFAILDETAILEle.setText(mHeadEle.getChildText(Desc));
		mRootEle.getChild("MAIN").addContent(mFAILDETAILEle);
		mRootEle.getChild("MAIN").addContent(mOKFLAGEle);
		//������Ϊ�������ֻ����е����˽���ʱ������ʧ����Ҫ����������Ϣ�ֶ�
		if(cFuncFlag.equals("3009")||cFuncFlag.equals("3010")||cFuncFlag.equals("3011")||cFuncFlag.equals("3012")){
			mRootEle.getChild("MAIN").addContent(cTRANSRDATEEle.detach());	// ��������
			mRootEle.getChild("MAIN").addContent(cTRANSRTIMEEle.detach());	// ����ʱ��
			mRootEle.getChild("MAIN").addContent(cTRANSRNOEle.detach());	// ������ˮ��
		}
		
		/* End-��֯���ر���ͷ */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�" + mSaveName);
		
//		JdomUtil.print(pOutNoStd);	// ��ӡ��������
		
		//�����ǰ��н����������ʽ�����������
		String xmlOutStr = JdomUtil.toStringFmt(pOutNoStd,GBK_ENCODING);
		xmlOutStr = transHtmlCharacter(xmlOutStr);
		
//		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		
		// ���ĳ���
		byte[] mBodyBytes = xmlOutStr.getBytes(GBK_ENCODING);
		int cLenInt = mBodyBytes.length;
		cLogger.info("���ر��ĳ��ȣ�" + cLenInt);
		String mLenStr = NumberUtil.fillWith0(cLenInt, 8);	//��0
		
		
		/*
		 * ������Ͷ�����ȣ�21
		 * ��ͷ����ʶ��(INSU _4λ)+������(9λ)+������ĳ���(8λ������ʱ8λʱ��ǰ�油��)
		 * 
		 * ��ͷ������=4,�̶�Ϊ��INSU����
		 */
		String mHeadBytes = BANK_FLAG + cOutFuncFlag + mLenStr;
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // ���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes); // ���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out CmbcNetImpl.send()!");
	}
	
	
	/**
	 * ��html�ַ�תΪ��Ӧ����
	 * 
	 * @param str
	 * @return
	 */
	private   String transHtmlCharacter(String str) {
		if (StringUtils.isBlank(str)){
			return "";
		}
		
		str = str.replaceAll("&gt;", ">");
		str = str.replaceAll("&lt;", "<");
		str = str.replaceAll("&amp;", "&");
		str = str.replaceAll("&apos;", "'");

		return str;
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException{
		
		String str = "INSURQ000T00150004064";
		byte[] mHeadBytes = new byte[21];
		mHeadBytes = str.getBytes();
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// �������б��ı��룺GBK
		String cOutFuncFlag =  xmlHead.substring(4, 13);
		int mBodyLen = Integer.parseInt(xmlHead.substring(13).trim());
		
		System.out.println("�����ĳ���[" + mBodyLen + "]--���н�����[" + cOutFuncFlag + "]");
		
	}

}
