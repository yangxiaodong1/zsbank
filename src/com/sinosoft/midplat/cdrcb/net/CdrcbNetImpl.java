package com.sinosoft.midplat.cdrcb.net;

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

public class CdrcbNetImpl extends SocketNetImpl {
	private String cOutFuncFlag = null;
	private String cInsuID = null;
	private Element mMAINEle = null;
	private Element mTransHeaderEle = null;
	
	public CdrcbNetImpl(Socket pSocket, Element pThisConfRoot) throws MidplatException {
		super(pSocket, pThisConfRoot);
	}
	
	public Document receive() throws Exception {
		cLogger.info("Into CdrcbNetImpl.receive()...");
		
		//处理报文头
		byte[] mHeadBytes = new byte[16];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLength = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLength);
		cOutFuncFlag = new String(mHeadBytes, 6, 4).trim();
		cLogger.info("交易代码：" + cOutFuncFlag);
		cInsuID = new String(mHeadBytes, 10, 6).trim();
		//处理报文体
		byte[] mBodyBytes = new byte[mBodyLength];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();
		
		System.out.println("接收到的原始报文======");
		System.out.println(new String (mBodyBytes));
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();
		
		JdomUtil.print(mXmlDoc);
		
		Element mMAIN = mRootEle.getChild("MAIN");
		if(mMAIN != null){
			mMAINEle = (Element) mMAIN.clone();
		}
		
		Element mTransHeaderEle1= mRootEle.getChild("TransHeader");
		if(mTransHeaderEle1 != null){
			mTransHeaderEle = (Element) mTransHeaderEle1.clone();
		}
		
		
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
		
