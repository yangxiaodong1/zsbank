package com.sinosoft.midplat.hxb.service;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.pubfun.MMap;
import com.sinosoft.lis.pubfun.PubSubmit;
import com.sinosoft.lis.schema.HxbankManagerSchema;
import com.sinosoft.lis.vschema.HxbankManagerSet;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.hxb.format.HxbConstant;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.VData;

/**
 * @Title: com.sinosoft.midplat.hxb.service.HxbManagerBlcService.java
 * @Description: TODO
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Apr 23, 2014 11:21:13 AM
 * @version 
 *
 */
public class HxbManagerBlcService extends ServiceImpl {

	public HxbManagerBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into HxbManagerBlcService.service()...");
		cInXmlDoc = pInXmlDoc;
		
		try {

			cTranLogDB = insertTranLog(cInXmlDoc);
			
			String tSqlStr = new StringBuilder("select 1 from TranLog where RCode=").append(CodeDef.RCode_OK)
				.append(" and TranDate=").append(cTranLogDB.getTranDate())
				.append(" and FuncFlag=").append(cTranLogDB.getFuncFlag())
				.append(" and TranCom=").append(cTranLogDB.getTranCom())
				.append(" and NodeNo='").append(cTranLogDB.getNodeNo()).append('\'')
				.toString();
			ExeSQL tExeSQL = new ExeSQL();
			if ("1".equals(tExeSQL.getOneValue(tSqlStr))) {
				throw new MidplatException("�ѳɹ������ͻ�������Ϣ���£������ظ�������");
			} else if (tExeSQL.mErrors.needDealError()) {
				throw new MidplatException("��ѯ�ͻ����������ʷ��Ϣ�쳣��");
			}
			
			//����ǰ�û��������ı�����Ϣ(ɨ�賬ʱ��)
			String tErrorStr = cInXmlDoc.getRootElement().getChildText(Error);
			if (null != tErrorStr) {
				throw new MidplatException(tErrorStr);
			}
			
			//����ͻ�������ϸ��Ϣ
			cOutXmlDoc = saveDetails(cInXmlDoc);
			
			Element tOutHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//����ʧ��
				throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out HxbManagerBlcService.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * ����ͻ�������ϸ�����ش���������
	 */
	@SuppressWarnings("unchecked")
	private Document saveDetails(Document pXmlDoc) throws Exception {
		cLogger.debug("Into HxbManagerBlcService.saveDetails()...");
		
		String currDate = DateUtil.getCur10Date();
		String currTime = DateUtil.getCur8Time();
		Document retDoc = new Document();	// ���صĽ������
		boolean flag = true;
		String msg = "hxb�ύ�ͻ��ͻ������������ɹ�";
		
		Element mTranDataEle = pXmlDoc.getRootElement();
		String mTranCom = mTranDataEle.getChild(Head).getChildTextTrim(TranCom);
		Element mBodyEle = mTranDataEle.getChild(Body);
		
		List<Element> mDetailList = mBodyEle.getChildren(Detail);
		int count = mDetailList.size();
		cLogger.debug("����hxb�ͻ�����������" + count + "��");
		
		if(count>0){	// �и������ݣ����������
			
			String mSqlStr = "delete from hxbankmanager";	// ɾ���ͻ������ȫ������
			boolean tSSRS = new ExeSQL().execUpdateSQL(mSqlStr);
			if(!tSSRS){
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "hxbɾ���ͻ���������ʧ��");
				throw new MidplatException("hxbɾ���ͻ���������ʧ�ܣ�");
			}
			
			HxbankManagerSet mHxbankManagerSet = new HxbankManagerSet();
			for(Element tDetailEle : mDetailList){
				
				HxbankManagerSchema tHxbankManagerSchema = new HxbankManagerSchema();
				
				tHxbankManagerSchema.setTranCom(mTranCom);
				tHxbankManagerSchema.setBankCode(tDetailEle.getChildTextTrim(HxbConstant.BankCode));
				tHxbankManagerSchema.setManagerCode(tDetailEle.getChildTextTrim(HxbConstant.ManagerCode));
				tHxbankManagerSchema.setManagerName(tDetailEle.getChildTextTrim(HxbConstant.ManagerName));
				tHxbankManagerSchema.setManagerCertifNo(tDetailEle.getChildTextTrim(HxbConstant.ManagerCertifNo));
				tHxbankManagerSchema.setCertifEndDate(tDetailEle.getChildTextTrim(HxbConstant.CertifEndDate));
				
				tHxbankManagerSchema.setMakeDate(currDate);
				tHxbankManagerSchema.setMakeTime(currTime);
				tHxbankManagerSchema.setModifyDate(currDate);
				tHxbankManagerSchema.setModifyTime(currTime);
				tHxbankManagerSchema.setOperator(HxbConstant.midplat);
				
				mHxbankManagerSet.add(tHxbankManagerSchema);
				
				if (mHxbankManagerSet.size() % 500 == 0) {
					if(!commonPart4GetCommision(mHxbankManagerSet)){
						cLogger.debug("hxb�ύ�ͻ��ͻ��������ݲ��ֻ�ȫ�����ʧ��");
						msg = "hxb�ύ�ͻ��ͻ��������ݲ��ֻ�ȫ�����ʧ��";
						flag = false;
					}
					mHxbankManagerSet.clear();
				}
			}
			
			if(!commonPart4GetCommision(mHxbankManagerSet)){
				cLogger.debug("hxb�ύ�ͻ��ͻ��������ݲ��ֻ�ȫ�����ʧ��");
				msg = "hxb�ύ�ͻ��ͻ��������ݲ��ֻ�ȫ�����ʧ��";
				flag = false;
			}
			
			if(flag){	// �ͻ������������ɹ� 
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, msg);	
			}else{	// �ͻ������������ʧ��
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, msg);
			}
			
		}else{	// �������򲻸���������Ϣ
			retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "���׳ɹ����ͻ������ļ������ݣ��������ݸ��£�����ǰһ��Ŀͻ���������");
		}
		
		cLogger.debug("Out HxbManagerBlcService.saveDetails()!");
		return retDoc;
	}
	
	/**
	 * �ύ���ݣ�����ɹ�����ture������ύ����ʧ�ܷ���false
	 * @param cHxbankManagerSet
	 * @return
	 */
	private boolean commonPart4GetCommision(HxbankManagerSet cHxbankManagerSet){
		
		MMap cMap = new MMap();

		cMap.put(cHxbankManagerSet, "INSERT");
		VData tInputData = new VData();
		tInputData.clear();
		tInputData.add(cMap);
		PubSubmit tPubSubmit = new PubSubmit();

		if(!tPubSubmit.submitData(tInputData, "")){
			cLogger.error("�ͻ����������Ϣʧ�ܣ�" + tPubSubmit.mErrors.getFirstError());
			return false;
		}
		return true;
		
	}
}

