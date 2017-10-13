package com.sinosoft.midplat.cmb.format;

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
		 
		Document mStdXml = 
			CancelInXsl.newInstance().getCache().transform(pNoStdXml);
		Element BodyEle = mStdXml.getRootElement().getChild(Body);
		Element headEle = mStdXml.getRootElement().getChild(Head);
//		Element mContPrtNoEle = BodyEle.getChild(ContPrtNo);
		Element mProposalPrtNoEle = BodyEle.getChild(ProposalPrtNo);
        String mContNo = BodyEle.getChildText(ContNo);
		
        //根据保单号找到对应的投保单号，单证号
        StringBuffer mSqlStr = new StringBuffer();
        mSqlStr.append("select otherno, proposalprtno from TranLog ");
        mSqlStr.append(" where Rcode = 0 and Funcflag = 1001");
        mSqlStr.append("   and contno = '" + mContNo + "'");
        mSqlStr.append("   and trancom = " + headEle.getChildText(TranCom));
        mSqlStr.append("   and Makedate =" + DateUtil.getCur8Date());
        mSqlStr.append(" order by Maketime desc");
//        String mContPrtNo = null;
        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(mSqlStr.toString());
        if (ssrs.MaxRow > 0) {
//            mContPrtNo = ssrs.GetText(1, 1);
//            mContPrtNoEle.setText(ssrs.GetText(1, 1));
            mProposalPrtNoEle.setText(ssrs.GetText(1, 2));
        }else{
        	throw new MidplatException("未找到有效的保单，不能做撤单操作！");
        }
//        if (null == mContPrtNo || "".equals(mContPrtNo)) {
//            throw new MidplatException("未找到有效的保单，不能做撤单操作！");
//        }
	        
        cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = 
			CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}