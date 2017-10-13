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
     // 需根据传递的流水号获取地区及网点代码，从成功的承保记录(funcflag=1)中查询
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
			throw new MidplatException("查询上一交易日志失败！");
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
      //在返回信息中增加银行交易流水号
		Element rootNoStdEle = mNoStdXml.getRootElement();
		Element transrNoEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//MAIN/TRANSRNO");
		transrNoEle.setText(transrNo);
        cLogger.info("Out Cancel.std2NoStd()!");
        return mNoStdXml;
    }
}