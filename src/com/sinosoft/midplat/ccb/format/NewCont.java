package com.sinosoft.midplat.ccb.format;

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

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	/* 
	 * 银行非标准报文转换为核心标准报文
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement();
		//获取主险代码，此处为还未转换为标准报文的银行报文
		String mainRiskCode = XPath.newInstance("/Transaction/Transaction_Body/PbInsuType").valueOf(rootNoStdEle);
		
		if("2046".equals(mainRiskCode)){// 走产品组合50002
			
			// 保终身, 组合产品50002，银行端传递保险年期为：终身，但是核心端校验认为保险年期为：5年（跟主险走）
			String tPbInsuYearFlag = XPath.newInstance("/Transaction/Transaction_Body/PbInsuYearFlag").valueOf(rootNoStdEle);
			if(null==tPbInsuYearFlag || "".equals(tPbInsuYearFlag)){
				throw new MidplatException("数据有误：保险年期类型不能为空!");
			}else if(!"1".equals(tPbInsuYearFlag)){	// 0：无关,1：终身,2：按年,3：按季,4：按月,5：按日,6：至某确定年龄

				throw new MidplatException("数据有误：保险期间应为终身!");
			}
			// 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
			mStdXml = NewContInXsl50002.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("CCB_建设银行，进入NewContInXsl50002进行报文转换，产品组合编码contPlanCode=[" + mainRiskCode + "]");
			
		}else{
			
			mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("CCB_建设银行，NewContInXsl进行报文转换，主险riskCode=[" + mainRiskCode + "]");
		}
		
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}
	
	/*
	 *	核心标准报文转换为银行非标准报文  
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		
		// 产品组合编码
		String contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if("50002".equals(contPlanCode)){	
			// 安邦长寿稳赢1号两全保险
			cLogger.info("CCB_建设银行，进入NewContOutXsl50002进行报文转换，产品组合编码contPlanCode=[" + contPlanCode + "]");
			mNoStdXml = NewContOutXsl50002.newInstance().getCache().transform(pStdXml);
		}else {   
		    // 其他产品
            mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);
            cLogger.info("CCB_建设银行，NewContInXsl进行报文转换");
        }
		
		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:\\Documents and Settings\\ab033862\\桌面\\abc.xml"));
		//BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/11_out.xml")));
		JdomUtil.output(new NewCont(null).noStd2Std(doc),System.out);
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/ccb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/ccb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
		
		//out.close();
		System.out.println("******ok*********");
    }
	
}


