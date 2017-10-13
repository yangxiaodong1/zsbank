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
    	//BUSDAYCHECK+���д��루4λ��+ҵ�����ڣ�8λ��.TXT
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
        
//        //�����������
//        String[] mSubMsgs = mBufReader.readLine().split("\\|", -1);
//        //�ܱ���
//        mCountEle.setText(mSubMsgs[2].trim());
//        //�ܽ��
//        mPremEle.setText(String.valueOf(NumberUtil.yuanToFen(mSubMsgs[3].trim())));
        int mCount = 0 ; 
        long mPrem = 0;
        for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
            cLogger.info(tLineMsg);

            // ���У�ֱ������
            tLineMsg = tLineMsg.trim();
            if ("".equals(tLineMsg)) {
                cLogger.warn("���У�ֱ��������������һ����");
                continue;
            }
            /**
             * ����		XML��ǩ	��ʼλ��	��󳤶�	��ע
			 * 	���б���	Bankno	1	4C	����CD03 
			 * 	��������	Zoneno	5	5C	�������5λ�󲹿ո�
			 * 	���״���	�� 1��	10	4C	���
			 * 	��������	workDate	14	8C	����,�·ݣ�������λ����0������DD�����ڣ�������λ����0����
			 * 	���н�����ˮ	agentSeialno	22	16C	�������16λ�󲹿ո�
			 * 	Ͷ����/������	sApplno/userno	38	26C	�������26λ�Ҳ��ո�
			 * 	Ͷ��������	Username	64	20C	�������20λ�Ҳ��ո�
			 * 	Ӧ������	�� ��	84	8C	�ɿգ��µ�Ϊ�գ�CD01
			 * 	���׽��	Amount	92	14C	����CD23������14λ�Ҳ��ո�,����ԡ��֡�Ϊ��λ
			 * 	�����־	��1��	106	1C	�̶�Ϊ1��
			 *  ���磺1112  194102220120913  57809124108636090137145  ��ľˮ        100000   1
             */
           
            //��������
            Element tTranDateEle = new Element(TranDate);
            tTranDateEle.setText(tLineMsg.substring(13, 21).trim());
            //ǩ��������ˮ��
            Element tTranNoEle = new Element(TranNo);
            tTranNoEle.setText(tLineMsg.substring(21, 37).trim());
            //���е�������+�������
            Element tNodeNoEle = new Element(NodeNo);
//            tNodeNoEle.setText();
            //Ͷ������
            String proposalPrtNo = tLineMsg.substring(37, 63).trim();
            cLogger.info("Ͷ������===" + proposalPrtNo);
            Element tProposalPrtNo = new Element("ProposalPrtNo");
            tProposalPrtNo.setText(proposalPrtNo);
            
            //��Ժ������⣬�����������ֽ�
            byte[] tLineMsgBytes = tLineMsg.getBytes();
            
            //Ͷ��������
            Element tAppntName = new Element("AppntName");
            tAppntName.setText(new String(tLineMsgBytes,63,20).trim());
            //���պ�ͬ��/������
            Element tContNoEle = new Element(ContNo);
//            tContNoEle.setText();
            //����ʵ�ս�� ��
            Element tPremEle = new Element(Prem);
            String premStr = new String(tLineMsgBytes,91,14).trim();
            tPremEle.setText(premStr);
            cLogger.info("premStr===" + premStr);
            //������0-���棬1-������8�����ն�
            Element tSourceType = new Element("SourceType");
            tSourceType.setText("0");
            
            
         // ����ݴ��ݵ���ˮ�Ż�ȡ������������룬�ӳɹ��ĳб���¼(funcflag=1)�в�ѯ
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
				cLogger.error("���ж��ˣ���ѯ������־ʧ�ܣ���ˮ��[" + tTranNoEle.getTextTrim() + "]");
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
            int tPremFen = Integer.valueOf(premStr);//��λ��
            mPrem += tPremFen;
            mCount ++;
        }
        mBufReader.close(); // �ر���
        mCountEle.setText(mCount + "");
        mPremEle.setText(mPrem + "");
        cLogger.info("Out JxnxsBusiBlc.parse()!");
        return mBodyEle;
    }

    public static void main(String[] args) throws Exception {
        Logger mLogger = Logger
                .getLogger("com.sinosoft.midplat.psbc.bat.CibBusiBlc.main");
        mLogger.info("����ʼ...");

        JxnxsBusiBlc mBatch = new JxnxsBusiBlc();

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

