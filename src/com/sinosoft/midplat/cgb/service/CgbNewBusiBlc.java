package com.sinosoft.midplat.cgb.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.cgb.CgbConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.common.SaveMessage;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;

public class CgbNewBusiBlc extends ServiceImpl {

	private Element thisRootConf;
	
	private final static String FUNCFLAG_BLC_NEWCONT = "2210";	// �µ����ն���

	
	public CgbNewBusiBlc(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into CgbNewBusiBlc.service()...");
		cInXmlDoc = inXmlDoc;
		JdomUtil.print(inXmlDoc);
		this.thisRootConf = CgbConf.newInstance().getConf().getRootElement();

		String localFilePath = getOutLocalDir();
		InputStream is = null;
		BufferedReader mBufReader = null;
		// ����ˮ
		try {
//			cTranLogDB = insertTranLog(inXmlDoc);
			Document inNoStdDoc = null;
			// ���ܺ��ٵ�����Ӧ�Ķ��˽ӿ�
			Element reqBodyEle = new Element("Body");
    		int reqCountInt = 0;
    		long reqPremLong = 0;
			// 1.��ȡ����ĳ�����ն����ļ������������ļ����������ն����ļ����������ն����ļ���
			Element mBankEle = thisRootConf.getChild("bank");
			Element mTranDataEle = inXmlDoc.getRootElement();
			Element mHeadEle = mTranDataEle.getChild("Head");
			//�������ն����ļ�
			String guimianNameTxt = mBankEle.getAttributeValue("insu") + mBankEle.getAttributeValue(id)+ mHeadEle.getChildText("TranDate") +"01.txt";			
			//����ר�����ն����ļ���
			String netBankNameXml = "D018001"+ mHeadEle.getChildText("TranDate") + "01.xml";
			String netBankNameXml02 = "D018001"+ mHeadEle.getChildText("TranDate") + "02.xml";
			//���������µ������ļ�
			File guimianFile = new File(localFilePath+guimianNameTxt);			
			//����ר�����ն����ļ�
			File guimianZSFile = new File(localFilePath+netBankNameXml);
			if(!guimianZSFile.exists()){
				guimianZSFile = new File(localFilePath+netBankNameXml02);
			}
			// 1. ������泣������ļ�
            if(guimianFile.exists()){//�ļ�����
            	is = new FileInputStream(guimianFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	Element mBodyEle = new Element(Body);
//            	Element mDetailList = new Element("Detail_List");
        		Element mCountEle = new Element(Count);
        		Element mPremEle = new Element(Prem);
//        		mBodyEle.setContent(mDetailList);
        		
        		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {
        			cLogger.info(tLineMsg);
        			// ���У�ֱ������
        			tLineMsg = tLineMsg.trim();
        			if ("".equals(tLineMsg)) {
        				cLogger.warn("���У�ֱ��������������һ����");
        				continue;
        			}
        			String[] tSubMsgs = tLineMsg.split("\\|", -1);
        			//�����ʱֻ�гб�����
        			if (!"1013".equals(tSubMsgs[4])) {
        				cLogger.warn("ֱ��������������һ����");
        				continue;
        			}
                    //��������
        			Element tTranDateEle = new Element(TranDate);
        			tTranDateEle.setText(tSubMsgs[1]);
                    //������ˮ��
        			Element tTranNoEle = new Element(TranNo);
        			tTranNoEle.setText(tSubMsgs[5]);
                    //�������
        			Element tNodeNoEle = new Element(NodeNo);
        			tNodeNoEle.setText(tSubMsgs[2]+tSubMsgs[3]);
                    //��������
        			Element tContNoEle = new Element(ContNo);
        			tContNoEle.setText(tSubMsgs[6]);
                    //���ѽ��
        			Element tPremEle = new Element(Prem);
        			long tPremFen = NumberUtil.yuanToFen(tSubMsgs[7]);
        			tPremEle.setText(String.valueOf(tPremFen));  			
        			reqCountInt++;
        			reqPremLong = reqPremLong + tPremFen;

        			Element tDetailEle = new Element(Detail);
        			tDetailEle.addContent(tTranDateEle);
        			tDetailEle.addContent(tNodeNoEle);
        			tDetailEle.addContent(tTranNoEle);
        			tDetailEle.addContent(tContNoEle);
        			tDetailEle.addContent(tPremEle);

        			mBodyEle.addContent(tDetailEle);
        		}
        		mCountEle.setText(reqCountInt+"");
        		mPremEle.setText(reqPremLong+"");
        		mBodyEle.addContent(mCountEle);
        		mBodyEle.addContent(mPremEle);
//        		mBufReader.close(); // �ر���
        		inNoStdDoc = new Document(mBodyEle);
        		System.out.println("===========��������ļ�ת�����������ʼ===============");
        		JdomUtil.print(inNoStdDoc);
        		System.out.println("===========��������ļ�ת�������������===============");
                List<Element> detailEleList = XPath.selectNodes(inNoStdDoc.getRootElement(),"//Detail");	
//              System.out.println("detailEleList.size=========================="+detailEleList.size());
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            // 2�� �������ר�������ļ�
            if(guimianZSFile.exists()){//�ļ�����
            	is = new FileInputStream(guimianZSFile);
            	mBufReader = new BufferedReader(new InputStreamReader(is));
            	StringBuffer sb = new StringBuffer();
        		for (String tLineMsg; null != (tLineMsg = mBufReader.readLine());) {       			
        			sb.append(tLineMsg.trim());
        		}
        		String mCharset = cThisBusiConf.getChildText(charset);
        		if (null==mCharset || "".equals(mCharset)) {
        			mCharset = "GBK";
        		}
        		Document pNoStdXml = JdomUtil.build(sb.toString());
        		JdomUtil.print(pNoStdXml);
        		
        		//��־ǰ׺
        		Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='2211']");
        		StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
        				.getName()).append('_').append(NoFactory.nextAppNo()).append(
        				'_').append(thisBusiConf.getChildText(funcFlag)).append(
        				"_in.xml");              
        		SaveMessage.save(pNoStdXml, thisBusiConf.getChildText(TranCom), mSaveName.toString());
        		cLogger.info("����Ǳ�׼��������ϣ�");
        		String tFormatClassName = thisBusiConf.getChildText(format);
        		//����ת��ģ��
        		cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString()); 
        		Constructor tFormatConstructor =  Class.forName(tFormatClassName).getConstructor(new Class[] { Element.class });
        		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { thisBusiConf });
        		//��xmlת���ɱ�׼����
        		cLogger.info("convert nonstandard xml to standard xml...");
        		Document pStdXml = tFormat.noStd2Std(pNoStdXml);
//        		mBufReader.close(); // �ر���
        		System.out.println("===========�������XMLת�����������ʼ===============");
        		JdomUtil.print(pStdXml);

        		System.out.println("===========�������XMLת�������������===============");
        		reqCountInt = reqCountInt + Integer.parseInt(pStdXml.getRootElement().getChild("Body").getChild("Count").getText());
        		long tPremFen = Long.parseLong((pStdXml.getRootElement().getChild("Body").getChild("Prem").getText()));
        		reqPremLong = reqPremLong + tPremFen;
                List<Element> detailEleList = XPath.selectNodes(pStdXml.getRootElement(),"//Detail");	
//              System.out.println("detailEleList.size=========================="+detailEleList.size());
				for (Element detailEle : detailEleList) {
					reqBodyEle.addContent(detailEle.detach());
				}
            }
            //ֻ�е����ж����ļ����ܿ�ʼ����Ľ��ж��˴���
          if(guimianFile.exists() && guimianZSFile.exists()){
            	// ��֯���ģ����������ն��˽���ת��ʹ��
    			Document totalDetail = new Document(new Element(TranData));
    			
    			Element reqCountEle = new Element(Count);
    			reqCountEle.setText(reqCountInt+"");   			
        		Element reqPremEle = new Element(Prem);
        		reqPremEle.setText(reqPremLong+"");
        		reqBodyEle.addContent(reqCountEle);
        		reqBodyEle.addContent(reqPremEle);
    			totalDetail.getRootElement().addContent(reqBodyEle);	
    			Element cHeadEle = (Element)inXmlDoc.getRootElement().getChild(Head).clone();
//    			cHeadEle.getChild(TranDate).setText(DateUtil.getDateStr(new Date(), "yyyyMMdd"));
    			cHeadEle.getChild(TranDate).setText(mHeadEle.getChildText("TranDate"));
    			totalDetail.getRootElement().addContent(cHeadEle);
//    			System.out.println("===========����ǰ���ĸ�ʽ�����ʼ===============");
//        		JdomUtil.print(totalDetail);
//        		System.out.println("===========����ǰ���ĸ�ʽ�������===============");
    				
    			//�㷢�µ����˽���
				NewCgbBusiBlcTread blcThread = new NewCgbBusiBlcTread(FUNCFLAG_BLC_NEWCONT, totalDetail);
				blcThread.start();
    			
            }else{     	
            	cLogger.error("�����ļ������ڣ��ļ���Ϊ��"+guimianFile+";"+guimianZSFile);
            	throw new MidplatException("�����ļ������ڣ��ļ���Ϊ��"+guimianFile+";"+guimianZSFile);
            }
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");	
			
		} catch (Exception e) {
			cLogger.error(cThisBusiConf.getChildText(name) + "����ʧ�ܣ�", e);

			if (null != cTranLogDB) { // ������־ʧ��ʱcTranLogDB=null
				cTranLogDB.setRCode(CodeDef.RCode_ERROR); // -1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
				cTranLogDB.setRText(NumberUtil.cutStrByByte(e.getMessage(), 150, MidplatConf.newInstance().getDBCharset()));
			}
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, e.getMessage());
		}finally{//�ر���
			if(mBufReader != null){
				mBufReader.close();
			}
			if(is != null){
				is.close();
			}
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-tStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		cLogger.info("Out CgbNewBusiBlc.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * @Description: ���ղ�������ˣ��µ���
	 * Copyright: Copyright (c) 2014
	 * Company:�����IT��
	 * 
	 * @date Dec 31, 2014 11:30:24 AM
	 * @version 
	 *
	 */
	private class NewCgbBusiBlcTread extends Thread {
		private final Document cInXmlDoc;
		private final String cfuncFlag;

		private NewCgbBusiBlcTread(String funcFlag,Document noStdXmlDoc) {
			cInXmlDoc = (Document)noStdXmlDoc.clone();// �˴���Ҫ��¡һ���µģ��������ն��ˣ���ȫ���˲���ͬһ�����󣬵���funflag��ֵ��һ�¡�
			cfuncFlag = funcFlag;
		}

		public void run() {
			cLogger.info("Into NewCgbBusiBlcTread.run()...");

			this.setName(String.valueOf(NoFactory.nextTranLogNo()));
			try {
				Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + cfuncFlag + "']");
				// ��Ҫ����һ�½�����
//				Element funcFlagEle = (Element) XPath.selectSingleNode(cInXmlDoc.getRootElement(), "//Head/FuncFlag");
//				funcFlagEle.setText(cfuncFlag);

//				System.out.println("-------NewCcbBusiBlcTread---------");
//				JdomUtil.print(cInXmlDoc);
				// 1. ת����׼����
//				Document inStdDoc = nostd2std(cInXmlDoc, thisBusiConf);
				// ����Ǳ�׼����
				StringBuffer mSaveName = new StringBuffer(Thread.currentThread()
						.getName()).append('_').append(NoFactory.nextAppNo()).append(
						'_').append(cfuncFlag).append("_in.xml");
				SaveMessage.save(cInXmlDoc,((Element) thisRootConf.getChild(TranCom).clone()).getText(), mSaveName.toString());
				JdomUtil.print(cInXmlDoc);
				// 2. �������ն��˷���
				sendRequest(cInXmlDoc, thisBusiConf);
			} catch (Exception e) {
				cLogger.error("���ս���ʧ�ܣ�������[" + cfuncFlag + "]", e);
			}

			cLogger.info("Out NewCgbBusiBlcTread.run()!");
		}
	}
	
	/**
	 * ����ת�������Ǳ�׼����ת��Ϊ���ĵı�׼���ġ�
	 * 
	 * @param pNoStdXml
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	private Document nostd2std(Document pNoStdXml, Element thisBusiConf) throws Exception {
		String tFormatClassName = thisBusiConf.getChildText(format);
		// ����ת��ģ��
		cLogger.info((new StringBuilder("����ת��ģ�飺")).append(tFormatClassName).toString());
		Constructor tFormatConstructor = Class.forName(tFormatClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Format tFormat = (Format) tFormatConstructor.newInstance(new Object[] { thisBusiConf });
		return tFormat.noStd2Std(pNoStdXml);
	}
	
	/**
	 * ���ͽ�������
	 * 
	 * @param tInStd	��׼����
	 * @param thisBusiConf
	 * @return
	 * @throws Exception
	 */
	protected Document sendRequest(Document tInStd, Element thisBusiConf) throws Exception {

		// ҵ����
		String tServiceClassName = thisBusiConf.getChildText(service);
		cLogger.debug((new StringBuilder("ҵ����ģ�飺")).append(tServiceClassName).toString());
		Constructor tServiceConstructor = Class.forName(tServiceClassName).getConstructor(new Class[] { org.jdom.Element.class });
		Service tService = (Service) tServiceConstructor.newInstance(new Object[] { thisBusiConf });
		Document tOutStdXml = tService.service(tInStd);

		// У������Ƿ���������		
		Element tOutHeadEle = tOutStdXml.getRootElement().getChild(Head);
		if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//����ʧ��
			throw new MidplatException(tOutHeadEle.getChildText(Desc));
		}
		return tOutStdXml;

	}

	/**
	 * ��ȡ�ļ����·��
	 * @return
	 */
	public String getOutLocalDir() {
		
		String filePath = cThisBusiConf.getChildText(localDir);
		if(filePath.endsWith("/")){
			// do nothing...
		}else{
			filePath = filePath + "/";
		}
		return filePath;
	}
	
	public static void main(String[] args) {
		try {
			Element tCcbConfEle = CgbConf.newInstance().getConf().getRootElement();
			Element tBusiConf = (Element) XPath.selectSingleNode(tCcbConfEle, "business[funcFlag='321']");
			CgbNewBusiBlc tCcbFinanceBlc = new CgbNewBusiBlc(tBusiConf);
			
			Document inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(new File("D:/CCBfile/put/653598_23_321_in.xml"))));
			tCcbFinanceBlc.service(inNoStdDoc);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

