package com.sinosoft.midplat.cmb.format;

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

public class Query extends XmlSimpFormat {

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

		String  contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		
		if(null == contPlanCode || "".equals(contPlanCode)){	// 走非产品组合
			mNoStdXml = QueryOutXsl.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_招商银行，QueryOutXsl进行报文转换");
		}else{	 
			// 走产品组合
			cLogger.info("CMB_招商银行，进入QueryOutXslForPlan进行报文转换，产品组合编码contPlanCode=[" + contPlanCode + "]");
			if("50002".equals(contPlanCode)){
                // 安邦长寿稳赢1号两全保险

                //校验保险期间是否录入正确，本来应该核心系统校验，但是此套餐比较特殊
                Element insuYearFlag = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYearFlag").selectSingleNode(pStdXml.getRootElement());
                Element insuYear = (Element)XPath.newInstance("//Risk[RiskCode=MainRiskCode]/InsuYear").selectSingleNode(pStdXml.getRootElement());

                //将保险期间重置为保终身
                insuYearFlag.setText("Y");
                insuYear.setText("100");
            }
            
        	mNoStdXml = QueryOutXslForPlan.newInstance().getCache().transform(pStdXml);
		}

		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream(
        "D:/工作文档/寿险银保通文档/招商银行/03XML报文实例/675050_3838_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        System.out.println(JdomUtil.toStringFmt(new Query(null).std2NoStd(doc)));
    }
}
