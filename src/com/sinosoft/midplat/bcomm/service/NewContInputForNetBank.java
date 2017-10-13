package com.sinosoft.midplat.bcomm.service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.db.ContDB;
import com.sinosoft.midplat.common.AblifeCodeDef;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.RuleParser;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.CallWebsvcAtomSvc;
import com.sinosoft.midplat.service.ServiceImpl;

/**
 * @Title: com.sinosoft.midplat.service.NewContInputForNetBank.java
 * @Description: �����µ������������
 * Copyright: Copyright (c) 2014
 * Company:�����IT��
 * 
 * @date Nov 17, 2014 3:59:06 PM
 * @version 
 *
 */
public class NewContInputForNetBank extends ServiceImpl {

	public NewContInputForNetBank(Element thisBusiConf) {
		super(thisBusiConf);
	}

	
	@SuppressWarnings("unchecked")
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into NewContInputForNetBank.service()...");
		cInXmlDoc = pInXmlDoc;
		
		Element mRootEle = cInXmlDoc.getRootElement();
		
		Element mBodyEle = mRootEle.getChild(Body);
		String mProposalPrtNo = mBodyEle.getChildText(ProposalPrtNo);
		
		try {
			cTranLogDB = insertTranLog(cInXmlDoc);
			
			//У��ϵͳ���Ƿ�����ͬ�������ڴ�����δ����
			int tLockTime = 300;	//Ĭ�ϳ�ʱ����Ϊ5����(300s)�����δ��������ʱ�䣬��ʹ�ø�ֵ��
			try {
				tLockTime = Integer.parseInt(cThisBusiConf.getChildText(locktime));
			} catch (Exception ex) {	//ʹ��Ĭ��ֵ
				cLogger.debug("δ��������ʱ�䣬����������ʹ��Ĭ��ֵ(s)��"+tLockTime, ex);
			}
			Calendar tCurCalendar = Calendar.getInstance();
			tCurCalendar.add(Calendar.SECOND, -tLockTime);
			
			new RuleParser().check(cInXmlDoc);
			
			cOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_ContInput_IcbcNet).call(cInXmlDoc);
			
			Element tOutRootEle = cOutXmlDoc.getRootElement();
			Element tOutHeadEle = tOutRootEle.getChild(Head);
			Element tOutBodyEle = tOutRootEle.getChild(Body);
			int errorCode = Integer.parseInt(tOutHeadEle.getChildText(Flag));
			if (CodeDef.RCode_OK != errorCode ) {
                throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			
			//�����յ�������ǰ��
			List<Element> tRiskList = tOutBodyEle.getChildren(Risk);
			int tSize = tRiskList.size();
			for (int i = 0; i < tSize; i++) {
				Element ttRiskEle = tRiskList.get(i);
				
				if (ttRiskEle.getChildText(MainRiskCode).equals(ttRiskEle.getChildText(RiskCode))) {
					tRiskList.add(0, tRiskList.remove(i));	//�����յ�������ǰ��
				}
			}
			
			//��ʱ�Զ�ɾ������
			long tUseTime = System.currentTimeMillis() - mStartMillis;
			int tTimeOut = 60;	//Ĭ�ϳ�ʱ����Ϊ1���ӣ����δ���ó�ʱʱ�䣬��ʹ�ø�ֵ��
			try {
				tTimeOut = Integer.parseInt(cThisBusiConf.getChildText(timeout));
			} catch (Exception ex) {	//ʹ��Ĭ��ֵ
				cLogger.debug("δ���ó�ʱ������������ʹ��Ĭ��ֵ(s)��"+tTimeOut, ex);
			}
			if (tUseTime > tTimeOut*1000) {
				cLogger.error("����ʱ��UseTime=" + tUseTime/1000.0 + "s��TimeOut=" + tTimeOut + "s��Ͷ���飺" + mProposalPrtNo);
				rollback();	//�ع�ϵͳ����
				throw new MidplatException("ϵͳ��æ�����Ժ����ԣ�");
			}
			
			//���汣����Ϣ
			ContDB tContDB = getContDB();
			Date tCurDate = new Date();
			tContDB.setMakeDate(DateUtil.get8Date(tCurDate));
			tContDB.setMakeTime(DateUtil.get6Time(tCurDate));
			tContDB.setModifyDate(tContDB.getMakeDate());
			tContDB.setModifyTime(tContDB.getMakeTime());
			if (!tContDB.insert()) {
				cLogger.error("������Ϣ(Cont)���ʧ�ܣ�" + tContDB.mErrors.getFirstError());
			}
			cTranLogDB.setContNo(tContDB.getContNo());
			/*
			 * ��������������Ͷ�����Ź�������Ҫ�����ĵ�Ͷ������ά����tranlog���У��Ա�ǩ��������ͨ��Ͷ�����Ų�������ţ�����ǩ������
			 * �����е������������ն˻ᴫͶ�����Ź���������Ҫ���������Ĳ�������Ȼ����״̬�ش�����ʱ�������޷������ҷ��ṩ������
			 */
			cTranLogDB.setBak5(tContDB.getProposalPrtNo());
			cTranLogDB.setManageCom(tContDB.getManageCom());
			cTranLogDB.setAgentCom(tContDB.getAgentCom());
			cTranLogDB.setAgentCode(tContDB.getAgentCode());
		} catch (Exception ex) {
			
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			if (null != cTranLogDB) {    //������־ʧ��ʱcTranLogDB=null
		        cTranLogDB.setRCode(String.valueOf(CodeDef.RCode_ERROR));
	            cTranLogDB.setRText(ex.getMessage());
			}
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
		
		cLogger.info("Out NewContInputForNetBank.service()!");
		return cOutXmlDoc;
	}
	
