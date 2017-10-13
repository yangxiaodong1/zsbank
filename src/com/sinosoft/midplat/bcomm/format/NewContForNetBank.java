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

/**   
 * @Title: NewContForNetBank.java 
 * @Package com.sinosoft.midplat.bcomm.format 
 * @Description: 交行网银新单试算交易处理 
 * @date Jan 5, 2016 3:52:22 PM 
 * @version V1.0   
 */

public class NewContForNetBank extends XmlSimpFormat {

	public NewContForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.noStd2Std()...");

		Element noStdRoot = pNoStdXml.getRootElement();

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
		
		Document mStdXml = NewContForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);
		Element rootEle = mStdXml.getRootElement();
		
		Element mBodyEle = rootEle.getChild(Body);
		String accName = mBodyEle.getChildText(AccName);
		String accNo = mBodyEle.getChildText(AccNo);
		
		// 4. 其他付费方式账户不能为空
		if (accName == null || accName.trim().length() == 0 || accNo == null || accNo.trim().length() == 0) {
			throw new MidplatException("缴费账户号或账户名不能为空");
		}
		
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into NewContForNetBank.std2NoStd()...");

		Document noStdXml = NewContForNetBankOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out NewContForNetBank.std2NoStd()!");
		return noStdXml;
	}

	public static void main(String[] args) throws Exception {
		Document doc = JdomUtil.build(new FileInputStream("D:/679310_292_1401_in.xml"));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:/679310_292_1401_out.xml")));
		out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).noStd2Std(doc)));

		out.close();
		System.out.println("******ok*********");
	}
}
