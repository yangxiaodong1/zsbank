package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class ContConfirm extends XmlSimpFormat {
	
	//账户号
	Element accNum = new Element("AccountNumber");
	//账户名
	Element accName = new Element("AcctHolderName");
	
	public ContConfirm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into ContConfirm.noStd2Std()...");
		
		Document mStdXml = null;
		mStdXml = new NewCont(cThisBusiConf).noStd2Std(pNoStdXml);
		
		//保存账户信息，回传给招行
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		accName.setText(mBodyEle.getChildTextTrim(AccName));
		accNum.setText(mBodyEle.getChildTextTrim(AccNo));
		
		// removed PBKINSR-293 20140321
//		Document mStdXml = ContConfirmInXsl.newInstance().getCache().transform(pNoStdXml);
//		
//		// 根据投保单号从TranLog中查出ProposalPrtNo、ContNo、ContPrtNo
//		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
//		//保存账户信息，回传给招行
//		accName = (Element)mBodyEle.getChild("AcctHolderName").detach();
//		accNum = (Element)mBodyEle.getChild("AccountNumber").detach();
//		
//		StringBuffer mSqlStr = new StringBuffer();
//		mSqlStr.append("select ProposalPrtNo, ContNo, OtherNo,Makedate,Maketime from TranLog ");
//		mSqlStr.append(" where Rcode = '0' and Funcflag = '1000'");
//		mSqlStr.append("   and ProposalPrtNo = '"+mBodyEle.getChildText("ProposalPrtNo")+"'");
//		mSqlStr.append("   and Makedate ="+ DateUtil.getCur8Date());
//		mSqlStr.append(" order by Maketime desc");
//		
//		SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
//		if (mSSRS.MaxRow < 1) {
//			throw new MidplatException("查询上一交易日志失败！");
//		}
//		mBodyEle.getChild(ContNo).setText(mSSRS.GetText(1, 2));
		
		cLogger.info("Out ContConfirm.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into ContConfirm.Std2StdnoStd()...");
		
		Document mNoStdXml = null;

		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		if(null == tContPlanCode || "".equals(tContPlanCode)){	// 不是产品组合

			//获取主险代码
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
			if(newTemplate(mainRiskCode)){ // 122035-安邦盛世9号两全保险（万能型）,L12052-安邦长寿智赢1号年金保险
				mNoStdXml = ContConfirmOutXsl122035.newInstance().getCache().transform(pStdXml);
			} else { // 其他险种
				mNoStdXml = ContConfirmOutXsl.newInstance().getCache().transform(pStdXml);
			}
			cLogger.info("CMB_招商银行，进入ContConfirmOutXsl进行报文转换，主险险种riskCode=[" + mainRiskCode + "]");
			//PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级
		}else if("50015".equals(tContPlanCode)){
			// 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、安邦长寿添利终身寿险（万能型）组成
			
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_招商银行，进入ContConfirmOutXsl50002进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 20150723  增加安享3号组合产品   begin
		else if("50011".equals(tContPlanCode)){
			// 50011: L12068-安邦长寿安享3号年金保险、L12069-安邦附加长寿添利3号两全保险（万能型）组成		
			mNoStdXml = ContConfirmOutXsl50011.newInstance().getCache().transform(pStdXml);
			cLogger.info("CMB_招商银行，进入ContConfirmOutXsl50011进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		//add by duanjz 20150723  增加安享3号组合产品   end
		
		else if("50006".equals(tContPlanCode)){
            // 安邦长寿智赢1号,2014-08-29停售
            
            mNoStdXml = ContConfirmOutXsl50006.newInstance().getCache().transform(pStdXml);
            cLogger.info("CMB_招商银行，进入ContConfirmOutXsl50006进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
        }
		
		System.out.println(JdomUtil.toStringFmt(mNoStdXml));
	    
	    // 增加动态打印的行号等参数
		Element tBasePlanPrintInfosEle = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//BasePlanPrintInfos");
		if(tBasePlanPrintInfosEle!=null){
			//保单打印节点
			Element contPrintEle = (Element)tBasePlanPrintInfosEle.getChild("ContPrint").detach();
			//现金价值打印节点
			Element cashValueEle = (Element)tBasePlanPrintInfosEle.getChild("CashValue").detach();
			if(cashValueEle.getChildren("PrintInfo").size()>0){
				//打印现金价值表了
				int contLength = contPrintEle.getChildren("PrintInfo").size();
				//以固定行数为一页，进行换页，目前暂定66行为一页
				for(int i=66-contLength; i>0; i--){
					//将首页不够66行的，补空行
					Element mPrintInfoEle = new Element("PrintInfo");
					contPrintEle.addContent(mPrintInfoEle);
				}
			}
	
			//所有PrintInfo节点集中处理
			List<Element> tPrintInfoList = new ArrayList<Element>();
			tPrintInfoList.addAll(contPrintEle.getChildren("PrintInfo"));
			tPrintInfoList.addAll(cashValueEle.getChildren("PrintInfo"));
			for (int i = 0; i < tPrintInfoList.size(); i++) {
				Element tBasePlanPrintInfo = new Element("BasePlanPrintInfo");
				Element tPrintInfoEle = (Element) tPrintInfoList.get(i).detach();
				String info = tPrintInfoEle.getText();
				if(!"".equals(info.trim())){
					//非空行
					//@是特殊字符，招行解析时不会过滤开头的空格
					tPrintInfoEle.setText("@"+info);
				}
				tBasePlanPrintInfo.addContent(tPrintInfoEle);
				// 增加行号
				Element mInfoIndexEle = new Element("InfoIndex");
				mInfoIndexEle.setText(String.valueOf(i + 1));
				tBasePlanPrintInfo.addContent(mInfoIndexEle);
				tBasePlanPrintInfosEle.addContent(tBasePlanPrintInfo);
			}
	        
			//回传账户信息
			Element ePolicy = (Element) XPath.selectSingleNode(mNoStdXml.getRootElement(), "//OLife/Holding/Policy");
			if(ePolicy != null){
				ePolicy.addContent(9,accName);
				ePolicy.addContent(10,accNum);
			}
	        
		}
		cLogger.info("Out ContConfirm.Std2StdnoStd()!");
	
		return mNoStdXml;
	}

	/**
	 * 采用新的打印模板
	 * @param cRiskCode
	 * @return
	 */
	private boolean newTemplate(String cRiskCode){
		//PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级
		return ("L12074".equals(cRiskCode) || "L12052".equals(cRiskCode));
	}
	
    public static void main(String[] args) throws Exception {
        Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
        
        ContConfirm con = new ContConfirm(null);
        
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
                        new FileOutputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc_out.xml")));
        out.write(JdomUtil.toStringFmt(con.std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
