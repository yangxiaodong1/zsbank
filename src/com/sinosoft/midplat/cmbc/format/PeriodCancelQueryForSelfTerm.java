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

public class PeriodCancelQueryForSelfTerm extends XmlSimpFormat {

	public PeriodCancelQueryForSelfTerm(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForSelfTerm.noStd2Std()...");
		
		Document mStdXml = PeriodCancelQueryForSelfTermInXsl.newInstance().getCache().transform(pNoStdXml);

		cLogger.info("Out PeriodCancelQueryForSelfTerm.noStd2Std()!");
		return mStdXml;
	}
	
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PeriodCancelQueryForSelfTerm.std2NoStd()...");
		
		Document mNoStdXml = PeriodCancelQueryForSelfTermOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out PeriodCancelQueryForSelfTerm.std2NoStd()!");
		return mNoStdXml;
	}
	
    public static void main(String[] args) throws Exception{
        Document doc = JdomUtil.build(new FileInputStream("d:/677150_103_3005_in.xml"));
        BufferedWriter out = new BufferedWriter ( new OutputStreamWriter(new FileOutputStream("d:/677150_103_3005_out.xml")));
        out.write(JdomUtil.toStringFmt(new NewContForSelfTerm(null).noStd2Std(doc)));
        out.close();
        System.out.println("******ok*********");
    }
}

