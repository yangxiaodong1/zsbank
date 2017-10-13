package com.sinosoft.midplat.cmb.bat;

import org.apache.log4j.Logger;
import org.jdom.Element;

import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.cmb.service.CmbBalance;
import com.sinosoft.midplat.exception.MidplatException;

public class CmbReContBlc extends CmbBalance {
    
	public CmbReContBlc() {
		super(CmbConf.newInstance(), "1025");
	}
	
	protected Element getHead() {
		Element mHead = super.getHead();
		Element mBankCode = new Element("BankCode");
		mBankCode.setText(cThisConfRoot.getChild(TranCom).getAttributeValue(outcode));
		mHead.addContent(mBankCode);
		return mHead;
	}
	
	public static void main(String[] args) throws Exception {
		Logger mLogger = Logger
				.getLogger("com.sinosoft.midplat.cmbc.bat.CmbReContBlc.main");
		mLogger.info("����ʼ...");

		CmbReContBlc mBatch = new CmbReContBlc();
		
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
				Element headEle = mBatch.getHead();
				headEle.setAttribute("TranDate",args[0]);
			} else {
				throw new MidplatException("���ڸ�ʽ����ӦΪyyyyMMdd��" + args[0]);
			}
		}
		mBatch.run();
		if(mBatch.cResultMsg != null && !"".equals(mBatch.cResultMsg.trim())){
			
		}else{
			mBatch.cResultMsg = "��������ɣ���鿴��־��Ϣ��";
		}
		
		mLogger.info("�ɹ�������");
	}

	@Override
	protected String getFileName() {	
		// TODO Auto-generated method stub
		return "1";
	}

}

