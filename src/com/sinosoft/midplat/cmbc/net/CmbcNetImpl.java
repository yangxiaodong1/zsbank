package com.sinosoft.midplat.cmbc.net;

import java.io.UnsupportedEncodingException;
import java.net.Socket;

import org.apache.commons.lang.StringUtils;
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

public class CmbcNetImpl extends SocketNetImpl{

	// 银行固定标识
	private static final String BANK_FLAG = "INSU";
	// 银行交易代码
	private String cOutFuncFlag = null;
	
	// 编码集
	private static final String GBK_ENCODING = "GBK";
	
	private Element cTRANSRDATEEle = null;	// 交易日期
	private Element cTRANSRTIMEEle = null;	// 交易时间
	private Element cBANK_CODEEle = null;	// 银行代码
	private Element cTRANSRNOEle = null;	// 交易流水号
	
	public CmbcNetImpl(Socket socket, Element thisConfRoot) throws MidplatException {
		super(socket, thisConfRoot);
	}
	
	/* 
	 * 接收银行的请求报文，提取请求报文转换为Document，并保存与本地
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#receive()
	 */
	public Document receive() throws Exception {
		
		cLogger.info("Into CmbcNetImpl.receive()...");
		
		/*
		 * 处理报文投保长度：21
		 * 包头：标识码(INSU _4位)+交易码(9位)+报文体的长度(8位，不足时8位时在前面补零)
		 * 
		 * 包头：长度=4,固定为“INSU”。
		 */
		
		// 处理包头
		byte[] mHeadBytes = new byte[21];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// 民生银行报文编码：GBK
		cOutFuncFlag =  xmlHead.substring(4, 13);
		int mBodyLen = Integer.parseInt(xmlHead.substring(13).trim()); // 报文长度不包含包头长度
		cLogger.debug("请求报文长度[" + mBodyLen + "]--银行交易码[" + cOutFuncFlag + "]");
		
		
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		//解析交易码
		/*XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);*/
		
		//映射交易码,网银渠道优先
		String tCHNL_CODE = XPath.newInstance("//MAIN/CHNL_CODE").valueOf(mRootEle);
		
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @CHNL_CODE='"+tCHNL_CODE+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if("".equals(cFuncFlag)){	// 如果没有匹配到网银的就默认为是银保通柜面
		    //映射柜面发起的交易
		     mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
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
		
		/*
		 * 取出银行报文中的部分节点，用于返回报文时使用
		 */
		Element cTempEle = null;
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRDATE");
		cTRANSRDATEEle = (Element)cTempEle.clone();
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRTIME");
		cTRANSRTIMEEle = (Element)cTempEle.clone();
		
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/BANK_CODE");
		if(cTempEle != null){
			cBANK_CODEEle = (Element)cTempEle.clone();
		}
			
		cTempEle = (Element)XPath.selectSingleNode(mRootEle, "//MAIN/TRANSRNO");
		cTRANSRNOEle = (Element)cTempEle.clone();

		cLogger.info("out CmbcNetImpl.receive()...");
		return mXmlDoc;
	}
	
	
	/* 
	 * 将给银行的非标准报文保存于本地，并封装为可以发送给银行端格式的报文
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.net.SocketNetImpl#send(org.jdom.Document)
	 */
	public void send(Document pOutNoStd) throws Exception {
		
		cLogger.info("Into CmbcNetImpl.send()...");
		
		/* Start-组织返回报文头 */
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		
		Element mOKFLAGEle = new Element("RESULTCODE");	// 0=失败,1=成功
		Element mFAILDETAILEle = new Element("ERR_INFO");
		
		if (CodeDef.RCode_OK == mFlagInt) {	// 交易成功

			mOKFLAGEle.setText("1");
			
			mRootEle.getChild("MAIN").addContent(cTRANSRDATEEle.detach());	// 交易日期
			mRootEle.getChild("MAIN").addContent(cTRANSRTIMEEle.detach());	// 交易时间
			if(cBANK_CODEEle != null){
				mRootEle.getChild("MAIN").addContent(cBANK_CODEEle.detach());	// 银行代码
			}
			mRootEle.getChild("MAIN").addContent(cTRANSRNOEle.detach());	// 交易流水号
			
		} else {	// 交易失败
			mOKFLAGEle.setText("0");
			
			if (mRootEle.getChild("MAIN") == null) {	// 交易抛出异常--银保通
				
				/*
				 * 保单试算、签单、重打的返回根标签名字是相同的。当日侧单返回报文跟标签名称与其他交易不同，需要注意
				 */
				if(cFuncFlag.equals("3002")){	// 当日侧单交易。
					mRootEle.setName("FEETRANSCANCRET");
				}else{
					mRootEle.setName("RETURN");
				}
					
				Element mMAINEle = new Element("MAIN");
				mRootEle.addContent(mMAINEle);			
			}
		}
		mFAILDETAILEle.setText(mHeadEle.getChildText(Desc));
		mRootEle.getChild("MAIN").addContent(mFAILDETAILEle);
		mRootEle.getChild("MAIN").addContent(mOKFLAGEle);
		//当交易为网银和手机银行的犹退交易时，返回失败需要返回如下信息字段
		if(cFuncFlag.equals("3009")||cFuncFlag.equals("3010")||cFuncFlag.equals("3011")||cFuncFlag.equals("3012")){
			mRootEle.getChild("MAIN").addContent(cTRANSRDATEEle.detach());	// 交易日期
			mRootEle.getChild("MAIN").addContent(cTRANSRTIMEEle.detach());	// 交易时间
			mRootEle.getChild("MAIN").addContent(cTRANSRNOEle.detach());	// 交易流水号
		}
		
		/* End-组织返回报文头 */
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);
		
//		JdomUtil.print(pOutNoStd);	// 打印报文内容
		
