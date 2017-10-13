package com.sinosoft.midplat.icbc.net;

import java.net.Socket;

import javax.crypto.Cipher;

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
import com.sinosoft.midplat.icbc.service.KeyChangeRollback;
import com.sinosoft.midplat.net.SocketNetImpl;

public class IcbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	
	public IcbcNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into IcbcNetImp.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		cInsuID = new String(mHeadBytes, 10, 6).trim();
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		cLogger.info("开始解密...");
		try{
		    mBodyBytes = decode(mBodyBytes);
		}catch(Exception e){
		    if(e instanceof javax.crypto.BadPaddingException){
		        //密钥不匹配引起的解密异常
		        cLogger.info("解密失败，尝试恢复密钥...");
		        new KeyChangeRollback().service(null);
		    }
	        throw e;
		}
		cLogger.info("解密成功！");
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//映射交易码,网银渠道优先
		String SourceType = XPath.newInstance(
		"//SourceType").valueOf(mRootEle);
		XPath mXPath = XPath.newInstance(
		        "business/funcFlag[@outcode='" + cOutFuncFlag + "' and @sourceType='"+SourceType+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if("".equals(cFuncFlag)){
		    //映射柜面发起的交易
		     mXPath = XPath.newInstance(
		            "business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_in.xml");
		
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		//生成标准报文头
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		Element mFuncFlagEle = new Element(FuncFlag);
		mFuncFlagEle.setText(cFuncFlag);
		
		Element mHeadEle = new Element(Head);
		mHeadEle.addContent(mClientIpEle);
		mHeadEle.addContent(cTranComEle);
		mHeadEle.addContent(mFuncFlagEle);
      
		mRootEle.addContent(mHeadEle);
		
		cLogger.info("Out IcbcNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into IcbcNetImp.send()...");
		
		/*Start-组织返回报文头*/
		Element mRootEle = pOutNoStd.getRootElement();
		
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mResultCode = new Element("ResultCode");
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
			mResultCode.setText("0000");
		} else if (CodeDef.RCode_RenHe == mFlagInt) {
			mResultCode.setText("1222");
		} else {
			mResultCode.setText("1234");
		}
		
		Element mResultInfoDesc = new Element("ResultInfoDesc");
		mResultInfoDesc.setText(mHeadEle.getChildText(Desc));
		Element mResultInfo = new Element("ResultInfo");
		mResultInfo.addContent(mResultInfoDesc);
		
		Element mTransResult = new Element("TransResult");
		mTransResult.addContent(mResultCode);
		mTransResult.addContent(mResultInfo);
		
		if ("0001".equals(cOutFuncFlag)) {	//密钥更新
			mRootEle.setName("DesKeyNotifyResponse");
			mRootEle.addContent(mTransResult);
		} else {
			if (mRootEle.getChild("TXLifeResponse") == null) {
				// 当银保通系统系统发生异常时，以下节点为空
	            Element mTXLifeResponse = new Element("TXLifeResponse");
	            mTXLifeResponse.addContent(mTransResult);
	            
	            Element mTransRefGUID = new Element("TransRefGUID");
	            mTXLifeResponse.addContent(mTransRefGUID);
	            
	            Element mTransType = new Element("TransType");
	            mTransType.setText("1013");	// 新单承保--1013
	            mTXLifeResponse.addContent(mTransType);
	            
	            Element mTransExeDate = new Element("TransExeDate");
	            mTransExeDate.setText(DateUtil.getCur10Date());
	            mTXLifeResponse.addContent(mTransExeDate);
	            
	            Element mTransExeTime = new Element("TransExeTime");
	            mTransExeTime.setText(DateUtil.getCur8Time());
	            mTXLifeResponse.addContent(mTransExeTime);
	            
	            mRootEle.addContent(mTXLifeResponse);
			}else{
				mRootEle.getChild("TXLifeResponse").addContent(0, mTransResult);				
			}
			mRootEle.setName("TXLife");

		}
		/*End-组织返回报文头*/
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		cLogger.info("开始加密...");
		mBodyBytes = encode(mBodyBytes);
		cLogger.info("加密成功！");
		
		byte[] mHeadBytes = new byte[16];
		//报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith_(mLengthStr, 6, false);//左对齐，右补空格，6位
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		
		//交易代码
		cOutFuncFlag = NumberUtil.fillStrWith_(cOutFuncFlag, 4, false);//左对齐，右补空格，4位
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6, mFuncFlagBytes.length);
		//公司代码
		cInsuID = NumberUtil.fillStrWith_(cInsuID, 6, false);//左对齐，右补空格，6位
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 10, mInsuIDBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out IcbcNetImp.send()!");
	}
	
	/**
	 * 解密
	 */
	private byte[] decode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		mCipher.init(Cipher.DECRYPT_MODE, IcbcKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
	
	/**
	 * 加密
	 */
	private byte[] encode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		mCipher.init(Cipher.ENCRYPT_MODE, IcbcKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
}