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
 * Company:安邦保险IT部
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
				throw new MidplatException("已成功做过客户经理信息更新，不能重复操作！");
			} else if (tExeSQL.mErrors.needDealError()) {
				throw new MidplatException("查询客户经理更新历史信息异常！");
			}
			
			//处理前置机传过来的报错信息(扫描超时等)
			String tErrorStr = cInXmlDoc.getRootElement().getChildText(Error);
			if (null != tErrorStr) {
				throw new MidplatException(tErrorStr);
			}
			
			//保存客户经理明细信息
			cOutXmlDoc = saveDetails(cInXmlDoc);
			
			Element tOutHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			if (CodeDef.RCode_ERROR == Integer.parseInt(tOutHeadEle.getChildText(Flag))) {	//交易失败
				throw new MidplatException(tOutHeadEle.getChildText(Desc));
			}
			
		} catch (Exception ex) {
			cLogger.error(cThisBusiConf.getChildText(name)+"交易失败！", ex);
			cOutXmlDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, ex.getMessage());
		}
		
		if (null != cTranLogDB) {	//插入日志失败时cTranLogDB=null
			Element tHeadEle = cOutXmlDoc.getRootElement().getChild(Head);
			cTranLogDB.setRCode(tHeadEle.getChildText(Flag));	//-1-未返回；0-交易成功，返回；1-交易失败，返回
			cTranLogDB.setRText(tHeadEle.getChildText(Desc));
			long tCurMillis = System.currentTimeMillis();
			cTranLogDB.setUsedTime((int)(tCurMillis-mStartMillis)/1000);
			cTranLogDB.setModifyDate(DateUtil.get8Date(tCurMillis));
			cTranLogDB.setModifyTime(DateUtil.get6Time(tCurMillis));
			if (!cTranLogDB.update()) {
				cLogger.error("更新日志信息失败！" + cTranLogDB.mErrors.getFirstError());
			}
		}
		
		cLogger.info("Out HxbManagerBlcService.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * 保存客户经理明细，返回处理结果报文
	 */
	@SuppressWarnings("unchecked")
	private Document saveDetails(Document pXmlDoc) throws Exception {
		cLogger.debug("Into HxbManagerBlcService.saveDetails()...");
		
		String currDate = DateUtil.getCur10Date();
		String currTime = DateUtil.getCur8Time();
		Document retDoc = new Document();	// 返回的结果报文
		boolean flag = true;
		String msg = "hxb提交客户客户经理数据入库成功";
		
		Element mTranDataEle = pXmlDoc.getRootElement();
		String mTranCom = mTranDataEle.getChild(Head).getChildTextTrim(TranCom);
		Element mBodyEle = mTranDataEle.getChild(Body);
		
		List<Element> mDetailList = mBodyEle.getChildren(Detail);
		int count = mDetailList.size();
		cLogger.debug("更新hxb客户经理总数：" + count + "条");
		
		if(count>0){	// 有更新数据，则更新网点
			
			String mSqlStr = "delete from hxbankmanager";	// 删除客户经理的全部数据
			boolean tSSRS = new ExeSQL().execUpdateSQL(mSqlStr);
			if(!tSSRS){
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "hxb删除客户经理数据失败");
				throw new MidplatException("hxb删除客户经理数据失败！");
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
						cLogger.debug("hxb提交客户客户经理数据部分或全部入库失败");
						msg = "hxb提交客户客户经理数据部分或全部入库失败";
						flag = false;
					}
					mHxbankManagerSet.clear();
				}
			}
			
			if(!commonPart4GetCommision(mHxbankManagerSet)){
				cLogger.debug("hxb提交客户客户经理数据部分或全部入库失败");
				msg = "hxb提交客户客户经理数据部分或全部入库失败";
				flag = false;
			}
			
			if(flag){	// 客户经理数据入库成功 
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, msg);	
			}else{	// 客户经理数据入库失败
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, msg);
			}
			
		}else{	// 无数据则不更新网点信息
			retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功！客户经理文件无数据，不做数据更新，沿用前一天的客户经理数据");
		}
		
		cLogger.debug("Out HxbManagerBlcService.saveDetails()!");
		return retDoc;
	}
	
	/**
	 * 提交数据，如果成功返回ture，如果提交数据失败返回false
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
			cLogger.error("客户经理入库信息失败！" + tPubSubmit.mErrors.getFirstError());
			return false;
		}
		return true;
		
	}
}

