package com.sinosoft.midplat.common.transfer;

public interface ITransferXslClass {

	/**
	 * 通过银行编码，险种编码，管理机构加载报文转换类
	 * @param cTrancom
	 * @param cRiskcCode
	 * @param cManageCom
	 * @return
	 */
	public String getTransXslClass(String cTrancom, String cRiskcCode, String cManageCom) throws Exception;
	
	/**
	 * 通过银行编码，险种编码加载报文转换类
	 * @param cTrancom
	 * @param cRiskcCode
	 * @return
	 */
	public String getTransXslClass(String cTrancom, String cRiskcCode) throws Exception;
}
