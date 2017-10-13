package com.sinosoft.midplat.hxb.bat;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.jdom.Element;

import com.sinosoft.midplat.bat.Balance;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.hxb.HxbConf;
import com.sinosoft.midplat.hxb.format.HxbConstant;

/**
 * @Title: com.sinosoft.midplat.hxb.bat.HxbAgentComBlc.java
 * @Description: ����������Ϣ����
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 22, 2014 6:14:26 PM
 * @version 
 *
 */
public class HxbAgentComBlc extends Balance{

	public HxbAgentComBlc() {
		super(HxbConf.newInstance(), 1506);	// ��������������Ϣ����
	}

	/* 
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		/*
		 * �ļ���������hxb_jgxx+ҵ�����ڣ�8λ��+.txt
		 * ���磺hxb_jgxx20140302.txt
		 */
		StringBuffer strBuffer = new StringBuffer();
		String strFile = strBuffer.append("hxb_jgxx").append(DateUtil.get8Date(cTranDate)).append(".txt").toString();
		return strFile;
	}
	
	/* �����ļ���ʽת��
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		/*
		 * ��������|�������|����ȫ��|��������|�ϼ���������|�ϼ��������
		 * 1�����ֶ��ԡ�|���ֿ���һ����¼һ�С�
		 * ���磺1453|����·֧��|����·֧��|֧��|1400|��������
		 * 0363|����֧��|����֧��|֧��|0300|�Ͼ�����
		 * 2���������𣺻������У������У������С�֧��
		 * 3������¼�����ֶ�Ϊ��ֵ������ʾΪ�ո������������ϼ��������������¼��ʾΪ��
		 * ���磺3041000|��������|��������|��������|  |  
		 */
		cLogger.info("Into HxbAgentComBlc.parse()...");
		
		String mCharset = cThisBusiConf.getChildText(charset);
		if (null==mCharset || "".equals(mCharset)) {
			mCharset = "GBK";
		}
		
		BufferedReader mBufReader = new BufferedReader(new InputStreamReader(pBatIs, mCharset));
		Element mBodyEle = new Element(Body);
		
		for (String tLineMsg; null != (tLineMsg=mBufReader.readLine());) {
			cLogger.info(tLineMsg);
			
			//���У�ֱ������
			tLineMsg = tLineMsg.trim();
			if ("".equals(tLineMsg)) {
				cLogger.warn("���У�ֱ��������������һ����");
				continue;
			}
			
			String[] tSubMsgs = tLineMsg.split("\\|", -1);
			
			Element mBankCodeEle = new Element(HxbConstant.BankCode);	// ������������
			mBankCodeEle.setText(tSubMsgs[0]);
			
			Element mBankShortNameEle = new Element(HxbConstant.BankShortName);	// �������
			mBankShortNameEle.setText(tSubMsgs[1]);
			
			Element mBankFullNameEle = new Element(HxbConstant.BankFullName);	// ����ȫ��
			mBankFullNameEle.setText(tSubMsgs[2]);
			
			Element mBankTypeEle = new Element(HxbConstant.BankType);	// ��������
			mBankTypeEle.setText(tSubMsgs[3]);
			
			Element mUpBankCodeEle = new Element(HxbConstant.UpBankCode);	// �ϼ���������
			mUpBankCodeEle.setText(tSubMsgs[4]);
			
			Element mUpBankShotNameEle = new Element(HxbConstant.UpBankShotName);	// �ϼ��������
			mUpBankShotNameEle.setText(tSubMsgs[5]);
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(mBankCodeEle);
			tDetailEle.addContent(mBankShortNameEle);
			tDetailEle.addContent(mBankFullNameEle);
			tDetailEle.addContent(mBankTypeEle);
			tDetailEle.addContent(mUpBankCodeEle);
			tDetailEle.addContent(mUpBankShotNameEle);
			
			mBodyEle.addContent(tDetailEle);
			JdomUtil.print(tDetailEle);//��ӡÿ��Detail
		}
		mBufReader.close();	//�ر���
		
		cLogger.info("Out HxbAgentComBlc.parse()!");
		
		return mBodyEle;
	}
	
}
