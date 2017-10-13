package com.sinosoft.midplat.jlyh.format;

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
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewCont.noStd2Std()...");
		
		//校验
		checkInNoStdDoc(pNoStdXml);
		
		Document mStdXml =  NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		//套餐代码
		String tContPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		if("50015".equals(tContPlanCode)){
		    //长寿稳赢套餐，由50002升级为50015
		    //校验保险期间是否录入正确，本来应该核心系统校验，但是该套餐比较特殊
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(rootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(rootEle);
		    if(!"A".equals(insuYearFlag.getText()) || !"106".equals(insuYear.getText())){
		        //录入的不为保终身
		       throw new MidplatException("该套餐保险期间为保终身"); 
		    }
		    //将保险期间重置为保5年
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		    
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
	
	/**
	 * 对银行端输入的报文进行校验
	 * 不允许现金缴费
	 * 投保人和账户名一致
	 * @throws Exception
	 */
	private void checkInNoStdDoc(Document cNoStdXml) throws Exception{
		
		Element noStdRoot = cNoStdXml.getRootElement();
		
		String tPayMode = XPath.newInstance("//Risk/PayMode").valueOf(noStdRoot);
		if("1".equals(tPayMode)){
			throw new MidplatException("银保通出单不支持现金缴费。");
		}
		
		// 投保人姓名
		String appName = XPath.newInstance("//Appnt/Name").valueOf(noStdRoot).trim();
		// 缴费账户户名
		String accName = XPath.newInstance("//AccName").valueOf(noStdRoot).trim();
		if(!appName.equals(accName)){
			throw new MidplatException("投保人与缴费账户户名不是同一人。");
		}
		
		String jobNotice = XPath.newInstance("//Body/JobNotice").valueOf(noStdRoot).trim();
		if(jobNotice.equals("Y")){
			throw new MidplatException("银保通出单，被保险人有职业告知事项");
		}
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:/YBT_TEST/jlyh/122010_1800_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("D:/YBT_TEST/jlyh/122010_1800_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    	
    }
}
