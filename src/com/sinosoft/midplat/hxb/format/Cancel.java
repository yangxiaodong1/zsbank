package com.sinosoft.midplat.hxb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Cancel extends XmlSimpFormat{

	private String appNo = "";	// 返回规银行的投保单号
	private String contNo = "";	// 返回给银行的合同号
	
	public Cancel(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Cancel.noStd2Std()...");
		
		Document mStdXml = CancelInXsl.newInstance().getCache().transform(pNoStdXml);
		
		JdomUtil.output(mStdXml, System.out);
		
		Element mBodyEle = mStdXml.getRootElement().getChild(Body);
		appNo = mBodyEle.getChildTextTrim(ProposalPrtNo);
		contNo = mBodyEle.getChildTextTrim(ContNo);
		
		cLogger.info("Out Cancel.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into Cancel.std2NoStd()...");
		
		Document mNoStdXml = CancelOutXsl.newInstance().getCache().transform(pStdXml);
		
		Element mainEle = mNoStdXml.getRootElement().getChild("MAIN");
			
		// 交易失败: 1 成功，0 失败
		if((appNo==null || appNo.equals("")) || (contNo==null || contNo.equals(""))){	// 投保单号不存在
			throw new MidplatException("未获取到投保单号、合同号信息");
		}else{
			// 保单号
			Element contNoEle = new Element("INSURNO");
			contNoEle.setText(contNo);
			mainEle.setContent(contNoEle);
			// 投保单号
			Element appNoEle = new Element("APPLYNO");
			appNoEle.setText(appNo);
			mainEle.addContent(appNoEle);
		}
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}


