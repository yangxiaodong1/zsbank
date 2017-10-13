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
			Document cBusiBlcInXml = xmlDocList.get(0);              //获取新单对账报文
			Document cClientConTractBlcInXml = xmlDocList.get(1);    //获取签约解约对账报文
			cThreadName = Thread.currentThread().getName();
			
			//启动新单对账线程
			new BusiBlcTread(cBusiBlcInXml).start(); 
			
			//启动签约解约对账线程
			new ClinentConTractBlcTread(cClientConTractBlcInXml).start();

		} catch (Exception ex) {
			cLogger.error("拆分对账交易失败", ex);
		}

		cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");
		
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
	 * 把建行业务对账报文拆分为：1、新单对账      2、签约解约对账
	 * @param pNoStdXml
	 * @return
	 * @throws Exception
	 */
	protected List<Document> divideInXmlDoc(Document pNoStdXml)	throws Exception {
		cLogger.debug("Into CcbNewContBlc.divideInXmlDoc()...");

		List<Document> docList = new LinkedList<Document>();

		//定义标签：新单对账
		Element aTranEle = new Element("TranData");		
		Element aBodyEle = new Element("Body");
		Element aCountEle = new Element("Count");
		Element aPremEle = new Element("Prem");
		aBodyEle.addContent(aCountEle);
		aBodyEle.addContent(aPremEle);
		
		//定义标签：签约解约对账
		Element bTranEle = new Element("TranData");		
		Element bBodyEle = new Element("Body");
		Element bCountEle = new Element("Count");		
		bBodyEle.addContent(bCountEle);
		
        //组织新单对账报文
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
		aTranEle.addContent((Element) pNoStdXml.getRootElement().getChild("Head").clone()); //报文头
		aDoc.getRootElement().addContent(aBodyEle);//报文体
		docList.add(aDoc);
		
		//组织签约解约对账报文
		bCountEle.setText(String.valueOf(bCount));		
		Document bDoc = new Document(bTranEle);	
		bTranEle.addContent((Element) pNoStdXml.getRootElement().getChild("Head").clone());//报文头
		bDoc.getRootElement().addContent(bBodyEle);	//报文体	
		docList.add(bDoc);

		cLogger.debug("Out CcbNewContBlc.divideInXmlDoc()...");
		
		return (List<Document>) docList;

	}

}
