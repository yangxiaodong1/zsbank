package com.sinosoft.midplat.cmbc.bat;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.bat.ABBalance;
import com.sinosoft.midplat.cmbc.CmbcConf;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;

public class CmbcBusiBlc extends ABBalance{

	public CmbcBusiBlc() {
        super(CmbcConf.newInstance(), 3004);
    }

    /* 
     * ���չ�˾����(00xx)+�ļ����ͣ�L�ʽ���ʣ�+8λ��������,����0024L20140809.txt
     * (non-Javadoc)
     * @see com.sinosoft.midplat.bat.ABBalance#getFileName()
     */
	protected String getFileName() {
		
		Element mBankEle = cThisConfRoot.getChild("bank");
		
		StringBuffer strBuff = new StringBuffer(mBankEle.getAttributeValue("insu")).append("L")
			.append(DateUtil.getDateStr(cTranDate, "yyyyMMdd")).append(".txt");
		
    	return  strBuff.toString();
    }
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.cmbc.bat.CmbcPeriodCancelBlc.main");
		mLogger.info("����ʼ...");

		CmbcBusiBlc mBatch = new CmbcBusiBlc();

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
