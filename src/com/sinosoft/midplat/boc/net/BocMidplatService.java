package com.sinosoft.midplat.boc.net;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.DOMBuilder;
import org.jdom.output.DOMOutputter;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.WebservStrServ;
import com.sinosoft.midplat.boc.BocConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.exception.MidplatException;

public class BocMidplatService extends WebservStrServ {
	private String cTranCom = null;

	private String cMsgPath = null;

	private Element cFuncFlagEle = null;

	private String cFuncFlag = "";

	public BocMidplatService(XmlConf thisConf) throws MidplatException {
		super(thisConf);
	}

	public BocMidplatService() throws MidplatException {
		super(BocConf.newInstance());
	}

	public org.w3c.dom.Element[] externalService(org.w3c.dom.Element[] pDomEles) {
		cLogger.info("Into BocMidplatService.externalService()...");

		long mStartMillis = System.currentTimeMillis();
		Document mShelledXml = null;
		try {
			//获得去除中行外壳后的报文
			Document mNoShellXml = getNoShellXml(pDomEles[0]);

			String mInNoStdStr = JdomUtil.toString(mNoShellXml);

			String mOutNoStdStr = super.service(mInNoStdStr);

			Document mOutNoStdXml = JdomUtil.build(mOutNoStdStr);			

			Element mTranData = mOutNoStdXml.detachRootElement();			 
			Element mHeadEle = mTranData.getChild(Head);
			int mFlagInt = Integer.parseInt(mHeadEle.getChildText(Flag));

			if (mFlagInt == CodeDef.RCode_OK) {				
				// 添加中行报文的外壳
				Namespace mNamespace = Namespace.getNamespace("m","www.bocsoft.com.cn");
				Element mOnLineResponse = new Element(
						cFuncFlagEle.getAttributeValue("rescode"), mNamespace);				

				mOnLineResponse.addContent(mTranData);

				mShelledXml = new Document(mOnLineResponse);
			} else {
				if("java.lang.NullPointerException".equals(mHeadEle.getChildText(Desc))){
					mShelledXml = getSoapError("服务异常，请重新操作。");
				}else{
					mShelledXml = getSoapError(mHeadEle.getChildText(Desc));
				}				
			}

		} catch (Throwable e) {
			cLogger.error("BocWebService服务处理出错！", e);
			mShelledXml = getSoapError("服务异常，请重新操作。");
		}

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
		.append('_').append(NoFactory.nextAppNo())
		.append('_').append(cFuncFlag)
		.append("_OutShell.xml");
		SaveMessage.save(mShelledXml, cTranComEle.getText(), mSaveName.toString());				
		cLogger.info("保存返回银行报文完毕！" + mSaveName);

		org.w3c.dom.Element mOutDomEles[] = new org.w3c.dom.Element[1];
		try {
			org.w3c.dom.Document mOutDomDoc = new DOMOutputter().output(mShelledXml);
			mOutDomEles[0] = mOutDomDoc.getDocumentElement();
		} catch (JDOMException e) {
			cLogger.error("jdom.Document --> dom.Document转换失败！", e);
		}

		cLogger.info("BocWebService服务处理总耗时："
				+ (System.currentTimeMillis() - mStartMillis) / 1000.0 + "s");

		cLogger.info("Out BocMidplatService.externalService()!");
		return mOutDomEles;
	}


	/**
	 * 获得去除中行外壳后的报文
	 * @param pDomEle
	 * @return
	 * @throws Exception
	 */
	private Document getNoShellXml(org.w3c.dom.Element pDomEle)	throws Exception {
		cLogger.info("Into BocMidplatService.getNoShellXml()...");

		Element mJdomEle = new DOMBuilder().build(pDomEle);
		Document mShellXmlDoc = mJdomEle.getDocument();

		cTranCom = cThisConfRoot.getChildText(TranCom);
		XPath mXPath = XPath.newInstance("msg/@path");
		cMsgPath = mXPath.valueOf(cThisConfRoot);
		if (null == cMsgPath || "".equals(cMsgPath)) {
			cMsgPath = cTranCom;
		}
		Element mHeadEle = mShellXmlDoc.getRootElement().getChild(TranData).getChild(Head);
		cFuncFlag = mHeadEle.getChild(FuncFlag).getText();

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread().getName())
		.append('_').append(NoFactory.nextAppNo())
		.append('_').append(cFuncFlag)
		.append("_InShell.xml");
		SaveMessage.save(mShellXmlDoc, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存原始报文完毕！"+mSaveName);

		Element mHead = mJdomEle.getChild(TranData).getChild(Head);
		mHead.getChild(TranCom).setText(cTranCom);		
		Element mTranCom = mHead.getChild(TranCom);
		mTranCom.setAttribute("outcode", cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));	


		Element mFuncFlag = mHead.getChild(FuncFlag);
		String mFuncName = mJdomEle.getName();
		mXPath = XPath.newInstance("business/funcFlag[@outcode='" + mFuncName + "']");
		cFuncFlagEle = (Element) mXPath.selectSingleNode(cThisConfRoot);	

		mFuncFlag.setText(mFuncName);

		// 去除中行报文的外壳
		Element mTranData = (Element) mShellXmlDoc.getRootElement().getChild(TranData).detach();

		cLogger.info("Out BocMidplatService.getNoShellXml()!");
		return new Document(mTranData);
	}

	/**
	 * 中行报错返回报文
	 * @param pError
	 * @return
	 */
	private Document getSoapError(String pError) {
		cLogger.info("Into BocMidplatService.getSoapError()...");

		Element mFaultCode = new Element(faultcode);
		mFaultCode.addContent("1"); // 0-成功, 1-失败

		Element mFaultString = new Element(faultstring);
		mFaultString.addContent(pError);

		Namespace mNamespace = Namespace.getNamespace("SOAP-ENV", SOAP_URI);
		Element mFault = new Element(Fault, mNamespace);
		mFault.addContent(mFaultCode);
		mFault.addContent(mFaultString);

		cLogger.info("Out BocMidplatService.getSoapError()!");
		return new Document(mFault);
	}
}
