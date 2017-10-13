package com.sinosoft.midplat.cib.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.cib.CibConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class CibBusiBlc extends Balance {
    public CibBusiBlc() {
        super(CibConf.newInstance(), 2304);
    }

    protected Element getHead() {
        Element mHead = super.getHead();

        Element mBankCode = new Element("BankCode");
        mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
        mHead.addContent(mBankCode);

        return mHead;
    }

    protected String getFileName() {
    	//ABSX_YBT_YYYYMMDD.txt
    	Element mBankEle = cThisConfRoot.getChild("bank");
        return  mBankEle.getAttributeValue("id") +  "_" + DateUtil.getDateStr(cTranDate, "yyyyMMdd") + ".txt";
    }

    protected Element parse(InputStream pBatIs) throws Exception {
        cLogger.info("Into CibBusiBlc.parse()...");

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
            //0日期，1“000000”（固定），2银行交易流水号（核保交易流水号），3为空（固定），4保险合同号（保单号，5为金额，6银行机构号（前两位为地区代号，后三位为网点代号），7渠道操作员号
            
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tSubMsgs[0]);

            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tSubMsgs[2]);

            Element tNodeNoEle = new Element(NodeNo);
            //调整一下取值位置，兴业银行在金额与银行机构号之间增加了一位渠道|2|，调整取银行机构号的取值位置，由原第6位换成第7位
//            tNodeNoEle.setText(tSubMsgs[6]);
            tNodeNoEle.setText(tSubMsgs[7]);

            Element tContNoEle = new Element(ContNo);
            tContNoEle.setText(tSubMsgs[4]);

            Element tPremEle = new Element(Prem);
            long tPremFen = NumberUtil.yuanToFen(tSubMsgs[5]);
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

        cLogger.info("Out CibBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
        mLogger.info("程序开始...");

        CibBusiBlc mBatch = new CibBusiBlc();

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

