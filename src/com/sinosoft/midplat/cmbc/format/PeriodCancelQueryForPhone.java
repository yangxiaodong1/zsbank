package com.sinosoft.midplat.cmbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.check.CheckFieldManager;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PeriodCancelQueryForPhone extends XmlSimpFormat {

	public PeriodCancelQueryForPhone(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForPhone.noStd2Std()...");
		
		Document mStdXml = PeriodCancelQueryForPhoneInXsl.newInstance().getCache().transform(pNoStdXml);

		cLogger.info("Out PeriodCancelQueryForPhone.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForPhone.std2NoStd()...");
		
		Document mNoStdXml = PeriodCancelQueryForPhoneOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out PeriodCancelQueryForPhone.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/677150_103_3005_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/677150_103_3005_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForNetBank(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}
