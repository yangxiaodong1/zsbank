package com.sinosoft.midplat.common;

import java.util.HashMap;

/**
 * ����ʱ��Ҫ��δ���õ�����������
 * @author ab029800
 *
 */
public class ABlifeConstants implements AblifeCodeDef {
	
		
	public static String getEdrServiceId(String funcFlag) throws Exception{
		
		switch(Integer.valueOf(funcFlag)){
			case 106 : return SID_BANK_EDR_SERVICE; 					
			
			case 108 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			case 107 : return SID_BANK_EDR_SERVICE ;
			
			case 109 : return SID_BANK_EDR_SERVICE ;
						
			case 110 : return SID_BANK_EDR_SERVICE; 
			
			case 111 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			case 132 : return SID_BANK_EDR_SERVICE;
			
			case 133 : return SID_BANK_EDR_SERVICE;
			
			case 142 : return SID_BANK_EDR_SERVICE;
			
			case 143 : return SID_BANK_EDR_SERVICE;
			
			case 113 : return SID_BANK_EDR_SERVICE ;
			
			case 114 : return SID_BANK_EDR_SERVICE ;
			
			case 115 : return SID_BANK_EDR_CANCEL_SERVICE ;

			case 117 : return SID_BANK_EDR_SERVICE ;

			case 118 : return SID_BANK_EDR_SERVICE ;

			case 119 : return SID_BANK_EDR_CANCEL_SERVICE ;

			case 1008 : return SID_BANK_EDR_SERVICE ;//��������

			case 408 : return SID_BANK_EDR_SERVICE ;//ũ�����ڲ�ѯ

			case 409 : return SID_BANK_EDR_SERVICE ;//ũ�����ڽɷ�

			case 410 : return SID_BANK_EDR_CANCEL_SERVICE ;//ũ�����ڽɷѳ���
			
            case 1023 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			case 1024 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			default:throw new Exception("δ���÷���id")  ; 
	    }
	}
	
	public static String getEdrType(String funcFlag) throws Exception{
		switch(Integer.valueOf(funcFlag)){
			case 106 : return EDR_TYPE_TB;		
				
			case 107 : return EDR_TYPE_TB ;				
			
			case 108 : return EDR_TYPE_TB ;
			
			case 109 : return EDR_TYPE_WT ;
			
			case 110 : return EDR_TYPE_WT ;
			
			case 111 : return EDR_TYPE_WT ;
			
			case 132 : return EDR_TYPE_WT ;
			
			case 133 : return EDR_TYPE_WT ;
			
			case 142 : return EDR_TYPE_WT ;
			
			case 143 : return EDR_TYPE_WT ;
			
			case 113 : return EDR_TYPE_XQ ;
			
			case 114 : return EDR_TYPE_XQ ;
			
			case 115 : return EDR_TYPE_XQ ;
			
			case 117 : return EDR_TYPE_MQ ;
			
			case 118 : return EDR_TYPE_MQ ;
			
			case 119 : return EDR_TYPE_MQ ;
			
			case 1008 : return EDR_TYPE_WT ;//��������

			case 408 : return EDR_TYPE_XQ ;//ũ�����ڲ�ѯ

			case 409 : return EDR_TYPE_XQ ;//ũ�����ڽɷ�

			case 410 : return EDR_TYPE_XQ ;//ũ�����ڽɷѳ���
			
			case 1023 : return EDR_TYPE_WT ;
			
			case 1024 : return EDR_TYPE_TB ;
			
			default : throw new Exception("δ���õ���������") ;			
		}
    }
							
	public static String getEdrFlag(String funcFlag) throws Exception{
		switch(Integer.valueOf(funcFlag)){
		
			case 106 : return EDR_FLAG_QUERY;
			
			case 107 : return EDR_FLAG_COMFIRM ;
			
			case 132 : return EDR_FLAG_QUERY;
			
			case 133 : return EDR_FLAG_COMFIRM ;
			
			case 142 : return EDR_FLAG_QUERY;
			
			case 143 : return EDR_FLAG_COMFIRM ;
			
			case 109 : return EDR_FLAG_QUERY ;
			
			case 110 : return EDR_FLAG_COMFIRM ;
			
			case 113 : return EDR_FLAG_QUERY ;
			
			case 114 : return EDR_FLAG_COMFIRM ;
			
			case 117 : return EDR_FLAG_QUERY ;

			case 118 : return EDR_FLAG_COMFIRM ;
			
			case 119 : return EDR_FLAG_QUERY ;
			
			case 1008 : return EDR_FLAG_COMFIRM ;//��������

			case 408 : return EDR_FLAG_QUERY ;//ũ�����ڲ�ѯ
			
			case 409 : return EDR_FLAG_COMFIRM ;//ũ�����ڽɷ�
			
																
			default : throw new Exception("δ�������Ĳ�����") ;			
		}
	}		
	
	public static HashMap<String,String> icbcBlcEdorTypeMap = new HashMap<String,String>();
	
//		��2��	ҵ�����ͣ�05Ͷ����ת����06Ͷ���ղ�����ȡ��07��ԥ�ڳ�����09 ���ڸ�����10�˱��� 
	
	public static final String EDR_XQ_BLC_TYPE = "999" ;//���и���ҵ�����͡���ʹ���Զ����ҵ�����ͱ�ʶ
	
	/**
	 * ��ȫ��Ŀ���˱�ʶ ������ʱ�ر�������ԥ���˱����˱�
	 */	
	static{		
		
		icbcBlcEdorTypeMap.put("10",EDR_TYPE_TB) ;
		icbcBlcEdorTypeMap.put("07", EDR_TYPE_WT) ;
		icbcBlcEdorTypeMap.put("09", EDR_TYPE_MQ) ;
		icbcBlcEdorTypeMap.put(EDR_XQ_BLC_TYPE, EDR_TYPE_XQ) ;
	}
	
}