		cLogger.info("Out CdrcbNetImpl.receive()!");
		return mXmlDoc;
	}
	
	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CdrcbNetImpl.send()...");
		Element mRootEle = pOutNoStd.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).detach();
		/* Start-组织返回报文头 */
		if(mMAINEle != null){			
			Element mMAIN = mRootEle.getChild("MAIN");
			if (mMAIN == null) {
				mMAIN = new Element("MAIN");
				mRootEle.addContent(mMAIN);
			}
			Element mRESULTCODE = new Element("RESULTCODE");
			int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
			if (CodeDef.RCode_ERROR == mFlagInt) {
				
				mRESULTCODE.setText("1111");
				
				if (!mRootEle.getName().equals("INSUREQRET")) {	// 交易抛出异常--银保通
					mRootEle.setName("INSUREQRET");
				}
				Element corp_depnoEle = pOutNoStd.getRootElement().getChild("MAIN").getChild("CORP_DEPNO");
				if(null == corp_depnoEle){
					corp_depnoEle = new Element("CORP_DEPNO");
					pOutNoStd.getRootElement().getChild("MAIN").addContent(corp_depnoEle);
				}
				
				Element corp_agentnoEle = pOutNoStd.getRootElement().getChild("MAIN").getChild("CORP_AGENTNO");
				if(null == corp_agentnoEle){
					corp_agentnoEle = new Element("CORP_AGENTNO");
					pOutNoStd.getRootElement().getChild("MAIN").addContent(corp_agentnoEle);
				}
				
				Element transrno_oriEle = pOutNoStd.getRootElement().getChild("MAIN").getChild("TRANSRNO_ORI");
				if(null == transrno_oriEle){
					transrno_oriEle = new Element("TRANSRNO_ORI");
					transrno_oriEle.setText(Thread.currentThread().getName());
					pOutNoStd.getRootElement().getChild("MAIN").addContent(transrno_oriEle);
				}
			} else {
				mRESULTCODE.setText("0000");
				if("0001".equals(cOutFuncFlag)){
					pOutNoStd.getRootElement().getChild("MAIN").getChild("TRANSRNO_ORI").setText(Thread.currentThread().getName());
				}			
			}
			Element mMSGDESC = new Element("MSGDESC");
			mMSGDESC.setText(mHeadEle.getChildText(Desc));

			mMAIN.addContent((Element) mMAINEle.getChild("TRANSRDATE").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("TRANSRTIME").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("TRANSRNO").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("TRANSRID").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("BANK_CODE").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("BRACH_NO").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("TELLER_NO").clone());
			mMAIN.addContent((Element) mMAINEle.getChild("INSUID").clone());
			mMAIN.addContent(mRESULTCODE);
			mMAIN.addContent(mMSGDESC);
		}else if(mTransHeaderEle != null){
			//PBKINSR-1097 成都农商行直销银行保单质押功能
			if("0008".equals(cOutFuncFlag)){
				//0008-保单估值查询，该交易与其他交易报文结构不一致，需要特殊处理
//				JdomUtil.print(pOutNoStd);
				
				Element mTransHeaderEle_back = new Element("TransHeader");
				Element mRespCodeEle = new Element("CResult");
				int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
				if (CodeDef.RCode_ERROR == mFlagInt) {
					mRespCodeEle.setText("001");
				}else {
					mRespCodeEle.setText("000");
				}
				mTransHeaderEle_back.addContent(mRespCodeEle);
				
				Element descEle = new Element("CDesc");
				descEle.setText(mHeadEle.getChildText(Desc));
				mTransHeaderEle_back.addContent(descEle);
					
				mRootEle.addContent(0,mTransHeaderEle_back);
				
				mRootEle.removeChild(Head);
			}else {
//				mRootEle.addContent(mTransHeaderEle);
				Element mTransHeaderEle_back = new Element("TransHeader");
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("TransCode").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("TransDate").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("TransTime").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("XDSerialNo").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("BranchId").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("OperatorId").clone());
				mTransHeaderEle_back.addContent((Element) mTransHeaderEle.getChild("BusiSerialNo").clone());
				mRootEle.addContent(0,mTransHeaderEle_back);
				
				Element mTransBodyEle = mRootEle.getChild("TransBody");
				Element mResponseEle = null;
				if (mTransBodyEle == null) {
					mTransBodyEle = new Element("TransBody");
					mRootEle.addContent(mTransBodyEle);					
					mResponseEle = new Element("Response");
					mTransBodyEle.addContent(mResponseEle);
				}
				else {
					mResponseEle = mTransBodyEle.getChild("Response");
				}
				
				Element mRespCodeEle = new Element("RespCode");
				int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));
				if (CodeDef.RCode_ERROR == mFlagInt) {
					mRespCodeEle.setText("001");
				}else {
					mRespCodeEle.setText("000");
				}
				mResponseEle.addContent(0,mRespCodeEle);
				
				Element mRespMessageEle = new Element("RespMessage");
				mRespMessageEle.setText(mHeadEle.getChild(Desc).getText());
				mResponseEle.addContent(1,mRespMessageEle);
				
				mRootEle.removeChild(Head);
			}
					
			
			//PBKINSR-1097 成都农商行直销银行保单质押功能
		}
		/* End-组织返回报文头 */
		
		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
			.append('_').append(NoFactory.nextAppNo())
			.append('_').append(cFuncFlag)
			.append("_out.xml");
		SaveMessage.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！"+mSaveName);
		
		byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		
		byte[] mHeadBytes = new byte[16];
		//报文体长度		
		String mLengthStr = String.valueOf(NumberUtil.fillWith0(mBodyBytes.length, 6));
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);
		//交易代码
		byte[] mFuncFlagBytes = cOutFuncFlag.getBytes();
		System.arraycopy(mFuncFlagBytes, 0, mHeadBytes, 6, mFuncFlagBytes.length);
		//公司代码
		byte[] mInsuIDBytes = cInsuID.getBytes();
		System.arraycopy(mInsuIDBytes, 0, mHeadBytes, 10, mInsuIDBytes.length);
		
		cSocket.getOutputStream().write(mHeadBytes);	//发送报文头
		cSocket.getOutputStream().write(mBodyBytes);	//发送报文体
		cSocket.shutdownOutput();
		
		cLogger.info("Out CdrcbNetImpl.send()!");
	}
}