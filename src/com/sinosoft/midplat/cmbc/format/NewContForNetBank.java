package com.sinosoft.midplat.cmbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

/**   
 * @Title: NewContForNetBank.java 
 * @Package com.sinosoft.midplat.cmbc.format 
 * @Description: 民生银行网银新单试算交易 
 * @date Oct 9, 2015 9:37:15 AM 
 * @version V1.0   
 */

public class NewContForNetBank extends XmlSimpFormat {

	public NewContForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.noStd2Std()...");
		
		Document mStdXml = NewContForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		
//		JdomUtil.print(pNoStdXml);
		
		Element rootStdEle = mStdXml.getRootElement();
		//50002银行必须录入为终身，银保通转换
		String riskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootStdEle);
		
		//应核心要求,银保通增加 投保人年收入非空的校验
		//校验报文字段
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(rootStdEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		//PBKINSR-682 民生银行盛2、盛3、50002产品升级
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
		
		
		
		/**
		 * 修改民生银行投保人及被保险人地址及固定电话问题：把地址中的“-”统一替换空格；电话中的“-”统一去除
		 */
		 //处理民生的地址，替换“-”为空格

        List<Element> addressList = XPath.selectNodes(rootStdEle, "//Address");

        if (addressList != null) {

            for (Element valueEle : addressList) {

                String valueRep = valueEle.getText().replaceAll("-", " ");

                valueEle.setText(valueRep);

            }

        }
      //处理民生的电话，去除“-”

        List<Element> phoneList = XPath.selectNodes(rootStdEle, "//Phone");

        if (phoneList != null) {

            for (Element valueEle : phoneList) {

                String valueRep = valueEle.getText().replaceAll("-", "");

                valueEle.setText(valueRep);

            }

        }


		cLogger.info("Out NewContForNetBank.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");
		
		Document mNoStdXml = NewContForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/677150_103_3005_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/677150_103_3005_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
