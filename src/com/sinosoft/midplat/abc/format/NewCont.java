package com.sinosoft.midplat.abc.format;

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
	public NewCont(Element pThisConf) {
		super(pThisConf);
	}

	/* 
	 * 银行端非标准报文转换为标准报文
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Document mStdXml = null;
		
		//获取主险代码
		String mainRiskCode = XPath.newInstance("/Req/Risks/Risk/MainRiskCode").valueOf(pNoStdXml.getRootElement());
        
		// 农行上线的组合产品50001，银行端传递组合产品的主险代码122046，不传递产品组合码50001
		if("122046".equals(mainRiskCode)){ // 组合产品50001：122046-安邦长寿稳赢1号两全保险 + 122047-安邦附加长寿稳赢两全保险
			
			mStdXml = NewContIn50001.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-中国农业银行，进入NewContIn50001进行报文转换，产品组合编码contPlanCode=[50001]");
		}else{
			
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-中国农业银行，NewContInXsl进行报文转换，主险riskCode=[" + mainRiskCode + "]");
		}
        
		//获取套餐代码
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());
        if("50002".equals(planCode)){	// 安邦长寿稳赢保险计划两全保险

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
        
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;

	}

	/* 
	 * 核心标准报文转换为银行端非标准报文
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		Document mNoStdXml = null;
		
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
        
		if(null == tContPlanCode || "".equals(tContPlanCode)){	// 不是产品组合
			//获取主险代码
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());

			if("122035".equals(mainRiskCode) || "122036".equals(mainRiskCode)){
				// 122035-安邦盛世9号两全保险（万能型）,122036-安邦黄金鼎6号两全保险（分红型）A款
            	
				mNoStdXml = ContConfirmOutXsl4SpeFormat.newInstance().getCache().transform(pStdXml);
				cLogger.info("ABC-中国农业银行，进入ContConfirmOutXsl4SpeFormat进行报文转换，针对riskcode=[" + mainRiskCode + "]");
			}else{	// 传统模板
				
				mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
				cLogger.info("ABC-中国农业银行，NewContOutXsl进行报文转换，针对riskcode=[" + mainRiskCode + "]");
			}
		}else if("50001".equals(tContPlanCode)){	// 是组合产品
			mNoStdXml = ContConfirmOut50001.newInstance().getCache().transform(pStdXml);
			cLogger.info("ABC-中国农业银行，进入ContConfirmOut50001进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}else if("50002".equals(tContPlanCode)){
			mNoStdXml = ContConfirmOutXsl50002.newInstance().getCache().transform(pStdXml);
			cLogger.info("ABC-中国农业银行，进入ContConfirmOut50002进行报文转换，产品组合编码contPlanCode=[" + tContPlanCode + "]");
		}
		
		
		Element mMessages=mNoStdXml.getRootElement().getChild("Messages");
		Element mPrnts=mNoStdXml.getRootElement().getChild("Prnts");
		if(mMessages!=null){
			cLogger.info("给Messages下的count赋值");
			List mMessageList=mMessages.getChildren("Message");
			Element mCount=mMessages.getChild("Count");
			cLogger.info("Count====="+String.valueOf(mMessageList.size()));
			mCount.setText(String.valueOf(mMessageList.size()));
		}
		if(mPrnts!=null){
			cLogger.info("给Prnts下的count赋值");
			List mPrntList=mPrnts.getChildren("Prnt");
			cLogger.info("Count====="+String.valueOf(mPrntList.size()));
			Element mCount=mPrnts.getChild("Count");
			cLogger.info("Count object==="+mCount);
			mCount.setText(String.valueOf(mPrntList.size()));
		}

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	   public static void main(String[] args) throws Exception {
	        
	        Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/funcflag=401承保/out_std.xml"));
	    
		    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/funcflag=401承保/out_nostd.xml")));
		    out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
		    out.close();
		    System.out.println("******ok*********");
	    }
}