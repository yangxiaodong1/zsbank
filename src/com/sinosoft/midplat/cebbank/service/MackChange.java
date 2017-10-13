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
				throw new MidplatException("报文头中交易类型"+tFuncFlag+"和报文体中交易码"+ tTransNo+"不匹配");
			}*/
			if ((tMacKey.length() != 16) && (tMacKey.length() != 32) && (tMacKey.length() != 48)) {
				throw new MidplatException("密钥数据块MacKey长度错."+ tMacKey);
			}
			if (tMacVerify.length() != 8) {
				throw new MidplatException("校验值MacVerify长度错."+ tMacVerify);
			}
			SoftEnc.Init(new String(SysInfo.cHome+"key/cebbankkey/"));//1.SYS路径
			SoftEnc.WriteMACK(tMacKey, tMacVerify);//生成3.sys
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功");
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out MackChange.service()!");
		return cOutXmlDoc;
	}
	
}
