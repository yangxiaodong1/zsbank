/**
 * 冲正+录单核保+收费签单，针对北京银行新契约
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
		
	      //非实时核保标志
        boolean noRealTimeFlag = false;
        
		try {
			cTranLogDB = insertTranLog(cInXmlDoc);
			
			//校验系统中是否有相同保单正在处理，尚未返回
			int tLockTime = 300;	//默认超时设置为5分钟(300s)；如果未配置锁定时间，则使用该值。
			try {
				tLockTime = Integer.parseInt(cThisBusiConf.getChildText(locktime));
			} catch (Exception ex) {	//使用默认值
				cLogger.debug("未配置锁定时间，或配置有误，使用默认值(s)："+tLockTime, ex);
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
		        throw new MidplatException("此保单数据正在处理中，请稍候！");
		    }
			//通用交易
			new RuleParser().check(cInXmlDoc);
			/**
			 * 北京银行在新契约申请时保险公司直接生成保单，但北京银行只有新契约确认后才生成正式保单；
			 * 北京银行会同一投保单号、同一单证号重复新契约申请
			 */
			//-------------------------------------------------------------冲正交易begin----------------------------------------------
			
			String mSqlStr = "select   *  from cont  where ProposalPrtNo='" + mProposalPrtNo +"'"
			+ " and TranDate=" + mHeadEle.getChildText(TranDate)
			+ " and TranCom=" + mHeadEle.getChildText(TranCom)
	        + " and NodeNo=" + mHeadEle.getChildText(NodeNo)
	        + " and State = "+AblifeCodeDef.ContState_Sign+""
	        ;
			ContSet mContSet = new ContDB().executeQuery(mSqlStr);
			if (1 <= mContSet.size()) {
				//如果银行重复新契约申请，需要冲正后再生成保单
//				Element mContNo = new Element("ContNo");
//				mContNo.setText(mSSRS.GetText(1, 1));
//				mBodyEle.addContent(mContNo);
				rollback();
				ContSchema tContSchema = mContSet.get(1);
				//重置为未签单状态
				Date tCurDate = new Date();
				tSqlStr = new StringBuilder("update Cont set State=-State")
					.append(", ModifyDate=").append(DateUtil.get8Date(tCurDate))
					.append(", ModifyTime=").append(DateUtil.get6Time(tCurDate))
					.append(" where RecordNo=").append(tContSchema.getRecordNo())
					.toString();
				ExeSQL tExeSQL = new ExeSQL();
				if (!tExeSQL.execUpdateSQL(tSqlStr)) {
					cLogger.error("更新保单状态(Cont)失败！" + tExeSQL.mErrors.getFirstError());
				}
				
			}
			//-------------------------------------------------------------冲正交易end------------------------------------------------
			
			//请求核心
		    cOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_ContInput).call(cInXmlDoc);
			Element tOutRootEle = cOutXmlDoc.getRootElement();
			Element tOutHeadEle = tOutRootEle.getChild(Head);
			Element tOutBodyEle = tOutRootEle.getChild(Body);
            int resultCode =  Integer.parseInt(tOutHeadEle.getChildText(Flag));
            if (resultCode!=CodeDef.RCode_OK) { //交易失败 修正Oracle不能存储单引号的bug
                if(resultCode==AblifeCodeDef.RCode_NoRealTime){
                    //转人工核保
                    noRealTimeFlag = true;
                }
                throw new MidplatException(tOutHeadEle.getChildText(Desc));
            }
			
			//调用收费签单接口，准备请求报文
			Element tBodyEle = new Element(Body);
			//传统银保通
			tBodyEle.addContent(
			        (Element) mBodyEle.getChild(ProposalPrtNo).clone());
			tBodyEle.addContent(
			        (Element) mBodyEle.getChild(ContPrtNo).clone());
			tBodyEle.addContent(
					(Element) tOutBodyEle.getChild(ContNo).clone());
			Element tTranDataEle = new Element(TranData);
			tTranDataEle.addContent(mHeadEle);
			tTranDataEle.addContent(tBodyEle);
			
			//请求核心
		    cOutXmlDoc = new CallWebsvcAtomSvc(AblifeCodeDef.SID_Bank_ContConfirm).call(new Document(tTranDataEle));
			
			//校验响应结果
			tOutRootEle = cOutXmlDoc.getRootElement();
			tOutHeadEle = tOutRootEle.getChild(Head);
			tOutBodyEle = tOutRootEle.getChild(Body);
			if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {
				throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			

			//核心不存保单印刷号，用请求报文对应值覆盖
			tOutBodyEle.getChild(ContPrtNo).setText(mContPrtNo);
			
			//核心可能将一个产品的两个险种都定义为主险，而银行则认为一主一附，以银行报文为准，覆盖核心记录
			/*
			 * REMOVED 2013-11-26 与核心开发同事沟通，目前不存在：核心可能将一个产品的两个险种都定义为主险，所以去掉下面代码。
			 */
//			String tMainRiskCode = mBodyEle.getChild(Risk).getChildText(MainRiskCode);
			List<Element> tRiskList = tOutBodyEle.getChildren(Risk);
			int tSize = tRiskList.size();
			for (int i = 0; i < tSize; i++) {
				Element ttRiskEle = tRiskList.get(i);
				
				/*
				 * 因按照产品组合方式通过银保通出单时，银行方录入产品组合编码时会认为产品组合编码是主险编码，存入cont表中的bak1中。<br>
				 * 但是在核心系统返回的相应报文中，产品组合编码是contPlancode，主险：<risk />标签里的<riskCode>和<mainRiskcode>相同的为主险；
				 * 附加险：<risk />标签里的<riskCode>和<mainRiskcode>不相同的附加险。<br>
				 * 如果按照："核心可能将一个产品的两个险种都定义为主险，而银行则认为一主一附，以银行报文为准，覆盖核心记录"进行<mainRiskcode>标签修改就会导致
				 * 没有<riskCode>和<mainRiskcode>相同的情况。在后续银保通做转码时会出现问题，
				 * 所以没有必要执行：核心可能将一个产品的两个险种都定义为主险，而银行则认为一主一附，以银行报文为准，覆盖核心记录。
				 * 
				 * REMOVED 2013-11-26 与核心开发同事沟通，目前不存在：核心可能将一个产品的两个险种都定义为主险，所以去掉下面代码。
				 */
				
//				ttRiskEle.getChild(MainRiskCode).setText(tMainRiskCode);
				
//				if (tMainRiskCode.equals(ttRiskEle.getChildText(RiskCode))) {
				if (ttRiskEle.getChildText(MainRiskCode).equals(ttRiskEle.getChildText(RiskCode))) {
					tRiskList.add(0, tRiskList.remove(i));	//将主险调整到最前面
				}
			}
			
			//超时自动删除数据
			long tUseTime = System.currentTimeMillis() - mStartMillis;
			int tTimeOut = 60;	//默认超时设置为1分钟；如果未配置超时时间，则使用该值。
			try {
				tTimeOut = Integer.parseInt(cThisBusiConf.getChildText(timeout));
			} catch (Exception ex) {	//使用默认值
				cLogger.debug("未配置超时，或配置有误，使用默认值(s)："+tTimeOut, ex);
			}
			if (tUseTime > tTimeOut*1000) {
				cLogger.error("处理超时！UseTime=" + tUseTime/1000.0 + "s；TimeOut=" + tTimeOut + "s；投保书：" + mProposalPrtNo);
				rollback();	//回滚系统数据
				throw new MidplatException("系统繁忙，请稍后再试！");
			}
			
			//保存保单信息
			ContDB tContDB = getContDB();
			Date tCurDate = new Date();
			tContDB.setMakeDate(DateUtil.get8Date(tCurDate));
			tContDB.setMakeTime(DateUtil.get6Time(tCurDate));
			tContDB.setModifyDate(tContDB.getMakeDate());
			tContDB.setModifyTime(tContDB.getMakeTime());
			if (!tContDB.insert()) {
				cLogger.error("保单信息(Cont)入库失败！" + tContDB.mErrors.getFirstError());
			}
			cTranLogDB.setContNo(tContDB.getContNo());
			cTranLogDB.setManageCom(tContDB.getManageCom());
			cTranLogDB.setAgentCom(tContDB.getAgentCom());
			cTranLogDB.setAgentCode(tContDB.getAgentCode());
	        cTranLogDB.setRCode(0); //-1-未返回；0-交易成功，返回；1-交易失败，返回
	        cTranLogDB.setRText("交易成功");
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			if (null != cTranLogDB) {    //插入日志失败时cTranLogDB=null
			    if( noRealTimeFlag ){
			        cTranLogDB.setRCode(AblifeCodeDef.RCode_NoRealTime);
			    }else{
			        cTranLogDB.setRCode(1);
			    }
	            cTranLogDB.setRText(ex.getMessage());
			}
			if( noRealTimeFlag ){
                //人核
                cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_RenHe, ex.getMessage());
            }else{
                cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
            }
		}
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
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
		Element mOutMainRiskEle = mOutBodyEle.getChild(Risk);	//前面已经做排序了，第一个节点就是主险信息
		
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
			cLogger.error("回滚数据失败！", ex);
		}
		
		cLogger.debug("Out NewContAll.getContDB()!");
	}
}
