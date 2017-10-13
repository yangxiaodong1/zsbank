package com.sinosoft.midplat.cebbank.format;

import org.jdom.Document;
import org.jdom.Element;


import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class RePrint extends XmlSimpFormat {
	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		Document mStdXml = RePrintInXsl.newInstance().getCache().transform(
				pNoStdXml);	
		//���д�ContNo����ѯ�а��ɹ��ı���
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where FuncFlag = '901' and ContNo = '"+ mBodyEle.getChildText("ContNo")+"' ";
			
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
//		mBodyEle.getChild(ContPrtNo).setText(mBodyEle.getChildText("ContPrtNo"));			
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//�ش���µ����ر��Ļ�����ȫһ��������ֱ�ӵ���
		Document mNoStdXml = new NewCont(cThisBusiConf).std2NoStd(pStdXml);
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
}