package com.sinosoft.midplat.citic.net;

import java.net.Socket;

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
 * @Title: com.sinosoft.midplat.citic.net.CiticNetImpl.java
 * @Description: 
 * Copyright: Copyright (c) 2013 
 * Company:安邦保险IT部
 * 
 * @date Aug 19, 2013 8:19:53 PM
 * @version 
 *
 */
public class CiticNetImpl extends SocketNetImpl {

	private Element cTransaction_HeaderEle;

	public CiticNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into CiticNetImpl.receive()...");

		// 处理报文头
		byte[] mHeadBytes = new byte[6];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLen = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLen);
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();

		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		
		
		Element mRootEle = mXmlDoc.getRootElement();

		//保存报文头，由于返回中信
		cTransaction_HeaderEle = (Element) mRootEle.getChild(
				"Transaction_Header").clone();

		//解析交易码
		
		//add 20150925 PBKINSR-878  中信银行手机银行项目（盛2、长寿稳赢） begin
		//获取中信银行发起渠道代码
		String saleChannel = cTransaction_HeaderEle.getChildText("BkChnlNo");
		cFuncFlag = cTransaction_HeaderEle.getChildText("BkTxCode");
		String cOutFuncFlag = cFuncFlag;
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "' and @saleChannel='"+saleChannel+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		if(cFuncFlag != null && !"".equals(cFuncFlag.trim())){
			
		}else{
			cFuncFlag = cOutFuncFlag;
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		/**注释掉原来的获取方式
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='"+ cTransaction_HeaderEle.getChildText("BkTxCode") + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		**/
		//add 20150925 PBKINSR-878  中信银行手机银行项目（盛2、长寿稳赢） end
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

		cLogger.info("Out CiticNetImpl.receive()!");
		return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CiticNetImpl.send()...");

		/* Start-组织返回报文头 */
		Element mRootEle = pOutNoStd.getRootElement();
		mRootEle.setName("Transaction");

		Element mBkOthDateEle = new Element("BkOthDate");
		mBkOthDateEle.setText(DateUtil.getCurDate("yyyyMMdd"));
		Element mBkOthSeqEle = new Element("BkOthSeq");
		mBkOthSeqEle.setText(Thread.currentThread().getName());

		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mBkOthRetCodeEle = new Element("BkOthRetCode");
		if (CodeDef.RCode_OK == Integer.parseInt(mHeadEle.getChildText(Flag))) {
			mBkOthRetCodeEle.setText("00000");
		} else {
			mBkOthRetCodeEle.setText("11111");
		}
		Element mBkOthRetMsgEle = new Element("BkOthRetMsg");
		mBkOthRetMsgEle.setText(mHeadEle.getChildText(Desc));

		Element mTran_ResponseEle = new Element("Tran_Response");
		mTran_ResponseEle.addContent(mBkOthDateEle);
		mTran_ResponseEle.addContent(mBkOthSeqEle);
		mTran_ResponseEle.addContent(mBkOthRetCodeEle);
		mTran_ResponseEle.addContent(mBkOthRetMsgEle);

		cTransaction_HeaderEle.addContent(mTran_ResponseEle);
		mRootEle.addContent(0, cTransaction_HeaderEle);
		/* End-组织返回报文头 */

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// 打印报文内容

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);

		byte[] mHeadBytes = new byte[6];
		// 报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 6, true);//左补0
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();

		cLogger.info("Out CiticNetImpl.send()!");
	}
	
}
