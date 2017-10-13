package com.sinosoft.midplat.cmb.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.text.DecimalFormat;

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
 
		//转换标准报文
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		
		//获取套餐代码
        String planCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(mStdXml.getRootElement());
		
        //按套餐出单
        //PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级
        if("50015".equals(planCode)){
            // 安邦长寿稳赢1号两全保险

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

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");
		//套餐代码
		String  contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(pStdXml.getRootElement());
		Document mNoStdXml = null;
		if(!"".equals(contPlanCode)){
		    //按套餐出单
			mNoStdXml = NewContOutXslForPlan.newInstance().getCache().transform(pStdXml);
		}else{	
		    //按险种出单
		    mNoStdXml= NewContOutXsl.newInstance().getCache().transform(pStdXml);
        }

		cLogger.info("Out NewCont.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("C:/Documents and Settings/ab033862/桌面/abc.xml"));
		System.out.println(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));
		
		/*Document doc = JdomUtil.build(new FileInputStream("E:/YBT_test_doc/cmb/2_outSvc.xml"));
		BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("E:/YBT_test_doc/cmb/22_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).std2NoStd(doc)));*/
		
		
		System.out.println("******ok*********");
    }
}