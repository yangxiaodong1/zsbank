package com.sinosoft.midplat.icbczj.format;

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
import com.sinosoft.midplat.icbc.IcbcUtil;

/**   
 * @Title: WithdrawMoneyRollBack.java 
 * @Package com.sinosoft.midplat.icbczj.format 
 * @Description: 提现冲正交易 
 * @date Dec 18, 2015 1:32:36 PM 
 * @version V1.0   
 */

public class WithdrawMoneyRollBack extends XmlSimpFormat {

	// 银行的交易流水号，取银行请求报文的交易流水号，在给银行的应答报文中返回。
	private String tranNo = "";
	
	public WithdrawMoneyRollBack(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.noStd2Std()...");

		tranNo = XPath.newInstance("//transrefguid").valueOf(pNoStdXml.getRootElement());
		Document mStdXml = WithdrawMoneyRollBackInXsl.newInstance().getCache().transform(pNoStdXml);

		/*
		 * 浙江工行专属产品保单只能在浙江工行进行保单账号变更操作。
		 * 银保通系统根据地区码在“01202--01211”范围、且柜员代码为“231”来进行判断；
		 */
		String regionCode = XPath.newInstance("//regioncode").valueOf(pNoStdXml.getRootElement());
		String teller = XPath.newInstance("//teller").valueOf(pNoStdXml.getRootElement());
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller)))  {
			throw new MidplatException("非浙江工行专属渠道，不允许进行此交易！");
		}
		cLogger.info("Out WithdrawMoneyRollBack.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into WithdrawMoneyRollBack.std2NoStd()...");
		
		Document mNoStdXml = WithdrawMoneyRollBackOutXsl.newInstance().getCache().transform(pStdXml);
		Element tranNoEle = (Element)XPath.selectSingleNode(mNoStdXml.getRootElement(), "//ans/transrefguid");
		if(null !=tranNoEle ){
			tranNoEle.setText(tranNo);	
		}
		cLogger.info("Out WithdrawMoneyRollBack.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
        
        Document doc = JdomUtil.build(new FileInputStream("d:/139267_73_32_outSvc.xml"));
    
	    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("d:/139267_73_32_out.xml")));
	    out.write(JdomUtil.toStringFmt(new WithdrawMoneyRollBack(null).std2NoStd(doc)));
	    out.close();
	    System.out.println("******ok*********");
    }
}
