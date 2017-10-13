package com.sinosoft.midplat.jsbc.net;

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

public class JsbcNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;

	public JsbcNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	private Element tTRANSRNOEle = null;
	public Document receive() throws Exception {
		cLogger.info("Into JsbcNetImpl.receive()...");

		// 处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		
		cLogger.info("报文头：" + new String(mHeadBytes, 0, 16).trim());
		cOutFuncFlag = new String(mHeadBytes, 4, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim());
		cLogger.info("请求报文长度：" + mBodyLength);

		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];

		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
        Document mXmlDoc = JdomUtil.build(mBodyBytes);
        Element mRootEle = mXmlDoc.getRootElement();
        
        //保存请求报文
        XPath mXPath = XPath.newInstance(
                "business/funcFlag[@outcode='" + cOutFuncFlag + "']");
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
        
        tTRANSRNOEle = (Element) XPath.newInstance("//MAIN/TRANSRNO").selectSingleNode(mRootEle);
        
        cLogger.info("Out JsbcNetImpl.receive()!");
        return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into JsbcNetImpl.send()...");
		/* Start-组织返回报文头 */
		Element mRootEle = pOutNoStd.getRootElement();
		

		//获取、设置返回码：处理结果（返回码）：	1 成功，0 失败 
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		Element mResultCode = new Element("RESULTCODE");
		int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
		if (CodeDef.RCode_OK == mFlagInt) {
			mResultCode.setText("1");
		}else {
			mResultCode.setText("0");
		}
		Element mResultInfoDesc = new Element("ERR_INFO");
		mResultInfoDesc.setText(mHeadEle.getChildText(Desc));

		//返回报文是否包含main节点
//		String hasMain = XPath.newInstance(
//                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/mainElement").valueOf(cThisConfRoot);
		//获取main节点
		Element mMainEle = mRootEle.getChild("MAIN");
		if (mRootEle.getChild("MAIN") == null ) {
		    // 当系统发生异常时，该节点为空。
		    mMainEle = new Element("MAIN");
		    mRootEle.addContent(mMainEle);
		    
		}
		mMainEle.addContent(mResultCode);
	    mMainEle.addContent(mResultInfoDesc);
	   //增加银行流水号字段
	    Element mTRANSRNO = new Element("TRANSRNO");
	    mTRANSRNO.setText(tTRANSRNOEle.getText());
	    mMainEle.addContent(mTRANSRNO);
		
	    // 设置返回报文root节点tag
        XPath mXPath = XPath.newInstance(
                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/reRootTab");
        String reRootTab = mXPath.valueOf(cThisConfRoot);
        mRootEle.setName(reRootTab);
        
        StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
            .append('_').append(NoFactory.nextAppNo())
            .append('_').append(cFuncFlag)
            .append("_out.xml");
        SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
        cLogger.info("保存报文完毕！"+mSaveName);

		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);

		
		
		byte[] mHeadBytes = new byte[16];
		//包头
		byte[] mInsuIDBytes = "INSU".getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);
		
		// 获取返回交易码
        mXPath = XPath.newInstance(
                "business[funcFlag[@outcode='" + cOutFuncFlag + "']]/reFuncFlag");
        String reFuncFlag = mXPath.valueOf(cThisConfRoot);
		byte[] mSdRvFlagBytes = reFuncFlag.getBytes();
		System.arraycopy(mSdRvFlagBytes, 0, mHeadBytes, 4, mSdRvFlagBytes.length);
		
		//包长度
		String mLengthStr = String.valueOf(NumberUtil.fillStrWith0(String.valueOf(mBodyBytes.length), 8));
		cLogger.info("返回包长度：" + mLengthStr);
		cLogger.info("返回交易码：" + new String(mSdRvFlagBytes));
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();

		cLogger.info("Out JsbcNetImpl.send()!");
	}
}
