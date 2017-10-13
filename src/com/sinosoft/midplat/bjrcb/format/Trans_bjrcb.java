package com.sinosoft.midplat.bjrcb.format;

public class Trans_bjrcb {

	/**
	 * "营销人员姓名"和"营销人员代理保险销售资格证"两个信息项的值都通过"PolHPrintCode"标签传递给我司银保通
	 * （营销人员姓名：营销人员代理保险销售资格证），中间用半角的"："分隔
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
	 * 获取：营销人员代理保险销售资格证
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
