package com.sinosoft.midplat.icbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.midplat.icbc.IcbcUtil;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

/**
 * @Title: com.sinosoft.midplat.icbc.format.IcbcNetBankTBEdrFormat.java
 * @Description: 工行网银退保确认交易
 * Copyright: Copyright (c) 2014
 * Company:安邦保险IT部
 * 
 * @date Jul 18, 2014 3:41:23 PM
 * @version 
 *
 */
public class IcbcNetBankTBEdrFormat extends XmlSimpFormat{
	
	public IcbcNetBankTBEdrFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcNetBankTBEdrFormat.noStd2Std()...");

		Document mStdXml = IcbcNetBankTBEdrFormatInXsl.newInstance().getCache().transform(pNoStdXml);
		/**
		 * 判断是否为浙江工行专属产品，如果是，则不需要进行该校验
		 * PBKINSR-818 浙江工行专项产品项目（一期）
		 */
		String regionCode = XPath.newInstance("//RegionCode").valueOf(pNoStdXml);
		String teller = XPath.newInstance("//Teller").valueOf(pNoStdXml);
		//非浙江工行专属产品
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller))){
			//申请书号
			XPath certifyCodePath = XPath.newInstance("//Certify/CertifyCode");
			String certifyCode = certifyCodePath.valueOf(mStdXml.getRootElement());
			if(certifyCode == null || certifyCode.trim().equals("")){
			    //银行没有传递了申请书号
			    
			    //交易码
			    XPath funcPath = XPath.newInstance("//Head/FuncFlag");

			    //保单号
			    XPath contNoPath = XPath.newInstance("//PubContInfo/ContNo");
			    String contNo = contNoPath.valueOf(mStdXml.getRootElement());

			    //保全申请日期
			    XPath tranDatePath = XPath.newInstance("//PubEdorInfo/EdorAppDate");
			    String tranDate = tranDatePath.valueOf(mStdXml.getRootElement());

			    //根据查询交易获取申请书号
			    StringBuffer tSqlStr = new StringBuffer();
			    tSqlStr.append("select otherno, contno from TranLog where RCode=0 ");
			    tSqlStr.append(" and contno='"+contNo+"'");
			    tSqlStr.append(" and TranDate =").append(DateUtil.date10to8(tranDate));
		        //网银犹退查询交易
		        tSqlStr.append(" and FuncFlag=132");
			    tSqlStr.append(" Order by MakeTime desc");

			    SSRS ssrs = new SSRS();
			    ssrs = new ExeSQL().execSQL( tSqlStr.toString());
			    if (ssrs.MaxRow > 0) {
			        Element certifyCodeEle = (Element)XPath.selectSingleNode(mStdXml.getRootElement(), "//Certify/CertifyCode");
			        certifyCodeEle.setText(ssrs.GetText(1, 1));
			    }else{
			        throw new MidplatException("查询上一交易日志失败！");
			    }
			}
		}
		
		cLogger.info("Out IcbcNetBankTBEdrFormat.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into IcbcNetBankTBEdrFormat.std2NoStd()...");

		Document mNoStdXml = null;
		String tMainRiskCode = XPath.newInstance("/TranData/Body/PubContInfo/ContPlanCode").valueOf(pStdXml.getRootElement());
		//PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级
		if("50002".equals(tMainRiskCode) || "50015".equals(tMainRiskCode)){
			/*
			 * 组合产品-50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成，
			 * 前五年50002这款产品的主险为122046，五年后这款主险的产品为122048,如果5年后做退保时核心传的主险险种便成了122048
			 */
			mNoStdXml = IcbcNetBankTBEdrFormatOutXsl50002.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_工商银行，进入IcbcNetBankTBEdrFormatOutXsl50002进行报文转换。");
			
		}else{	// 非组合产品
			mNoStdXml = IcbcNetBankTBEdrFormatOutXsl.newInstance().getCache().transform(pStdXml);
			
			cLogger.info("ICBC_工商银行，进入IcbcNetBankTBEdrFormatOutXsl进行报文转换。");
		}
		
		cLogger.info("Out IcbcNetBankTBEdrFormat.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args) throws Exception {
		
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/1_in.xml"));
//		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/11_out.xml")));
//		out.write(JdomUtil.toStringFmt(new IcbcNetBankTBEdrFormat(null).noStd2Std(doc)));
		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/icbc/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/icbc/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new IcbcNetBankTBEdrFormat(null).std2NoStd(doc)));
		
		out.close();
		System.out.println("******ok*********");
	}
}
