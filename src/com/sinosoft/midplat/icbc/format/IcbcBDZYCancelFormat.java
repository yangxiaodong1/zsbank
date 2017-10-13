package com.sinosoft.midplat.icbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class IcbcBDZYCancelFormat extends XmlSimpFormat {
	public IcbcBDZYCancelFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYCancelFormat.noStd2Std()...");
		
		Document mStdXml = 
			IcbcBDZYCancelFormatInXsl.newInstance().getCache().transform(pNoStdXml);
 	
//		//工行传上一步流水号，我方从TranLog中查出 FUNCFLAG ，根据 FUNCFLAG 获取 EdorType
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select FUNCFLAG from TranLog where RCode=0 and TRANNO='" + mBodyEle.getChildText("OldLogNo") + "'";
		
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		 
		System.out.println("FUNCFLAG: "+mSSRS.GetText(1, 1)); 
		String cFUNCFLAG=  mSSRS.GetText(1, 1);
		
 		if ("162".equals(cFUNCFLAG) ) {
 			mBodyEle.getChild("EdorType").setText("BL");
 		}else if ("163".equals(cFUNCFLAG)) {
 			mBodyEle.getChild("EdorType").setText("BD");
 		}
		
		 
		
		cLogger.info("Out IcbcBDZYCancelFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcBDZYCancelFormat.std2NoStd()...");
		
		Document mNoStdXml = 
			IcbcBDZYCancelFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out IcbcBDZYCancelFormat.std2NoStd()!");
		return mNoStdXml;
	}
}
