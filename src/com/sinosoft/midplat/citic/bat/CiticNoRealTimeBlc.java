package com.sinosoft.midplat.citic.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.citic.CiticConf;
import com.sinosoft.midplat.common.DateUtil;

/**
 * @Title: com.sinosoft.midplat.citic.bat.CiticNoRealTimeBlc.java
 * @Description: 中信银行日终非实时报文对账
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date May 29, 2014 11:18:10 AM
 * @version 
 *
 */
public class CiticNoRealTimeBlc extends Balance {
	
	public CiticNoRealTimeBlc() {
		super(CiticConf.newInstance(), "1106");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();

		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);

		return mHead;
	}
	
	/** 
	 * 1、CITIC+保险公司代码+FSS+8位日期（yyyymmdd）+REQ.txt
	 * 2、安邦人寿代码：161
	 * (non-Javadoc)
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	protected String getFileName() {
		Element mBankEle = cThisConfRoot.getChild("bank");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("CITIC").append(mBankEle.getAttributeValue("insu"))
				.append("FSS").append(DateUtil.getDateStr(cTranDate, "yyyyMMdd")).append("REQ.txt");
		return strBuff.toString();
	}
	
	/**
	 * 解析对账文件，组织成XML报文用于发送
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
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		
		Element mBodyEle = new Element(Body);
		Element mCountEle = new Element(Count);
		
		mBodyEle.addContent(mCountEle);
		int mCount = 0;
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//空行，直接跳过
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("空行，直接跳过，继续下一条！");
				continue;
			}
			
			Element tDetailEle = lineToNode(tLineMsg);
			mBodyEle.addContent(tDetailEle);
			mCount++;
		}
		mCountEle.setText(String.valueOf(mCount));
		mBufReader.close();	//关闭流
		
		cLogger.info("Out " + this.getClass().getName() + ".parse()!");
		return mBodyEle;
	 }
	
	/**
     * 将对账文件的每行数据转换为报文中的一个XML节点
     * 
     * @param lineMsg
     * @return
     */
	private Element lineToNode(String lineMsg){
		
		String[] tSubMsgs = lineMsg.split("\\|", -1);
		
		Element tTranDateEle = new Element(TranDate);
		tTranDateEle.setText(tSubMsgs[1]);
		
		Element tNodeNoEle = new Element(NodeNo);
		tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);
		
		Element tTranNoEle = new Element(TranNo);
		tTranNoEle.setText(tSubMsgs[5]);
		
		Element tProposalPrtNoEle = new Element(ProposalPrtNo);
		tProposalPrtNoEle.setText(tSubMsgs[6]);

		Element tAccNoEle = new Element(AccNo);
		tAccNoEle.setText(tSubMsgs[13]);
		
		Element tAppntNameEle = new Element("AppntName");
		tAppntNameEle.setText(tSubMsgs[9]);
		
		/*
		 * 银行方投保人证件类型：0身份证、1护照、2军官证、3士兵证、4回乡证、5临时身份证、6户口本、7 其他、8少儿证、9警官证。
		 */
		Element tAppntIDTypeEle = new Element("AppntIDType");
		tAppntIDTypeEle.setText(idTypeToPGI(tSubMsgs[10]));
		
		Element tAppntIDNoEle = new Element("AppntIDNo");
		tAppntIDNoEle.setText(tSubMsgs[11]);

		/*
		 * 目前中信银行只有柜面出单
		 * 销售渠道：0柜面、1网银、2电银、3法人营销、4全部、5手机银行。
		 * 安邦：sourcetype=0--柜面,sourcetype=1--网银
		 */
		Element tSourTypeEle = new Element("SourceType");
		tSourTypeEle.setText(tSubMsgs[7]);
		
		Element tDetailEle = new Element(Detail);
		tDetailEle.addContent(tTranDateEle);
		tDetailEle.addContent(tNodeNoEle);
		tDetailEle.addContent(tTranNoEle);
		tDetailEle.addContent(tProposalPrtNoEle);
		tDetailEle.addContent(tAccNoEle);
		tDetailEle.addContent(tAppntNameEle);
		tDetailEle.addContent(tAppntIDTypeEle);
		tDetailEle.addContent(tAppntIDNoEle);
		tDetailEle.addContent(tSourTypeEle);
		
		return tDetailEle;
	}
	
	/**
	 * 银行的身份证件类型对应到核心
	 * 身份证类型转为核心
	 * 银行方投保人证件类型：0公民身份证号码、1军官证、8(港澳)回乡证及通行证、a其它、b户口簿、I护照
	 * 					      
	 * @param idType 银行的身份证类型
	 * @return 		 核心身份证类型
	 */
	private String idTypeToPGI(String idType){
		if ("0".equals(idType)) {
		    //身份证
		    return "0";
		}else if("1".equals(idType)) {
		    //军官证
		    return "2";
		}else if("I".equals(idType)) {
		    //护照
		    return "1";
		}else if("b".equals(idType)) {
		    //户口本
		    return "5";
		}else{
		    //其他
		    return "8";
		}		    

	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CiticNoRealTimeBlc blc = new CiticNoRealTimeBlc();
		blc.run();
	}
	
}
