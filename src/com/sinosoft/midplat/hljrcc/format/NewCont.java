package com.sinosoft.midplat.hljrcc.format;

import java.io.FileInputStream;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.hljrcc.format.NewCont;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
//		Element rootNoStdEle = pNoStdXml.getRootElement(); // 非标准报文
		
		// 信息校验
//		infoCheck(rootNoStdEle);
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element rootStdEle = mStdXml.getRootElement();
		
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(rootStdEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		//50002银行必须录入为终身，银保通转换
		// 50015：由50002升级为50015安邦长寿稳赢保险计划
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootStdEle);
		if("50015".equals(riskCode)){
			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(rootStdEle);
			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(rootStdEle);
			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
				// 录入的不为保终身
				throw new MidplatException("数据错误：该套餐保险期间为保终身");
			}
			// 保险期间设为保5年
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	
	private void infoCheck(Element tRootNoStdEle) throws Exception{
		
		String tSalary = XPath.newInstance("//Appnt/Salary").valueOf(tRootNoStdEle);
		
		if(StringUtils.isEmpty(tSalary)){
			throw new MidplatException("投保人年收入不能为空");
		}
		
		String tFamilySalary = XPath.newInstance("//Appnt/FamilySalary").valueOf(tRootNoStdEle);
		if(StringUtils.isEmpty(tFamilySalary)){
			throw new MidplatException("投保人家庭年收入不能为空");
		}
		String tLiveZone = XPath.newInstance("//Appnt/LiveZone").valueOf(tRootNoStdEle);

		if(StringUtils.isEmpty(tLiveZone)){
			throw new MidplatException("居民类型不能为空");
		}
		String tSalarySource = XPath.newInstance("//Appnt/SalarySource").valueOf(tRootNoStdEle);
		if(StringUtils.isEmpty(tSalarySource)){
			throw new MidplatException("投保人收入来源不能为空");
		}
		
		String tFamilySalarySource = XPath.newInstance("//Appnt/FamilySalarySource").valueOf(tRootNoStdEle);
		if(StringUtils.isEmpty(tFamilySalarySource)){
			throw new MidplatException("投保人家庭收入来源不能为空");
		}
		
		String tPremBudget = XPath.newInstance("//Appnt/PremBudget").valueOf(tRootNoStdEle);
		if(StringUtils.isEmpty(tPremBudget)){
			throw new MidplatException("投保人保费预算不能为空");
		}
		
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
   public static void main(String[] args) throws Exception {
	        Document doc = JdomUtil.build(new FileInputStream("D:/试算最新_in.xml"));
	        System.out.println(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
	        
	        Document doc1 = JdomUtil.build(new FileInputStream("D:/试算最新_out.xml"));
            System.out.println(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc1)));
	        
	    }
}