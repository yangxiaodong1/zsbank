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
        // ������������ˮ�ţ����ô��ֶ�
        Element mContPrtNoEle = mBodyEle.getChild(ContPrtNo);
        // ������
        Element mContNoEle = mBodyEle.getChild(ContNo);
        // Ͷ������
        Element mProposalPrtNoEle = mBodyEle.getChild(ProposalPrtNo);

        StringBuffer tSqlStr2 = new StringBuffer();
        tSqlStr2.append("select otherno, contno, proposalprtno from TranLog where RCode=0 ");
        tSqlStr2.append(" and TranNo='" + mContPrtNoEle.getText() + "'");
        tSqlStr2.append(" and TranDate =" + DateUtil.getCur8Date());

        SSRS ssrs = new SSRS();
        ssrs = new ExeSQL().execSQL(tSqlStr2.toString());
        if (ssrs.MaxRow > 0) {
            // ����ӡˢ�ţ��ر�ע��һ�£����ش�󳷵�ʱ���˴�ȡ���ǳб��ĵ�֤�ţ����������µĵ�֤�ţ��������ճ�������ʱ�����Ļ���ʾ�õ�֤�Ѻ��������ճ������ɹ�
//            mContPrtNoEle.setText(ssrs.GetText(1, 1));
        	mContPrtNoEle.setText("");
            // ������
            mContNoEle.setText(ssrs.GetText(1, 2));
            // Ͷ������
            mProposalPrtNoEle.setText(ssrs.GetText(1, 3));
        } else {
            throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
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
