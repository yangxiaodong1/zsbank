package com.sinosoft.midplat.bjbank.net;

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

public class BjbankNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private Document pNoStdXml = null;
	private String cOutFlag = null;
	
	public BjbankNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into BjbankNetImp.receive()...");
		
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
		cLogger.info("解密成功！" );
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		//增加银行方请求报文，以便响应时对响应报文做补充
		this.pNoStdXml = mXmlDoc;
		Element mRootEle = mXmlDoc.getRootElement();
		//如果是新契约取消或确认交易时，这两个交易码相同，需要特殊处理一下
		if("02".equals(cOutFuncFlag)){
			String confirmFlag = XPath.newInstance("/TranData/LCCont/ConfirmFlag").valueOf(pNoStdXml.getRootElement());
			cOutFuncFlag = cOutFuncFlag + confirmFlag;
		}
		
		//解析交易码
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
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
		
		cLogger.info("Out BjbankNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into BjbankNetImp.send()...");
		
		/* 如果银保通系统异常  */
		
		try{
			cOutFlag = pOutNoStd.getRootElement().getChild("RetData").getChildText("Flag");
		}catch(Exception exp){
			/*
			 * 返回的pOutNoStd报文为核心系统的标准报文，
			 * 因银保通系统校验错误抛出异常后，平台错误处理机制将异常信息封装为核心的标准报文格式，
			 * 所以在此需将标准报文转化为银行的非标准报文格式，便于银行端解释报文展示信息。
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// 标准报文中，返回标识Flag=1为失败
				cOutFlag = "0";
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild(Head).setName("RetData");
			}
		}
		/*Start-组织返回报文头*/
		Element mRootEle = pOutNoStd.getRootElement();//银行响应报文
		Element iRootEle = pNoStdXml.getRootElement();//银行请求报文
		Element iBaseInfoEle = iRootEle.getChild("BaseInfo");
		//增加银行响应报文中的BaseInfo节点数据
		Element mBaseInfo = new Element("BaseInfo");
        
		//<!-- 银行交易日期 -->
		Element bankDate = new Element("BankDate");
		bankDate.setText(iBaseInfoEle.getChildText("BankDate"));
		mBaseInfo.addContent(bankDate);
		
		//<!-- 银行代码 -->
		Element bankCode = new Element("BankCode");
		bankCode.setText(iBaseInfoEle.getChildText("BankCode"));
		mBaseInfo.addContent(bankCode);
		
		//<!-- 地区代码 -->
		Element zoneNo = new Element("ZoneNo");
		zoneNo.setText(iBaseInfoEle.getChildText("ZoneNo"));
		mBaseInfo.addContent(zoneNo);
		
		//<!-- 网点代码 -->
		Element brNo = new Element("BrNo");
		brNo.setText(iBaseInfoEle.getChildText("BrNo"));
		mBaseInfo.addContent(brNo);
		//<!-- 柜员代码 -->
		Element tellerNo = new Element("TellerNo");
		tellerNo.setText(iBaseInfoEle.getChildText("TellerNo"));
		mBaseInfo.addContent(tellerNo);
		//<!-- 交易流水号 -->
		Element transrNo = new Element("TransrNo");
		transrNo.setText(iBaseInfoEle.getChildText("TransrNo"));
		mBaseInfo.addContent(transrNo);
		//<!-- 处理标志) -->
		Element functionFlag = new Element("FunctionFlag");
		functionFlag.setText(iBaseInfoEle.getChildText("FunctionFlag"));
		mBaseInfo.addContent(functionFlag);
		//<!-- 保险公司代码 -->
		Element insuID = new Element("InsuID");
		insuID.setText(iBaseInfoEle.getChildText("InsuID"));
		mBaseInfo.addContent(insuID);
		mRootEle.addContent(mBaseInfo);
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
		//新契约确认与新契约取消，需要特殊处理一下
		if("021".equals(cOutFuncFlag) || "020".equals(cOutFuncFlag)){
			cOutFuncFlag = "02";
		}
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
		
		cLogger.info("Out BjbankNetImp.send()!");
	}
	
	/**
	 * 解密
	 */
	private byte[] decode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		
		mCipher.init(Cipher.DECRYPT_MODE, BjbankKeyCache.newInstance().getKey());
		
		return mCipher.doFinal(pBytes);
	}
	
	/**
	 * 加密
	 */
	private byte[] encode(byte[] pBytes) throws Exception {
		Cipher mCipher = Cipher.getInstance("DES");
		//更新密钥成功后，银行的响应报文用旧密钥加密处理
		if("10".equals(cOutFuncFlag) && "1".equals(cOutFlag)){
			cLogger.info("返回银行时加密开始");
			mCipher.init(Cipher.ENCRYPT_MODE, new BjbankOldKeyCache().getKey());
			cLogger.info("返回银行时加密结束");
		}else {
			mCipher.init(Cipher.ENCRYPT_MODE, BjbankKeyCache.newInstance().getKey());
		}
		return mCipher.doFinal(pBytes);
		//modify
//		byte[] oBytes = mCipher.doFinal(pBytes);
//		if("10".equals(cOutFuncFlag) && "1".equals(cOutFlag)){
//			String hexString = bytesToHexString(oBytes);
//			cLogger.info("北京银行密钥更新交易返回16进制报文");
//			cLogger.info(hexString);
//		}
//		return oBytes;
	}
	 /**
	  * 数组转换成十六进制字符串
	  * @param byte[]
	  * @return HexString
	  */
	 public static final String bytesToHexString(byte[] bArray) {
	  StringBuffer sb = new StringBuffer(bArray.length);
	  String sTemp;
	  for (int i = 0; i < bArray.length; i++) {
	   sTemp = Integer.toHexString(0xFF & bArray[i]);
	   if (sTemp.length() < 2)
	    sb.append(0);
	   sb.append(sTemp.toUpperCase());
	  }
	  return sb.toString();
	 }
}