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

	// 银行固定标识
	private static final String BANK_FLAG = "HFBC";
	// 编码集
	private static final String GBK_ENCODING = "GBK";
	// 银行交易代码
	private String cOutFuncFlag = null;
	
	public HfbankNetImpl(Socket socket, Element thisConfRoot) throws MidplatException {
		super(socket, thisConfRoot);
	}

	/* 
	 * 接收银行的请求报文，提取请求报文转换为Document，并保存与本地
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into HfbankNetImpl.receive()...");
		
		/*
		 * 每个数据包的基本格式为：包头+包长+包体。
		 * 包头：HFBC（4字符）+交易码（4字符）。其中HFBC为标识码，包头总占位为8个字符。
		 * 包长：占位为10 字符，采用右对齐，左补“0”的方式填充。报文长不包括8位包头以及10位包长的长度，即包长仅为包体的长度。
		 * 包体：XML报文，报文体通过明文传输。
		 */
		
		// 处理包头
		byte[] mHeadBytes = new byte[18];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);
		cOutFuncFlag =  xmlHead.substring(4, 8);
		int mBodyLen = Integer.parseInt(xmlHead.substring(8).trim());
		cLogger.debug("请求报文长度[" + mBodyLen + "]--银行交易码[" + cOutFuncFlag + "]");
		
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
//		System.out.println(new String (mBodyBytes));
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		Element cTransaction_HeaderEle_Temp = (Element) mRootEle.getChild("Head");
		
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
		
		cTransaction_HeaderEle_Temp.addContent(mClientIpEle);
		cTransaction_HeaderEle_Temp.addContent(cTranComEle);
		cTransaction_HeaderEle_Temp.addContent(mFuncFlagEle);

		return mXmlDoc;
	}
	
	/* 
	 * 将给银行的非标准报文保存于本地，并封装为可以发送给银行端格式的报文
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into HfbankNetImpl.send()...");
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		int cLenStr = Integer.parseInt(String.valueOf(mBodyBytes.length));
		cLogger.info("返回报文长度：" + cLenStr);
		String mLenStr = NumberUtil.fillWith0(cLenStr, 10);	//右对齐，左补0
		String mHeadBytes = BANK_FLAG + cOutFuncFlag + mLenStr;
		
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out HfbankNetImpl.send()!");
	}
		
}
