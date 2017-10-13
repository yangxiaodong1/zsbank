package com.sinosoft.midplat.cgb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CgbWithdrawMoney extends XmlSimpFormat {
		
	public CgbWithdrawMoney(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into CgbWithdrawMoney.noStd2Std()...");
	    
		Element noStdRoot = pNoStdXml.getRootElement();
		String policyNo = noStdRoot.getChild("Body").getChild("ContNo").getText();
		Document mStdXml = CgbWithdrawMoneyInXsl.newInstance().getCache().transform(pNoStdXml);	
		//���������޷�����������룬����ҵ����з�ȷ�ϣ�ȡ��������
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo,NodeNo from TranLog where TranCom = 22 and Funcflag = '2208' and Rcode = '0' " +
	    		" and ContNo = '"+ policyNo+"' " +
	    		" order by Maketime desc");
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (0 >= mSSRS.MaxRow) {
	       throw new MidplatException("��ѯ������Ϣʧ�ܣ�");
        }
        JdomUtil.print(mStdXml);
        System.out.println(mSSRS.GetText(1,2));
        Element mHeadEle = mStdXml.getRootElement().getChild(Head);
        mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1,2));
        
        Element mBodyEle = mStdXml.getRootElement().getChild(Body);
        mBodyEle.getChild("PubContInfo").getChild("PayGetBankCode").setText(mSSRS.GetText(1,2).substring(0, 10));
        
        //д������Ա����
        mHeadEle.getChild(TellerNo).setText("sys");
		JdomUtil.print(mStdXml);
		
		cLogger.info("Out CgbWithdrawMoney.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into CgbWithdrawMoney.std2NoStd()...");

        
        Document  mNoStdXml = CgbWithdrawMoneyOutXsl.newInstance().getCache().transform(pStdXml);
        
        
		cLogger.info("Out CgbWithdrawMoney.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/����/abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\����\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}

