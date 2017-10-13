package com.sinosoft.midplat.hljrcc.format;

import java.io.FileInputStream;
import org.jdom.Document;
import org.jdom.Element;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
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
		Element BodyEle = mStdXml.getRootElement().getChild(Body);
		Element headEle = mStdXml.getRootElement().getChild(Head);
		Element mContPrtNoEle = BodyEle.getChild(ContPrtNo);
		Element mProposalPrtNoEle = BodyEle.getChild(ProposalPrtNo);
        String mProposalPrtNo=BodyEle.getChildText(ProposalPrtNo);
		
        //���ݱ������ҵ���Ӧ��Ͷ�����ţ���֤��
        StringBuffer mSqlStr = new StringBuffer();
        mSqlStr.append("select otherno, proposalprtno from TranLog where");
        mSqlStr.append(" Rcode = 0 and Funcflag = 2102 and");//�շ�ǩ��
        mSqlStr.append(" proposalprtno = '" + mProposalPrtNo + "'");
        mSqlStr.append(" and trancom = " + headEle.getChildText(TranCom));
        mSqlStr.append(" and trandate =" + DateUtil.getCur8Date());
        mSqlStr.append(" order by Maketime desc");
        
        String mContPrtNo = null;
        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(mSqlStr.toString());
        if (ssrs.MaxRow > 0) {
            mContPrtNo = ssrs.GetText(1, 1);
            mContPrtNoEle.setText(ssrs.GetText(1, 1));
            mProposalPrtNoEle.setText(ssrs.GetText(1, 2));
        }
        if (null == mContPrtNo || "".equals(mContPrtNo)) {
            throw new MidplatException("δ�ҵ���Ч�ı���������������������");
        }
	        
        cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
    public static void main(String[] args) throws Exception {

        Document doc = JdomUtil.build(new FileInputStream(
        "C:/Users/ab041120/Desktop/hljrcc/������ũ����-cancel.xml"));
        System.out.println(JdomUtil.toStringFmt(new Cancel(null)
                .noStd2Std(doc)));
        
        Document doc1 = JdomUtil.build(new FileInputStream(
        "C:/Users/ab041120/Desktop/hljrcc/������ũ����-cancelout.xml"));
        System.out.println(JdomUtil.toStringFmt(new Cancel(null)
        .std2NoStd(doc1)));
    }
}