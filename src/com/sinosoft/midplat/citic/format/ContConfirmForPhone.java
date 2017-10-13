package com.sinosoft.midplat.citic.format;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirmForPhone extends XmlSimpFormat {
	public ContConfirmForPhone(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirmForPhone.std2NoStd()...");
		
		Document mStdXml = ContConfirmForPhoneInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//�������д���һ����ˮ�ţ��ҷ���TranLog�в��ProposalPrtNo��ContNo��ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("��ѯ��һ������־ʧ�ܣ�");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirmForPhone.noStd2Std()!");
		return mStdXml;
	}
	
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirmForPhone.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		//��ȡ��Ʒ��ϴ���
        String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());

		mNoStdXml = ContConfirmForPhoneOutXsl.newInstance().getCache().transform(pStdXml);		
		
		cLogger.info("Out ContConfirmForPhone.std2NoStd()!");
		return mNoStdXml;
	}
    public static void main(String[] args) throws Exception{

    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/2.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/22.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/

    	Document doc = JdomUtil.build(new FileInputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\����ͨ��Ŀ\\���Ա���\\50002\\���Դ�ӡģ��_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
