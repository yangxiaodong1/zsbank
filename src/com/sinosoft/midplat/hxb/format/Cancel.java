package com.sinosoft.midplat.hxb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.XmlSimpFormat;

public class Cancel extends XmlSimpFormat{

	private String appNo = "";	// ���ع����е�Ͷ������
	private String contNo = "";	// ���ظ����еĺ�ͬ��
	
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
			
		// ����ʧ��: 1 �ɹ���0 ʧ��
		if((appNo==null || appNo.equals("")) || (contNo==null || contNo.equals(""))){	// Ͷ�����Ų�����
			throw new MidplatException("δ��ȡ��Ͷ�����š���ͬ����Ϣ");
		}else{
			// ������
			Element contNoEle = new Element("INSURNO");
			contNoEle.setText(contNo);
			mainEle.setContent(contNoEle);
			// Ͷ������
			Element appNoEle = new Element("APPLYNO");
			appNoEle.setText(appNo);
			mainEle.addContent(appNoEle);
		}
		cLogger.info("Out Cancel.std2NoStd()!");
		return mNoStdXml;
	}
}


