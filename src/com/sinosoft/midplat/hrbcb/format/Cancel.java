package com.sinosoft.midplat.hrbcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
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
		
		Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);
        // 保单号
        Element mContNoEle = mBodyEle.getChild(ContNo);
        // 投保单号
        Element mProposalPrtNoEle = mBodyEle.getChild(ProposalPrtNo);

        StringBuffer tSqlStr2 = new StringBuffer();
        tSqlStr2.append("select contno, proposalprtno from TranLog where RCode=0 ");
        tSqlStr2.append(" and proposalprtno='" + mProposalPrtNoEle.getText() + "'");
        tSqlStr2.append(" and TranDate =" + DateUtil.getCur8Date());
        tSqlStr2.append(" and funcflag=2601");

        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(tSqlStr2.toString());
        if (ssrs.MaxRow > 0) {
            // 保单号
            mContNoEle.setText(ssrs.GetText(1, 1));
        } else {
            throw new MidplatException("查询上一交易日志失败！");
        }
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}

    public Document std2NoStd(Document outStd) throws Exception {
        cLogger.info("Into Cancel.std2NoStd()...");
         Document mNoStdXml = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");
        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }

}
