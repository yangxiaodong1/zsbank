package com.sinosoft.midplat.cib.net;

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

public class CibNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private String cOutFlag = null;
	private String reFlag = null;
	
	public CibNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into CibNetImp.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		//保险公司代码4位
		cInsuID = new String(mHeadBytes, 0, 4).trim();
		//发送/接收标志2位
		reFlag = new  String(mHeadBytes, 4, 2).trim();
		//交易码2位
		cOutFuncFlag = new  String(mHeadBytes, 6, 2).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		//报文长度，包长 = 16 + 报文体长；采用左对齐，右补空格(英文空格)方式填充。
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim())-16;		
		cLogger.debug("请求报文长度：" + mBodyLength);
		
		
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		/**
		 * 由于兴业银行接口试算和确认交易中渠道代码字段标签不一致，需要分别处理
		 */
		//获取渠道代码
		String tCHNL_CODE = XPath.newInstance("//MAIN/CHANNEL").valueOf(mRootEle);
		//解析交易码
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @channel='"+tCHNL_CODE+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		if("".equals(cFuncFlag)){
			tCHNL_CODE = XPath.newInstance("//MAIN/TEMP").valueOf(mRootEle);	
			mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @channel='"+tCHNL_CODE+"']");
			cFuncFlag = mXPath.valueOf(cThisConfRoot);			
		}
		if("".equals(cFuncFlag)){//如果没有匹配到自组终端的就默认为是银保通柜面
		    //映射柜面发起的交易
		    mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
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
		
		cLogger.info("Out CibNetImp.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CibNetImp.send()...");
		
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
				cOutFlag = "0";
				
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setText("0");
				pOutNoStd.getRootElement().getChild(Head).getChild(Flag).setName("OKFLAG");
				
				/*
				 * 交易失败时，标签有两种：FAILDETAIL（保单重打），REJECTNO（试算，签单，当日侧单）
				 */
				pOutNoStd.getRootElement().getChild(Head).getChild(Desc).setName("FAILDETAIL");
				Element tREJECTNOEle = new Element("REJECTNO");
				tREJECTNOEle.setText(pOutNoStd.getRootElement().getChild(Head).getChildText("FAILDETAIL"));
				pOutNoStd.getRootElement().getChild(Head).addContent(tREJECTNOEle);
				
				pOutNoStd.getRootElement().getChild(Head).setName("MAIN");
			}
		}
		
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		byte[] mHeadBytes = new byte[16];
		
		//公司代码
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, 4);
		//发送/接收标志
		reFlag = "20";
		byte[] mReFlagBytes = reFlag.getBytes();
		System.arraycopy(mReFlagBytes, 0, mHeadBytes, 4, 2);
		//交易码2位
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6, mFuncFlagBytes.length);
		
		//报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length + 16);
		mLengthStr = NumberUtil.fillStrWith_(mLengthStr, 8, false);//左对齐，右补空格，8位
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out CibNetImp.send()!");
	}
	

}