package com.sinosoft.midplat.icbczj;

/**
 * �㽭����ϵͳ��Ӧ�������ֵ�ӳ���
 * ��������
 * eg��PGI������
 *     ����ToPGI����ʾ����ӳ�䵽����ϵͳ
 *     ����FromPGI:��ʾ����ϵͳӳ�䵽����
 *     
 * @author liying
 * @date   20150805
 * 
 */
public class IcbcZJCodeMapping {
	
	
	/**
	 * ���ִ���ӳ�䣬���ĵ�����
	 * @param riskCode	���ִ���
	 * @return					���ж˶�������ִ���
	 */
	public static String riskCodeFromPGI(String riskCode) {
	     if ("L12077".equals(riskCode)) {
            // ����ʢ��2���������գ������ͣ�
            return "008";
        }else if("L12102".equals(riskCode)) {//����ʢ��9����ȫ���գ������ͣ�
        	return "014";
        }else {
            return "";
        }
	}
	
	/**
	 * ҵ������ӳ�䣬���ĵ�����
	 * @param edorType	ҵ������
	 * @return  �㽭���ж����ҵ������
	 */
	public static String edorTypeFromPGI(String edorType) {
	     if ("WT".equals(edorType)) {
           // ����
           return "07";
       }else if ("MQ".equals(edorType)) {
           // ����
           return "09";
       } else {
           return "";
       }
	}
	
	/**
	 * ��������ӳ�䣬�ո�������--֧�����˽��ף�ҵ�����͹�ϵת����
	 * @param tranType	�������ͣ�01��ԥ���˱���02���ڸ�����03��
	 * @return  �㽭���ж���Ľ�������
	 */
	public static String tranTypeFromPGI(String tranType) {
		//Ŀǰ�ո�ϵͳ��������ͨCT��XT������������
	     if ("CT".equals(tranType)) {
           // ����
           return "01";
       }else if ("XT".equals(tranType)) {
           // Э���˱�
           return "01";
       }else if ("MQ".equals(tranType)) {
           // ����
           return "02";
       }else if ("PN".equals(tranType)) {
           // ���
           return "03";
       } else {
           return "";
       }
	}
	
	/**
	 * ��������ӳ�䣬���ĵ�����--��˾��ȫ�����ļ��������ף�ҵ�����͹�ϵת��
	 * @param tranType	�������ͣ�01��ԥ���˱���02���ڸ�����03��
	 * @return  �㽭���ж���Ľ�������
	 */
	public static String tranType1FromPGI(String tranType) {
		//Ŀǰ�ո�ϵͳ��������ͨCT��XT������������
	     if ("WT".equals(tranType)) {
           // ����
           return "01";
       }else if ("MQ".equals(tranType)) {
           // ����
           return "02";
       } else {
           return "";
       }
	}
	
	/**
	 * ��������ӳ�䣬���ĵ�����
	 * ���У���������(3λ)��0-����;1-����;2-����;3-����Ӫ��;5-�ֻ�����; 6-ҵ������;7- ������۷����ն�;8-�����ն�;10-����Ӫ����
	 * ���ģ�����������6-���棬7-������8�����նˡ�M-�ֻ�
	 * @param SourceType	��������
	 * @return  �㽭���ж����������������
	 */
	public static String sourceTypeFromPGI(String sourceType) {
		if ("6".equals(sourceType)) {
           // ����
           return "0";
       }else if ("7".equals(sourceType)) {
           // ����
           return "1";
       }else if ("8".equals(sourceType)) {
           // �����ն�
           return "8";
       }else if ("M".equals(sourceType)) {
           // �ֻ�
           return "5";
       } else{
           return "";
       }
	}
	
	
	
	/**
	 * �����ո����㽭����ר����Ʒ��Ʒ���룬���У�����ж����Ʒʱ����","�ָ�
	 * @return  �㽭����ר����Ʒ�����Ĳ�Ʒ�����б�
	 */
	public static String riskCodes() {
		return "L12077";
	}
	
	/**
	 * �����ո����㽭����ר����Ʒ��Ʒ���룬���У�����ж����Ʒʱ����","�ָ�
	 * @return  �㽭����ר����Ʒ�����Ĳ�Ʒ�����б�
	 */
	public static String riskCode_add() {
		return "L12102";
	}
}
