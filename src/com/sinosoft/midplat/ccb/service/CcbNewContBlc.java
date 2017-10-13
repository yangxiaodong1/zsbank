package com.sinosoft.midplat.ccb.service;

import java.util.LinkedList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.ccb.service.ClinentConTractBlc;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.service.NewContBlc;
import com.sinosoft.midplat.service.ServiceImpl;

public class CcbNewContBlc extends ServiceImpl {

	String cThreadName;

	public CcbNewContBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document service(Document pInXmlDoc) {
		cLogger.info("Into CcbNewContBlc.service()...");
		try {
			List<Document> xmlDocList = divideInXmlDoc(pInXmlDoc);
			Document cBusiBlcInXml = xmlDocList.get(0);              //��ȡ�µ����˱���
			Document cClientConTractBlcInXml = xmlDocList.get(1);    //��ȡǩԼ��Լ���˱���
			cThreadName = Thread.currentThread().getName();
			
			//�����µ������߳�
			new BusiBlcTread(cBusiBlcInXml).start(); 
			
			//����ǩԼ��Լ�����߳�
			new ClinentConTractBlcTread(cClientConTractBlcInXml).start();

		} catch (Exception ex) {
			cLogger.error("��ֶ��˽���ʧ��", ex);
		}

		cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");
		
		cLogger.info("Out CcbNewContBlc.service()!");
		return cOutXmlDoc;
	}

	private class BusiBlcTread extends Thread {
		private final Document cInXmlDoc;

		private BusiBlcTread(Document pInXmlDoc) {
			cInXmlDoc = pInXmlDoc;
		}

		public void run() {
			cLogger.info("Into BusiBlcTread.run()...");

			this.setName(cThreadName);
			Document mOutXmlDoc = new NewContBlc(cThisBusiConf).service(cInXmlDoc);
			JdomUtil.print(mOutXmlDoc);

			cLogger.info("Out BusiBlcTread.run()!");
		}
	}

	private class ClinentConTractBlcTread extends Thread {
		private final Document cInXmlDoc;

		private ClinentConTractBlcTread(Document pInXmlDoc) {
			cInXmlDoc = pInXmlDoc;
		}

		public void run() {
			cLogger.info("Into ClinentConTractBlcTread.run()...");
			
			// this.setName(cThreadName);
			Document mOutXmlDoc = new ClinentConTractBlc(cThisBusiConf).service(cInXmlDoc);
			JdomUtil.print(mOutXmlDoc);

			cLogger.info("Out ClinentConTractBlcTread.run()!");
		}
	}

	
	/**
	 * �ѽ���ҵ����˱��Ĳ��Ϊ��1���µ�����      2��ǩԼ��Լ����
	 * @param pNoStdXml
	 * @return
	 * @throws Exception
	 */
	protected List<Document> divideInXmlDoc(Document pNoStdXml)	throws Exception {
		cLogger.debug("Into CcbNewContBlc.divideInXmlDoc()...");

		List<Document> docList = new LinkedList<Document>();

		//�����ǩ���µ�����
		Element aTranEle = new Element("TranData");		
		Element aBodyEle = new Element("Body");
		Element aCountEle = new Element("Count");
		Element aPremEle = new Element("Prem");
		aBodyEle.addContent(aCountEle);
		aBodyEle.addContent(aPremEle);
		
		//�����ǩ��ǩԼ��Լ����
		Element bTranEle = new Element("TranData");		
		Element bBodyEle = new Element("Body");
		Element bCountEle = new Element("Count");		
		bBodyEle.addContent(bCountEle);
		
        //��֯�µ����˱���
		Element mBodyEle = pNoStdXml.getRootElement().getChild("Body");
		@SuppressWarnings("unchecked")
		List<Element> mDetailList = mBodyEle.getChildren("Detail");		
		int aCount = 0;
		int bCount = 0;
		int mPrem = 0;
		for (Element tDetailEle : mDetailList) {
			String txCode = tDetailEle.getChildText("TranType");
			Element tempE = (Element) tDetailEle.clone();
			if ("OPR011".equals(txCode)) {
				aBodyEle.addContent(tempE);
				aCount = aCount + 1;
				mPrem = mPrem + Integer.valueOf(tDetailEle.getChildText("Prem"));
			} else {

				bBodyEle.addContent(tempE);
				bCount = bCount + 1;
			}
		}
		aCountEle.setText(String.valueOf(aCount));
		aPremEle.setText(String.valueOf(mPrem));
		Document aDoc = new Document(aTranEle);
		aTranEle.addContent((Element) pNoStdXml.getRootElement().getChild("Head").clone()); //����ͷ
		aDoc.getRootElement().addContent(aBodyEle);//������
		docList.add(aDoc);
		
		//��֯ǩԼ��Լ���˱���
		bCountEle.setText(String.valueOf(bCount));		
		Document bDoc = new Document(bTranEle);	
		bTranEle.addContent((Element) pNoStdXml.getRootElement().getChild("Head").clone());//����ͷ
		bDoc.getRootElement().addContent(bBodyEle);	//������	
		docList.add(bDoc);

		cLogger.debug("Out CcbNewContBlc.divideInXmlDoc()...");
		
		return (List<Document>) docList;

	}

}
