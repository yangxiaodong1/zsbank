package com.sinosoft.midplat.abc.net;

import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class AbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	
	public AbcNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into AbcNetImpl.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
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
		
		cLogger.info("Out AbcNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into AbcNetImpl.send()...");
		/*Start-组织返回报文头*/
		//添加流水号	
		String cFlag = "";
		// MODIFY 2013-09-34 PBKINSR-167_寿险农行银保通上线新产品	----BEGIN----
		try{
			
			// 返回的报文pOutNoStd为银行的非标准报文
			cFlag = pOutNoStd.getRootElement().getChild("RetData").getChildText("Flag");
			System.out.println("cFlag"+cFlag);
			System.out.println("cOutFuncFlag"+cOutFuncFlag);
			if(cFlag.equals("1")&&cOutFuncFlag.equals("01")){//1 代表成功     01代表试算交易
				pOutNoStd.getRootElement().getChild("Base").getChild("ReqsrNo").setText(Thread.currentThread().getName());
			}
			/* End-组织返回报文头 */
		}catch(Exception exp){

			/*
			 * 返回的pOutNoStd报文为核心系统的标准报文，
			 * 因银保通系统校验错误抛出异常后，平台错误处理机制将异常信息封装为核心的标准报文格式，
			 * 所以在此需将标准报文转化为银行的非标准报文格式，便于银行端解释报文展示信息。
			 */
			if (pOutNoStd.getRootElement().getChild(Head) != null
					&& pOutNoStd.getRootElement().getChild(Head).getChild(Flag).getText().equals("1")) {
				// 标准报文中，返回标识Flag=1为失败

				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild("Head").getChild("Desc").setName("Mesg");
				pOutNoStd.getRootElement().setName("Ret");
				pOutNoStd.getRootElement().getChild(Head).setName("RetData");
			}
		}		
		// MODIFY 2013-09-34 PBKINSR-167_寿险农行银保通上线新产品	-----END-----
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		byte[] mHeadBytes = new byte[6];
		//报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out AbcNetImpl.send()!");
	}
	
}

