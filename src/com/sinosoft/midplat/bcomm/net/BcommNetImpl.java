package com.sinosoft.midplat.bcomm.net;

import java.net.Socket;

import org.apache.commons.lang.StringUtils;
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
import com.sinosoft.midplat.net.SocketNetImpl;

/**
 * @Title: com.sinosoft.midplat.bcomm.net.BcommNetImpl.java
 * @Description: 负责接收银行请求报文，发送保险公司响应报文
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Feb 7, 2014 9:51:00 AM
 * @version 
 *
 */
public class BcommNetImpl extends SocketNetImpl{
	
	// 包长
	private static final int PACKAGE_LEN = 8;
	
	// 银行固定标识
	private static final String BANK_FLAG = "BANK&&COMM";
	
	// 编码集
	private static final String ENCODING = "GBK";
	
	private String K_TRLIST = "K_TrList";
	
	// 银行交易代码
	private String bankOutCode;

	public BcommNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	/* 
	 * 接收银行端报文
	 */
	public Document receive() throws Exception {
		cLogger.info("Into BcommNetImpl.receive()...");

		/*
		 * 处理报文头: 报文头长度=24
		 * 加密标志（1字节）+ 交易标识（10字节）+ 交易码（5字节）+ 报文长（8字节）
		 * 加密标志：1－加密，0－不加密。
		 * 交易标识：目前约定为BANK&&COMM, 且必须为大写字母。
		 */ 
		byte[] mHeadBytes = new byte[24];	
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, ENCODING);	// 交通银行报文编码：GBK
		int mBodyLen = Integer.parseInt(xmlHead.substring(16).trim());
		bankOutCode = xmlHead.substring(11, 16).trim();
		cLogger.debug("请求报文长度[" + mBodyLen + "]--银行交易码[" + bankOutCode + "]");
		
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();

		/*
		 * 解析交易码，优先映射电子渠道的交易码，如果映射不到，在映射柜面的交易码
		 */
		String tChanNo =  XPath.newInstance("//K_TrList/ChanNo").valueOf(mRootEle);	// 银行交易渠道
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "' and @chanNo='"+tChanNo+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if(StringUtils.isEmpty(cFuncFlag)){
		    //映射柜面发起的交易
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
		/*XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + bankOutCode + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);*/
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
		
		cLogger.info("Out BcommNetImpl.receive()!");
		return mXmlDoc;
	}

	/* 
	 * 发送报文给银行
	 */
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into BcommNetImpl.send()...");

		/* Start-组织返回报文头 */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));

		Element mResultCode = new Element("K_RetCode");
		Element mResultMsg = new Element("K_RetMsg");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// 交易成功

			mResultCode.setText("1");
			mResultMsg.setText(mHeadEle.getChildText(Desc));
		} else {	// 交易失败
			mResultCode.setText("0");
			mResultMsg.setText(mHeadEle.getChildText(Desc));
			if (mRootEle.getChild(K_TRLIST) == null) {	// 交易抛出异常--银保通
				
				mRootEle.setName("RMBP");
			}
		}
		
		mRootEle.addContent(0, mResultCode);
		mRootEle.addContent(1, mResultMsg);
		
		/*
		 * 增加公共标签：保险公司交易日期、时间、流水号
		 */
		Element mK_TrList = mRootEle.getChild(K_TRLIST);
		if(null == mK_TrList){
			mK_TrList = new Element(K_TRLIST);
			mRootEle.addContent(2, mK_TrList);
		}
		Element mKR_EntTrDate = new Element("KR_EntTrDate");
		mKR_EntTrDate.setText(DateUtil.getCurDate("yyyyMMdd"));
		
		Element mKR_EntTrTime = new Element("KR_EntTrTime");
		mKR_EntTrTime.setText(String.valueOf(DateUtil.getCur6Time()));
		
		Element mKR_EntSeq = new Element("KR_EntSeq");
		mKR_EntSeq.setText(Thread.currentThread().getName());
		
		mK_TrList.addContent(mKR_EntTrDate);	// 保险公司交易日期
		mK_TrList.addContent(mKR_EntTrTime);	// 保险公司交易时间
		mK_TrList.addContent(mKR_EntSeq);	// 保险公司交易流水号

		/* End-组织返回报文头 */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// 打印报文内容

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, ENCODING);
		// 报文长度
		String mLenStr = String.valueOf(mBodyBytes.length);
		mLenStr = NumberUtil.fillStrWith0(mLenStr, PACKAGE_LEN, true);	//左补0
		cLogger.info("返回报文长度：" + mLenStr);
		/*
		 * 加密标志（1字节）+ 交易标识（10字节）+ 交易码（5字节）+ 报文长（8字节）
		 * 0-不加密,1-加密
		 */
		String mHeadBytes = 0 + BANK_FLAG + bankOutCode + mLenStr;
		
		cSocket.getOutputStream().write(mHeadBytes.getBytes(ENCODING)); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();

		cLogger.info("Out BcommNetImpl.send()!");
	}
}
