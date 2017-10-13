package com.sinosoft.midplat.boc.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.boc.format.NewContInXsl;
import com.sinosoft.midplat.boc.format.TrialOutXsl;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Trial extends XmlSimpFormat {

	public Trial(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into Trial.noStd2Std()...");

		String payIntv = pNoStdXml.getRootElement().getChild(Body).getChild(Risk).getChildText("PayIntv");
		String riskCode = pNoStdXml.getRootElement().getChild(Body).getChild(Risk).getChildText("RiskCode");
		cLogger.info("���ִ��룺" + riskCode + "    �ɷѷ�ʽ:" + payIntv);
		if("122008".equals(riskCode) || "122009".equals(riskCode) || "122010".equals(riskCode)){
			if (null == payIntv || "".equals(payIntv)) {
				throw new MidplatException("�ɷѷ�ʽ ����¼�룡");
			} else if (!"0".equals(payIntv)) {
				throw new MidplatException("�ɷѷ�ʽ����Ϊ������");
			}
		}		
		
		Document mStdXml = NewContInXsl.newInstance().getCache().transform(pNoStdXml);

		cLogger.info("Out Trial.noStd2Std()!");
		return mStdXml;
	}
	
	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into Trial.std2NoStd()...");

		Document mNoStdXml = TrialOutXsl.newInstance().getCache().transform(pStdXml);

		cLogger.info("Out Trial.std2NoStd()!");
		return mNoStdXml;
	}
}