package com.sinosoft.midplat.jxnxs.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Cancel extends XmlSimpFormat {
    public Cancel(Element pThisBusiConf) {
        super(pThisBusiConf);
    }
    private String transrNo = "";
    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into Cancel.noStd2Std()...");
        transrNo = XPath.newInstance("/MAIN/TRANSRNO").valueOf(pNoStdXml.getRootElement());
        Document mStdXml = CancelInXsl.newInstance().getCache().transform(
                pNoStdXml);
     // ����ݴ��ݵ���ˮ�Ż�ȡ������������룬�ӳɹ��ĳб���¼(funcflag=1)�в�ѯ
        Element mRootEle = mStdXml.getRootElement();
		Element mHeadEle = mRootEle.getChild(Head);
		Element mBodyEle = mRootEle.getChild(Body);
        String mSqlStr = "select ProposalPrtNo, ContNo from TranLog where TranNo=" + mBodyEle.getChildText("OldLogNo")
		+ " and TranDate=" + mHeadEle.getChildText(TranDate)
		+ " and TranCom=" + mHeadEle.getChildText(TranCom)
		+ " and ProposalPrtNo=" + mBodyEle.getChildText(ProposalPrtNo)
		+ " and FuncFlag=2501"
        + " and Rcode=0";
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
        cLogger.info("Out Cancel.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into Cancel.std2NoStd()...");
        Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(
                pStdXml);
      //�ڷ�����Ϣ���������н�����ˮ��
		Element rootNoStdEle = mNoStdXml.getRootElement();
		Element transrNoEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//MAIN/TRANSRNO");
		transrNoEle.setText(transrNo);
        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }
}