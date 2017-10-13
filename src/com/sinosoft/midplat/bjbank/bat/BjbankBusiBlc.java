package com.sinosoft.midplat.bjbank.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.bjbank.BjbankConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class BjbankBusiBlc extends Balance {
    public BjbankBusiBlc() {
        super(BjbankConf.newInstance(), 1907);
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
    	//保险公司代码（2位）+银行代码（2位）+交易代码（2位）+日期（8位）.txt
    	Element mBankEle = cThisConfRoot.getChild("bank");
        return  mBankEle.getAttributeValue("insu") + mBankEle.getAttributeValue("id") +  mBankEle.getAttributeValue("functionFlag") +
        			DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
    }

    protected Element parse(InputStream pBatIs) throws Exception {
        cLogger.info("Into BjrcbBusiBlc.parse()...");

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
        
        //处理对账首行
        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
        //总笔数
        mCountEle.setText(mSubMsgs[2].trim());
        //总金额
        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[3].trim())));

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // 空行，直接跳过
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("空行，直接跳过，继续下一条！");
                continue;
            }
            //0交易流水号（16位）|1银行代码（10位）|2银行分行代码（8位）|3网点代码（20位）|4柜员代码（16位）|5交易代码（2位）|6保险单号码（20位）|7交易日期（10位）|8交易金额|
            //保单号（20位）|银行流水号（8位）|交易日期（8位）|交易时间（6位）|交易金额（算小数点精确到分16位）|地区代码（4位）|网点代码（6位）|备注（100位）|
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tSubMsgs[7]);

            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tSubMsgs[0]);

            Element tNodeNoEle = new Element(NodeNo);
            tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);

            Element tContNoEle = new Element(ContNo);
            tContNoEle.setText(tSubMsgs[6]);

            Element tPremEle = new Element(Prem);
            long tPremFen = NumberUtil.yuanToFen(tSubMsgs[8]);
            tPremEle.setText(String.valueOf(tPremFen));

            Element tDetailEle = new Element(Detail);
            tDetailEle.addContent(tTranDateEle);
            tDetailEle.addContent(tNodeNoEle);
            tDetailEle.addContent(tTranNoEle);
            tDetailEle.addContent(tContNoEle);
            tDetailEle.addContent(tPremEle);

            mBodyEle.addContent(tDetailEle);
        }
        mBufReader.close(); // 关闭流

        cLogger.info("Out BjrcbBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.BjbankBusiBlc.main");
        mLogger.info("程序开始...");

        BjbankBusiBlc mBatch = new BjbankBusiBlc();

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

