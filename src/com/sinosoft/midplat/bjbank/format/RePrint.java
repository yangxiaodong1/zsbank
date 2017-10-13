package com.sinosoft.midplat.bjbank.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;

public class RePrint extends XmlSimpFormat {
	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");

		Document mStdXml = RePrintInXsl.newInstance().getCache().transform(
				pNoStdXml);
		//�������д�ContNo���ҷ���Cont�в��ProposalPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo from Cont where Type=0 and ContNo='" + mBodyEle.getChildText(ContNo) + "'";
		mBodyEle.getChild(ProposalPrtNo).setText(new ExeSQL().getOneValue(mSqlStr));
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into RePrint.std2NoStd()...");

		// �ش���µ����ر��Ļ�����ȫһ��������ֱ�ӵ���
		NewCont mNewCont = new NewCont(cThisBusiConf);
		Document mNoStdXml = mNewCont.std2NoStd(pStdXml);

		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
}
