package com.sinosoft.midplat.citicHZ.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.citicHZ.util.CiticHZKeyUtil;
import com.sinosoft.midplat.citicHZ.util.SecMsg;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

/**
 * @Title: com.sinosoft.midplat.citicHZ.net.CiticHZNetImpl.java
 * @Description: 
 * Copyright: Copyright (c) 2016
 * Company:安邦保险IT部 
 *
 */
public class CiticHZNetImpl extends SocketNetImpl {

	private Element cTransaction_HeaderEle;
	
//	private SecMsg secMsgB1 = null;
	
	private SecMsg secMsgB1 = null;

	public CiticHZNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}

	public Document receive() throws Exception {
		cLogger.info("Into CiticHZNetImpl.receive()...");
		
		// 处理报文头
		byte[] mHeadBytes = new byte[6];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLen = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLen);
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		//获取验签标签内容,此次根据银行提供的验证方式进行验证
		//使用银行方提供的加解密签名工具解析请求报文获取报文信息		
		secMsgB1 = new SecMsg();
		secMsgB1.setSecMsgChper(mBodyBytes);
		
		String cerpath = SysInfo.cHome+"key/citichzkey/";
		boolean result = CiticHZKeyUtil.clearSignForReceive(secMsgB1,cerpath+"CNCB.cer", cerpath+"ServerA.cer", cerpath+"ServerA.key", cerpath+"ServerA.pwd");
		if (!result){
			throw new MidplatException("验证请求报文明文和签名有误！");
		}
		byte[] msgRecv = secMsgB1.getSecMsgClear();
		
		System.out.println("==1==== msgRecv(长度:" + msgRecv.length + ")=[" + new String(msgRecv,"GBK") + "]");

		//明文报文内容报文体
		Document mXmlDoc = JdomUtil.build(msgRecv);	
		Element mRootEle = mXmlDoc.getRootElement();

		//保存报文头，由于返回中信
		cTransaction_HeaderEle = (Element) mRootEle.getChild("Transaction_Header").clone();

		//解析交易码
		//获取中信银行发起渠道代码
		String saleChannel = cTransaction_HeaderEle.getChildText("BkChnlNo");
		cFuncFlag = cTransaction_HeaderEle.getChildText("BkTxCode");
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cFuncFlag + "' and @saleChannel='"+saleChannel+"']");
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

		cLogger.info("Out CiticHZNetImpl.receive()!");
		return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CiticHZNetImpl.send()...");

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

		if(cTransaction_HeaderEle != null){
			cTransaction_HeaderEle.addContent(mTran_ResponseEle);
			mRootEle.addContent(0, cTransaction_HeaderEle);
		}else{
			Element mTran_Header = new Element("Transaction_Header");
			mTran_Header.addContent(mTran_ResponseEle);
			mRootEle.addContent(0, mTran_Header);
		}		
		/* End-组织返回报文头 */

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
		JdomUtil.print(pOutNoStd);	// 打印报文内容

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		String resStr = new String(mBodyBytes,"GBK").replaceAll("\r\n","");
		resStr = resStr.replaceAll("<PbInsuExp />","<PbInsuExp></PbInsuExp>");
		resStr = resStr.replaceAll("<Pbmaxamt />","<Pbmaxamt></Pbmaxamt>");
		mBodyBytes = resStr.getBytes("GBK");
        System.out.println("mBodyBytes====222====="+new String(mBodyBytes));
		byte[] mHeadBytes = new byte[6];
		//增加验签内容，根据银行提供的方法进行签名
		String cerpath = SysInfo.cHome+"key/citichzkey/";
		byte[] msgSend2 = CiticHZKeyUtil.sendsignEncyptRe(mBodyBytes, cerpath+"ServerA.pwd", cerpath+"ServerA.key", cerpath+"ServerA.cer", cerpath+"CNCB.cer",
				secMsgB1.getSessionKey());
		// 报文体长度
		String mLengthStr = String.valueOf(msgSend2.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 6, true);//左补0
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		cSocket.getOutputStream().write(mHeadBytes); // 发送报文头
		cSocket.getOutputStream().write(msgSend2); // 发送报文体
		cSocket.shutdownOutput();

		cLogger.info("Out CiticHZNetImpl.send()!");
	}
	
}
