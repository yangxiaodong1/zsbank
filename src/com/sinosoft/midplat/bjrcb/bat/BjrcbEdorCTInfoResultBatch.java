package com.sinosoft.midplat.bjrcb.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.bjrcb.BjrcbConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.psbc.bat.PsbcBusiBlc;

public class BjrcbEdorCTInfoResultBatch extends Balance {
    public BjrcbEdorCTInfoResultBatch() {
        super(BjrcbConf.newInstance(), 1208);
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
        return  "BRCB_BDZTTB_H_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
    }

    protected Element parse(InputStream pBatIs) throws Exception {
        cLogger.info("Into BjrcbEdorCTInfoResultBatch.parse()...");

        String mCharset = cThisBusiConf.getChildText(charset);
        if (null == mCharset || "".equals(mCharset)) {
            mCharset = "GBK";
        }

        BufferedReader mBufReader = new BufferedReader(new InputStreamReader(
                pBatIs, mCharset));

        Element mBodyEle = new Element(Body);
        Element mCountEle = new Element(Count);
        mBodyEle.addContent(mCountEle);
        
        //处理对账首行: 总笔数（8位）|成功笔数（8位）|日期（8位）|备注（100）|
        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
        //总笔数
        mCountEle.setText(mSubMsgs[0].trim());

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // 空行，直接跳过
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("空行，直接跳过，继续下一条！");
                continue;
            }
            //保单号（30位）|保单印刷号（30位）|犹豫期退保日期(8位)|处理结果（1位）|备注（100位）|
            //处理结果：0成功1失败
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tContNoEle = new Element(ContNo);
            tContNoEle.setText(tSubMsgs[0]);

            Element tEdorCTDateEle = new Element("EdorCTDate");
            tEdorCTDateEle.setText(tSubMsgs[2]);

            Element tResultCodeEle = new Element("ResultCode");
            if("0".equals(tSubMsgs[3])){
                //成功
                tResultCodeEle.setText("0000");
            }else {
                //失败
                tResultCodeEle.setText("1111");
            }

            Element tDetailEle = new Element(Detail);
            tDetailEle.addContent(tContNoEle);
            tDetailEle.addContent(tEdorCTDateEle);
            tDetailEle.addContent(tResultCodeEle);

            mBodyEle.addContent(tDetailEle);
        }
        mBufReader.close(); // 关闭流

        cLogger.info("Out BjrcbEdorCTInfoResultBatch.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.PsbcBusiBlc.main");
        mLogger.info("程序开始...");

        PsbcBusiBlc mBatch = new PsbcBusiBlc();

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

