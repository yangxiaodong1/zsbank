package com.sinosoft.midplat.cgb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class Cancel extends XmlSimpFormat {
    public Cancel(Element pThisBusiConf) {
        super(pThisBusiConf);
    }

    public Document noStd2Std(Document pNoStdXml) throws Exception {
        cLogger.info("Into Cancel.noStd2Std()...");

        Document mStdXml = CancelInXsl.newInstance().getCache().transform(
                pNoStdXml);
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);
        // 待冲正交易流水号，借用此字段
        Element mContPrtNoEle = mBodyEle.getChild(ContPrtNo);
        // 保单号
        Element mContNoEle = mBodyEle.getChild(ContNo);
        // 投保单号
        Element mProposalPrtNoEle = mBodyEle.getChild(ProposalPrtNo);

        StringBuffer tSqlStr2 = new StringBuffer();
        tSqlStr2.append("select otherno, contno, proposalprtno from TranLog where RCode=0 ");
        tSqlStr2.append(" and TranNo='" + mContPrtNoEle.getText() + "'");
        tSqlStr2.append(" and TranDate =" + DateUtil.getCur8Date());

        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(tSqlStr2.toString());
        if (ssrs.MaxRow > 0) {
            // 保单印刷号：特别注意一下：先重打后撤单时，此处取的是承保的单证号，而不是重新的单证号，在做当日撤单交易时，核心会提示该单证已核销，当日撤单不成功
//            mContPrtNoEle.setText(ssrs.GetText(1, 1));
        	mContPrtNoEle.setText("");
            // 保单号
            mContNoEle.setText(ssrs.GetText(1, 2));
            // 投保单号
            mProposalPrtNoEle.setText(ssrs.GetText(1, 3));
        } else {
            throw new MidplatException("查询上一交易日志失败！");
        }

        cLogger.info("Out Cancel.noStd2Std()!");
        return mStdXml;
    }

    public Document std2NoStd(Document pStdXml) throws Exception {
        cLogger.info("Into Cancel.std2NoStd()...");

        Document mNoStdXml = null;

        mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);

        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }
}
