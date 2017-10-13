package com.sinosoft.midplat.cmbc.format;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PeriodCancelQueryForNetBank extends XmlSimpFormat {

	public PeriodCancelQueryForNetBank(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForNetBank.noStd2Std()...");
		
		Document mStdXml = PeriodCancelQueryForNetBankInXsl.newInstance().getCache().transform(pNoStdXml);

		cLogger.info("Out PeriodCancelQueryForNetBank.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForNetBank.std2NoStd()...");
		
		Document mNoStdXml = PeriodCancelQueryForNetBankOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out PeriodCancelQueryForNetBank.std2NoStd()!");
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

