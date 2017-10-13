package com.sinosoft.midplat.hxb.service;

import java.util.List;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.lis.pubfun.MMap;
import com.sinosoft.lis.pubfun.PubSubmit;
import com.sinosoft.lis.schema.HxbankInfoSchema;
import com.sinosoft.lis.vschema.HxbankInfoSet;
import com.sinosoft.midplat.common.CodeDef;
import com.sinosoft.midplat.common.DateUtil;
import com.sinosoft.midplat.common.MidplatUtil;
import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.midplat.hxb.format.HxbConstant;
import com.sinosoft.midplat.service.ServiceImpl;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.VData;

public class HxbAgentComBlcService extends ServiceImpl {

	public HxbAgentComBlcService(Element pThisBusiConf) {
		super(pThisBusiConf);
	}
	
	public Document service(Document pInXmlDoc) {
		long mStartMillis = System.currentTimeMillis();
		cLogger.info("Into HxbAgentComBlcService.service()...");
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
				throw new MidplatException("已成功做过网点信息更新，不能重复操作！");
			} else if (tExeSQL.mErrors.needDealError()) {
				throw new MidplatException("查询网点更新历史信息异常！");
			}
			
			//处理前置机传过来的报错信息(扫描超时等)
			String tErrorStr = cInXmlDoc.getRootElement().getChildText(Error);
			if (null != tErrorStr) {
				throw new MidplatException(tErrorStr);
			}
			
			//保存网点明细信息
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
		
		cLogger.info("Out HxbAgentComBlcService.service()!");
		return cOutXmlDoc;
	}
	
	/**
	 * 保存网点明细，返回处理结果报文
	 */
	@SuppressWarnings("unchecked")
	private Document saveDetails(Document pXmlDoc) throws Exception {
		cLogger.debug("Into HxbAgentComBlcService.saveDetails()...");
		
		String currDate = DateUtil.getCur10Date();
		String currTime = DateUtil.getCur8Time();
		Document retDoc = new Document();	// 返回的结果报文
		boolean flag = true;
		String msg = "hxb提交客户网点数据入库成功";
		
		Element mTranDataEle = pXmlDoc.getRootElement();
		String mTranCom = mTranDataEle.getChild(Head).getChildTextTrim(TranCom);
		Element mBodyEle = mTranDataEle.getChild(Body);
		
		List<Element> mDetailList = mBodyEle.getChildren(Detail);
		int count = mDetailList.size();
		cLogger.debug("更新hxb网点总数：" + count + "条");
		
		if(count>0){	// 有更新数据，则更新网点
			
			String mSqlStr = "delete from hxbankinfo";	// 删除网点的全部数据
			boolean tSSRS = new ExeSQL().execUpdateSQL(mSqlStr);
			if(!tSSRS){
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "hxb删除网点数据失败");
				throw new MidplatException("hxb删除网点数据失败！");
			}
			
			HxbankInfoSet mHxbankInfoSet = new HxbankInfoSet();
			for(Element tDetailEle : mDetailList){
				
				HxbankInfoSchema tHxbankInfoSchema = new HxbankInfoSchema();

				tHxbankInfoSchema.setTranCom(mTranCom);
				tHxbankInfoSchema.setBankCode(tDetailEle.getChildTextTrim(HxbConstant.BankCode));
				tHxbankInfoSchema.setBankFullName(tDetailEle.getChildTextTrim(HxbConstant.BankFullName));
				tHxbankInfoSchema.setBankShortName(tDetailEle.getChildTextTrim(HxbConstant.BankShortName));
				tHxbankInfoSchema.setBankType(tDetailEle.getChildTextTrim(HxbConstant.BankType));
				tHxbankInfoSchema.setUpBankCode(tDetailEle.getChildTextTrim(HxbConstant.UpBankCode));
				tHxbankInfoSchema.setUpBankShotName(tDetailEle.getChildTextTrim(HxbConstant.UpBankShotName));
				
				tHxbankInfoSchema.setMakeDate(currDate);
				tHxbankInfoSchema.setMakeTime(currTime);
				tHxbankInfoSchema.setModifyDate(currDate);
				tHxbankInfoSchema.setModifyTime(currTime);
				tHxbankInfoSchema.setOperator(HxbConstant.midplat);
				
				mHxbankInfoSet.add(tHxbankInfoSchema);
				
				if (mHxbankInfoSet.size() % 500 == 0) {
					if(!commonPart4GetCommision(mHxbankInfoSet)){
						cLogger.debug("hxb提交客户网点数据部分或全部入库失败");
						msg = "hxb提交客户网点数据部分或全部入库失败";
						flag = false;
					}
					mHxbankInfoSet.clear();
				}
			}
			
			if(!commonPart4GetCommision(mHxbankInfoSet)){
				cLogger.debug("hxb提交客户网点数据部分或全部入库失败");
				msg = "hxb提交客户网点数据部分或全部入库失败";
				flag = false;
			}
			
			if(flag){	// 网点数据入库成功 
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, msg);	
			}else{	// 网点数据入库失败
				retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_ERROR, msg);
			}
			
		}else{	// 无数据则不更新网点信息
			retDoc = MidplatUtil.getSimpOutXml(CodeDef.RCode_OK, "交易成功！网点文件无数据，不做数据更新，沿用前一天的网点数据");
		}
		
		cLogger.debug("Out HxbAgentComBlcService.saveDetails()!");
		return retDoc;
	}
	
	/**
	 * 提交数据，如果成功返回ture，如果提交数据失败返回false
	 * @param cHxbankInfoSet
	 * @return
	 */
	private boolean commonPart4GetCommision(HxbankInfoSet cHxbankInfoSet){
		
		MMap cMap = new MMap();

		cMap.put(cHxbankInfoSet, "INSERT");
		VData tInputData = new VData();
		tInputData.clear();
		tInputData.add(cMap);
		PubSubmit tPubSubmit = new PubSubmit();

		if(!tPubSubmit.submitData(tInputData, "")){
			cLogger.error("网点入库信息失败！" + tPubSubmit.mErrors.getFirstError());
			return false;
		}
		return true;
		
	}
}
