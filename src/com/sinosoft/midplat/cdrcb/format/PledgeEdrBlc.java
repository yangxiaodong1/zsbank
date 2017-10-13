package com.sinosoft.midplat.cdrcb.format;

import org.jdom.Document;
import org.jdom.Element;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PledgeEdrBlc extends XmlSimpFormat{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

	}
	public PledgeEdrBlc(Element pThisBusiConf) 
	{
		super(pThisBusiConf);
	}

	@Override
	public Document noStd2Std(Document pInNoStd) throws Exception 
	{
		cLogger.info("Into PledgeEdrBlc.noStd2Std()...");
        Document mStdXml = PledgeEdrBlcInxsl.newInstance().getCache().transform(
        		pInNoStd);

        cLogger.info("Out PledgeEdrBlc.noStd2Std()!");
        return mStdXml;
	}
}
