package com.sinosoft.midplat.cib.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

/**
 * 
 * @author guoxl
 * @desc ��ҵ��������ͨ�����˱����ݻش�����-����
 * @dete 2016-06-23 11:08:45
 *
 */

public class SurrenderDataReturn extends XmlSimpFormat {

	public SurrenderDataReturn(Element thisBusiConf) {
		super(thisBusiConf);
	}

	//�����еı���ת���ɱ��պ��ĵı�׼����
	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into load SurrenderDataReturn.noStd2Std()...");
		Document document = SurrenderDataReturnInXsl.newInstance().getCache().transform(pNoStdXml);
		cLogger.info("Out load SurrenderDataReturn.noStd2Std()!");
		
		return document;
	}
	
	//�����պ��ĵı���ת�������еı���
	public Document std2NoStd(Document pStdXml) throws Exception {
		
		cLogger.info("Into load SurrenderDataReturn.std2NoStd()...");
		
		Document document = SurrenderDataReturnOutXsl.newInstance().getCache().transform(pStdXml);
		
		cLogger.info("Out load SurrenderDataReturn.std2NoStd()!");
		
		return document;
	}
	
	
	
}
