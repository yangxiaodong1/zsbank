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
        
        //�����������
        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
        //�ܱ���
        mCountEle.setText(mSubMsgs[2].trim());
        //�ܽ��
        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[3].trim())));

        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // ���У�ֱ������
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("���У�ֱ��������������һ����");
                continue;
            }
            //0���ڣ�1��000000�����̶�����2���н�����ˮ�ţ��˱�������ˮ�ţ���3Ϊ�գ��̶�����4���պ�ͬ�ţ������ţ�5Ϊ��6���л����ţ�ǰ��λΪ�������ţ�����λΪ������ţ���7��������Ա��
            
            String[] tSubMsgs = tLineMsg.split("\\|", -1);

            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tSubMsgs[0]);

            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tSubMsgs[2]);

            Element tNodeNoEle = new Element(NodeNo);
            //����һ��ȡֵλ�ã���ҵ�����ڽ�������л�����֮��������һλ����|2|������ȡ���л����ŵ�ȡֵλ�ã���ԭ��6λ���ɵ�7λ
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
        mBufReader.close(); // �ر���

        cLogger.info("Out CibBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
        mLogger.info("����ʼ...");

        CibBusiBlc mBatch = new CibBusiBlc();

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

