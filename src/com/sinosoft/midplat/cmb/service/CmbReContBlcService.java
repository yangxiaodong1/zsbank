package com.sinosoft.midplat.cmb.service;

import java.io.File;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.lang.reflect.Constructor;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.cmb.CmbConf;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.IOTrans;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.NumberUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.format.Format;
import com.sinosoft.midplat.service.Service;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class CmbReContBlcService extends ServiceImpl {

	private Element thisRootConf;
	private final static String FUNCFLAG_BLC_NEWCONT = "1006";
    private String logNo = "";
	
	public CmbReContBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document inXmlDoc) throws Exception {
		
		long tStartMillis = System.currentTimeMillis();
		cLogger.info("Into CmbReContBlcService.service()...");
		cInXmlDoc = inXmlDoc;
		this.thisRootConf = CmbConf.newInstance().getConf().getRootElement();
		Element rootEle = inXmlDoc.getRootElement();

		// ����ˮ
		try {
			cTranLogDB = insertTranLog(inXmlDoc);
			Element mHeadEle = rootEle.getChild("Head");
			String tranDate = mHeadEle.getChildText("TranDate");
			
			StringBuffer mSqlStr = new StringBuffer();
	        mSqlStr.append("select logno from TranLog ");
	        mSqlStr.append(" where trancom = 10 and Funcflag = 1006 and RCode=1 ");
	        mSqlStr.append(" and trandate =" + tranDate);
	        mSqlStr.append(" order by Makedate,Maketime desc ");
	        SSRS ssrs = new SSRS();
	        ssrs = new ExeSQL().execSQL(mSqlStr.toString());
	        if (ssrs.MaxRow > 0) {
	        	logNo = ssrs.GetText(1,1);
	        	Document inNoStdDoc = null;
				//������ˮ�ŵ���Ӧ����־Ŀ¼·�������Ҷ�Ӧ����־�ļ�	    
//	        	String filedir = tranDate.substring(0,4)+"/"+tranDate.substring(0,6)+"/"+tranDate;
//	        	StringBuilder mFilePath = new StringBuilder(getOutLocalDir()).append("10").append('/').append(filedir);
	        	File[] fileArray = getBatchFiles(tranDate);
	        	if(fileArray.length>0){
//	        		File blcFile = new File(mFilePath+"/"+fileArray[0]);
					//��ȡ�ļ���Ϣ
					inNoStdDoc = JdomUtil.build(IOTrans.toString(new FileReader(fileArray[0])));					
					NewCmbBusiBlcTread tNewCcbBusiBlcTread = new NewCmbBusiBlcTread(FUNCFLAG_BLC_NEWCONT, inNoStdDoc);
					tNewCcbBusiBlcTread.start();
	        	}else{
	        		throw new MidplatException("δ�ҵ���־·������Ч��־�ļ����޷�������");
	        	}	
	        }else{
	        	throw new MidplatException("δ�ҵ����ݿ�����Ч��־��¼���޷�������");
	        }	
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");	
			
		} catch (Exception e) {
			cLogger.error(cThisBusiConf.getChildText(name) + "����ʧ�ܣ�", e);

			if (null != cTranLogDB) { // ������־ʧ��ʱcTranLogDB=null
				cTranLogDB.setRCode(CodeDef.RCode_ERROR); // -1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
				cTranLogDB.setRText(NumberUtil.cutStrByByte(e.getMessage(), 150, MidplatConf.newInstance().getDBCharset()));
			}
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, e.getMessage());
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
		cLogger.info("Out CcbFinanceBlc.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * @Description:
	 * Copyright: Copyright (c) 2016
	 * Company:�����IT��
	 * @version 
	 *
	 */
	private class NewCmbBusiBlcTread extends Thread {
		private final Document cInXmlDoc;
		private final String cfuncFlag;

		private NewCmbBusiBlcTread(String funcFlag,Document noStdXmlDoc) {
			cInXmlDoc = (Document)noStdXmlDoc.clone();// �˴���Ҫ��¡һ���µģ��������ն��ˣ���ȫ���˲���ͬһ�����󣬵���funflag��ֵ��һ�¡�
			cfuncFlag = funcFlag;
		}

		public void run() {
			cLogger.info("Into NewCmbBusiBlcTread.run()...");

			this.setName(String.valueOf(NoFactory.nextTranLogNo()));
			try {
				Element thisBusiConf = (Element) XPath.selectSingleNode(thisRootConf, "business[funcFlag='" + cfuncFlag + "']");
				JdomUtil.print(cInXmlDoc);
				// ��Ҫ����һ�½�����
//				Element newContBlcEle = (Element) XPath.selectSingleNode(cInXmlDoc.getRootElement(), "//Head");
				Element tHead = new Element("Head");
				//���ӽ�����ڵ㲢��ֵ
				Element funcFlagEle = new Element("FuncFlag");
				funcFlagEle.setText("1006");
				//�������д���ڵ㲢��ֵ
				Element tranComEle = new Element("TranCom");
				tranComEle.setText(thisRootConf.getChild("TranCom").getValue());
				tranComEle.setAttribute("outcode",thisRootConf.getChild("TranCom").getAttributeValue("outcode"));

				tHead.addContent(funcFlagEle);
				tHead.addContent(tranComEle);
				cInXmlDoc.getRootElement().addContent(tHead);
				// 1. ת����׼����
				Document inStdDoc = nostd2std(cInXmlDoc, thisBusiConf);
				JdomUtil.print(inStdDoc);
				
				// 2. �������ն��˷���
				sendRequest(inStdDoc, thisBusiConf);
			} catch (Exception e) {
				cLogger.error("���ս���ʧ�ܣ�������[" + cfuncFlag + "]", e);
			}
			cLogger.info("Out NewCmbBusiBlcTread.run()!");
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
	 * @param tInStd ��׼����
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

	
	File[] getBatchFiles(String tranDate) throws MidplatException {
        if (null == getOutLocalDir() || "".equals(getOutLocalDir())) {
            throw new MidplatException("û��������������[1025]��localDir");
        }
        String filedir = tranDate.substring(0,4)+"/"+tranDate.substring(0,6)+"/"+tranDate;
    	StringBuilder mFilePath = new StringBuilder(getOutLocalDir()).append("10").append('/').append(filedir);
        // ��ʼ�������ļ�Ŀ¼
        File mDirFile = new File(mFilePath.toString());
        if (!mDirFile.exists()) {
            cLogger.debug("�����ļ�Ŀ¼[" + mFilePath.toString() + "]�����ڣ���ʼ��Ŀ¼");
        }

        // ��ȡ�����ϴ��ļ�������
        return mDirFile.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                // TODO Auto-generated method stub
                return (name.startsWith(logNo)&&name.endsWith("1006_in.xml"));
            }

        });
    }
}
