package com.sinosoft.midplat.cmb.format;

import java.io.FileInputStream;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PeriodCancel extends XmlSimpFormat {
	public PeriodCancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PeriodCancel.noStd2Std()...");
		Document mStdXml = PeriodCancelInXsl.newInstance().getCache()
				.transform(pNoStdXml);
		cLogger.info("Out PeriodCancel.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PeriodCancel.std2NoStd()...");

		Document mNoStdXml = PeriodCancelOutXsl.newInstance().getCache()
		.transform(pStdXml);
       
		cLogger.info("Out PeriodCancel.std2NoStd()!");
		return mNoStdXml;
	}
	
	public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("D:/工作文档/寿险银保通文档/招商银行/03XML报文实例/犹豫期撤单请求报文V1.0（安邦）.xml"));
        System.out.println(JdomUtil.toStringFmt(new PeriodCancel(null).noStd2Std(doc)));
    }
}
