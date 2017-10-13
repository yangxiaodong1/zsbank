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
 * @Description: 负责接收银行请求报文，发送保险公司响应报文
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Apr 1, 2014 3:24:05 PM
 * @version 
 *
 */
public class HxbNetImpl extends SocketNetImpl {

	
	// 银行固定标识
	private static final String BANK_FLAG = "NCLF";
	// “10”：银行向保险公司发送的数据
	private static final String SEND_FLAG = "10";
	// “20”：保险公司向银行发送的数据
	private static final String RECE_FLAG = "20";
	
	// 银行交易代码
	private String cOutFuncFlag = null;
	
	// 编码集
	private static final String GBK_ENCODING = "GBK";
	
	public HxbNetImpl(Socket socket, Element thisConfRoot)throws MidplatException {
		super(socket, thisConfRoot);
	}
	
	/* 
	 * 接收银行的请求报文，提取请求报文转换为Document，并保存与本地
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into HxbNetImpl.receive()...");
		
		/*
		 * 处理报文投保长度：16
		 * 包头+发送/接收标志+操作码+包长
		 * 
		 * 包头：长度=4,固定为“NCLF”。
		 * 发送/接收标志：长度=2，“10”：银行向保险公司发送的数据；“20”：保险公司向银行发送的数据；
		 * 操作码：长度=2
		 * 包长： 长度=8，包长值：16 + 报文体长；采用左对齐，右补空格(英文空格)方式填充。
		 */
		
		// 处理包头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// 华夏银行报文编码：GBK
		cOutFuncFlag =  xmlHead.substring(6, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim())-16;
		cLogger.debug("请求报文长度[" + mBodyLen + "]--银行交易码[" + cOutFuncFlag + "]");
		
		
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//解析交易码
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_in.xml");
		SaveMessage.save(mXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
		// 生成标准报文头
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
	 * 将给银行的非标准报文保存于本地，并封装为可以发送给银行端格式的报文
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into HxbNetImpl.send()...");
		
		/* Start-组织返回报文头 */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		
		Element mOKFLAGEle = new Element("OKFLAG");
		Element mFAILDETAILEle = new Element("FAILDETAIL");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// 交易成功

			mOKFLAGEle.setText("1");
		} else {	// 交易失败
			mOKFLAGEle.setText("0");
			mFAILDETAILEle.setText(mHeadEle.getChildText(Desc));
			if (mRootEle.getChild("MAIN") == null) {	// 交易抛出异常--银保通
				
				mRootEle.setName("RETURN");
				Element mMAINEle = new Element("MAIN");
				mRootEle.addContent(mMAINEle);
			}
			mRootEle.getChild("MAIN").addContent(mFAILDETAILEle);
		}

		/*
		 * 这部分代码放在各自的报文转换中逻辑更好一些，因为接收非标准报文是也要区分交易类型，而且区分度更细
		 */
		
//		if(cFuncFlag.equals("1501") || cFuncFlag.equals("1502") || cFuncFlag.equals("1504")){
//			/*
//			 * 不论成功、失败，且交易是投保-1501、承保-1502、重打-1504，添加 投保单号：APP
//			 */
//			mRootEle.getChild("MAIN").getChild("APP").setText(text);
//		}else if(cFuncFlag.equals("1503")){
//			/*
//			 * 不论成功、失败，且交易是撤单-1503,给标签添加值：
//			 * 保险单号：INSURNO，投保单号：APPLYNO
//			 */
//			mRootEle.getChild("MAIN").getChild("INSURNO").setText(text);
//			mRootEle.getChild("MAIN").getChild("APPLYNO").setText(text);
//		}
		
		mRootEle.getChild("MAIN").addContent(mOKFLAGEle);
		
		/* End-组织返回报文头 */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// 打印报文内容
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		
		// 报文长度
		int cLenStr = Integer.parseInt(String.valueOf(mBodyBytes.length));
		cLogger.info("返回报文长度：" + cLenStr);
		cLenStr = cLenStr + 16;
		String mLenStr = NumberUtil.fillWith_(cLenStr, 8, false);	//左对齐，右补空格
		
		/*
		 * 处理报文投保长度：16
		 * 包头+发送/接收标志+操作码+包长
		 * 
		 * 包头：长度=4,固定为“NCLF”。
		 * 发送/接收标志：长度=2，“10”：银行向保险公司发送的数据；“20”：保险公司向银行发送的数据；
		 * 操作码：长度=2
		 * 包长： 长度=8，包长值：16 + 报文体长；采用左对齐，右补空格(英文空格)方式填充。
		 */
		String mHeadBytes = BANK_FLAG + RECE_FLAG + cOutFuncFlag + mLenStr;
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out HxbNetImpl.send()!");
	}
	
	
	public static void main(String[] args) throws UnsupportedEncodingException{
		
		String str = "NCLF10v1726     ";
		byte[] mHeadBytes = new byte[16];
		mHeadBytes = str.getBytes();
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// 华夏银行报文编码：GBK
		String cOutFuncFlag =  xmlHead.substring(6, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim());
		System.out.println("请求报文长度[" + mBodyLen + "]--银行交易码[" + cOutFuncFlag + "]");
		
	}
}
