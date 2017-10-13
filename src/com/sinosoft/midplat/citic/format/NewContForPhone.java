package com.sinosoft.midplat.citic.format;

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

public class NewContForPhone extends XmlSimpFormat {
	
	public NewContForPhone(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.noStd2Std()...");
		
		Document mStdXml = null;
		Element rootNoStdEle = pNoStdXml.getRootElement();
		
		/*
		 * 对银行端输入的报文进行校验.
		 * 因投保人、被保人国籍在转换非标准报文到标准包时，找不到对应值时会赋默认值：OTH，所以在未转换非标准报文前做非空校验。
		 */
		checkInNoStdDoc(pNoStdXml);
		
		//获取主险代码
        String mainRiskCode = XPath.newInstance("/Transaction/Transaction_Body/PbInsuType").valueOf(rootNoStdEle);
        //获取机构代码
        String bkBrchNo = XPath.newInstance("/Transaction/Transaction_Header/BkBrchNo").valueOf(rootNoStdEle);
        
        if("50015".equals(mainRiskCode)){// 走产品组合
        	
        	// 保终身, 组合产品50002，银行端传递保险年期为：终身，但是核心端校验认为保险年期为：5年（跟主险走）
			String tPbInsuYearFlag = XPath.newInstance("/Transaction/Transaction_Body/PbInsuYearFlag").valueOf(rootNoStdEle);
			if(null==tPbInsuYearFlag || "".equals(tPbInsuYearFlag)){
				throw new MidplatException("数据有误：保险年期类型不能为空!");
			}else if(!"1".equals(tPbInsuYearFlag)){	// 0：无关,1：终身,2：按年,3：按季,4：按月,5：按日,6：至某确定年龄

				throw new MidplatException("数据有误：保险期间应为终身!");
			}
		}
		
		mStdXml = NewContForPhoneInXsl.newInstance().getCache().transform(pNoStdXml);
		cLogger.info("CITIC_中信银行，NewContForPhoneInXsl进行报文转换，主险riskCode=[" + mainRiskCode + "]");
		
		//add 20160718 PBKINSR-1389  中信济南分行专属产品需求
		if("0125".equals(bkBrchNo.substring(0,4))|| "0141".equals(bkBrchNo.substring(0,4))||"0142".equals(bkBrchNo.substring(0,4))){//满足该条件为中信济南分行专属产品
        	//盛世2号
			if("122012".equals(mainRiskCode)){
        		Element rootEle = mStdXml.getRootElement();
            	Element riskCode = (Element)XPath.newInstance("//Risk/RiskCode").selectSingleNode(rootEle);
            	Element mainRiskCodeIn = (Element)XPath.newInstance("//Risk/MainRiskCode").selectSingleNode(rootEle);
            	riskCode.setText("L12098");//浙江分行专属产品盛世2号
            	mainRiskCodeIn.setText("L12098");//浙江分行专属产品盛世2号
        	}
        }  
		
		checkInStdDoc(mStdXml);
		
		cLogger.info("Out NewContForPhone.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForPhone.std2NoStd()...");
		
		Document mNoStdXml = null;

        mNoStdXml = NewContForPhoneOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out NewContForPhone.std2NoStd()!");
		return mNoStdXml;
	}
	
