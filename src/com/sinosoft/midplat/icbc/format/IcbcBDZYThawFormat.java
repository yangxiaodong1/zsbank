package com.sinosoft.midplat.icbc.format;

import java.io.FileInputStream;
import java.io.InputStream;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.midplat.icbc.IcbcUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcBDZYThawFormat extends XmlSimpFormat {
	public IcbcBDZYThawFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYThawFormat.noStd2Std()...");


		Document mStdXml = 
			IcbcBDZYThawFormatInXsl.newInstance().getCache().transform(pNoStdXml);

		
		
		//根据质押贷款查询交易，获取银行账户，账户名以供核心使用 
		 		Element mBodyEle = mStdXml.getRootElement().getChild(Body); 
		 	 
				String mContNo = XPath.newInstance("//Body/PubContInfo/ContNo").valueOf(mStdXml.getRootElement());	
				System.out.println("mContNo: "+mContNo);

		 		String mSqlStr = "select BAK2,BAK3 from TranLog where RCode=0 and funcflag='161' and BAK2 <> ' ' and BAK3 <> ' ' and rownum =1 and CONTNO='" + mContNo + "'";
					
				SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
				if (1 != mSSRS.MaxRow) {
					throw new MidplatException("质押前必须做质押贷款查询交易！");
				}
				 
				System.out.println("BankAccNo: "+mSSRS.GetText(1, 1)); 
				System.out.println("BankAccName: "+mSSRS.GetText(1, 2)); 
				String BankAccNo=  mSSRS.GetText(1, 1);
				String BankAccName=  mSSRS.GetText(1, 2);
		 	
		        mBodyEle.getChild("PubContInfo").getChild("BankAccNo").setText(BankAccNo);
		        mBodyEle.getChild("PubContInfo").getChild("BankAccName").setText(BankAccName);
		 
		
		
	
		cLogger.info("Out IcbcBDZYThawFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYThawFormat.std2NoStd()...");
		
		Document mNoStdXml = 
			IcbcBDZYThawFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		
		
		cLogger.info("Out IcbcBDZYThawFormat.std2NoStd()!");
		return mNoStdXml;
	}
}
