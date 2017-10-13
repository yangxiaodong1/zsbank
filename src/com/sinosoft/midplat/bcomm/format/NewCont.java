package com.sinosoft.midplat.bcomm.format;

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

		Element noStdRoot = pNoStdXml.getRootElement();

		// FIXME 被保险人是未成年人时的累计风险这个标签要转化
		// 2. 职业告知项:交通银行职业告知校验，若银行传"是"，则核保不通过，不传或者传"否"，则核保通过。
		String insJobNotice = XPath.newInstance("//Ins/WorkFlag").valueOf(noStdRoot);
		if("1".equals(insJobNotice)){	// 被保人是否危险职业:0=否，1=是
			throw new MidplatException("银保通出单，被保险人有职业告知事项");
		}
		
		// 3. 银行端有职业告知项
		String jobNotice = XPath.newInstance("//Private/WorkFlag").valueOf(noStdRoot);
		if("Y".equals(jobNotice)){	// 职业告知标志: Y=是，N=否
			throw new MidplatException("银保通出单，有职业告知事项");
		}
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		
		Element mBodyEle = rootEle.getChild(Body);
		String accName = mBodyEle.getChildText(AccName);
		String accNo = mBodyEle.getChildText(AccNo);
		
		// 4. 其他付费方式账户不能为空
		if (accName == null || accName.trim().length() == 0 || accNo == null || accNo.trim().length() == 0) {
			throw new MidplatException("缴费账户号或账户名不能为空");
		}
		
		String contPlanCode = XPath.newInstance("//ContPlan/ContPlanCode").valueOf(rootEle);
		// 组合产品50002的保险年期为保终身，但是核心端定义的保险年期为以主险122046为依据，即保5年
		if ("50002".equals(contPlanCode)) {
			Element insuYearFlag = (Element) XPath.newInstance("//Risk/InsuYearFlag").selectSingleNode(rootEle);
			Element insuYear = (Element) XPath.newInstance("//Risk/InsuYear").selectSingleNode(rootEle);
			if (!"A".equals(insuYearFlag.getText())) {
				// 录入的不为保终身
				throw new MidplatException("数据错误：该套餐保险期间为保终身");
			}
			// 保险期间设为保5年
			insuYearFlag.setText("Y");
			insuYear.setText("5");
		}

		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewCont.std2NoStd()...");

		Document noStdXml = NewContOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewCont.std2NoStd()!");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("D:/679310_292_1401_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/679310_292_1401_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewCont(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
}