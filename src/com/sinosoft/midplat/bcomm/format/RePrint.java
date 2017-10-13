package com.sinosoft.midplat.bcomm.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.bcomm.format.ContConfirm;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class RePrint extends XmlSimpFormat{

	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	/* 
	 * �����д��ݵķǱ�׼����ת��Ϊ��׼����
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		
		Document mStdXml =RePrintInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element mHead = mStdXml.getRootElement().getChild(Head);
		// ��ͨ���д�contno���ҷ���tranlog�����в���ɹ��б��ı�������;	��ͨ�����շ�ǩ��,FuncFlag=1402
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from TranLog where FuncFlag = '1402' and ContNo = '"
			+ mBodyEle.getChildText(ContNo)
			+ "' and trandate="
			+ mHead.getChildText(TranDate)
			+ " and trancom="
			+ mHead.getChildText(TranCom)
			+ " and rcode=0";
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * �����Ĵ��ݵı�׼����ת��Ϊ���еķǱ�׼����
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//�ش���µ����ر��Ļ�����ȫһ��������ֱ�ӵ���
		ContConfirm mContConfirm = new ContConfirm(cThisBusiConf);
		Document mNoStdXml = mContConfirm.std2NoStd(pStdXml);
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args){
		
	}
}


