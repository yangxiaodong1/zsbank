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
public class IcbcCodeMapping {
	
	/**
	 * ���е����֤�����Ͷ�Ӧ������
	 * ���֤����תΪ����
	 * @param idType ���е����֤����
	 * @return 		 �������֤����
	 */
	public static String idTypeToPGI(String idType){
		if ("0".equals(idType)) {
		    //���֤
		    return "0";
		}else if("1".equals(idType)) {
		    //����
		    return "1";
		}else if("2".equals(idType)) {
		    //����֤
		    return "2";
		}else if("3".equals(idType)) {
		    //ʿ��֤
		    return "2";
		}else if("5".equals(idType)) {
		    //��ʱ���֤
		    return "0";
		}else if("6".equals(idType)) {
		    //���ڱ�
		    return "5";
		}else if("9".equals(idType)) {
		    //����֤
		    return "2";
		}else{
		    //����
		    return "8";
		}		    

	}
	
	/**
	 * ���ĵ�ID���Ͷ�Ӧ������
	 * @param pgiIdType
	 * @return
	 */
	public static String idTypeFromPGI(String pgiIdType){
		switch (Integer.valueOf(pgiIdType)) {
		case 0:
			return "0";//���֤
		case 1:
			return "1";//����
		case 2:
			return "2";//����֤
		case 5:
			return "6";//���ڲ�
		default:
			return "7"; //����
		}
	}
	
	/**
	 * �ɷ�Ƶ�Σ����ĵ�����
	 * @param pgiPayIntv  ����ϵͳ��ʾ�Ľɷ�Ƶ��
	 * @return	���б�ʾ�Ľɷ�Ƶ��
	 */
	public static String payIntvFromPGI(String pgiPayIntv){
		switch (Integer.valueOf(pgiPayIntv)) {
		case 12:
			return "1";//�꽻
		case 1:
			return "2";//�½�
		case 6:
			return "3";//���꽻
		case 3:
			return "4";//����
		case 0:
			return "5";//����
		case -1:
			return "6";//�����ڽ�
		default:
			return "9";//����
		}
	}
	
	/**
	 * �ɷ��ڼ����ͣ����ĵ�����
	 * @param pgiPayEndYearFlag
	 * @return
	 */
	public static String payEndYearFlagFromPGI(String pgiPayEndYearFlag){
		if("A".equals(pgiPayEndYearFlag)){
			return "1";//����ĳȷ������
		}
		else if("Y".equals(pgiPayEndYearFlag)){
			return "2";//����
		}
		else if("M".equals(pgiPayEndYearFlag)){
			return "3";//����
		}
		else if("D".equals(pgiPayEndYearFlag)){
			return "4";//����
		}
		else
			return "9";//����
	}
	
	/**
	 * �����ڼ����ͣ����ĵ�����
	 * @param pgiInsuYearFlag	���ı����ڼ�
	 * @return					���б����ڼ�
	 */	
	public static String insuYearFlagFromPGI(String pgiInsuYearFlag){
		if("A".equals(pgiInsuYearFlag)){
			return "1";//����ĳȷ������
		}
		else if("Y".equals(pgiInsuYearFlag)){
			return "2";//�걣
		}
		else if("M".equals(pgiInsuYearFlag)){
			return "3";//�±�
		}
		else if("D".equals(pgiInsuYearFlag)){
			return "4";//�ձ�������
		}else{
			return "9";//����
		}
	}
	
	/**
	 * �˱�����,���ĵ�����
	 * @param pgiUWResult
	 * @return
	 */
	public static String uwResultFromPGI(String pgiUWResult){
        if ("9".equals(pgiUWResult)) {
            //���� ��׼�б�
            return "0"; //���� ����ͨ�� 
        }else if("4".equals(pgiUWResult)) {
            //���� �α�׼��
            return "1"; //���� �������б�
            
        }else if("1".equals(pgiUWResult)) {
            //���� �ܱ�
            return "3"; //���� �ܱ�
            
        }else if("2".equals(pgiUWResult)) {
            //���� ����
            return "5"; //���� ����
            
        }else if("a".equals(pgiUWResult)) {
            //���� ����
            return "4"; //���� �ͻ�ȡ��Ͷ��
        }else{
            //����
            return ""; 
        }
	}
	
