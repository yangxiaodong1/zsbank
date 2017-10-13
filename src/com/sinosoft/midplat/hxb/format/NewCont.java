package com.sinosoft.midplat.hxb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.lis.db.HxbankInfoDB;
import com.sinosoft.lis.db.HxbankManagerDB;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat{

	private String appNo = "";	// 返回规银行的投保单号
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* (non-Javadoc)
	 * @see com.sinosoft.midplat.format.XmlSimpFormat#noStd2Std(org.jdom.Document)
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		String tBankCode = "";	// 银行机构码
		String tBankMgrNo = "";	// 银行销售人员工号
		String tTranCom = "";	// 银行编码
		
		checkInNoStdDoc(pNoStdXml);
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();
		Element tBodyEle = stdRootEle.getChild(Body);
		
		//套餐代码
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
		if("50015".equals(tContPlanCode)){
		    //长寿稳赢套餐,套餐代码由50002升级为50015
		    //校验保险期间是否录入正确，本来应该核心系统校验，但是改套餐比较特殊
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
		    if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
		        //录入的不为保终身
		       throw new MidplatException("该套餐保险期间为保终身"); 
		    }
		    //将保险期间重置为保5年
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		    
		}
		
		appNo = tBodyEle.getChildTextTrim(ProposalPrtNo);
		tBankMgrNo = tBodyEle.getChildText("SellerNo");
		tTranCom = stdRootEle.getChild(Head).getChildTextTrim(TranCom);
		tBankCode = XPath.newInstance("//MAIN/BRNO").valueOf(pNoStdXml.getRootElement());		
		
		HxbankInfoDB tHxbankInfoDB = new HxbankInfoDB();
		tHxbankInfoDB.setBankCode(tBankCode);
		tHxbankInfoDB.setTranCom(tTranCom);
		tHxbankInfoDB.getInfo();
		if(null != tHxbankInfoDB){
			tBodyEle.getChild(AgentComName).setText(tHxbankInfoDB.getBankFullName());	// 设置银行网点全称
		}
		HxbankManagerDB tHxbankManagerDB = new HxbankManagerDB();
		tHxbankManagerDB.setBankCode(tBankCode);
		tHxbankManagerDB.setTranCom(tTranCom);
		tHxbankManagerDB.setManagerCode(tBankMgrNo);
		tHxbankManagerDB.getInfo();
		if(null != tHxbankManagerDB){
			tBodyEle.getChild("TellerCertiCode").setText(tHxbankManagerDB.getManagerCertifNo());	// 设置银行销售人员资格证号
			tBodyEle.getChild("TellerName").setText(tHxbankManagerDB.getManagerName());	// 设置银行销售人员名称
		}

		cLogger.info("Out NewCont.noStd2Std()...");
		return mStdXml;
	}
	
	
	/**
	 * 对银行端输入的报文进行校验
	 * @param cStdXml 未经转换成标准报文格式的报文，还是银行端格式的报文，
	 * 因为NewContIn.xsl文件中对投保人、被保人国籍为空的情况赋予了默认值，因此投保人、被保人国籍非空校验是对银行的非标准报文进行校验。
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		Element noStdRoot = cNoStdXml.getRootElement();
		
		/*
		 * 银现金缴费时银行不填写缴费账户户名，所以先交易缴费形式.
		 * 
		 * 1. 银保通校验不许现金缴费。 银行端缴费形式:C现金，T转帐
		 * 2. 银保通交易验证投保人和银行卡账户名必须是同一人
		 */
		String tPayMode = XPath.newInstance("//MAIN/PAYMODE").valueOf(noStdRoot);
		if(tPayMode.equals("C")){
			throw new MidplatException("银保通出单不支持现金缴费。");
		}
		
		// 投保人姓名
		String appName = XPath.newInstance("//TBR/TBR_NAME").valueOf(noStdRoot).trim();
		// 缴费账户户名
		String accName = XPath.newInstance("//MAIN/PAYNAME").valueOf(noStdRoot).trim();
		if(!appName.equals(accName)){
			throw new MidplatException("投保人与缴费账户户名不是同一人。");
		}
		
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document noStdXml = null;
		//套餐代码
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		if("50015".equals(tContPlanCode)){
			// 长寿稳赢套餐,由50002升级为50015
			noStdXml = NewContOut50002Xsl.newInstance().getCache().transform(pStdXml);
		}
		//add 20150807 增加安享3号和安享5号产品分支处理  begin
		else if("50011".equals(tContPlanCode)){//安享3号
			noStdXml = NewContOut50011Xsl.newInstance().getCache().transform(pStdXml);
		}else if("50012".equals(tContPlanCode)){//安享5号
			noStdXml = NewContOut50012Xsl.newInstance().getCache().transform(pStdXml);
		}
		//add 20150807 增加安享3号和安享5号产品分支处理  end
		else{
			noStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
		}

		Element mainEle = noStdXml.getRootElement().getChild("MAIN");
			
		// 交易状态: 1 成功，0 失败，无论成功失败都写入该字段
		if(appNo==null || appNo.equals("")){	// 投保单号不存在
			throw new MidplatException("未获取到投保单号信息");
		}else{
			Element appNoEle = new Element("APP");
			appNoEle.setText(appNo);
			mainEle.addContent(appNoEle);
		}

		cLogger.info("Out NewCont.std2NoStd()...");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
//		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/hxb/122010_1501_in.xml"));
//		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/hxb/122010_1501_out.xml")));
//		out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));

		
		Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/hxb/10033_3_0_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/hxb/10033_3_0_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
		out.close();
		System.out.println("******ok*********");
	}

}
