package com.sinosoft.midplat.bjrcb.format;

public class Trans_bjrcb {

	/**
	 * "Ӫ����Ա����"��"Ӫ����Ա�����������ʸ�֤"������Ϣ���ֵ��ͨ��"PolHPrintCode"��ǩ���ݸ���˾����ͨ
	 * ��Ӫ����Ա������Ӫ����Ա�����������ʸ�֤�����м��ð�ǵ�"��"�ָ�
	 * @param polHPrintCode
	 * @return
	 */
	public static String BankToTellerName(String polHPrintCode) {
		if(polHPrintCode.contains(":")){
			String[] tSubMsgs = polHPrintCode.toString().split(":", -1);
			polHPrintCode = tSubMsgs[0];
				return polHPrintCode;
		}
		return polHPrintCode;
	}
	/**
	 * ��ȡ��Ӫ����Ա�����������ʸ�֤
	 * @param polHPrintCode
	 * @return
	 */
	public static String BankToTellerCertiCode(String polHPrintCode) {
		if(polHPrintCode.contains(":")){
			String[] tSubMsgs = polHPrintCode.toString().split(":", -1);
			polHPrintCode = tSubMsgs[1];
				return polHPrintCode;
		}
		return "";
	}
}
