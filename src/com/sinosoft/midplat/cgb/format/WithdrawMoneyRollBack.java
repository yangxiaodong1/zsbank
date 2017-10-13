package com.sinosoft.midplat.cgb.format;

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
import com.sinosoft.midplat.icbc.IcbcUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**   
 * @Title: WithdrawMoneyRollBack.java 
 * @Package com.sinosoft.midplat.cgb.format 
 * @Description: 提现冲正交易 
 * @date Dec 18, 2015 1:32:36 PM 
 * @version V1.0   
 */

public class WithdrawMoneyRollBack extends XmlSimpFormat {
	
	public WithdrawMoneyRollBack(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();
		String policyNo = noStdRoot.getChild("Body").getChild("ContNo").getText();
		
		Document mStdXml = WithdrawMoneyRollBackInXsl.newInstance().getCache().transform(pNoStdXml);
		JdomUtil.print(mStdXml);
		//由于银行无法传递网点代码，经过业务和行方确认，取出单网点
		StringBuffer mSqlStr = new StringBuffer();
		mSqlStr.append("select ProposalPrtNo,NodeNo from TranLog where TranCom = 22 and Funcflag = '2208' and Rcode = '0' " +
	    		" and ContNo = '"+ policyNo+"' " +
	    		" order by Maketime desc");
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (0 >= mSSRS.MaxRow) {
	       throw new MidplatException("查询保单信息失败！");
        }
        Element mHeadEle = mStdXml.getRootElement().getChild(Head);
        mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1,2));
        //写死操作员代码
        mHeadEle.getChild(TellerNo).setText("sys");
        
		cLogger.info("Out WithdrawMoneyRollBack.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.std2NoStd()...");
		
		Document mNoStdXml = WithdrawMoneyRollBackOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out WithdrawMoneyRollBack.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
        
        Document doc = JdomUtil.build(new FileInputStream("d:/139267_73_32_outSvc.xml"));
    
	    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("d:/139267_73_32_out.xml")));
	    out.write(JdomUtil.toStringFmt(new WithdrawMoneyRollBack(null).std2NoStd(doc)));
	    out.close();
	    System.out.println("******ok*********");
    }
}
