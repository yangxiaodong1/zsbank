package com.sinosoft.midplat.jxnxs.format;

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


public class NewCont extends XmlSimpFormat {
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	private String transrNo = "";
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // 非标准报文
		
//		//50002银行必须录入为终身，银保通转换
//		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootNoStdEle);
//		if("122046".equals(riskCode)){
//			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(rootNoStdEle);
//			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(rootNoStdEle);
//			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
//				// 录入的不为保终身
//				throw new MidplatException("数据错误：该套餐保险期间为保终身");
//			}
//			// 保险期间设为保5年
//			insuYearFlag.setText("Y");
//			insuYear.setText("5");
//		}
//		//“被保人是否从事危险职业”，如果传Y是，则银保通校验不通过。
//		String jobNotice = XPath.newInstance("/INSU/BBR/BBR_METIERDANGERINF").valueOf(rootNoStdEle);
//		if("Y".equals(jobNotice)){
//			throw new MidplatException("银保通出单，被保险人有从事危险职业");
//		}
//		//“被保人是否有重疾”，如果传Y是，则银保通校验不通过。
//		String healthNotice = XPath.newInstance("/INSU/BBR/BBR_HEALTHINF").valueOf(rootNoStdEle);
//		if("Y".equals(healthNotice)){
//			throw new MidplatException("银保通出单，被保险人有重疾");
//		}
		String healthNotice = XPath.newInstance("//HEALTH_NOTICE/NOTICE_ITEM").valueOf(rootNoStdEle);
		//健康告知
		if("Y".equals(healthNotice)){
			throw new MidplatException("银保通出单，有健康告知项");
		}
		//被保险人职业为其它，不允许出单
		String jobCode = XPath.newInstance("//BBR/BBR_WORKCODE").valueOf(rootNoStdEle);
		if("8000010".equals(jobCode)) {
			throw new MidplatException("银保通出单，被保险人职业为“其它”，不允许出单");
		}
		
		transrNo = XPath.newInstance("//MAIN/TRANSRNO").valueOf(rootNoStdEle);
		cLogger.info("流水号为："+transrNo);
		mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		//50002银行必须录入为终身，银保通转换
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(mStdXml.getRootElement());
		//PBKINSR-636 江西农商银行上线新的盛2、新的盛3、鼎5，50002升级
		if("50015".equals(riskCode)){
			Element insuYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
			Element insuYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(mStdXml.getRootElement());
			if (!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())) {
				// 录入的不为保终身
				throw new MidplatException("数据错误：该套餐保险期间为保终身");
			}
			// 保险期间设为保5年
			insuYearFlag.setText("Y");
			insuYear.setText("5");
			
			//增加缴费年期校验
			Element payEndYearFlag = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayEndYearFlag").selectSingleNode(mStdXml.getRootElement());
			Element payEndYear = (Element) XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayEndYear").selectSingleNode(mStdXml.getRootElement());
			if (!"Y".equals(payEndYearFlag.getText()) || !"1000".equals(payEndYear.getText())) {
				// 录入的不为趸缴
				throw new MidplatException("数据错误：该套餐缴费年期为趸交");
			}
		}
		
		cLogger.info("JXNXS_江西农商行，进入NewContInXsl进行报文转换");
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		
		mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		Element rootNoStdEle = mNoStdXml.getRootElement();
		//在返回信息中增加银行交易流水号
		Element transrNoEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//MAIN/TRANSRNO");
		transrNoEle.setText(transrNo);
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("e:/13966_99_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("e:/13966_99_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}