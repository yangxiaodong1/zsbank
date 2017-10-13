package com.sinosoft.midplat.cgb.format;

import org.jdom.Document;
import org.jdom.Element;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class NewContBlc extends XmlSimpFormat{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

	}
	public NewContBlc(Element pThisBusiConf) 
	{
		super(pThisBusiConf);
	}

	@Override
	public Document noStd2Std(Document pInNoStd) throws Exception 
	{
		cLogger.info("Into NewContBlc.noStd2Std()...");
        Document mStdXml = NewContBlcInxsl.newInstance().getCache().transform(
        		pInNoStd);

        cLogger.info("Out NewContBlc.noStd2Std()!");
        return mStdXml;
	}
}
