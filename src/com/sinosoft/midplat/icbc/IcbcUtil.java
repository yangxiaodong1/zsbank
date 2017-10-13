package com.sinosoft.midplat.icbc;

/**
 * 工行系统对应的数据字典映射表
 * 命名规则：
 * eg：PGI：核心
 *     类型ToPGI：表示银行映射到核心系统
 *     类型FromPGI:表示核心系统映射到银行
 *     
 * @author ChengNing
 * @date   Apr 11, 2013
 * 
 */
public class IcbcUtil {
	
	/**
	 * 地区码在“1202--1211”范围且柜员代码为“231”
	 * @param regionCode 地区代码
	 * @param teller 柜员代码 
	 * @return 		 判断是否为浙江工行专属:1是，0否
	 */
	public static String zjCheck(String regionCode, String teller){
		
		if("01202".compareTo(regionCode) <= 0 && "01211" .compareTo(regionCode) >=0 && "231".equals(teller) ) {
			return "1";
		}else {
			return "0";
		}

	}
	public static void main(String[] args) {
		String regionCode = "01209";
		String teller = "231";
		System.out.println(zjCheck(regionCode,teller));
	}
	
}
