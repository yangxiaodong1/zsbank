package com.sinosoft.midplat.abc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Trial extends XmlSimpFormat {
	public Trial(Element pThisConf) {
		super(pThisConf);
	}

	/**
	 * 银行的非标准报文-->核心的标准报文 
	 */
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Trial.noStd2Std()...");

		Document mStdXml = null;
		
		//获取主险代码
        String mainRiskCode = XPath.newInstance("/Req/Risks/Risk/MainRiskCode").valueOf(pNoStdXml.getRootElement());
        
        // 农行上线的组合产品50001，银行端传递组合产品的主险代码122046，不传递产品组合码50001
        if("122046".equals(mainRiskCode)){// 组合产品50001（122046-安邦长寿稳赢1号两全保险 + 122047-安邦附加长寿稳赢两全保险）
        	
        	mStdXml = NewContIn50001.newInstance().getCache().transform(pNoStdXml);
			cLogger.info("ABC-中国农业银行，进入NewContIn50001进行报文转换，产品组合编码contPlanCode=[50001]");
        }else{
        	
        	mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
        	cLogger.info("ABC-中国农业银行，NewContInXsl进行报文转换，主险riskCode=[" + mainRiskCode + "]");
        }
        
		// 对银行端输入的报文进行校验
		checkNoStdDoc(mStdXml);
		
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

		cLogger.info("Out Trial.noStd2Std()!");
		return mStdXml;
	}
	
	/**
	 * 对银行端输入的报文进行校验
	 * @param cStdXml
	 * @return
	 * @throws Exception
	 */
	private void checkNoStdDoc(Document cStdXml) throws Exception {
		
		Element mBodyEle = cStdXml.getRootElement().getChild(Body);
		String appIDTypeEndDate = "";	// 证件有效止期
		String retMsg = "";
		String insuIDTypeEndDate = "";
		
		appIDTypeEndDate = mBodyEle.getChild(Appnt).getChildText("IDTypeEndDate");	// IDTypeEndDate--投保人证件有效止期
		// 1. 投保人证件有效期不能为空
		if(null == appIDTypeEndDate || "".equals(appIDTypeEndDate)){
			throw new MidplatException("投保人的证件有效止期不能为空");
		}
		
		// 2. 投保人证件数字校验：8位数字
		retMsg = checkValidDate(appIDTypeEndDate);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("投保人" + retMsg);	
		}
		
		// 3. 被保人证件有效期不能为空
		insuIDTypeEndDate = mBodyEle.getChild(Insured).getChildText("IDTypeEndDate");	// IDTypeEndDate--被保人证件有效止期
		if(null == insuIDTypeEndDate || "".equals(insuIDTypeEndDate)){
			throw new MidplatException("被保人的证件有效止期不能为空");
		}
		
		// 4. 投保人证件数字校验：8位数字
		retMsg = checkValidDate(insuIDTypeEndDate);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("被保人" + retMsg);	
		}
		
	}
	
	/**
	 * 证件为8位数字，如不是返回相应提示，如满足条件返回null
	 * @param cZipCode
	 * @return
	 */
	private String checkValidDate(String cValidDate){
		
		if(null == cValidDate || "".equals(cValidDate)){
			return "证件不能为空";
		}else{
			if(cValidDate.length()!=8 || (!checkNumber(cValidDate))){
				return "证件应为8位数字";
			}
			return null;
		}
	}
	
	/**
	 * @Description: 判断输入的字符是否为数字；如果是返回true，否则返回false。如果输入字符串为空也返回false
	 * @param str 输入字符串
	 * @return
	 */
	private boolean checkNumber(String str){
		
			Pattern pattern = Pattern.compile("[0-9]*"); 
			if(!pattern.matcher(str).matches()){
				return false;
			}else{
				return true;
			}
	}

	/**
	 * 核心的标准报文-->银行的非标准报文
	 */
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Trial.std2NoStd()...");

		Document mNoStdXml = null;
		
		String  contPlanCode = XPath.newInstance("/TranData/Body/ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		
		if(null == contPlanCode || "".equals(contPlanCode)){	// 走非产品组合
			cLogger.info("ABC-中国农业银行，NewContOutXsl进行报文转换");
			mNoStdXml = TrialOutXsl.newInstance().getCache().transform(pStdXml);
		
		}else if("50001".equals(contPlanCode) || "50002".equals(contPlanCode)){	// 组合产品50001（122046-安邦长寿稳赢1号两全保险 + 122047-安邦附加长寿稳赢两全保险）
        	
			cLogger.info("ABC-中国农业银行，进入NewContOut50001进行报文转换，产品组合编码contPlanCode=[" + contPlanCode + "]");
			mNoStdXml = NewContOut50001.newInstance().getCache().transform(pStdXml);
		}
		
		cLogger.info("Out Trial.std2NoStd()!");
		return mNoStdXml;
	}
	
	
	public static void main(String[] args) throws Exception{
    	
        Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/funcflag=400试算/400_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/funcflag=400试算/400_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        
    	/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/abc/1101/2_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/abc/1101/2_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
        out.close();
        System.out.println("******ok*********");
    }
}