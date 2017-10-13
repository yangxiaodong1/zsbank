package com.sinosoft.midplat.bjrcb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewCont extends XmlSimpFormat {
	public NewCont(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	@SuppressWarnings("unchecked")
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");

		Element noStdRootEle = pNoStdXml.getRootElement();
		String jobNotice = XPath.newInstance("//PolicyInfo/DangerInf").valueOf(noStdRootEle).trim();
		String tCusAnnualIncome = XPath.newInstance("//PolicyHolder/CustomsGeneralInfo/CusAnnualIncome").valueOf(noStdRootEle).trim();
		
		if("Y".equals(jobNotice)){
			throw new MidplatException("银保通出单，被保人有危险职业告知"); 
		}
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();
		/*
		 * 该字段包含年收入+客户类型+家庭年收入；
		 * 规则：年收入和家庭年收入均为整数，拼接结果为123.0300009
		 * 结果中小数点前面为年收入，小数点后第一位是标志位，0为城镇1为农村；
		 * 整个字符串最后一位9为了防止系统自动将0去掉，所以最后一位的9是固定值无意义
		 * 123.0300009 年收入=123元，0城镇，家庭年收入=30000元
		 * 123.1300009 年收入=123元，1农村，家庭年收入=30000元
		 * 
		 * 投保人居住地：
		 * 银行：0为城镇，1为农村；核心：1为城镇，2为农村；
		 * 收入单位：
		 * 银行：元；核心：分
		 */
		if((tCusAnnualIncome!=null) && (!tCusAnnualIncome.equals(""))){
			String []tArray = tCusAnnualIncome.split("\\.");
			
			Element tAppntEle = stdRootEle.getChild(Body).getChild(Appnt);
			// 投保人年收入
			String tSalary = "";
			if((tArray[0]!=null) && (!tArray[0].equals(""))){
				tSalary = String.valueOf(NumberUtil.yuanToFen(tArray[0]));	
			}
			tAppntEle.getChild("Salary").setText(tSalary);
			
			// 投保人居住地
			String tLiveZone = "";
			if(tArray[1].substring(0, 1).equals("0")){	// 城镇
				tLiveZone = "1";	
			}else{	// 农村
				tLiveZone = "2";
			}
			tAppntEle.getChild("LiveZone").setText(tLiveZone);

			// 投保人家庭年收入
			String tFamilySalary = tArray[1].substring(1, (tArray[1].length()-1));
			if((tFamilySalary!=null) && (!tFamilySalary.equals(""))){
				tFamilySalary = String.valueOf(NumberUtil.yuanToFen(tFamilySalary));	
			}
			tAppntEle.getChild("FamilySalary").setText(tFamilySalary);
		}
		
		/*
		 * 组合产品50002(50015)的保险年期为保终身，但是核心端定义的保险年期为以主险122046为依据，即保5年
		 * 万能型产品进行改造，稳赢产品的套餐代码由50002编号为50015
		 */
		String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
		if("50015".equals(contPlanCode)){	// 组合产品50002(50015)
			
			//校验保险期间是否录入正确，本来应该核心系统校验，但是改套餐比较特殊
			Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
			Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
			if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
				//录入的不为保终身
				throw new MidplatException("数据错误：该套餐保险期间为保终身"); 
			}
			//将保险期间重置为保5年
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}
		
		//设置投保人职业代码
		Object appJobCodeEle = XPath.selectSingleNode(stdRootEle, "Body/Appnt/JobCode");
		if(appJobCodeEle !=null){
		    Element temp = (Element)appJobCodeEle;
		    String outCode = temp.getText();
		    temp.setText(NewContJobCode.newInstance().getJobCode(outCode));
		}
		
		//设置被保人职业代码
		Object insuJobCodeEle = XPath.selectSingleNode(stdRootEle, "Body/Insured/JobCode");
		if(insuJobCodeEle !=null){
		    Element temp = (Element)insuJobCodeEle;
		    String outCode = temp.getText();
		    temp.setText(NewContJobCode.newInstance().getJobCode(outCode));
		}
		cLogger.info("Out NewCont.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");

		Document mNoStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/906438_371_1200_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}