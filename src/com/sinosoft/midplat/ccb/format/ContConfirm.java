package com.sinosoft.midplat.ccb.format;

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
	
	/*
	 *	银行非标准报文转换为核心标准报文  
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		String mPayMode = XPath.newInstance("/Transaction/Transaction_Body/BkPayMode").valueOf(pNoStdXml.getRootElement());
		
		if("1".equals(mPayMode)){
			/*
			 * 银保通出单，核心端记录的缴费方式为A（银行代扣），所以不用传递缴费方式给核心，且银保通不支持现金缴费。
			 * 1=现金,2=折代扣,3=卡代扣,9=对公代扣
			 */
			throw new MidplatException("银保通出单不支持现金缴费！");
		}
		Document mStdXml =  ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//建行传上一步流水号，我方从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		String mSqlStr = "select ProposalPrtNo, ContNo, OtherNo from TranLog where LogNo=" + mBodyEle.getChildText("OldLogNo");
		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr);
		if (1 != mSSRS.MaxRow) {
			throw new MidplatException("查询上一交易日志失败！");
		}
		mBodyEle.getChild(ProposalPrtNo).setText(mSSRS.GetText(1, 1));
		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		mBodyEle.getChild(ContPrtNo).setText(mSSRS.GetText(1, 3));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}
	
	/* 
	 * 核心标准报文转换为银行非标准报文
	 */
	@SuppressWarnings("unchecked")
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.std2NoStd()...");
		
		Document mNoStdXml = null;
		Element rootEle = pStdXml.getRootElement();
		
		// 获取产品组合代码
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(rootEle);
			
		if("50002".equals(tContPlanCode)){ 
		    // 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CCB_建设银行，进入ContConfirmOutXsl50002进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}else if("50006".equals(tContPlanCode)){ 
		    // 50006: 长寿智赢1号年金保险计划,2014-08-29停售
		    mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
		    cLogger.info("CCB_建设银行，进入ContConfirmOutXsl50006进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}else{
		    //按险种出单
		    // 获取主险的riskcode
		    String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(rootEle);
		    if(newTemplate(mainRiskCode)){ // 122035-安邦盛世9号两全保险（万能型）,L12052-安邦长寿智赢1号年金保险
		        
		        mNoStdXml = ContConfirmOutXsl122035.newInstance().getCache().transform(pStdXml);
		        cLogger.info("CCB_建设银行，进入ContConfirmOutXsl122035进行报文转换，产品编码riskCode=[" + mainRiskCode + "]");
		    }else{ // 其它险种走传统模板进行xml文件转换
		        
		        mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
		        cLogger.info("CCB_建设银行，进入ContConfirmOutXsl进行报文转换，产品编码riskCode=[" + mainRiskCode + "]");
		    }
		}
		
		List<Element> mDetail_list = mNoStdXml.getRootElement().getChild("Transaction_Body").getChildren("Detail_List");
		for (Element e : mDetail_list) {
			Element tDetail = e.getChild(Detail);
			Element tBkRecNum = e.getChild("BkRecNum");
			List<Element> tBkDetail1 = tDetail.getChildren("BkDetail1");
			tBkRecNum.setText(String.valueOf(tBkDetail1.size()));
		}
		
		cLogger.info("Out ContConfirm.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	/**
	 * 采用新的打印模板
	 * @param cRiskCode
	 * @return
	 */
	private boolean newTemplate(String cRiskCode){
		
		return ("122035".equals(cRiskCode) || "L12052".equals(cRiskCode));
	}
	public static void main(String[] args) throws Exception{

    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/ccb/2.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/22.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/

    	Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(new ContConfirm(null).std2NoStd(doc)));
        
        out.close();
        System.out.println("******ok*********");
        
    }
}
