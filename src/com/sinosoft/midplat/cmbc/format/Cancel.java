package com.sinosoft.midplat.cmbc.format;

import org.jdom.Document;
import org.jdom.Element;

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
		
		/*需求变化，以银行传递的网点为准。
		 * Element mHeadEle = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
		if(mHeadEle.getChildText("SourceType").equals("1") || mHeadEle.getChildText("SourceType").equals("17")){
			
			 * 网银、手机银行走这段逻辑,SourceType=1 网上银行，SourceType=17 手机银行，
			 * 这段逻辑就是查询该交易的虚拟网点信息。
			 
			StringBuffer mSqlStr = new StringBuffer();
		    if(mHeadEle.getChildText("SourceType").equals("1")){	// 网银，签单funcflag=3006
		    	mSqlStr.append("select NodeNo from TranLog where Rcode = '0' and Funcflag = '3006' and ContNo = '"
			    		+ mBodyEle.getChildText(ContNo)
			    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate)
			    		+ "' order by Maketime desc");
		    }else if(mHeadEle.getChildText("SourceType").equals("17")){	// 手机银行，签单funcflag=3008
		    	mSqlStr.append("select NodeNo from TranLog where Rcode = '0' and Funcflag = '3008' and ContNo = '"
			    		+ mBodyEle.getChildText(ContNo)
			    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate)
			    		+ "' order by Maketime desc");
		    }
		    
	        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
	        if (mSSRS.MaxRow < 1) {
	            throw new MidplatException("查询上一交易日志失败！");
	        }
			// 网银、手机银行当日撤单使用的网点以网银签单时记录的为准。
			mHeadEle.getChild(NodeNo).setText(mSSRS.GetText(1, 1));
		}*/
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}