	private ContDB getContDB() {
		cLogger.debug("Into NewContInputForNetBank.getContDB()...");
		
		Element mInBodyEle = cInXmlDoc.getRootElement().getChild(Body);
		Element mInRiskEle = mInBodyEle.getChild(Risk);
		
		Element mOutBodyEle = cOutXmlDoc.getRootElement().getChild(Body);
		Element mOutAppntEle = mOutBodyEle.getChild(Appnt);
		Element mOutInsuredEle = mOutBodyEle.getChild(Insured);
		Element mOutMainRiskEle = mOutBodyEle.getChild(Risk);	//ǰ���Ѿ��������ˣ���һ���ڵ����������Ϣ
		
		ContDB mContDB = new ContDB();
		mContDB.setRecordNo(NoFactory.nextContRecordNo());
		mContDB.setType(AblifeCodeDef.ContType_Bank);
		mContDB.setContNo(mOutBodyEle.getChildText(ContNo));
		mContDB.setProposalPrtNo(mOutBodyEle.getChildText(ProposalPrtNo));
		//mContDB.setProductId(mInBodyEle.getChildText(ProductId));
		mContDB.setTranCom(cTranLogDB.getTranCom());
		mContDB.setNodeNo(cTranLogDB.getNodeNo());
		mContDB.setAgentCom(mOutBodyEle.getChildText(AgentCom));
		mContDB.setAgentComName(mOutBodyEle.getChildText(AgentComName));
		mContDB.setAgentCode(mOutBodyEle.getChildText(AgentCode));
		mContDB.setAgentName(mOutBodyEle.getChildText(AgentName));
		mContDB.setManageCom(mOutBodyEle.getChildText(ComCode));
		mContDB.setAppntNo(mOutAppntEle.getChildText(CustomerNo));
		mContDB.setAppntName(mOutAppntEle.getChildText(Name));
		mContDB.setAppntSex(mOutAppntEle.getChildText(Sex));
		mContDB.setAppntBirthday(mOutAppntEle.getChildText(Birthday));
		mContDB.setAppntIDType(mOutAppntEle.getChildText(IDType));
		mContDB.setAppntIDNo(mOutAppntEle.getChildText(IDNo));
		mContDB.setInsuredNo(mOutInsuredEle.getChildText(CustomerNo));
		mContDB.setInsuredName(mOutInsuredEle.getChildText(Name));
		mContDB.setInsuredSex(mOutInsuredEle.getChildText(Sex));
		mContDB.setInsuredBirthday(mOutInsuredEle.getChildText(Birthday));
		mContDB.setInsuredIDType(mOutInsuredEle.getChildText(IDType));
		mContDB.setInsuredIDNo(mOutInsuredEle.getChildText(IDNo));
		mContDB.setTranDate(cTranLogDB.getTranDate());
		mContDB.setPolApplyDate(mOutMainRiskEle.getChildText(PolApplyDate));
		mContDB.setPrem(mOutBodyEle.getChildText(Prem));
		mContDB.setAmnt(mOutBodyEle.getChildText(Amnt));
		mContDB.setState(AblifeCodeDef.ContState_Input);
		mContDB.setBak1(mInRiskEle.getChildText(MainRiskCode));
		mContDB.setOperator(CodeDef.SYS);
		
		cLogger.debug("Out NewContInputForNetBank.getContDB()!");
		return mContDB;
	}
	
	/**
	 * �����ع�
	 */
	private void rollback() {
		cLogger.debug("Into NewContInputForNetBank.rollback()...");
		
		Element mInRootEle = cInXmlDoc.getRootElement();
		Element mInBodyEle = mInRootEle.getChild(Body);
		Element mHeadEle = (Element) mInRootEle.getChild(Head).clone();
		mHeadEle.getChild(ServiceId).setText(AblifeCodeDef.SID_Bank_ContRollback);
		Element mBodyEle = new Element(Body);
		mBodyEle.addContent((Element) mInBodyEle.getChild(ProposalPrtNo).clone());
		mBodyEle.addContent((Element) mInBodyEle.getChild(ContPrtNo).clone());
		mBodyEle.addContent((Element) cOutXmlDoc.getRootElement().getChild(Body).getChild(ContNo).clone());
		Element mTranDataEle = new Element(TranData);
		mTranDataEle.addContent(mHeadEle);
		mTranDataEle.addContent(mBodyEle);
		Document mInXmlDoc = new Document(mTranDataEle);
		
		try {
			new CallWebsvcAtomSvc(mHeadEle.getChildText(ServiceId)).call(mInXmlDoc);
		} catch (Exception ex) {
			cLogger.error("�ع�����ʧ�ܣ�", ex);
		}
		
		cLogger.debug("Out NewContInputForNetBank.rollback()!");
	}
}
