package com.sinosoft.midplat.cgb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContZSBlc extends XmlSimpFormat{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

	}
	public NewContZSBlc(Element pThisBusiConf) 
	{
		super(pThisBusiConf);
	}

	@Override
	public Document noStd2Std(Document pInNoStd) throws Exception 
	{
		cLogger.info("Into NewContZSBlc.noStd2Std()...");
        Document mStdXml = NewContZSBlcInXsl.newInstance().getCache().transform(
        		pInNoStd);

        cLogger.info("Out NewContZSBlc.noStd2Std()!");
        return mStdXml;
	}
}

