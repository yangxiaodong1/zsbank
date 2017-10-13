package com.sinosoft.midplat.icbczj.format;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;
import com.sinosoft.midplat.icbc.IcbcUtil;

public class IcbcZJAccountEdrFormat extends XmlSimpFormat {
	public IcbcZJAccountEdrFormat(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	private String tranNo = "";
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into IcbcZJAccountEdrFormat.noStd2Std()...");

		tranNo = XPath.newInstance("//transrefguid").valueOf(pNoStdXml.getRootElement());
		Document mStdXml = 
			IcbcZJAccountEdrFormatInXsl.newInstance().getCache().transform(pNoStdXml);

		//浙江工行专属产品保单只能在浙江工行进行保单账号变更操作。银保通系统根据地区码在“01202--01211”范围、且柜员代码为“231”来进行判断；
		String regionCode = XPath.newInstance("//regioncode").valueOf(pNoStdXml.getRootElement());
		String teller = XPath.newInstance("//teller").valueOf(pNoStdXml.getRootElement());
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller)))  {
			throw new MidplatException("非浙江工行专属渠道，不允许进行此交易！");
		}
		cLogger.info("Out IcbcZJAccountEdrFormat.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into IcbcZJAccountEdrFormat.std2NoStd()...");
		
		Document mNoStdXml = 
			IcbcZJAccountEdrFormatOutXsl.newInstance().getCache().transform(pStdXml);
		
		Element tranNoEle = (Element)XPath.selectSingleNode(mNoStdXml.getRootElement(), "//ans/transrefguid");
		tranNoEle.setText(tranNo);
		
		cLogger.info("Out IcbcZJAccountEdrFormat.std2NoStd()!");
		return mNoStdXml;
	}
}
