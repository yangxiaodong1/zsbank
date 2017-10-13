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
        
        //�����������: �ܱ�����8λ��|�ɹ�������8λ��|���ڣ�8λ��|��ע��100��|
        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
        //�ܱ���
        mCountEle.setText(mSubMsgs[0].trim());

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // ���У�ֱ������
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("���У�ֱ��������������һ����");
                continue;
            }
            //�����ţ�30λ��|����ӡˢ�ţ�30λ��|��ԥ���˱�����(8λ)|��������1λ��|��ע��100λ��|
            //��������0�ɹ�1ʧ��
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tContNoEle = new Element(ContNo);
            tContNoEle.setText(tSubMsgs[0]);

            Element tEdorCTDateEle = new Element("EdorCTDate");
            tEdorCTDateEle.setText(tSubMsgs[2]);

            Element tResultCodeEle = new Element("ResultCode");
            if("0".equals(tSubMsgs[3])){
                //�ɹ�
                tResultCodeEle.setText("0000");
            }else {
                //ʧ��
                tResultCodeEle.setText("1111");
            }

            Element tDetailEle = new Element(Detail);
            tDetailEle.addContent(tContNoEle);
            tDetailEle.addContent(tEdorCTDateEle);
            tDetailEle.addContent(tResultCodeEle);

            mBodyEle.addContent(tDetailEle);
        }
        mBufReader.close(); // �ر���

        cLogger.info("Out BjrcbEdorCTInfoResultBatch.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.PsbcBusiBlc.main");
        mLogger.info("����ʼ...");

        PsbcBusiBlc mBatch = new PsbcBusiBlc();

        // ���ڲ����ˣ����ò���������
        if (0 != args.length) {
            mLogger.info("args[0] = " + args[0]);

            /**
             * �ϸ�����У���������ʽ��\\d{4}((0\\d)|(1[012]))(([012]\\d)|(3[01]))��
             * 4λ��-2λ��-2λ�ա� 4λ�꣺4λ[0-9]�����֡�
             * 1��2λ�£�������Ϊ0��[0-9]�����֣�˫���±�����1��ͷ��β��Ϊ0��1��2������֮һ��
             * 1��2λ�գ���0��1��2��ͷ��[0-9]�����֣�������3��ͷ��0��1��
             * 
             * ������У���������ʽ��\\d{4}\\d{2}\\d{2}��
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

