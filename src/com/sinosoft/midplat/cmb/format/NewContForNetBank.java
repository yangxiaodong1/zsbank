package com.sinosoft.midplat.cmb.format;

import java.io.FileInputStream;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * @Title: com.sinosoft.midplat.cmb.format.NewContForNetBank.java
 * @Description: 招行网银新单试算交易
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Nov 17, 2014 1:59:36 PM
 * @version 
 *
 */
public class NewContForNetBank extends XmlSimpFormat {

	public NewContForNetBank(Element thisBusiConf) {
		super(thisBusiConf);
	}
	private String mult = "";
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
 
		//转换标准报文
		Document mStdXml = NewContForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		//modify liying begin
		//投保份数核心试算返回时有时为空，需要从请求报文里取值
		Element rootNoStdEle = mStdXml.getRootElement(); // 标准报文
		mult = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/Mult").valueOf(rootNoStdEle);
		//modify liying end
		
		//modify liying begin 修改122035产品附加险问题
		String riskCode = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootNoStdEle);
		//<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
		if("L12074".equals(riskCode)){
			List risks =  XPath.selectNodes(rootNoStdEle, "/TranData/Body/Risk");
			if(risks != null && risks.size() >1){
				// 网银出单不支持附加险
				throw new MidplatException("安邦盛世9号两全保险（万能型），网银出单暂不出售附加险！");
			}
		}
		//modify liying end 
		//modify 20160105 PBKINSR-1012 招行网银新增产品—长寿稳赢 begin
		//获取套餐代码
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());	
        //按套餐出单
        if("50015".equals(planCode)){
            // 安邦长寿稳赢1号两全保险
            //校验保险期间是否录入正确，本来应该核心系统校验，但是此套餐比较特殊
            Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(mStdXml.getRootElement());
            Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(mStdXml.getRootElement());
            if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
                //录入的不为保终身
                throw new MidplatException("数据有误：保险期间应为终身!"); 
            }
            //将保险期间重置为保5年
            insuYearFlag.setText("Y");
            insuYear.setText("5");
        }
        //modify 20160105 PBKINSR-1012 招行网银新增产品—长寿稳赢 end
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		//modify liying begin
		//判断投保份数，核心返回是否为0，如果是，则从请求报文中取值
		Element rootNoStdEle = pStdXml.getRootElement(); // 标准报文
		String stdMult = XPath.newInstance("/TranData/Body/Risk[RiskCode=MainRiskCode]/Mult").valueOf(rootNoStdEle);
		if(stdMult == null || "0".equals(stdMult)){
			Element multEle  = (Element) XPath.selectSingleNode(rootNoStdEle, "//TranData/Body/Risk[RiskCode=MainRiskCode]/Mult");
			multEle.setText(mult);
		}
		//modify liying end
		//套餐代码
		String  contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if(!"".equals(contPlanCode)){
		    //按套餐出单
			mNoStdXml = NewContForNetBankOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else{	
		    //按险种出单
			mNoStdXml =  NewContForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
        }
		

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/cmb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/cmb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).std2NoStd(doc)));*/
		
		System.out.println("******ok*********");
    }

}
