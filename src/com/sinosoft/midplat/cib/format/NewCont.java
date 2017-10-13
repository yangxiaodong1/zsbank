package com.sinosoft.midplat.cib.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;


import com.sinosoft.midplat.cib.format.NewContOutXsl50002;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;


public class NewCont extends XmlSimpFormat {
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // 非标准报文
		
		// 信息校验
		infoCheck(rootNoStdEle);
		
		mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootStdEle = mStdXml.getRootElement();
		//50002银行必须录入为终身，银保通转换
		// 长寿稳赢套餐，代码由50002升级为50015
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
		
		cLogger.info("CIB_兴业银行，进入NewContInXsl进行报文转换");
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	/**
	 * 对银行的报文进行基本数据校验
	 * @param tRootNoStdEle
	 * @throws Exception
	 */
	private void infoCheck(Element tRootNoStdEle) throws Exception{
		
		//“被保人是否从事危险职业”，如果传Y是，则银保通校验不通过。
		String jobNotice = XPath.newInstance("/INSU/BBR/BBR_METIERDANGERINF").valueOf(tRootNoStdEle);
		if("Y".equals(jobNotice)){
			throw new MidplatException("银保通出单，被保险人有从事危险职业");
		}
		//“被保人是否有重疾”，如果传Y是，则银保通校验不通过。
		String healthNotice = XPath.newInstance("/INSU/BBR/BBR_HEALTHINF").valueOf(tRootNoStdEle);
		if("Y".equals(healthNotice)){
			throw new MidplatException("银保通出单，被保险人有重疾");
		}
		healthNotice = XPath.newInstance("/HEALTH_NOTICE/NOTICE_ITEM").valueOf(tRootNoStdEle);
		//健康告知
		if("Y".equals(healthNotice)){
			throw new MidplatException("银保通出单，有健康告知");
		}
		String tPhone = XPath.newInstance("/INSU/TBR/TBR_TEL").valueOf(tRootNoStdEle);
		if(tPhone.length()>18){
			throw new MidplatException("银保通出单，投保人电话长度不能超过18位");
		}
		
		tPhone = XPath.newInstance("/INSU/BBR/BBR_TEL").valueOf(tRootNoStdEle);
		if(tPhone.length()>18){
			throw new MidplatException("银保通出单，被保人电话长度不能超过18位");
		}
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-626 兴业银行银保通上线新产品（盛世3号）
		//目前兴业银行只有50002一个产品，待将来有其他产品时再做判断
		// 长寿稳赢产品升级，代码由50002升级为50015
//		mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		if("50015".equals(tContPlanCode)){ 
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else {
			mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}
		//PBKINSR-626 兴业银行银保通上线新产品（盛世3号）
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/652406_710_0_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/dd_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}