package com.sinosoft.midplat.hfbank.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class Query extends XmlSimpFormat{

	public Query(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Query.noStd2Std()...");
		Document mStdXml = QueryInXsl.newInstance().getCache().transform(pNoStdXml);
		
		
		cLogger.info("Out Query.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Query.std2NoStd()...");
		
		Element rootEle = pStdXml.getRootElement();
		
		//套餐代码
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){
		    //长寿稳赢套餐
		    //该套餐：银行为保终身，但我司主险险种为5年期，长寿稳赢需要特殊处理。
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(rootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(rootEle);
		    //将保险期间重置为保5年
		    insuYearFlag.setText("A");
		    insuYear.setText("106");
		}
		
		Document mNoStdXml = QueryOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
}
