package com.sinosoft.midplat.jsbc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.format.XmlSimpFormat;
public class NoRealTimeBlc extends XmlSimpFormat{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{

	}
	public NoRealTimeBlc(Element pThisBusiConf) 
	{
		super(pThisBusiConf);
	}

	@Override
	public Document noStd2Std(Document pInNoStd) throws Exception 
	{
		cLogger.info("Into NoRealTimeBlc.noStd2Std()...");
		
        Document mStdXml = NoRealTimeBlcInxsl.newInstance().getCache().transform(
        		pInNoStd);
//        cLogger.info(JdomUtil.toString(mStdXml));
        cLogger.info("Out NoRealTimeBlc.noStd2Std()!");
        return mStdXml;
	}
}
