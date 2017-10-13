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
	 * ��ת������Ϣ�����ݿ��м��س�����������Map��
	 */
	private void init(){
		
		cLogger.info("Into TransXslContainer���ر���ת������Ϣ...");
		try{
			StringBuffer mSqlStr = new StringBuffer();
	        mSqlStr.append("select t.MANAGECOM,t.TRANCOM,t.RISKCODE,t.CLASSNAME FROM TRANSFERXSLCLASS t ");
	        SSRS mSSRS = new ExeSQL().execSQL(mSqlStr.toString());
	        
	        if(mSSRS.MaxRow==0){
	        	throw new MidplatException("δ��ѯ����ת����������Ϣ����ȷ�������Ϣ�Ѿ�����");
	        }else{
	        	for(int i=1; i<=mSSRS.MaxRow; i++){
	        		String tKey = getKey(mSSRS.GetText(i, 1).trim(),mSSRS.GetText(i, 2).trim(),mSSRS.GetText(i, 3).trim());
		        	hashMap.put(tKey, mSSRS.GetText(i, 4).trim());
	        	}
	        }
	        
		}catch(Exception exp){
			
			cLogger.error("���ر���ת������Ϣ����...", exp);
		}
		
		cLogger.info("Out TransXslContainer���ر���ת������Ϣ...");
	}
	
	/**
	 * �ȴ��ڴ�Map�в�ѯת������Ϣ�������ѯ����������ݿ��м��ء�
	 * @param cManageCom �������
	 * @param cTranCom	���׻���
	 * @param cRiskCode	���ִ���
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
	 * �����ݿ������ת����Ϣ
	 * @param cManageCom �������
	 * @param cTranCom	���׻���
	 * @param cRiskCode	���ִ���
	 * @param cKey	������cManageCom_cTranCom_cRiskCode
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
	        	throw new MidplatException("��ѯ����ת�����������");
	        }
	        
	        className = mSSRS.GetText(1, 1).trim();
	        
	        hashMap.put(cKey, className);
	        
		}catch(Exception exp){
			
			cLogger.error("��ѯ���ݿ���Ϣ����...", exp);
		}
		
		return className;
	}
	
	/**
	 * ��ȡ������������ʽ��cManageCom_cTranCom_cRiskCode
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
