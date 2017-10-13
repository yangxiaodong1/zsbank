package com.sinosoft.midplat.lnrcclife.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.lnrcclife.LnrcclifeConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class LnrcclifeBusiBlc extends Balance {
    public LnrcclifeBusiBlc() {
        super(LnrcclifeConf.newInstance(), 3605);
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
        return  "SABW01_LNNX_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
    }

    protected Element parse(InputStream pBatIs) throws Exception {
        cLogger.info("Into LnrcclifeBusiBlc.parse()...");

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
        mCountEle.setText(mSubMsgs[0].trim());
        //总金额
        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[1].trim())));

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // 空行，直接跳过
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("空行，直接跳过，继续下一条！");
                continue;
            }
            //保单号（20位）|银行流水号（8位）|交易日期（8位）|交易时间（6位）|交易金额（算小数点精确到分16位）|地区代码（4位）|网点代码（6位）|备注（100位）|
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tSubMsgs[2]);

            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tSubMsgs[1]);

            Element tNodeNoEle = new Element(NodeNo);
            tNodeNoEle.setText(tSubMsgs[5]+tSubMsgs[6]);

            Element tContNoEle = new Element(ContNo);
            tContNoEle.setText(tSubMsgs[0]);

            Element tPremEle = new Element(Prem);
            long tPremFen = NumberUtil.yuanToFen(tSubMsgs[4]);
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

        cLogger.info("Out LnrcclifeBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.lnrcclife.bat.lnrcclifeBusiBlc.main");
        mLogger.info("程序开始...");

        LnrcclifeBusiBlc mBatch = new LnrcclifeBusiBlc();

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

