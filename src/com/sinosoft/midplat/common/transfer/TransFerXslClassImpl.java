package com.sinosoft.midplat.common.transfer;

import org.apache.log4j.Logger;

public class TransFerXslClassImpl implements ITransferXslClass {

	protected final Logger cLogger = Logger.getLogger(getClass());
	
	private static TransFerXslClassImpl transFerXsl = new TransFerXslClassImpl();
	
	private TransFerXslClassImpl(){
		
	}
	
	public String getTransXslClass( String manageCom, String trancom, String riskcCode) throws Exception {
		
		cLogger.info("Into TransFerXslClassImpl.getTransXslClass ��ȡת������Ϣ");
		String transXslName = "";
		try{
			transXslName = TransXslContainer.getInstance().getTransXslClassName(manageCom, trancom, riskcCode);
	    
			cLogger.info("TransFerXslClassImpl.getTransXslClass ��ȡת������Ϣ:"
					+ transXslName + "; ���������Ϣ��manageCom����" + manageCom
					+ "; ���л�����trancom����" + trancom);
		}catch(Exception exp){
			
			cLogger.error("��ȡ����ת������Ϣ����...", exp);
		}
		
		cLogger.info("Out TransFerXslClassImpl.getTransXslClass ��ȡת������Ϣ");
		return transXslName;
	}

	public String getTransXslClass(String trancom, String riskcCode) throws Exception {

		return getTransXslClass("86",trancom,riskcCode);
	}


	public static TransFerXslClassImpl getInstance(){
		return transFerXsl;
	}
}


