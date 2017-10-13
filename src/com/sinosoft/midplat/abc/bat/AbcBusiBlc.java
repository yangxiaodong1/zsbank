/**
 * ũ������ҵ�����
 */

package com.sinosoft.midplat.abc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.abc.AbcConf;

public class AbcBusiBlc extends Balance {
	public AbcBusiBlc() {
		super(AbcConf.newInstance(), 406);
	}

	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(
				outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}

	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return "B" + mBankEle.getAttributeValue("insu")
				+ mBankEle.getAttributeValue(id)
				+ DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".TXT";
	}

	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into AbcBusiBlc.parse()...");

		String mCharset = cThisBusiConf.getChildText(charset);
		if (null == mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}

		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(
				pBatIs, mCharset));

		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mPremEle);

		String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
		mCountEle.setText(mSubMsgs[4].trim());
		mPremEle.setText(String.valueOf(NumberUtil
				.yuanToFen(mSubMsgs[5].trim())));

		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
			cLogger.info(tLineMsg);

			// ���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}

			String[] tSubMsgs = tLineMsg.split("\\|", -1);

			if (!"01".equals(tSubMsgs[11])) {
				cLogger.warn("�ǳб�������ֱ��������������һ����");
				continue;
			}

			Element tTranDateEle = new Element(TranDate);
			tTranDateEle.setText(tSubMsgs[0]);

			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[2]);

			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[3] + tSubMsgs[4] + tSubMsgs[5]);

			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[8]);

			Element tPremEle = new Element(Prem);
			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[9]);
			tPremEle.setText(String.valueOf(tPremFen));

			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);

			mBodyEle.addContent(tDetailEle);
		}
		mBufReader.close(); // �ر���

		cLogger.info("Out AbcBusiBlc.parse()!");
		return mBodyEle;
	}

	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.icbc.bat.AbcBusiBlc.main");
		mLogger.info("����ʼ...");

		AbcBusiBlc mBatch = new AbcBusiBlc();

		// ���ڲ����ˣ����ò���������
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);

			/**
			 * �ϸ�����У���������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
			 * 4λ��-2λ��-2λ�ա� 4λ�꣺4λ[0-9]�����֡�
			 * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
			 * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
			 * 
			 * ������У���������ʽ��\\d{4}\\d{2}\\d{2}��
			 */
			if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				mBatch.setDate(args[0]);
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("�ɹ�������");
	}
}
