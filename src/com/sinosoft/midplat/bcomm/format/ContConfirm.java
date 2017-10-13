package com.sinosoft.midplat.bcomm.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {

	private String mKr_TrType = "4";	// ���ѷ�ʽ,Ĭ��Ϊ��4=��ǿ�
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();
		
		mKr_TrType = ((Element) XPath.selectSingleNode(noStdRoot,"K_TrList/KR_TrType")).getTextTrim();
		/*
		 * 1. ���ѷ�ʽУ�飬�������ֽ�ɷѡ�
		 * �ֵ�˵����
		 * 0=�ֽ�,1=һ��ͨ,2=����,3=׼���ǿ����������ݲ�֧�֣�,4=��ǿ�,5=����֧Ʊ���������ݲ�֧�֣�,
		 * 7=����ƾ֤���������ݲ�֧�֣�,9=���˸��ѣ��������ݲ�֧�֣�,D=��λ֧Ʊ���������ݲ�֧�֣�
		 */
		if ("0".equals(mKr_TrType)) {
			throw new MidplatException("��֧���ֽ�ɷѣ���ѡ���������ѷ�ʽ");
		}
		
		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		Element mHead = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ContNo from TranLog where ");
        mSqlStr.append("  ProposalPrtNo='" + mBodyEle.getChildText(ProposalPrtNo)+"'");
        mSqlStr.append("  and trancom=" + mHead.getChildText(TranCom));
        mSqlStr.append("  and trandate=" + mHead.getChildText(TranDate));
        mSqlStr.append("  and rcode=0 order by Maketime desc");
        
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
		if (mSSRS.MaxRow <1) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 1));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");

		Document noStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		Element mRootEle = noStdXml.getRootElement();
		Element trTypeEle = (Element) XPath.selectSingleNode(mRootEle,"K_TrList/KR_TrType");
		if (trTypeEle != null) {
			trTypeEle.setText(mKr_TrType);
		}

		cLogger.info("Out ContConfirm.Std2StdnoStd()!");

		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		
		Document doc = JdomUtil.build(new FileInputStream("D:/test/BCOMM/����ʾ��life/bcomm_life_hexin_1_rtn.xml"));

		ContConfirm con = new ContConfirm(null);
		// con.noStd2Std(in);

		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/test/BCOMM/bcomm_life_cb002out.xml")));
		out.write(JdomUtil.toStringFmt(con.std2NoStd(doc)));
		out.close();
		System.out.println("******ok*********");
	}
}

