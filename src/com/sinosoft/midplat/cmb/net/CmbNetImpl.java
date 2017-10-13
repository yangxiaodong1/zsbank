package com.sinosoft.midplat.cmb.net;

import java.net.Socket;
import java.net.SocketException;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class CmbNetImpl extends SocketNetImpl {
    private String cOutFuncFlag = null;
    private String cFuncFlag = null;
    private String cTransRefGUID = null;
    private String cCarrierCode = null;
    private String cBankCode = null;
    private String cRegionCode = null;
    private String cBranchCode = null;
    private String cTellerCode = null;
    private String cOriginalTransRefGUID = null;
    
    public CmbNetImpl(Socket pSocket, Element pThisConfRoot)
            throws MidplatException {
        super(pSocket, pThisConfRoot);
    }

    public Document receive() throws Exception {
        cLogger.info("Into CmbNetImpl.receive()...");

        // 读取报文头
        byte[] mHeadBytes = new byte[16];
        IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
        //包长 = 16 + 报文长
        int mBodyLength = Integer.parseInt(new String(mHeadBytes, 8, 8).trim()) - 16;
        cLogger.debug("请求报文长度：" + mBodyLength);
        cOutFuncFlag = new String(mHeadBytes, 6, 2).trim();
        cLogger.info("交易代码：" + cOutFuncFlag);
        // 处理报文体
        byte[] mBodyBytes = new byte[mBodyLength];
        IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
        cSocket.shutdownInput();

        Document mXmlDoc = JdomUtil.build(mBodyBytes);
        Element mRootEle = mXmlDoc.getRootElement();
        
		//映射交易码,网银渠道优先
		String TransChannel = XPath.newInstance("//TransChannel").valueOf(mRootEle);
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "' and @transChannel='"+TransChannel+"']");
		cFuncFlag = mXPath.valueOf(cThisConfRoot);
		
		if("".equals(cFuncFlag)){
		    //映射柜面发起的交易
		     mXPath = XPath.newInstance("business/funcFlag[@outcode='" + cOutFuncFlag + "']");
		    cFuncFlag = mXPath.valueOf(cThisConfRoot);
		}
		
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

        //获取招行流水号，在返回报文中使用
        cTransRefGUID = XPath.newInstance("//TXLifeRequest/TransRefGUID").valueOf(
                mRootEle);
        cCarrierCode = XPath.newInstance("//TXLifeRequest/CarrierCode").valueOf(
                mRootEle);
        cBankCode = XPath.newInstance("//TXLifeRequest/BankCode").valueOf(
                mRootEle);
        cRegionCode = XPath.newInstance("//TXLifeRequest/RegionCode").valueOf(
                mRootEle);
        cBranchCode = XPath.newInstance("//TXLifeRequest/BranchCode").valueOf(
                mRootEle);
        cTellerCode = XPath.newInstance("//TXLifeRequest/TellerCode").valueOf(
                mRootEle);
        cOriginalTransRefGUID = XPath.newInstance("//TXLifeRequest/OriginalTransRefGUID").valueOf(
                mRootEle);
        cLogger.info("Out CmbNetImpl.receive()!");
        return mXmlDoc;
    }

    public void send(Document pOutNoStd) throws Exception {
        cLogger.info("Into CmbNetImpl.send()...");

        /* Start-组织返回报文头 */
        Element mRootEle = pOutNoStd.getRootElement();

        //统一转换成功失败标准报文
        Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
        Element mResultCode = new Element("ResultCode");
        int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
        if (CodeDef.RCode_OK == mFlagInt) {
            mResultCode.setText("0000");
        } else {
            mResultCode.setText("1111");
        }

        Element mResultInfoDesc = new Element("ResultInfoDesc");
        mResultInfoDesc.setText(mHeadEle.getChildText(Desc));
        Element mResultInfo = new Element("ResultInfo");
        mResultInfo.addContent(mResultInfoDesc);

        Element mTransResult = new Element("TransResult");
        mTransResult.addContent(mResultCode);
        mTransResult.addContent(mResultInfo);

        if (mRootEle.getChild("TXLifeResponse") == null) {
            // 当系统发生异常时，该节点为空
            Element mTXLifeResponse = new Element("TXLifeResponse");
            mTXLifeResponse.addContent(mTransResult);
            mRootEle.setName("TXLife");
            mRootEle.addContent(mTXLifeResponse);
        } else {
            mRootEle.getChild("TXLifeResponse").addContent(0, mTransResult);
        }
        
        //设置公共报文头
        Element mTransRefGUID = new Element("TransRefGUID");
        mTransRefGUID.setText(this.cTransRefGUID);
        mRootEle.getChild("TXLifeResponse").addContent(0,mTransRefGUID);
        
        Element mTransType = new Element("TransType");
        mTransType.setText(cOutFuncFlag);
        mRootEle.getChild("TXLifeResponse").addContent(1,mTransType);
        
        Element mTransExeDate = new Element("TransExeDate");
        mTransExeDate.setText(DateUtil.getCur8Date()+"");
        mRootEle.getChild("TXLifeResponse").addContent(2,mTransExeDate);
        
        Element mTransExeTime = new Element("TransExeTime");
        mTransExeTime.setText(DateUtil.getCur6Time()+"");
        mRootEle.getChild("TXLifeResponse").addContent(3,mTransExeTime);
        
        Element mCarrierCode = new Element("CarrierCode");
        mCarrierCode.setText(cCarrierCode);
        mRootEle.getChild("TXLifeResponse").addContent(4,mCarrierCode);
        
        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cBankCode);
        mRootEle.getChild("TXLifeResponse").addContent(5,mBankCode);
        
        Element mRegionCode = new Element("RegionCode");
        mRegionCode.setText(cRegionCode);
        mRootEle.getChild("TXLifeResponse").addContent(6,mRegionCode);

        Element mBranchCode = new Element("BranchCode");
        mBranchCode.setText(cBranchCode);
        mRootEle.getChild("TXLifeResponse").addContent(7,mBranchCode);

        Element mTellerCode = new Element("TellerCode");
        mTellerCode.setText(cTellerCode);
        mRootEle.getChild("TXLifeResponse").addContent(8,mTellerCode);
        
        if(cOriginalTransRefGUID != null && !"".equals(cOriginalTransRefGUID)){
            //犹退、当日撤单有原交易流水号节点
            Element mOriginalTransRefGUID = new Element("OriginalTransRefGUID");
            mOriginalTransRefGUID.setText(cOriginalTransRefGUID);
            mRootEle.getChild("TXLifeResponse").addContent(9,mOriginalTransRefGUID);
        }
        /* End-组织返回报文头 */

        StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
                .getName()).append('_').append(NoFactory.nextAppNo()).append(
                '_').append(cFuncFlag).append("_out.xml");
        SaveMessage
                .save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
        cLogger.info("保存报文完毕！" + mSaveName);

        byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);

        byte[] mHeadBytes = new byte[16];
        // 初始化前16位报文头为空格
        for (int i = 0; i < 16; i++) {
            mHeadBytes[i] = ' ';
        }
        // 固定代码
        byte[] mInsuIDBytes = "INSU20".getBytes();
        System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 0, mInsuIDBytes.length);
        // 交易代码
        byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
        System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6,
                mFuncFlagBytes.length);
        // 报文体长度,包长 = 16 + 报文长
        String mLengthStr = String.valueOf(mBodyBytes.length + 16);
        byte[] mLengthBytes = mLengthStr.getBytes();
        cLogger.info("返回报文长度：" + mLengthStr);
        System.arraycopy(mLengthBytes, 0, mHeadBytes, 8, mLengthBytes.length);

        //if ("30".equals(cOutFuncFlag)) {
        //招行冲正交易无需返回
        try {
            cSocket.getOutputStream().write(mHeadBytes); // 发送报文头
            cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
            cSocket.shutdownOutput();
        } catch (SocketException e) {
            cLogger.info("返回招行异常：" + e);
        }
        // }

        cLogger.info("Out CmbNetImpl.send()!");
    }

}