package com.sinosoft.midplat.cmb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Rollback extends XmlSimpFormat {

    public Rollback(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into Rollback.noStd2Std()...");
        
        Document mStdXml = RollbackInXsl.newInstance().getCache().transform(
                pNoStdXml);
        
        //招传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
        Element mRootEle = mStdXml.getRootElement();
        Element mHeadEle = mRootEle.getChild(Head);
        Element mBodyEle = mRootEle.getChild(Body);
        String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where TranCom=" + mHeadEle.getChildText(TranCom)
            + " and TranNo='" + mBodyEle.getChildText("OldTranNo") + "'"
            + " and TranDate=" + mHeadEle.getChildText(TranDate)
            + " and FuncFlag=1001"
            + " and Rcode=0";
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
        if (1 != mSSRS.MaxRow) {
            throw new MidplatException("查询上一交易日志失败！");
        }
        mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
        mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
        mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
        
        cLogger.info("Out Rollback.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into Rollback.std2NoStd()...");

        Document mNoStdXml = new Cancel(this.cThisBusiConf).std2NoStd(pStdXml);

        cLogger.info("Out Rollback.std2NoStd()!");
        return mNoStdXml;
    }
}
