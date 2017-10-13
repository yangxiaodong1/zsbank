package com.sinosoft.midplat.hxb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class RePrint extends XmlSimpFormat{

	private String appNo = "";	// 返回规银行的投保单号
	
	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");
		
		Document mStdXml = RePrintInXsl.newInstance().getCache().transform(pNoStdXml);
		appNo = mStdXml.getRootElement().getChild(Body).getChildTextTrim(ProposalPrtNo);
		
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into RePrint.std2NoStd()...");
		
		//保单重打和投保交易返回报文完全一样
		Document mNoStdXml = new ContConfirm(cThisBusiConf).std2NoStd(pStdXml);
		
		Element mainEle = mNoStdXml.getRootElement().getChild("MAIN");
		Element mHeadEle = pStdXml.getRootElement().getChild(Head);
		if(String.valueOf(CodeDef.RCode_ERROR).equals(mHeadEle.getChildText(Flag))){	//1-交易失败
			if(appNo==null || appNo.equals("")){	// 投保单号不存在
				// do nothing...
			}else{
				Element appNoEle = new Element("APP");
				appNoEle.setText(appNo);
				mainEle.addContent(appNoEle);	
			}
		}
		
		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
	
}
