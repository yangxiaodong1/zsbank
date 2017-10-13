package com.sinosoft.midplat.jxnxs.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.jxnxs.JxnxsConf;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class JxnxsBusiBlc extends Balance {
    public JxnxsBusiBlc() {
        super(JxnxsConf.newInstance(), 2503);
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
    	//BUSDAYCHECK+银行代码（4位）+业务日期（8位）.TXT
    	Element mBankEle = cThisConfRoot.getChild("bank");
        return  mBankEle.getAttributeValue("id") +  mBankEle.getAttributeValue("bankcode") + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".TXT";
    }

    protected Element parse(InputStream pBatIs) throws Exception {
        cLogger.info("Into JxnxsBusiBlc.parse()...");

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
        
//        //处理对账首行
//        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
//        //总笔数
//        mCountEle.setText(mSubMsgs[2].trim());
//        //总金额
//        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[3].trim())));
        int mCount = 0 ; 
        long mPrem = 0;
        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // 空行，直接跳过
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("空行，直接跳过，继续下一条！");
                continue;
            }
            /**
             * 名称		XML标签	起始位置	最大长度	备注
			 * 	银行编码	Bankno	1	4C	必填CD03 
			 * 	地区代码	Zoneno	5	5C	必填，不足5位左补空格
			 * 	交易代码	“ 1”	10	4C	必填，
			 * 	交易日期	workDate	14	8C	必填,月份（不足两位补“0”），DD：日期（不足两位补“0”）
			 * 	银行交易流水	agentSeialno	22	16C	必填，不足16位左补空格
			 * 	投保单/保单号	sApplno/userno	38	26C	必填，不足26位右补空格
			 * 	投保人姓名	Username	64	20C	必填，不足20位右补空格
			 * 	应收日期	“ ”	84	8C	可空（新单为空）CD01
			 * 	交易金额	Amount	92	14C	必填CD23，不足14位右补空格,金额以“分”为单位
			 * 	借贷标志	“1”	106	1C	固定为1，
			 *  例如：1112  194102220120913  57809124108636090137145  邹木水        100000   1
             */
           
            //交易日期
            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tLineMsg.substring(13, 21).trim());
            //签单交易流水号
            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tLineMsg.substring(21, 37).trim());
            //银行地区代码+网点代码
            Element tNodeNoEle = new Element(NodeNo);
//            tNodeNoEle.setText();
            //投保单号
            String proposalPrtNo = tLineMsg.substring(37, 63).trim();
            cLogger.info("投保单号===" + proposalPrtNo);
            Element tProposalPrtNo = new Element("ProposalPrtNo");
            tProposalPrtNo.setText(proposalPrtNo);
            
            //针对汉字问题，汉字是两个字节
            byte[] tLineMsgBytes = tLineMsg.getBytes();
            
            //投保人姓名
            Element tAppntName = new Element("AppntName");
            tAppntName.setText(new String(tLineMsgBytes,63,20).trim());
            //保险合同号/保单号
            Element tContNoEle = new Element(ContNo);
//            tContNoEle.setText();
            //交易实收金额 分
            Element tPremEle = new Element(Prem);
            String premStr = new String(tLineMsgBytes,91,14).trim();
            tPremEle.setText(premStr);
            cLogger.info("premStr===" + premStr);
            //渠道：0-柜面，1-网银，8自助终端
            Element tSourceType = new Element("SourceType");
            tSourceType.setText("0");
            
            
         // 需根据传递的流水号获取地区及网点代码，从成功的承保记录(funcflag=1)中查询
			String sqlStr = "select NodeNo, contno from TranLog where TranCom='"
					+ cThisConfRoot.getChildText(TranCom)
					+ "' and ProposalPrtno='"
					+ tProposalPrtNo.getTextTrim()
					+ "' and TranNo='"
					+ tTranNoEle.getTextTrim()
					+ "' and TranDate="
					+ tTranDateEle.getTextTrim() 
					+ " and Rcode=0 ";
			SSRS results = new ExeSQL().execSQL(sqlStr);
			if (results.MaxRow != 1) {
				cLogger.error("交行对账：查询交易日志失败，流水号[" + tTranNoEle.getTextTrim() + "]");
			} else {
				
				tNodeNoEle.setText(results.GetText(1, 1));
				tContNoEle.setText(results.GetText(1, 2));
			}

            Element tDetailEle = new Element(Detail);
            tDetailEle.addContent(tTranDateEle);
            tDetailEle.addContent(tNodeNoEle);
            tDetailEle.addContent(tTranNoEle);
            tDetailEle.addContent(tProposalPrtNo);
            tDetailEle.addContent(tAppntName);
            tDetailEle.addContent(tContNoEle);
            tDetailEle.addContent(tPremEle);
            tDetailEle.addContent(tSourceType);

            mBodyEle.addContent(tDetailEle);
            int tPremFen = Integer.valueOf(premStr);//单位分
            mPrem += tPremFen;
            mCount ++;
        }
        mBufReader.close(); // 关闭流
        mCountEle.setText(mCount + "");
        mPremEle.setText(mPrem + "");
        cLogger.info("Out JxnxsBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
        mLogger.info("程序开始...");

        JxnxsBusiBlc mBatch = new JxnxsBusiBlc();

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
                mBatch.setDate(args[0]);
            } else {
                throw new MidplatException("日期格式有误，应为yyyyMMdd！" + args[0]);
            }
        }

        mBatch.run();

        mLogger.info("成功结束！");
    }
}

