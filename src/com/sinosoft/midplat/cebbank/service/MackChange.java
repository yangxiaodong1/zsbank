package com.sinosoft.midplat.cebbank.service;


import org.jdom.Document;
import org.jdom.Element;

import cebenc.softenc.SoftEnc;

import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.service.ServiceImpl;

public class MackChange extends ServiceImpl {
	public MackChange(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into MackChange.service()...");
		try {
			cTranLogDB = insertTranLog(pInXmlDoc);
			String tMacKey = pInXmlDoc.getRootElement().getChildText("MacKey");
			String tMacVerify = pInXmlDoc.getRootElement().getChildText("MacVerify");
			/*String tTransNo = pInXmlDoc.getRootElement().getChildText("TransNo");
			String tFuncFlag = cThisBusiConf.getChild(funcFlag).getAttributeValue("outcode");
			if (!tTransNo.equals(tFuncFlag)) {
				throw new MidplatException("����ͷ�н�������"+tFuncFlag+"�ͱ������н�����"+ tTransNo+"��ƥ��");
			}*/
			if ((tMacKey.length() != 16) && (tMacKey.length() != 32) && (tMacKey.length() != 48)) {
				throw new MidplatException("��Կ���ݿ�MacKey���ȴ�."+ tMacKey);
			}
			if (tMacVerify.length() != 8) {
				throw new MidplatException("У��ֵMacVerify���ȴ�."+ tMacVerify);
			}
			SoftEnc.Init(new String(SysInfo.cHome+"key/cebbankkey/"));//1.SYS·��
			SoftEnc.WriteMACK(tMacKey, tMacVerify);//����3.sys
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ�");
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out MackChange.service()!");
		return cOutXmlDoc;
	}
	
}
