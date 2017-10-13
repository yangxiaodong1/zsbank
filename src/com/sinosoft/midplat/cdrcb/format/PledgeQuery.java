package com.sinosoft.midplat.cdrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class PledgeQuery extends XmlSimpFormat {
	public PledgeQuery(Element pThisConf) {
		super(pThisConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into PledgeQuery.noStd2Std()...");

		Document mStdXml = PledgeQueryInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out PledgeQuery.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into PledgeQuery.std2NoStd()...");
		
		Element mBodyEle = pStdXml.getRootElement().getChild(Body);
		if(mBodyEle != null){
			String tContState = mBodyEle.getChildText("ContState");
			if(!"00".equals(tContState)){
				throw new MidplatException("保单已失效或未生效！");
			}
		}

		Document mNoStdXml = PledgeQueryOutXsl.newInstance().getCache().transform(
				pStdXml);

		cLogger.info("Out PledgeQuery.std2NoStd()!");
		return mNoStdXml;
	}
}