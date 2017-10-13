package com.sinosoft.midplat.cib.bat;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.bat.UploadFileBatchService;
import com.sinosoft.midplat.cib.CibConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * 
 * @author guoxl
 * @desc 定时任务，每天定时查询兴业银行退保数据-寿险
 * @date 2016-06-23 14:35:00
 * 
 */
public class CibQueryPolicyStatus extends UploadFileBatchService {

	public CibQueryPolicyStatus() {
		super(CibConf.newInstance(), "2308");
	}

	@Override
	protected String getFileName() {

		StringBuilder sb = new StringBuilder();
		sb.append("CIB_").append("1004_");
		sb.append("0007_");
		sb.append(DateUtil.getDateStr(calendar, "yyyyMMdd"));
		sb.append(".txt");
		return sb.toString();
	}

	@Override
	protected void setHead(Element head) {
		
	}


	/**
	 * @desc 解析xml报文，返回信息
	 * @date 2016-06-23 14:22:24
	 * @param args
	 */
	protected String parse(Document tOutNoStdXml) throws Exception {
		StringBuffer sBuffer = new StringBuffer();

		Element element = (Element) XPath.selectSingleNode(tOutNoStdXml
				.getRootElement(), "//Head/Flag");

		List<Element> eList = XPath.selectNodes(tOutNoStdXml.getRootElement(),
				"//Body/Detail");

		// 返回报文信息并组装
		if (element != null && "0".equals(element.getValue())) {

			cLogger.info("核心返回信息条数：" + eList.size());

			// 设置文件内容报文头
			sBuffer.append(setFtpTxtHead(eList));

			for (Element e : eList) {
				sBuffer.append(getReadLine(e));
			}

		} else {

			// 设置空文件的报文头信息
			sBuffer.append(setFtpTxtHead(eList));

			cLogger.info("核心返回错误报文！生成空文件：" + getFileName());
		}

		return sBuffer.toString();

	}

	// 读取核心返回报文，并设置发送ftp服务器上文件的报文头
	public StringBuffer setFtpTxtHead(List<Element> eList) {
		StringBuffer sb = new StringBuffer();
		sb.append("F").append("|0007|1004|");
		sb.append(eList.size());
		sb.append("|");
		sb.append("||");
		sb.append("\n");
		return sb; 

	}

	// 读取核心返回的每条报文，并组装
	public StringBuffer getReadLine(Element element) {
		StringBuffer sBuffer = new StringBuffer();
		
		// 保单合同号
		String contNo = element.getChildText("ContNo");
		StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where ContNo = '"+contNo+"' " +
	    		" and Rcode = '0' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
        	sBuffer.append("01");// 线下保单
        }else{
        	sBuffer.append("00");// 线上保单
        }
	
		sBuffer.append("|");
		// 业务变更日期
		String editDate = element.getChildText("EdorCTDate");
		sBuffer.append(editDate).append("|");
		
		sBuffer.append(contNo).append("|");
		// 保单最新状态 --BusinessType 核心返回的业务种类
		// 00-犹豫期内部分退保、01-犹豫期内全额退保、02-保障期内部分退保、03-保障期内全额退保、
		//	04-保障期内理赔终止、05-满期给付终止、06-其他保单失效状态
		/**
			00保单有效  01满期终止 02	退保终止 04	理赔终止 WT	犹豫期退保终止 A拒保  B	待签单
		 */
		String state = element.getChildText("ContState");//核心返回的状态数据ContState
		if ("WT".equals(state)) {
			sBuffer.append("00|");//00-犹豫期内部分退保
		}else if ("02".equals(state)) {
			sBuffer.append("02|");//02-保障期内部分退保
		}else if("03".equals(state)) {
			sBuffer.append("03|");//03-保障期内全额退保
		}else if ("04".equals(state)) {
			sBuffer.append("04|");//04-保障期内理赔终止
		}else if ("01".equals(state)) {
			sBuffer.append("05|");//05-满期给付终止
		}else {
			sBuffer.append("06|");
		}

		// 退保金额
		String amt = element.getChildText("EdorCTPrem");
		sBuffer.append(NumberUtil.fenToYuan(amt)).append("|");
		// 退保渠道
		/* 00-保险公司 01-银行柜面 02-网银 03-自助通 04-电话银行 05-手机银行 */
		//String channelType = element.getChildText("");
		sBuffer.append("00").append("|");
		// 退保机构号
		String NodeNo = element.getChildText("NodeNo");
		sBuffer.append(NodeNo).append("|");

		// 备用字段
		sBuffer.append("|").append("|").append("|").append("|").append("\n");

		return sBuffer;
	}

	public static void main(String[] args) throws Exception {
		
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
		mLogger.info("程序开始...");

		CibQueryPolicyStatus mBatch = new CibQueryPolicyStatus();

		// 用于补对账，设置补对账日期
		if (0 != args.length) {
			mLogger.info("args[0] = " + args[0]);

			/**
			 * 严格日期校验的正则表达式：\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))。
			 * 4位年-2位月-2位日。 4位年：4位[0-9]的数字。
			 * 1或2位月：单数月为0加[0-9]的数字；双数月必须以1开头，尾数为0、1或2三个数之一。
			 * 1或2位日：以0、1或2开头加[0-9]的数字，或者以3开头加0或1。
			 * 
			 * 简单日期校验的正则表达式：\\d{4}\\d{2}\\d{2}。
			 */
		
		if (args[0].matches("\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))")) {
				// mBatch.setDate(args[0]);
				System.out.println("文件名称正确！");
			} else {
				throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
			}
		}

		mBatch.run();

		mLogger.info("成功结束！");
		/*Calendar   cal   =   Calendar.getInstance();
		  cal.add(Calendar.DATE,   -1);
		  String yesterday = new SimpleDateFormat( "yyyyMMdd ").format(cal.getTime());
		  System.out.println(yesterday);*/
	}

	@Override
	protected void setBody(Element bodyEle) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
