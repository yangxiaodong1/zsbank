package com.sinosoft.midplat.hbyh.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.hbyh.HbyhConf;


public class HbyhBusiBlc extends Balance {

	public HbyhBusiBlc() {
		super(HbyhConf.newInstance(), "3104");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	
	/**
	 *对账文件名：HEBB+日期+01.txt（例如：HEBB2015030101.txt）
	 *日期后面两位固定为"01"代表新单对账类型。
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		return  mBankEle.getAttributeValue(id)
		        + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + "01.txt";
	}
	
	protected Element parse(InputStream pBatIs) throws Exception {
		
		cLogger.info("Into HbyhBusiBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null == mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		Element mPremEle = new Element(Prem);
		mBodyEle.addContent(mCountEle);
		mBodyEle.addContent(mPremEle);
		
		long mSumPrem = 0;
		int mCount = 0;
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			
			cLogger.info(tLineMsg);
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			/*
			 * 银行编号（比如16）＋交易日期（YYYYMMDD）＋地区号（5位）＋网点号（5位）＋对帐交易码（固定0001）+新单承保交易流水号（20位）＋保单号（20位）＋金额（12位，带小数点，以元为单位，2位小数）＋销售渠道（2位）
			 * 例如：16|20121201|00200|00082|0001|41128299|130000045001|50000.00|01|
			 * 注释：
			 * （1）	每个字段通过‘|’进行分割，即类似于数据库文件格式（数据格式不定长，通过分隔符分割）
			 * （2）	每行结束有回车，在unix下生成
			 * （3）	投保对账文件的渠道字典项：01（其他，含柜面），02（网银，含电银、手机银行），06（区域中心）。
			 * （4）	只生成成功的交易明细；
			 */
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			Element tTranDateEle = new Element(TranDate);
			tTranDateEle.setText(tSubMsgs[1]);
			
			Element tNodeNoEle = new Element(NodeNo);
			tNodeNoEle.setText(tSubMsgs[2] + tSubMsgs[3]);
			
			Element tTranNoEle = new Element(TranNo);
			tTranNoEle.setText(tSubMsgs[5]);
			
			Element tContNoEle = new Element(ContNo);
			tContNoEle.setText(tSubMsgs[6]);
			
			Element tPremEle = new Element(Prem);
//			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
//			tPremEle.setText(String.valueOf(tPremFen));
			//银行最后确认给“分”
			long tPremFen = Long.parseLong(tSubMsgs[7]);
			tPremEle.setText(tSubMsgs[7]);

			//河北银行目前只有柜面
			Element tSourTypeEle = new Element("SourceType");
			tSourTypeEle.setText("0");
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(tTranDateEle);
			tDetailEle.addContent(tNodeNoEle);
			tDetailEle.addContent(tTranNoEle);
			tDetailEle.addContent(tContNoEle);
			tDetailEle.addContent(tPremEle);
			tDetailEle.addContent(tSourTypeEle);
			
			mBodyEle.addContent(tDetailEle);
			
			mCount++;
			mSumPrem += tPremFen;
			JdomUtil.print(tDetailEle);//打印每条Detail
		}
		
		mCountEle.setText(String.valueOf(mCount));
		mPremEle.setText(String.valueOf(mSumPrem));
		mBufReader.close();	//关闭流
		
		cLogger.info("Out HbyhBusiBlc.parse()!");
		return mBodyEle;
	}

}