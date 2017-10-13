package com.sinosoft.midplat.common.transfer;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

import com.sinosoft.midplat.exception.MidplatException;
import com.sinosoft.utility.ExeSQL;
import com.sinosoft.utility.SSRS;

public class TransXslContainer {

	protected final Logger cLogger = Logger.getLogger(getClass());
	
	private final Map<String,String> hashMap = new ConcurrentHashMap<String,String>();
	
	private static TransXslContainer transXslCon = new TransXslContainer();
	
	
	public static TransXslContainer getInstance(){
		
		return transXslCon;
	}
	
	private TransXslContainer(){
		
		init();
	}
	
	/**
	 * 将转换类信息从数据库中加载出来，缓存如Map中
	 */
	private void init(){
		
		cLogger.info("Into TransXslContainer加载报文转换类信息...");
		try{
			StringBuffer mSqlStr = new StringBuffer();
	        mSqlStr.append("select t.MANAGECOM,t.TRANCOM,t.RISKCODE,t.CLASSNAME FROM TRANSFERXSLCLASS t ");
	        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
	        
	        if(mSSRS.MaxRow==0){
	        	throw new MidplatException("未查询报文转换加载类信息，请确认相关信息已经配置");
	        }else{
	        	for(int i=1; i<=mSSRS.MaxRow; i++){
	        		String tKey = getKey(mSSRS.GetText(i, 1).trim(),mSSRS.GetText(i, 2).trim(),mSSRS.GetText(i, 3).trim());
		        	hashMap.put(tKey, mSSRS.GetText(i, 4).trim());
	        	}
	        }
	        
		}catch(Exception exp){
			
			cLogger.error("加载报文转换类信息错误...", exp);
		}
		
		cLogger.info("Out TransXslContainer加载报文转换类信息...");
	}
	
	/**
	 * 先从内存Map中查询转换类信息，如果查询不到则从数据库中加载。
	 * @param cManageCom 管理机构
	 * @param cTranCom	交易机构
	 * @param cRiskCode	险种代码
	 * @return
	 * @throws Exception
	 */
	public String getTransXslClassName(String cManageCom, String cTranCom, String cRiskCode) throws Exception {
		
		String tKey = getKey(cManageCom,cTranCom,cRiskCode);
		cLogger.info("into getTransXslClassName, key value is : " + tKey);
		
		String className = hashMap.get(tKey);
		
		if(null==className || "".equals(className)){
			
			className = loadTransXslClassNameFromDB(cManageCom,cTranCom,cRiskCode,tKey);
		}
		cLogger.info("out getTransXslClassName, key value is : " + tKey);
		return className;
	}
	
	/**
	 * 从数据库加载类转换信息
	 * @param cManageCom 管理机构
	 * @param cTranCom	交易机构
	 * @param cRiskCode	险种代码
	 * @param cKey	主键：cManageCom_cTranCom_cRiskCode
	 * @return
	 * @throws Exception
	 */
	private synchronized String loadTransXslClassNameFromDB(String cManageCom, String cTranCom, String cRiskCode,String cKey) throws Exception {
		
		String className = "";
		try{
			StringBuffer mSqlStr = new StringBuffer();
	        mSqlStr.append("select CLASSNAME FROM TRANSFERXSLCLASS t ");
	        mSqlStr.append(" where t.managecom='");
	        mSqlStr.append(cManageCom);
	        mSqlStr.append("' and t.trancom='");
	        mSqlStr.append(cTranCom);
	        mSqlStr.append("' and t.riskcode='");
	        mSqlStr.append(cRiskCode);
	        mSqlStr.append("' ");
	        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
	        
	        if(mSSRS.MaxRow!=1){
	        	throw new MidplatException("查询报文转换加载类错误");
	        }
	        
	        className = mSSRS.GetText(1, 1).trim();
	        
	        hashMap.put(cKey, className);
	        
		}catch(Exception exp){
			
			cLogger.error("查询数据库信息错误...", exp);
		}
		
		return className;
	}
	
	/**
	 * 获取主键，主键形式：cManageCom_cTranCom_cRiskCode
	 * @param cManageCom
	 * @param cTranCom
	 * @param cRiskCode
	 * @return
	 */
	private String getKey(String cManageCom, String cTranCom, String cRiskCode){
		
		StringBuffer strBuff = new StringBuffer();
		strBuff.append(cManageCom).append("_").append(cTranCom).append("_").append(cRiskCode);
		
		return strBuff.toString();
	}
}
