package com.sinosoft.midplat.cebbank.net;

import java.io.InputStream;
import java.net.Socket;
import java.util.Calendar;
import java.util.Date;


import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import cebenc.softenc.SoftEnc;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class CebBankNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private static String CHANGE_KEY = "9001";
	
	public CebBankNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into CebBankNetImpl.receive()...");
		InputStream mSocketIs = cSocket.getInputStream();
		//������ͷ
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, mSocketIs);
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());
		cLogger.debug("�����ĳ��ȣ�" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 4, 4).trim();
		cLogger.info("���״��룺" + cOutFuncFlag);
		//��������
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes,mSocketIs);
		cSocket.shutdownInput();
		
		if(!CHANGE_KEY.equals(cOutFuncFlag)){
			cLogger.info("��ʼ����...");
			mBodyBytes = decipherBytes(mBodyBytes);
			cLogger.info("���ܳɹ���");
		}
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		XPath mXPath = XPath.newInstance(
				"business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_in.xml");
		
		
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		//���ɱ�׼����ͷ
		Element mHeadEle = null;
		if(mRootEle.getChild(Head)==null){
			Calendar mCalendar = Calendar.getInstance();
			mHeadEle = new Element(Head);
			mHeadEle.addContent(new Element(TranDate).setText(String.valueOf(DateUtil.get8Date(mCalendar))));
			mHeadEle.addContent(new Element(TranTime).setText(String.valueOf(DateUtil.get6Time(mCalendar))));
			mHeadEle.addContent(new Element(TellerNo).setText("cebbank"));
			mHeadEle.addContent(new Element(TranNo).setText(getTransNo(cOutFuncFlag)));
			mHeadEle.addContent(new Element(NodeNo).setText("-"));
			mHeadEle.addContent(new Element(FuncFlag).setText(cFuncFlag));
			mHeadEle.addContent(cTranComEle);
			mRootEle.addContent(mHeadEle);
		}else{
			mHeadEle = mRootEle.getChild(Head);
			mHeadEle.getChild(FuncFlag).setText(cFuncFlag);
			mHeadEle.getChild(TranCom).setText(cTranComEle.getText());
			mHeadEle.getChild(TranCom).setAttribute("outcode",cTranComEle.getAttributeValue("outcode"));
		}
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		mHeadEle.addContent(mClientIpEle);
		mHeadEle.addContent(new Element("BankCode").setText(cTranComEle.getAttributeValue("outcode")));
		cLogger.info("Out CebBankNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CebBankNetImpl.send()...");
		if(CHANGE_KEY.equals(cOutFuncFlag)){
			Element mRootEle = pOutNoStd.getRootElement();
			Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
			/*Start-��֯���ر���ͷ*/
			Element mRetCode = new Element("RetCode");
			Element mRetMes = new Element("RetMes");
			mRetCode.setText(mHeadEle.getChildText(Flag));
			mRetMes.setText(mHeadEle.getChildText(Desc));
			
			Document outDoc = new Document();
			Element mMAKRET = new Element("MAKRET");
			outDoc.setRootElement(mMAKRET);
			mMAKRET.addContent(mRetCode);
			mMAKRET.addContent(mRetMes);
			/*End-��֯���ر���ͷ*/
			pOutNoStd = outDoc;
		}
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("���汨����ϣ�"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		if(!CHANGE_KEY.equals(cOutFuncFlag)){
			cLogger.info("��ʼ����...");
			mBodyBytes = encryptBytes(mBodyBytes);
			cLogger.info("���ܳɹ���");
		}
		byte[] mHeadBytes = new byte[16];
		//�����峤��
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillWith0(mBodyBytes.length, 8);//ռλΪ8 �ֽڣ������Ҷ��룬��"0"�ķ�ʽ���
		cLogger.info("���ر��ĳ��ȣ�" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		//���״���
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 4, mFuncFlagBytes.length);
		//��˾����
		byte[] mInsuIDBytes = "CEBB".getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//���ͱ���ͷ
		cSocket.getOutputStream().write(mBodyBytes);	//���ͱ�����
		cSocket.shutdownOutput();
		
		cLogger.info("Out CebBankNetImpl.send()!");
	}
	/**
	 * ����
	 * @param receiveBytes
	 * @return
	 * @throws Exception
	 */
	public byte[] decipherBytes(byte[] receiveBytes) throws Exception{
		SoftEnc.Init(new String(SysInfo.cHome+"key/cebbankkey/"));
		byte[] reBytes = new byte[receiveBytes.length-16];
		String mackStr = new String(receiveBytes, receiveBytes.length-16, 16).trim();
		System.arraycopy(receiveBytes, 0, reBytes, 0, reBytes.length);
		String genStr = SoftEnc.GenMac(reBytes);
		if(mackStr.equals(genStr)){
			return reBytes;
		}
		return null;
	}
	/**
	 * ����
	 * @param sendBytes
	 * @return
	 * @throws Exception
	 */
	public byte[] encryptBytes(byte[] sendBytes) throws Exception{
		SoftEnc.Init(new String(SysInfo.cHome+"key/cebbankkey/"));
		byte[] sdBytes = new byte[sendBytes.length+16];
		byte[] genBytes = SoftEnc.GenMac(sendBytes).getBytes();
		System.arraycopy(sendBytes, 0, sdBytes, 0, sendBytes.length);
		System.arraycopy(genBytes, 0, sdBytes, sendBytes.length, genBytes.length);
		return sdBytes;
	}
	/**
	 * ���ɽ�����Կ������ˮ��
	 * @param thisFuncFlag
	 * @return
	 */
	public String getTransNo(String thisFuncFlag) {
        Object ob = new Object();
        String transNo;
        synchronized (ob) {
            transNo = thisFuncFlag + DateUtil.getCur8Date()
                    + new Date().getTime();
        }
        return transNo;

    }
	
	
}