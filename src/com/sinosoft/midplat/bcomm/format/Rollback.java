package com.sinosoft.midplat.bcomm.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.bcomm.format.Rollback.java
 * @Description: �Զ���������
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Feb 12, 2014 2:04:43 PM
 * @version 
 *
 */
public class Rollback extends XmlSimpFormat{

	public Rollback(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	// ������
	private String contNo = "";
	// ������ȡ���У�
	private String cancelAmt = "";
	
	/* 
	 * ���еķǱ�׼����ת��Ϊ���ĵı�׼����
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Rollback.noStd2Std()...");
		
		Element inNoStdRoot = pNoStdXml.getRootElement();
		this.cancelAmt = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Amt")).getText();	// ������ȡ���У�
		this.contNo = ((Element) XPath.selectSingleNode(inNoStdRoot,"K_TrList/KR_Idx1")).getText();	// ������

		Document mStdXml = RollbackInXsl.newInstance().getCache().transform(pNoStdXml);
		
		// ��ͨ���д���һ�����׵�������ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContPrtNo
		Element mRootEle = mStdXml.getRootElement();
		Element mHeadEle = mRootEle.getChild(Head);
		Element mBodyEle = mRootEle.getChild(Body);
		String str = mHeadEle.getChildText(TranCom);
		System.out.println(str);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where TranCom=" 
			+ mHeadEle.getChildText(TranCom)
			+ " and TranNo='" + mBodyEle.getChildText("OldTranNo") + "' "
			+ " and TranDate=" + mBodyEle.getChildText("OldTranDate");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		if(!mBodyEle.getChildText(ContNo).equals(mSSRS.GetText(1, 2))){
			throw new MidplatException("��ѯ��ͬ���뱣���ع���ͬ�Ų�һ�£�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out Rollback.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * ���ĵı�׼����ת��Ϊ���еķǱ�׼����
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Rollback.std2NoStd()...");
		
		// ���������뵱�ճ������ر�����ͬ�����ü���
		Cancel cancel = new Cancel(this.cThisBusiConf);
		
		Document mNoStdXml = cancel.std2NoStd(pStdXml);
		
		// ���ķ��ر����޾����㣬ʹ����������ֵ
		Element root = mNoStdXml.getRootElement();
		
		Element contNoEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Idx1");
		if (contNoEle != null) {
			contNoEle.setText(contNo);
		}
		
		Element cancelAmtEle = (Element) XPath.selectSingleNode(root,"K_TrList/KR_Amt");
		if (cancelAmtEle != null) {
			cancelAmtEle.setText(cancelAmt);
		}

		cLogger.info("Out Rollback.std2NoStd()!");
		return mNoStdXml;
	}

	public static void main(String[] args){
		
	}
	
}


