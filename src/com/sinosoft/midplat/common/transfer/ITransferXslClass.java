package com.sinosoft.midplat.common.transfer;

public interface ITransferXslClass {

	/**
	 * ͨ�����б��룬���ֱ��룬����������ر���ת����
	 * @param cTrancom
	 * @param cRiskcCode
	 * @param cManageCom
	 * @return
	 */
	public String getTransXslClass(String cTrancom, String cRiskcCode, String cManageCom) throws Exception;
	
	/**
	 * ͨ�����б��룬���ֱ�����ر���ת����
	 * @param cTrancom
	 * @param cRiskcCode
	 * @return
	 */
	public String getTransXslClass(String cTrancom, String cRiskcCode) throws Exception;
}
