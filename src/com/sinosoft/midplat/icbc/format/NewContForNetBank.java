package com.sinosoft.midplat.icbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContForNetBank extends XmlSimpFormat {
	
	public NewContForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.noStd2Std()...");
		//转换报文
		Document mStdXml = NewContInXslForNetBank.newInstance().getCache().transform(pNoStdXml);
		Element stdRootEle = mStdXml.getRootElement();

		//校验报文字段
		String tranCom = XPath.newInstance("//Head/TranCom").valueOf(stdRootEle);
		String errorMsg = CheckFieldManager.getInstance().verify(tranCom, mStdXml);
		if(errorMsg!=null){
		    throw new MidplatException(errorMsg);
		}
		
		//获取套餐代码
		String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(stdRootEle);
		//<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
		if( "50015".equals(contPlanCode)){
		    // 安邦长寿稳赢1号
		    Element insuYearFlag = (Element)XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(stdRootEle);
		    Element insuYear = (Element)XPath.newInstance("//Risk/InsuYear").selectSingleNode(stdRootEle);
		    //将保险期间重置为保5年
		    insuYearFlag.setText("Y");
		    insuYear.setText("5");
		}
		
		cLogger.info("Out NewContForNetBank.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");
		Document mNoStdXml = new NewCont(this.cThisBusiConf).std2NoStd(pStdXml);
		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:\\252482_331_27_outSvc.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:\\252482_331_27_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).std2NoStd(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}