/**
 * 
 */
package com.sinosoft.midplat.icbc.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.icbc.IcbcConf;

/**
 * �˱���ʱ����
 * @author ChengNing
 * @date   Mar 29, 2013
 */
public class IcbcBlcTimeoutRemind extends Balance  {

	public IcbcBlcTimeoutRemind() {
		super(IcbcConf.newInstance(), "122");
	}

	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}

	/** 
	 * �����ļ���ʽ��
	 * ���չ�˾����(3λ)+���д���(2λ)+YYYYMMDD(����8λ)+CHAOSHI.txt
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return mBankEle.getAttributeValue("insu") + mBankEle.getAttributeValue(id)+DateUtil.getDateStr(cTranDate, "yyyyMMdd")+"CHAOSHI.txt";
	}
	
	/**
	 * ���������ļ�����֯��XML�������ڷ���
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 * 
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		cLogger.info("Into " + this.getClass().getName() + ".parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(
				new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		//Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		//mBodyEle.addContent(mPremEle);
		long mSumPrem = 0;
		int mCount = 0;
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			Element tDetailEle = lineToNode(tLineMsg);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			//mSumPrem += tPremFen;
		}
		mCountEle.setText(String.valueOf(mCount));
		//mPremEle.setText(String.valueOf(mSumPrem));
		mBufReader.close();	//�ر���
		
		cLogger.info("Out " + this.getClass().getName() + ".parse()!");
		return mBodyEle;
	}
	
	/**
	 * �������ļ���ÿ������ת��Ϊ�����е�һ��XML�ڵ�
	 * @param lineMsg
	 * @return
	 */
	private Element lineToNode(String lineMsg){
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[8]);
		
		Element tNodeNoEle = new Element(NodeNo);
		tNodeNoEle.setText(tSubMsgs[0]+tSubMsgs[1]);
		
		Element tTranNoEle = new Element(TranNo);
		tTranNoEle.setText(tSubMsgs[3]);
		
		Element tProposalPrtNoEle = new Element(ProposalPrtNo);
		tProposalPrtNoEle.setText(tSubMsgs[4]);

		Element tAccNoEle = new Element(PolApplyDate);
		tAccNoEle.setText(tSubMsgs[7]);
		
		Element tAppntNameEle = new Element("AppntName");
		tAppntNameEle.setText(tSubMsgs[5]);
		
		Element tDetailEle = new Element(Detail);
		tDetailEle.addContent(tTranDateEle);
		tDetailEle.addContent(tNodeNoEle);
		tDetailEle.addContent(tTranNoEle);
		tDetailEle.addContent(tProposalPrtNoEle);
		tDetailEle.addContent(tAccNoEle);
		tDetailEle.addContent(tAppntNameEle);
		
		return tDetailEle;
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IcbcBlcTimeoutRemind blc = new IcbcBlcTimeoutRemind();
		blc.run();
	}

}
