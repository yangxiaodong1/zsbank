package com.sinosoft.midplat.icbc;

/**
 * ����ϵͳ��Ӧ�������ֵ�ӳ���
 * ��������
 * eg��PGI������
 *     ����ToPGI����ʾ����ӳ�䵽����ϵͳ
 *     ����FromPGI:��ʾ����ϵͳӳ�䵽����
 *     
 * @author ChengNing
 * @date   Apr 11, 2013
 * 
 */
public class IcbcUtil {
	
	/**
	 * �������ڡ�1202--1211����Χ�ҹ�Ա����Ϊ��231��
	 * @param regionCode ��������
	 * @param teller ��Ա���� 
	 * @return 		 �ж��Ƿ�Ϊ�㽭����ר��:1�ǣ�0��
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
