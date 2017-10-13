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

		//�㽭����ר����Ʒ����ֻ�����㽭���н��б����˺ű������������ͨϵͳ���ݵ������ڡ�01202--01211����Χ���ҹ�Ա����Ϊ��231���������жϣ�
		String regionCode = XPath.newInstance("//regioncode").valueOf(pNoStdXml.getRootElement());
		String teller = XPath.newInstance("//teller").valueOf(pNoStdXml.getRootElement());
		if("0".equals(IcbcUtil.zjCheck(regionCode, teller)))  {
			throw new MidplatException("���㽭����ר����������������д˽��ף�");
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
