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
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, mSocketIs);
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());
		cLogger.debug("请求报文长度：" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 4, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes,mSocketIs);
		cSocket.shutdownInput();
		
		if(!CHANGE_KEY.equals(cOutFuncFlag)){
			cLogger.info("开始解密...");
			mBodyBytes = decipherBytes(mBodyBytes);
			cLogger.info("解密成功！");
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
		cLogger.info("保存报文完毕！"+mSaveName);
		
		//生成标准报文头
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
			/*Start-组织返回报文头*/
			Element mRetCode = new Element("RetCode");
			Element mRetMes = new Element("RetMes");
			mRetCode.setText(mHeadEle.getChildText(Flag));
			mRetMes.setText(mHeadEle.getChildText(Desc));
			
			Document outDoc = new Document();
			Element mMAKRET = new Element("MAKRET");
			outDoc.setRootElement(mMAKRET);
			mMAKRET.addContent(mRetCode);
			mMAKRET.addContent(mRetMes);
			/*End-组织返回报文头*/
			pOutNoStd = outDoc;
		}
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		if(!CHANGE_KEY.equals(cOutFuncFlag)){
			cLogger.info("开始加密...");
			mBodyBytes = encryptBytes(mBodyBytes);
			cLogger.info("加密成功！");
		}
		byte[] mHeadBytes = new byte[16];
		//报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillWith0(mBodyBytes.length, 8);//占位为8 字节，采用右对齐，左补"0"的方式填充
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		//交易代码
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 4, mFuncFlagBytes.length);
		//公司代码
		byte[] mInsuIDBytes = "CEBB".getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out CebBankNetImpl.send()!");
	}
	/**
	 * 解密
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
	 * 加密
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
	 * 生成交换密钥交易流水号
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