package com.sinosoft.midplat.icbc.format;

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

public class NewCont extends XmlSimpFormat {
	
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement(); // 非标准报文
		

		//获取主险代码，此处为还未转换为标准报文的银行报文
		String mainRiskCode = XPath.newInstance("/TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/ProductCode").valueOf(rootNoStdEle);
		
			
		// 职业告知项:工行职业告知校验，若银行传"是"，则核保不通过，不传或者传"否"，则核保通过。
		String jobNotice = XPath.newInstance("//OLifEExtension/OccupationIndicator").valueOf(rootNoStdEle);
		if("Y".equals(jobNotice)){
			throw new MidplatException("银保通出单，被保险人有职业告知事项");
		}

		if("013".equals(mainRiskCode)){// 走产品组合,工行定义该产品代码为'013'
			// 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			
			String durationMode = XPath.newInstance("/TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/OLifEExtension/DurationMode").valueOf(rootNoStdEle);
			if("5".equals(durationMode)){	// 保险期限年期类型:1-保至某确定年龄,2-年保,3-月保,4-日保,5-保终身,9-其他
				// donothing...
			}else{
				throw new MidplatException("数据有误：保险期间应为终身!");
			}
			mStdXml = NewContInXsl50002.newInstance().getCache().transform(pNoStdXml);
			
			cLogger.info("ICBC_工商银行，进入NewContInXsl50002进行报文转换，产品组合编码contPlanCode=[50002]");
			
		}else{	// 不是组合产品50002
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			
			/*if("014".equals(mainRiskCode)){	// 银行端该险种编码='014',riskcode='122038'
				String tranCom = XPath.newInstance("//Head/TranCom").valueOf(mStdXml.getRootElement());
		        String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		        if(errorMsg!=null){
		            throw new MidplatException(errorMsg);
		        }
			}*/
			cLogger.info("ICBC_工商银行，进入NewContInXsl进行报文转换");
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		Document mNoStdXml = null;
		
		String tContPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		//交易成功标志
		Element tFlag  = (Element) XPath.selectSingleNode(pStdXml.getRootElement(), "//Head/Flag");
		
		// MODIFY 20140319 PBKINSR-311 合同模板打印不区分地区。
		if(null == tContPlanCode || "".equals(tContPlanCode)){	
		    // 不是产品组合
			String  mainRiskCode = XPath.newInstance("//Risk[RiskCode=MainRiskCode]/RiskCode").valueOf(pStdXml.getRootElement());
			
			if("122038".equals(mainRiskCode)){
				
				mNoStdXml = ContConfirmOutXsl4SpeFormat.newInstance().getCache().transform(pStdXml);
			}else{
				mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);	
			}
		//PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级
		}else if("50002".equals(tContPlanCode)||"50015".equals(tContPlanCode)){	
		    // 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);	
		}
		
		//动态增加行数字段
		if (tFlag.getValue().equals("0")){
		    //成功返回的报文
		    List<Element> tSubVoucherList = XPath.selectNodes(mNoStdXml.getRootElement(), "//SubVoucher");
		    // 增加总行数及行号
		    for (Element tSubVoucherEle : tSubVoucherList) {
		        List<Element> tTextContentList = tSubVoucherEle.getChild("Text").getChildren("TextContent");
		        Element tTextEle = tSubVoucherEle.getChild("Text");
		        for (int i = 0; i < tTextContentList.size(); i++) {
		            Element tTextContentEle = tTextContentList.get(i);
		            // 增加行号
		            Element mRowNumEle = new Element("RowNum");
		            mRowNumEle.setText(String.valueOf(i + 1));
		            tTextContentEle.addContent(mRowNumEle);
		        }
		        // 增加总行数
		        Element mRowTotalEle = new Element("RowTotal");
		        mRowTotalEle.setText(tTextContentList.size() + "");
		        tTextEle.addContent(mRowTotalEle);
		    }
		}
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("e:/13966_99_1_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("e:/13966_99_1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}