		//银行是按行解析，这里格式化下输出报文
		String xmlOutStr = JdomUtil.toStringFmt(pOutNoStd,GBK_ENCODING);
		xmlOutStr = transHtmlCharacter(xmlOutStr);
		
//		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd, GBK_ENCODING);
		
		// 报文长度
		byte[] mBodyBytes = xmlOutStr.getBytes(GBK_ENCODING);
		int cLenInt = mBodyBytes.length;
		cLogger.info("返回报文长度：" + cLenInt);
		String mLenStr = NumberUtil.fillWith0(cLenInt, 8);	//左补0
		
		
		/*
		 * 处理报文投保长度：21
		 * 包头：标识码(INSU _4位)+交易码(9位)+报文体的长度(8位，不足时8位时在前面补零)
		 * 
		 * 包头：长度=4,固定为“INSU”。
		 */
		String mHeadBytes = BANK_FLAG + cOutFuncFlag + mLenStr;
		cSocket.getOutputStream().write(mHeadBytes.getBytes(GBK_ENCODING)); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out CmbcNetImpl.send()!");
	}
	
	
	/**
	 * 将html字符转为对应符号
	 * 
	 * @param str
	 * @return
	 */
	private   String transHtmlCharacter(String str) {
		if (StringUtils.isBlank(str)){
			return "";
		}
		
		str = str.replaceAll("&gt;", ">");
		str = str.replaceAll("&lt;", "<");
		str = str.replaceAll("&amp;", "&");
		str = str.replaceAll("&apos;", "'");

		return str;
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException{
		
		String str = "INSURQ000T00150004064";
		byte[] mHeadBytes = new byte[21];
		mHeadBytes = str.getBytes();
		String xmlHead = new String(mHeadBytes, GBK_ENCODING);	// 民生银行报文编码：GBK
		String cOutFuncFlag =  xmlHead.substring(4, 13);
		int mBodyLen = Integer.parseInt(xmlHead.substring(13).trim());
		
		System.out.println("请求报文长度[" + mBodyLen + "]--银行交易码[" + cOutFuncFlag + "]");
		
	}

}
