package com.sinosoft.midplat.bjrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class Query extends XmlSimpFormat {
	public Query(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Query.noStd2Std()...");

		Document mStdXml = QueryInXsl.newInstance().getCache().transform(
				pNoStdXml);

		cLogger.info("Out Query.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Query.std2NoStd()...");

		// 查询和新单确认返回报文基本完全一样，所以直接调用
		ContConfirm mContConfirm = new ContConfirm(cThisBusiConf);
		Document mNoStdXml = mContConfirm.std2NoStd(pStdXml);

		cLogger.info("Out Query.std2NoStd()!");
		return mNoStdXml;
	}
}