	/**
	 * 对银行端输入的报文进行校验
	 * @param cStdXml 未经转换成标准报文格式的报文，还是银行端格式的报文，
	 * 因为NewContIn.xsl文件中对投保人、被保人国籍为空的情况赋予了默认值，因此投保人、被保人国籍非空校验是对银行的非标准报文进行校验。
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		String retMsg = "";	// 返回信息
		Element mBodyEle = cNoStdXml.getRootElement().getChild("Transaction_Body");	// 中信银行交易报文体
		// 1. 投保人国籍不能为空
		String tAppNationality = mBodyEle.getChildText("PbNationality");	// 投保人国籍  
		retMsg = checkNationalityIsEmpty(tAppNationality);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("投保人" + retMsg);	
		}
		
		// 2. 被保人国籍不能为空
		String tInsuredNationality = mBodyEle.getChildText("LiNationality");	// 被保人国籍  
		retMsg = checkNationalityIsEmpty(tInsuredNationality);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("被保人" + retMsg);	
		}
		//保单递送方式需为电子发送
		String pbSendMode = mBodyEle.getChildText("PbSendMode");//保单递送方式
		retMsg = checkPbSendMode(pbSendMode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException(retMsg);	
		}
		
		//缴费账号不能为空
		String bkAcctNo1 = mBodyEle.getChildText("BkAcctNo1");//缴费账号不能为空
		retMsg = checkBkAcctNo1(bkAcctNo1);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException(retMsg);	
		}
	}
	
	/**
	 * 对银行端输入的报文进行校验
	 * @param cStdXml 已经转换成标准报文格式的报文
	 * @return
	 * @throws Exception
	 */
	private void checkInStdDoc(Document cStdXml) throws Exception {
		
		Element mBodyEle = cStdXml.getRootElement().getChild(Body);
		
		String tempIDTypeEndDate = "";	// 证件有效止期
		String retMsg = "";
		String tempEleCode = "";
		
		tempIDTypeEndDate = mBodyEle.getChild(Appnt).getChildText("IDTypeEndDate");	// IDTypeEndDate--证件有效止期
		// 1. 投保人证件有效期不能为空
		if(null == tempIDTypeEndDate || "".equals(tempIDTypeEndDate)){
//			tDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, "投保人的证件有效止期不能为空");
			throw new MidplatException("投保人的证件有效止期不能为空");
		}
		
		// 2. 投保人邮编校验：6位数字
		tempEleCode = mBodyEle.getChild(Appnt).getChildText(ZipCode);	// 投保人邮编
		retMsg = checkZipCode(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("投保人" + retMsg);	
		}
		
		// 3. 投保人证件类型为其它，自动核保不通过，需人工核保
		tempEleCode = mBodyEle.getChild(Appnt).getChildText(IDType);	// 投保人证件类型  
		retMsg = checkIDType(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("投保人" + retMsg);	
		}
		
		// 4. 被保人证件有效期不能为空
		tempIDTypeEndDate = mBodyEle.getChild(Insured).getChildText("IDTypeEndDate");	// IDTypeEndDate--证件有效止期
		if(null == tempIDTypeEndDate || "".equals(tempIDTypeEndDate)){
			throw new MidplatException("被保人的证件有效止期不能为空");
		}

		// 5. 被保人邮编校验：6位数字
		tempEleCode = mBodyEle.getChild(Insured).getChildText(ZipCode);	// 被保人邮编
		retMsg = checkZipCode(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("被保人" + retMsg);
		}
		
		// 6. 被保人证件类型为其它，自动核保不通过，需人工核保
		tempEleCode = mBodyEle.getChild(Insured).getChildText(IDType);	// 被保人邮编   
		retMsg = checkIDType(tempEleCode);
		if(!(null == retMsg || "".equals(retMsg))){
			throw new MidplatException("被保人" + retMsg);	
		}
		
		// 7. 被保人职业告知项校验
		String tJobNotice = mBodyEle.getChildText("JobNotice");	// JobNotice
		if(null == tJobNotice || "".equals(tJobNotice)){
			throw new MidplatException("职业告知项不能为空");
		}else if(tJobNotice.equals("Y")){
			throw new MidplatException("被保人属于拒保职业(危险职业)");
		}
	}
	
	/**
	 * 校验证件类型不能为空，且不能为'其它'，如果不是这两种情况返回null
	 * @param cempEleCode
	 * @return
	 */
	private String checkIDType(String cTempEleCode){
		
		if(null == cTempEleCode || "".equals(cTempEleCode)){
			return "证件类型不能为空";
		}else if(cTempEleCode.equals("8")){	// 8--证件类型：其它
			return "证件类型为其它，不允许投保";
		}
		return null;
	}
	
	private String checkNationalityIsEmpty(String cNationality){
		if(null == cNationality || "".equals(cNationality)){
			return "国籍不能为空";
		}
		return null;
	}
	/**
	 * 邮编为6位数字，如不是返回相应提示，如满足条件返回null
	 * @param cZipCode
	 * @return
	 */
	private String checkZipCode(String cZipCode){
		
		if(null == cZipCode || "".equals(cZipCode)){
			return "邮编不能为空";
		}else{
			if(cZipCode.length()!=6 || (!checkNumber(cZipCode))){
				return "邮编应为6位数字";
			}
			return null;
		}
	}
	/**
	 * 保单递送发送为电子发送
	 * @param pbSendMode
	 * @return
	 */
	private String checkPbSendMode(String pbSendMode){
		if(null == pbSendMode || "".equals(pbSendMode)){
			return "保单递送方式不能为空";
		}else{
			if(!"2".equals(pbSendMode)){
				return "保单递送方式应为电子发送";
			}
			return null;
		}
	}
	
	/**
	 * 保单递送发送为电子发送
	 * @param pbSendMode
	 * @return
	 */
	private String checkBkAcctNo1(String bkAcctNo1){
		if(null == bkAcctNo1 || "".equals(bkAcctNo1)){
			return "缴费账号不能为空";
		}
		return null;
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
	
    public static void main(String[] args) throws Exception{
    	
        /*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/1_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/1_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));*/
        
    	Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/citic/1101/2_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/citic/1101/2_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
    
}


