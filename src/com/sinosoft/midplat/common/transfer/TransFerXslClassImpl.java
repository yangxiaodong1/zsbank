package com.sinosoft.midplat.common.transfer;

import org.apache.log4j.Logger;

public class TransFerXslClassImpl implements ITransferXslClass {

	protected final Logger cLogger = Logger.getLogger(getClass());
	
	private static TransFerXslClassImpl transFerXsl = new TransFerXslClassImpl();
	
	private TransFerXslClassImpl(){
		
	}
	
	public String getTransXslClass( String manageCom, String trancom, String riskcCode) throws Exception {
		
		cLogger.info("Into TransFerXslClassImpl.getTransXslClass 获取转换类信息");
		String transXslName = "";
		try{
			transXslName = TransXslContainer.getInstance().getTransXslClassName(manageCom, trancom, riskcCode);
	    
			cLogger.info("TransFerXslClassImpl.getTransXslClass 获取转换类信息:"
					+ transXslName + "; 管理机构信息（manageCom）：" + manageCom
					+ "; 银行机构（trancom）：" + trancom);
		}catch(Exception exp){
			
			cLogger.error("获取报文转换类信息错误...", exp);
		}
		
		cLogger.info("Out TransFerXslClassImpl.getTransXslClass 获取转换类信息");
		return transXslName;
	}

	public String getTransXslClass(String trancom, String riskcCode) throws Exception {

		return getTransXslClass("86",trancom,riskcCode);
	}


	public static TransFerXslClassImpl getInstance(){
		return transFerXsl;
	}
}


