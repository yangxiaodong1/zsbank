package com.sinosoft.midplat.bjbank.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

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
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // 非标准报文
		
			
//		// 职业告知项:工行职业告知校验，若银行传"是"，则核保不通过，不传或者传"否"，则核保通过。
//		String jobNotice = XPath.newInstance("//OLifEExtension/OccupationIndicator").valueOf(rootNoStdEle);
//		if("Y".equals(jobNotice)){
//			throw new MidplatException("银保通出单，被保险人有职业告知事项");
//		}

		//银保通校验：“缴费形式”字段只能选择银行转账；
		//1：现金；
		//2：银行转账； //Risk[RiskCode=MainRiskCode]/RiskCode
		//由于北京银行这个字段不传值，不会存在现金的情况，所以不做此校验了
//		String payMode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/PayMode").valueOf(rootNoStdEle);
//		if("2".equals(payMode)){	
//			// donothing...
//		}else{
//			throw new MidplatException("“缴费形式”字段只能选择银行转账");
//		}
		//银保通校验：“账户姓名”与“投保人姓名”一致，银行默认投保人姓名为账户姓名
		//账户姓名
//		String accName = XPath.newInstance("/TranData/LCCont/AccName").valueOf(rootNoStdEle);
//		//投保人姓名
//		String appntName =  XPath.newInstance("/TranData/LCCont/LCAppnt/AppntName").valueOf(rootNoStdEle);
//		if(appntName != null && !"".equals(appntName.trim()) && accName != null && !"".equals(accName.trim())){
//			if(appntName.equals(accName)){	
//				// donothing...
//			}else{
//				throw new MidplatException("“账户姓名”与“投保人姓名”一致");
//			}
//		}else {
//			throw new MidplatException("“账户姓名”或“投保人姓名”为空值");
//		}
		mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		//50002银行必须录入为终身，银保通转换
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(mStdXml.getRootElement());
		//PBKINSR-673 北京银行盛2、盛3、50002产品升级
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
		}
		
		//获取险种代码个数，此处为还未转换为标准报文的银行报文
		
		
		cLogger.info("BJBANK_北京银行，进入NewContInXsl进行报文转换");
		
		//--------------------------------------------------------受益人与被保险人关系特殊处理 begin ----------------------------------------
		//此处需要特殊处理，由于北京银行传送受益人与被保险人关系为1父子、2父女、3母子、4母女，而保险公司对应的代码为01父母、03子女，无法转换
		//所以，先在xsl里均处理成01父母，在此处再特殊处理一下
		Element rootStdEle = mStdXml.getRootElement(); // 非标准报文
		//受益人与被保险人关系
		List bnfs =  XPath.selectNodes(rootStdEle, "/TranData/Body/Bnf[RelaToInsured=01]");
		//被保险人证件类型
		String insuredIDType = XPath.newInstance("/TranData/Body/Insured/IDType").valueOf(rootStdEle);
		//被保险人生日
		String insuredBirth = XPath.newInstance("/TranData/Body/Insured/Birthday").valueOf(rootStdEle);
			
		//证件类型为身份证
		if("0".equals(insuredIDType)){
			//被保险人证件号
			String insuredIDNo = XPath.newInstance("/TranData/Body/Insured/IDNo").valueOf(rootStdEle);
			
			if(insuredIDNo != null){
				//如果证件号为15位时，生日取6位，如果证件号为18位时，生日取8位
				if(insuredIDNo.length() == 15){
					insuredBirth = "19" + insuredIDNo.substring(6, 12);
				}else {
					insuredBirth = insuredIDNo.substring(6, 14);
				}
			}
			
			//受益人生日处理
			if(bnfs != null && bnfs.size() > 0){
				for(int i = 0 ; i < bnfs.size() ; i ++ ){
					Element bnf = (Element)bnfs.get(i);
					//受益人证件类型
					String bnfIDType = bnf.getChildText("IDType");
					//受益人证件号
					String bnfIDNo =  bnf.getChildText("IDNo");
					//受益人出生日期
					String bnfBirth = bnf.getChildText("Birthday");
					//证件类型为身份证
					if(bnfIDType != null && "0".equals(bnfIDType)){
						//如果证件号为15位时，生日取6位，如果证件号为18位时，生日取8位
						if(bnfIDNo.length() == 15){
							bnfBirth = "19" + bnfIDNo.substring(6, 12);
						}else {
							bnfBirth = bnfIDNo.substring(6, 14);
						}
					}
					
					if(insuredBirth != null && insuredBirth.length() > 0 && bnfBirth != null && bnfBirth.length() > 0){
						if(bnfBirth.compareTo(insuredBirth) > 0){

							//受益人比被保险人年龄小，关系为子女
							bnf.getChild("RelaToInsured").setText("03");
						}else {
							//受益人比被保险人年龄大，关系为父母
							bnf.getChild("RelaToInsured").setText("01");
						}
					}
				}
			}
		}
		//--------------------------------------------------------受益人与被保险人关系特殊处理 end ----------------------------------------
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		//交易成功标志
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		
		
//		String tContPlanCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
		// MODIFY 20140319 PBKINSR-311 合同模板打印不区分地区。
		//PBKINSR-673 北京银行盛2、盛3、50002产品升级
		if("50015".equals(tContPlanCode)){	
		    // 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{
			mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}
		
		
		
		//动态增加行数字段
		if (tFlag.equals("0")){
		    //成功返回的报文
			Element printEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print");
			Element print1Ele  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print/Print1");
		    // 增加总行数及行号
			List<Element> page1PrintList = print1Ele.getChildren("Page1Print");
			// 增加行号
            Element mRowNumEle1 = new Element("Page1Count");
            
            mRowNumEle1.setText(page1PrintList.size() + "");
            printEle.addContent(mRowNumEle1);
            
            // 增加总行数及行号
            Element print2Ele  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//TranData/LCCont/Print/Print2");
            // 增加行号
            Element mRowNumEle2 = new Element("Page2Count");
            if(print2Ele != null){
            	List<Element> page2PrintList = print2Ele.getChildren("Page2Print");
                mRowNumEle2.setText(page2PrintList.size() + "");
            }
            else {
            	mRowNumEle2.setText("0");
            }
			
            printEle.addContent(mRowNumEle2);
		}
		
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