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
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class ContConfirm extends XmlSimpFormat {

	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");

		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		Element mHeadEle = mStdXml.getRootElement().getChild(Head);
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		
        StringBuffer mSqlStr = new StringBuffer();
	    mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo from TranLog where Rcode = '0' and Funcflag = '3000' " 
	    		+ " and ContNo = '"+ mBodyEle.getChildText(ContNo) 
	    		+ "' and OtherNo= '"+ mBodyEle.getChildText(ContPrtNo)
	    		+ "' and Makedate ='" + mHeadEle.getChildText(TranDate) 
	    		+ "' order by Maketime desc");
	    
        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
        if (mSSRS.MaxRow < 1) {
            throw new MidplatException("查询上一交易日志失败！");
        }
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
//		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
//		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		
		//交易成功标志
		String tFlag = XPath.newInstance("/TranData/Head/Flag").valueOf(rootEle);
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		//PBKINSR-682 民生银行盛2、盛3、50002产品升级
		if("50015".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
		}
		//add by duanjz 2015-6-17 增加安邦长寿安享5号保险计划（50012） begin
		else if("50012".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50012.newInstance().getCache().transform(pStdXml);
		}
		//add by duanjz 2015-6-17 增加安邦长寿安享5号保险计划（50012） end
		//add by duanjz 2015-7-3 PBKINSR-737 增加安邦长寿安享3号保险计划50011 begin
		else if("50011".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
		}
		//add by duanjz 2015-7-3 PBKINSR-737 增加安邦长寿安享3号保险计划50011 end
		else{
			mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		}
		
		//动态增加行数字段
		if (tFlag.equals("0")){
            // 增加保单打印总行数
			Element printEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Prnts[Type=8]/Page");
			Element prtCountEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Prnts[Type=8]/Count");
            
			if(printEle != null){
				List<Element> pagePrintList = printEle.getChildren("Prnt");
				prtCountEle.setText(pagePrintList.size() + "");
			}else {
				prtCountEle.setText("0");
			}
			//PBKINSR-682 民生银行盛2、盛3、50002产品升级
			if("50015".equals(tContPlanCode)){
				Element msgPrintEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Messages[Type=9]/Page");
				Element msgCountEle  = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//RETURN/Messages[Type=9]/Count");
				
				if(msgPrintEle != null){
					List<Element> pageMessageList = msgPrintEle.getChildren("Message");
					msgCountEle.setText(pageMessageList.size() + "");
				}else {
					msgCountEle.setText("0");
				}
			}
		}
		if (tFlag.equals("0")){
			//民生不识别半角空格，这里将打印行中的空格全部替换为中文全角空格
			List<Element> prntValueList = XPath.selectNodes(mNoStdXml.getRootElement(), "//Prnts/Page/Prnt/Value");
			if(prntValueList != null){
				for(Element valueEle : prntValueList){
					String valueRep = valueEle.getText().replaceAll("  ", "　");
					valueEle.setText(valueRep);
				}
			}
			//PBKINSR-682 民生银行盛2、盛3、50002产品升级
			if("50015".equals(tContPlanCode)){
				List<Element> msgValueList = XPath.selectNodes(mNoStdXml.getRootElement(), "//Messages/Page/Message/Value");
				if(msgValueList != null){	
					for(Element valueEle : msgValueList){
						String valueRep = valueEle.getText().replaceAll("  ", "　");
						valueEle.setText(valueRep);
					}
				}
			}
		}
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:\\银保通项目\\测试报文\\50002\\测试打印模板_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
	}
}
