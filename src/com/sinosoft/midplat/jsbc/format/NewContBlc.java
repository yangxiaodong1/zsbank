package com.sinosoft.midplat.jsbc.format;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class NewContBlc extends XmlSimpFormat{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

	}
	public NewContBlc(Element pThisBusiConf) 
	{
		super(pThisBusiConf);
	}

	@Override
	public Document noStd2Std(Document pInNoStd) throws Exception 
	{
		cLogger.info("Into NewContBlc.noStd2Std()...");
        Document mStdXml = NewContBlcInxsl.newInstance().getCache().transform(
        		pInNoStd);

        //对账时，银行提供投保单号，银保通需要查出保单号给核心
//        
//        List<Element> detailList = XPath.selectNodes(mStdXml.getRootElement(), "//Detail");
//        if(detailList != null && detailList.size() > 0){
//        	for (Element detailEle : detailList) {
//        		StringBuffer mSqlStr = new StringBuffer();
//        	    mSqlStr.append("select ContNo from TranLog where Rcode = '0' and Funcflag = '3301' " +
//        	    		" and ProposalPrtNo = '"+ detailEle.getChildText(ProposalPrtNo)+"' " +
//        	    		" and TranNo=" + detailEle.getChildText("TranNo") +
//        	    		" and TranDate ='" + detailEle.getChildText(TranDate)+"' " +
//        	    				"order by Maketime desc");
//        	    SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//                if (mSSRS.MaxRow < 1) {
////                    throw new MidplatException("查询上一交易日志失败！");
//                }
//                else {
//                	detailEle.getChild(ContNo).setText(mSSRS.GetText(1, 1));
//                }
//        	}
//        }
        cLogger.info("Out NewContBlc.noStd2Std()!");
        return mStdXml;
	}
}
