package com.sinosoft.midplat.jxnxs.net;

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

public class JxnxsNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private String cOutFlag = null;
	private String reFlag = null;
	
	public JxnxsNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into JxnxsNetImpl.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		//保险公司代码4位
		cInsuID = new String(mHeadBytes, 0, 4).trim();
		//发送/接收标志1位（1请求2响应）
		reFlag = new  String(mHeadBytes, 4, 1).trim();
		//交易码3位
		cOutFuncFlag = new  String(mHeadBytes, 5, 3).trim();
		cLogger.info("交易代码：" + reFlag + cOutFuncFlag);
		//报文长度，报文体长；采用右对齐、左补“0”的方式填充。
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());		
		cLogger.debug("请求报文长度：" + mBodyLength);
		
		
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		//江西农商行采用"GB2312"编码
		Document mXmlDoc = JdomUtil.build(mBodyBytes,"GB2312");
		Element mRootEle = mXmlDoc.getRootElement();
		
		
		//解析交易码
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + reFlag + cOutFuncFlag + "']");
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
		
		cLogger.info("Out JxnxsNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into JxnxsNetImpl.send()...");
		
		/* 如果银保通系统异常  */
		
		try{
			cOutFlag = pOutNoStd.getRootElement().getChild("MAIN").getChildText("OKFLAG");
		}catch(Exception exp){
			/*
			 * 返回的pOutNoStd报文为核心系统的标准报文，
			 * 因银保通系统校验错误抛出异常后，平台错误处理机制将异常信息封装为核心的标准报文格式，
			 * 所以在此需将标准报文转化为银行的非标准报文格式，便于银行端解释报文展示信息。
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// 标准报文中，返回标识Flag=1为失败，银行1 成功，0 失败
				cOutFlag = "1111";
				
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("1111");
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setName("RESULTCODE");
				pOutNoStd.getRootElement().getChild(Head).getChild(Desc).setName("ERR_INFO");
				pOutNoStd.getRootElement().getChild(Head).setName("MAIN");
				if("021".equals(cOutFuncFlag)){//核保
					pOutNoStd.getRootElement().setName("INSUREQRET");
				}else if ("022".equals(cOutFuncFlag)){//缴费
					pOutNoStd.getRootElement().setName("RETURN");
				}else if("002".equals(cOutFuncFlag)){//当日撤单
					pOutNoStd.getRootElement().setName("FEETRANSCANCRET");
				}
				
			}
		}
		
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		//江西农商行采用“GB2312”
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd,"GB2312");
		
		byte[] mHeadBytes = new byte[16];
		
		//公司代码
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, 4);
		//发送/接收标志
		reFlag = "2";
		byte[] mReFlagBytes = reFlag.getBytes();
		System.arraycopy(mReFlagBytes, 0, mHeadBytes, 4, 1);
		//交易码3位
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 5, mFuncFlagBytes.length);
		
		//报文体长度
		String mLengthStr = NumberUtil.fillWith0(mBodyBytes.length, 8);//采用右对齐、左补“0”的方式填充
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out JxnxsNetImpl.send()!");
	}
	

}