	/**
	 * �˱�����״̬�����ĵ�����
	 * @param pgiUWResultState
	 * @return
	 */
	public static String uwResultStateFromPGI(String pgiUWResultState){
		if ("9".equals(pgiUWResultState)) {
		    //���� ��׼�б�
		    return "01"; //���� ����ͨ�� 
		}else if("4".equals(pgiUWResultState)) {
		    //���� �α�׼��
		    return "55"; //���� �����б�
		    
		}else if("1".equals(pgiUWResultState)) {
		    //���� �ܱ�
		    return "56"; //���� �ܱ�
		    
		}else if("2".equals(pgiUWResultState)) {
		    //���� ����
		    return "58"; //���� ����
		    
		}else if("a".equals(pgiUWResultState)) {
		    //���� ����
		    return "57"; //���� �ͻ�ȡ��Ͷ��
		}else{
		    //����
		    return ""; 
		}
	}
	
	/**
	 * ����״̬�����ĵ�����
	 * @param pgiProcessState	��������״̬
	 * @return					��������״̬
	 */
	public static String processStateFromPGI(String pgiProcessState) {
        if ("00".equals(pgiProcessState)) {
            // ���� δ����
            return "01";// ���� ¼����
        } else if ("01".equals(pgiProcessState)) {
            // ���� ¼����
            return "01";// ���� ¼����
        } else if ("02".equals(pgiProcessState)) {
            // ���� �˱���
            return "12";// ���� �˱�֪ͨ��
        } else if ("03".equals(pgiProcessState)) {
            // ���� �ջ���
            return "09";// ���� �ջ���
        } else if ("04".equals(pgiProcessState)) {
            // ���� �˱�ͨ�����շ�
            return "10";// ���� �˱�ͨ�����շ�
        } else {
            return "01"; // ���� ¼����
        }
    }

	/**
	 * ���ִ���ӳ�䣬���ĵ�����
	 * @param riskCode	���ִ���
	 * @return					���ж˶�������ִ���
	 */
	public static String riskCodeFromPGI(String riskCode) {
	     if ("122001".equals(riskCode)) {
            // ����ƽ�1����ȫ���գ��ֺ��ͣ�A��
            return "001";
        } else if ("122002".equals(riskCode)) {
            // ����ƽ�2����ȫ���գ��ֺ��ͣ�A��
            return "002";
        } else if ("122004".equals(riskCode)) {
            // ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A��
            return "101";
        } else if ("122003".equals(riskCode)) {
            // ����۱���1����ȫ���գ��ֺ��ͣ�A��
            return "003";
        } else if ("122006".equals(riskCode)) {
            // ����۱���2����ȫ���գ��ֺ��ͣ�A��
            return "004";
        } else if ("122008".equals(riskCode)) {
            // ���������1���������գ������ͣ�
            return "005";
        } else if ("122009".equals(riskCode)) {
            // ����ƽ�5����ȫ���գ��ֺ��ͣ�A��
            return "006";
        } else if ("122011".equals(riskCode)) {
            // ����ʢ��1���������գ������ͣ�
            return "007";
        } else if ("122012".equals(riskCode)) {
            // ����ʢ��2���������գ������ͣ�
            return "008";
        } else if ("122010".equals(riskCode)) {
            // ����ʢ��3���������գ������ͣ�
            return "009";
        } else if ("122029".equals(riskCode)) {
            // ����ʢ��5���������գ������ͣ�
            return "010";
        } else if ("122020".equals(riskCode)) {
            //�����6����ȫ���գ��ֺ��ͣ�
            return "011";
        } else if ("122036".equals(riskCode)) {
            //����ƽ�6����ȫ���գ��ֺ��ͣ�A�� 
            return "012";
        } else if("50002".equals(riskCode)){
        	// 50002-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����
        	return "013";
//        } else if("122038".equals(riskCode)){
//        	// �����ֵ����8���������գ��ֺ��ͣ�A��
//        	return "014";
        	//PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ����
        }  else if("L12079".equals(riskCode)){
        	// ����ʢ��2���������գ������ͣ�
        	return "008";
        } else if("L12078".equals(riskCode)){
        	// ����ʢ��3���������գ������ͣ�
        	return "009";
        } else if("L12100".equals(riskCode)){
        	// ����ʢ��3���������գ������ͣ�
        	return "009";
        } else if("L12074".equals(riskCode)){
        	// ����ʢ��9����ȫ���գ������ͣ�
        	return "014";
        } else if("50015".equals(riskCode)){
        	// 50015-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����
        	return "013";
        } else if("L12084".equals(riskCode)){
        	// PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A�
        	return "015";
        } else if("L12089".equals(riskCode)){
        	// PBKINSR-1023  �����²�Ʒʢ��1������ͨ����(����ʢ��1���������գ������ͣ�B��)
        	return "016";
        } else if("L12093".equals(riskCode)){
        	// PBKINSR-1235 ��������ͨ�����²�Ʒ-ʢ��9��B��
        	return "017";
        } else {
            return "";
        }
	}
	
}
