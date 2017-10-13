package com.sinosoft.midplat.ccb.net;

import java.io.ByteArrayOutputStream;
import java.net.Socket;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;

import com.adtec.security.BaseException;
import com.adtec.security.Nobis;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.SocketNetImpl;

public class CcbNetImpl extends SocketNetImpl {
	private final Nobis cNobis;

	private Element cTransaction_HeaderEle;

	public CcbNetImpl(Socket pSocket, Element pThisConfRoot)
			throws MidplatException {
		super(pSocket, pThisConfRoot);
		try {
			cNobis = Nobis.nobisFactory();
			cNobis.bisReadKey(SysInfo.cHome + "key/ccbKey.dat");
		} catch (BaseException ex) {
			throw new MidplatException("密钥文件有误！" + SysInfo.cHome
					+ "key/ccbKey.dat", ex);
		}
	}

	public Document receive() throws Exception {
		cLogger.info("Into CcbNetImpl.receive()...");

		// 处理报文头
		byte[] mHeadBytes = new byte[6];
		IOTrans.readFull(mHeadBytes, cSocket.getInputStream());
		int mBodyLen = Integer.parseInt(new String(mHeadBytes, 0, 6).trim());
		cLogger.debug("请求报文长度：" + mBodyLen);
		// 处理报文体
		byte[] mBodyBytes = new byte[mBodyLen];
		IOTrans.readFull(mBodyBytes, cSocket.getInputStream());
		cSocket.shutdownInput();

		cLogger.info("开始解密...");
		mBodyBytes = cNobis.bisPkgDecompressDec(mBodyBytes);
		cLogger.info("解密成功！");
		Document mXmlDoc = JdomUtil.build(mBodyBytes);
		Element mRootEle = mXmlDoc.getRootElement();

		cTransaction_HeaderEle = (Element) mRootEle.getChild(
				"Transaction_Header").clone();
		XPath mXPath = XPath.newInstance("business/funcFlag[@outcode='"
				+ cTransaction_HeaderEle.getChildText("BkTxCode") + "']");
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

		cLogger.info("Out CcbNetImpl.receive()!");
		return mXmlDoc;
	}

	public void send(Document pOutNoStd) throws Exception {
		cLogger.info("Into CcbNetImpl.send()...");

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

		cTransaction_HeaderEle.addContent(mTran_ResponseEle);
		mRootEle.addContent(0, cTransaction_HeaderEle);
		/* End-组织返回报文头 */

		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
				.getName()).append('_').append(NoFactory.nextAppNo()).append(
				'_').append(cFuncFlag).append("_out.xml");
		SaveMessage
				.save(pOutNoStd, cTranComEle.getText(), mSaveName.toString());
		cLogger.info("保存报文完毕！" + mSaveName);

		// byte[] mBodyBytes = JdomUtil.toBytes(pOutNoStd);
		Format mFormat = Format.getRawFormat().setEncoding("GBK").setIndent(
				"   ").setLineSeparator("\n");
		XMLOutputter mXMLOutputter = new XMLOutputter(mFormat);
		ByteArrayOutputStream mBaos = new ByteArrayOutputStream();
		mXMLOutputter.output(pOutNoStd, mBaos);
		byte[] mBodyBytes = mBaos.toByteArray();

		cLogger.info("开始加密...");
		mBodyBytes = cNobis.bisPkgCompressEnc(new String(mBodyBytes));
		cLogger.info("加密成功！");

		byte[] mHeadBytes = new byte[6];
		// 报文体长度
		String mLengthStr = String.valueOf(mBodyBytes.length);
		cLogger.info("返回报文长度：" + mLengthStr);
		byte[] mLengthBytes = mLengthStr.getBytes();
		System.arraycopy(mLengthBytes, 0, mHeadBytes, 0, mLengthBytes.length);

		cSocket.getOutputStream().write(mHeadBytes); // 发送报文头
		cSocket.getOutputStream().write(mBodyBytes); // 发送报文体
		cSocket.shutdownOutput();

		cLogger.info("Out CcbNetImpl.send()!");
	}
}
