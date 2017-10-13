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
        
        //������������
        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
        //�ܱ���
        mCountEle.setText(mSubMsgs[0].trim());
        //�ܽ��
        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[1].trim())));

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // ���У�ֱ������
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("���У�ֱ��������������һ����");
                continue;
            }
            //�����ţ�20λ��|������ˮ�ţ�8λ��|�������ڣ�8λ��|����ʱ�䣨6λ��|���׽���С���㾫ȷ����16λ��|�������루4λ��|������루6λ��|��ע��100λ��|
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
        mBufReader.close(); // �ر���

        cLogger.info("Out LnrcclifeBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.lnrcclife.bat.lnrcclifeBusiBlc.main");
        mLogger.info("����ʼ...");

        LnrcclifeBusiBlc mBatch = new LnrcclifeBusiBlc();

        // ���ڲ����ˣ����ò���������
        if (0 != args.length) {
            mLogger.info("args[0] = " + args[0]);

            /**
             * �ϸ�����У����������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
             * 4λ��-2λ��-2λ�ա� 4λ�꣺4λ[0-9]�����֡�
             * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
             * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
             * 
             * ������У����������ʽ��\\d{4}\\d{2}\\d{2}��
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
