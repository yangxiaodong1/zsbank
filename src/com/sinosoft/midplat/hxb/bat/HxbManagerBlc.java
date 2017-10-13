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
 * @Title: com.sinosoft.midplat.hxb.bat.HxbAgentBlc.java
 * @Description: �������пͻ�������Ϣ����
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 22, 2014 5:37:56 PM
 * @version 
 *
 */
public class HxbManagerBlc extends Balance{

	public HxbManagerBlc() {
		super(HxbConf.newInstance(), 1507);	// �������пͻ�������Ϣ����
	}
	
	/* 
	 * @see com.sinosoft.midplat.bat.Balance#getFileName()
	 */
	@Override
	protected String getFileName() {
		/*
		 * �ļ���������hxb_khjl +ҵ�����ڣ�8λ��+.txt
		 * ����: hxb_khjl20140302.txt
		 */
		StringBuffer strBuffer = new StringBuffer();
		String strFile = strBuffer.append("hxb_khjl").append(DateUtil.get8Date(cTranDate)).append(".txt").toString();
		return strFile;
	}
	
	/* �����ļ���ʽת��
	 * @see com.sinosoft.midplat.bat.Balance#parse(java.io.InputStream)
	 */
	protected Element parse(InputStream pBatIs) throws Exception {
		
		/*
		 * �ļ����ݸ�ʽ��������������|�ͻ��������|�ͻ���������|�ͻ������ʸ�֤���|�ʸ�֤����Ч��
		 * 1)���ֶ��ԡ�|���ֿ���һ����¼һ�С�
		 * ���磺0264|4181|����|20060911010090000820|2015102
		 * 0264|4182|����|20060911010090000821|20161021
		 * 2) ����¼�����ֶ�Ϊ��ֵ������ʾΪ�ո�
		 * 0261|4066|����|  |20160121
		 */
		cLogger.info("Into HxbManagerBlc.parse()...");
		
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
			
			Element mManagerCodeEle = new Element(HxbConstant.ManagerCode);	// �ͻ��������
			mManagerCodeEle.setText(tSubMsgs[1]);
			
			Element mManagerNameEle = new Element(HxbConstant.ManagerName);	// �ͻ���������
			mManagerNameEle.setText(tSubMsgs[2]);
			
			Element mManagerCertifNoEle = new Element(HxbConstant.ManagerCertifNo);	// �ͻ������ʸ�֤���
			mManagerCertifNoEle.setText(tSubMsgs[3]);
			
			Element mEndDateEle = new Element(HxbConstant.CertifEndDate);	// �ʸ�֤����Ч��
			mEndDateEle.setText(tSubMsgs[4]);
			
			Element tDetailEle = new Element(Detail);
			tDetailEle.addContent(mBankCodeEle);
			tDetailEle.addContent(mManagerCodeEle);
			tDetailEle.addContent(mManagerNameEle);
			tDetailEle.addContent(mManagerCertifNoEle);
			tDetailEle.addContent(mEndDateEle);
			
			mBodyEle.addContent(tDetailEle);
			JdomUtil.print(tDetailEle);//��ӡÿ��Detail
		}
		mBufReader.close();	//�ر���
		
		cLogger.info("Out HxbManagerBlc.parse()!");
		
		return mBodyEle;
	}
	
	
}


