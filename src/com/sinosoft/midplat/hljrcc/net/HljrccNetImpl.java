package com.sinosoft.midplat.hljrcc.net;

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

public class HljrccNetImpl extends SocketNetImpl {
	
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	
	public HljrccNetImpl(Socket socket, Element thisConfRoot)
			throws MidplatException {
		super(socket, thisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into HljrccNetImpl.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[20];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 6, 10).trim());
		cLogger.debug("请求报文长度：" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 16, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		cInsuID = new String(mHeadBytes, 0, 6).trim();
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
		//去除报文中的字段，以配置为准
		Element mHeadEle = mRootEle.getChild(Head);
		mHeadEle.getChild(FuncFlag).setText(cFuncFlag);
		mHeadEle.removeChild(TranCom);
		mHeadEle.addContent(cTranComEle);
		
		//生成标准报文头
		Element mClientIpEle = new Element(ClientIp);
		mClientIpEle.setText(cClientIp);
		mHeadEle.addContent(mClientIpEle);
		
		
		cLogger.info("Out HljrccNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into HljrccNetImpl.send()...");		
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		
		byte[] mHeadBytes = new byte[20];
		//公司代码
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);

		//交易代码
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 16, mFuncFlagBytes.length);

		//报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		mLengthStr = NumberUtil.fillStrWith0(mLengthStr, 10, true);//友对齐，左补0，10位
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 6, mLengthBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out HljrccNetImpl.send()!");
	}
}
