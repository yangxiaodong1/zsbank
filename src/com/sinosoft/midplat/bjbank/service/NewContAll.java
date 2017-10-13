/**
 * ����+¼���˱�+�շ�ǩ������Ա�����������Լ
 */

package com.sinosoft.midplat.bjbank.service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.db.ContDB;
import com.sinosoft.lis.schema.ContSchema;
import com.sinosoft.lis.vschema.ContSet;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.AblifeCodeDef;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.common.NoFactory;
import com.sinosoft.midplat.common.RuleParser;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.net.CallWebsvcAtomSvc;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class NewContAll extends ServiceImpl {
	public NewContAll(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	@SuppressWarnings("unchecked")
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into NewContAll.service()...");
		cInXmlDoc = pInXmlDoc;
		
		Element mRootEle = cInXmlDoc.getRootElement();
		Element mHeadEle = (Element) mRootEle.getChild(Head).clone();
		Element mBodyEle = mRootEle.getChild(Body);
		String mProposalPrtNo = mBodyEle.getChildText(ProposalPrtNo);
		String mContPrtNo = mBodyEle.getChildText(ContPrtNo) == null ? ""
                : mBodyEle.getChildText(ContPrtNo);
		
	      //��ʵʱ�˱���־
        boolean noRealTimeFlag = false;
        
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
		    String tSqlStr = new StringBuilder(
		    "select count(1) from TranLog where RCode=").append(
		            CodeDef.RCode_NULL).append(" and ProposalPrtNo='")
		            .append(mProposalPrtNo).append('\'').append(
		            " and MakeDate>=").append(
		                    DateUtil.get8Date(tCurCalendar)).append(
		                            " and MakeTime>=").append(
		                                    DateUtil.get6Time(tCurCalendar)).toString();
		    if (!"1".equals(new ExeSQL().getOneValue(tSqlStr))) {
		        throw new MidplatException("�˱����������ڴ����У����Ժ�");
		    }
			//ͨ�ý���
			new RuleParser().check(cInXmlDoc);
			/**
			 * ��������������Լ����ʱ���չ�˾ֱ�����ɱ���������������ֻ������Լȷ�Ϻ��������ʽ������
			 * �������л�ͬһͶ�����š�ͬһ��֤���ظ�����Լ����
			 */
			//-------------------------------------------------------------��������begin----------------------------------------------
			
			String mSqlStr = "select   *  from cont  where ProposalPrtNo='" + mProposalPrtNo +"'"
			+ " and TranDate=" + mHeadEle.getChildText(TranDate)
			+ " and TranCom=" + mHeadEle.getChildText(TranCom)
	        + " and NodeNo=" + mHeadEle.getChildText(NodeNo)
	        + " and State = "+AblifeCodeDef.ContState_Sign+""
	        ;
			ContSet mContSet = new ContDB().executeQuery(mSqlStr);
			if (1 <= mContSet.size()) {
				//��������ظ�����Լ���룬��Ҫ�����������ɱ���
//				Element mContNo = new Element("ContNo");
//				mContNo.setText(mSSRS.GetText(1, 1));
//				mBodyEle.addContent(mContNo);
				rollback();
				ContSchema tContSchema = mContSet.get(1);
				//����Ϊδǩ��״̬
				Date tCurDate = new Date();
				tSqlStr = new StringBuilder("update Cont set State=-State")
					.append(", ModifyDate=").append(DateUtil.get8Date(tCurDate))
					.append(", ModifyTime=").append(DateUtil.get6Time(tCurDate))
					.append(" where RecordNo=").append(tContSchema.getRecordNo())
					.toString();
				ExeSQL tExeSQL = new ExeSQL();
				if (!tExeSQL.execUpdateSQL(tSqlStr)) {
					cLogger.error("���±���״̬(Cont)ʧ�ܣ�" + tExeSQL.mErrors.getFirstError());
				}
				
			}
			//-------------------------------------------------------------��������end------------------------------------------------
			
			//�������
		    cOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_ContInput).call(cInXmlDoc);
			Element tOutRootEle = cOutXmlDoc.getRootElement();
			Element tOutHeadEle = tOutRootEle.getChild(Head);
			Element tOutBodyEle = tOutRootEle.getChild(Body);
            int resultCode =  Integer.parseInt(tOutHeadEle.getChildText(Flag));
            if (resultCode!=CodeDef.RCode_OK) { //����ʧ�� ����Oracle���ܴ洢�����ŵ�bug
                if(resultCode==AblifeCodeDef.RCode_NoRealTime){
                    //ת�˹��˱�
                    noRealTimeFlag = true;
                }
                throw new MidplatException(tOutHeadEle.getChildText(Desc));
            }
			
			//�����շ�ǩ���ӿڣ�׼��������
			Element tBodyEle = new Element(Body);
			//��ͳ����ͨ
			tBodyEle.addContent(
			        (Element) mBodyEle.getChild(ProposalPrtNo).clone());
			tBodyEle.addContent(
			        (Element) mBodyEle.getChild(ContPrtNo).clone());
			tBodyEle.addContent(
					(Element) tOutBodyEle.getChild(ContNo).clone());
			Element tTranDataEle = new Element(TranData);
			tTranDataEle.addContent(mHeadEle);
			tTranDataEle.addContent(tBodyEle);
			
			//�������
		    cOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_ContConfirm).call(new Document(tTranDataEle));
			
			//У����Ӧ���
			tOutRootEle = cOutXmlDoc.getRootElement();
			tOutHeadEle = tOutRootEle.getChild(Head);
			tOutBodyEle = tOutRootEle.getChild(Body);
			if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {
				throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			

			//���Ĳ��汣��ӡˢ�ţ��������Ķ�Ӧֵ����
			tOutBodyEle.getChild(ContPrtNo).setText(mContPrtNo);
			
			//���Ŀ��ܽ�һ����Ʒ���������ֶ�����Ϊ���գ�����������Ϊһ��һ���������б���Ϊ׼�����Ǻ��ļ�¼
			/*
			 * REMOVED 2013-11-26 ����Ŀ���ͬ�¹�ͨ��Ŀǰ�����ڣ����Ŀ��ܽ�һ����Ʒ���������ֶ�����Ϊ���գ�����ȥ��������롣
			 */
//			String tMainRiskCode = mBodyEle.getChild(Risk).getChildText(MainRiskCode);
			List<Element> tRiskList = tOutBodyEle.getChildren(Risk);
			int tSize = tRiskList.size();
			for (int i = 0; i < tSize; i++) {
				Element ttRiskEle = tRiskList.get(i);
				
				/*
				 * ���ղ�Ʒ��Ϸ�ʽͨ������ͨ����ʱ�����з�¼���Ʒ��ϱ���ʱ����Ϊ��Ʒ��ϱ��������ձ��룬����cont���е�bak1�С�<br>
				 * �����ں���ϵͳ���ص���Ӧ�����У���Ʒ��ϱ�����contPlancode�����գ�<risk />��ǩ���<riskCode>��<mainRiskcode>��ͬ��Ϊ���գ�
				 * �����գ�<risk />��ǩ���<riskCode>��<mainRiskcode>����ͬ�ĸ����ա�<br>
				 * ������գ�"���Ŀ��ܽ�һ����Ʒ���������ֶ�����Ϊ���գ�����������Ϊһ��һ���������б���Ϊ׼�����Ǻ��ļ�¼"����<mainRiskcode>��ǩ�޸ľͻᵼ��
				 * û��<riskCode>��<mainRiskcode>��ͬ��������ں�������ͨ��ת��ʱ��������⣬
				 * ����û�б�Ҫִ�У����Ŀ��ܽ�һ����Ʒ���������ֶ�����Ϊ���գ�����������Ϊһ��һ���������б���Ϊ׼�����Ǻ��ļ�¼��
				 * 
				 * REMOVED 2013-11-26 ����Ŀ���ͬ�¹�ͨ��Ŀǰ�����ڣ����Ŀ��ܽ�һ����Ʒ���������ֶ�����Ϊ���գ�����ȥ��������롣
				 */
				
//				ttRiskEle.getChild(MainRiskCode).setText(tMainRiskCode);
				
//				if (tMainRiskCode.equals(ttRiskEle.getChildText(RiskCode))) {
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
			cTranLogDB.setManageCom(tContDB.getManageCom());
			cTranLogDB.setAgentCom(tContDB.getAgentCom());
			cTranLogDB.setAgentCode(tContDB.getAgentCode());
	        cTranLogDB.setRCode(0); //-1-δ���أ�0-���׳ɹ������أ�1-����ʧ�ܣ�����
	        cTranLogDB.setRText("���׳ɹ�");
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"����ʧ�ܣ�", ex);
			if (null != cTranLogDB) {    //������־ʧ��ʱcTranLogDB=null
			    if( noRealTimeFlag ){
			        cTranLogDB.setRCode(AblifeCodeDef.RCode_NoRealTime);
			    }else{
			        cTranLogDB.setRCode(1);
			    }
	            cTranLogDB.setRText(ex.getMessage());
			}
			if( noRealTimeFlag ){
                //�˺�
                cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_RenHe, ex.getMessage());
            }else{
                cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
            }
		}
		
		if (null != cTranLogDB) {	//������־ʧ��ʱcTranLogDB=null
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("������־��Ϣʧ�ܣ�" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out NewContAll.service()!");
		return cOutXmlDoc;
	}
	
	private ContDB getContDB() {
		cLogger.debug("Into NewContAll.getContDB()...");
		
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
		mContDB.setSignDate(mOutMainRiskEle.getChildText(SignDate));
		mContDB.setPrem(mOutBodyEle.getChildText(Prem));
		mContDB.setAmnt(mOutBodyEle.getChildText(Amnt));
		mContDB.setState(AblifeCodeDef.ContState_Sign);
		mContDB.setBak1(mInRiskEle.getChildText(MainRiskCode));
		mContDB.setOperator(CodeDef.SYS);
		
		cLogger.debug("Out NewContAll.getContDB()!");
		return mContDB;
	}
	
	private void rollback() {
		cLogger.debug("Into NewContAll.rollback()...");
		
		Element mInRootEle = cInXmlDoc.getRootElement();
		Element mInBodyEle = mInRootEle.getChild(Body);
		Element mHeadEle = (Element) mInRootEle.getChild(Head).clone();
		if(mHeadEle.getChild(ServiceId) == null){
			Element mServiceIdEle = new Element(ServiceId);
			mHeadEle.addContent(mServiceIdEle);
		}
		mHeadEle.getChild(ServiceId).setText(AblifeCodeDef.SID_Bank_ContRollback);
		Element mBodyEle = new Element(Body);
		mBodyEle.addContent(
		        (Element) mInBodyEle.getChild(ProposalPrtNo).clone());
		mBodyEle.addContent(
		        (Element) mInBodyEle.getChild(ContPrtNo).clone());
		if(cOutXmlDoc!= null){
			mBodyEle.addContent(
					(Element) cOutXmlDoc.getRootElement().getChild(Body).getChild(ContNo).clone());
		}
		Element mTranDataEle = new Element(TranData);
		mTranDataEle.addContent(mHeadEle);
		mTranDataEle.addContent(mBodyEle);
		Document mInXmlDoc = new Document(mTranDataEle);
		
		try {
			new CallWebsvcAtomSvc(mHeadEle.getChildText(ServiceId)).call(mInXmlDoc);
		} catch (Exception ex) {
			cLogger.error("�ع�����ʧ�ܣ�", ex);
		}
		
		cLogger.debug("Out NewContAll.getContDB()!");
	}
}
