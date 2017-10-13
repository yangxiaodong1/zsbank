package com.sinosoft.midplat.common;

import java.util.HashMap;

/**
 * 联调时需要把未配置的数据配置上
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

			case 1008 : return SID_BANK_EDR_SERVICE ;//招行犹退

			case 408 : return SID_BANK_EDR_SERVICE ;//农行续期查询

			case 409 : return SID_BANK_EDR_SERVICE ;//农行续期缴费

			case 410 : return SID_BANK_EDR_CANCEL_SERVICE ;//农行续期缴费冲正
			
            case 1023 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			case 1024 : return SID_BANK_EDR_CANCEL_SERVICE ;
			
			default:throw new Exception("未配置服务id")  ; 
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
			
			case 1008 : return EDR_TYPE_WT ;//招行犹退

			case 408 : return EDR_TYPE_XQ ;//农行续期查询

			case 409 : return EDR_TYPE_XQ ;//农行续期缴费

			case 410 : return EDR_TYPE_XQ ;//农行续期缴费冲正
			
			case 1023 : return EDR_TYPE_WT ;
			
			case 1024 : return EDR_TYPE_TB ;
			
			default : throw new Exception("未配置的批改类型") ;			
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
			
			case 1008 : return EDR_FLAG_COMFIRM ;//招行犹退

			case 408 : return EDR_FLAG_QUERY ;//农行续期查询
			
			case 409 : return EDR_FLAG_COMFIRM ;//农行续期缴费
			
																
			default : throw new Exception("未配置批改操作项") ;			
		}
	}		
	
	public static HashMap<String,String> icbcBlcEdorTypeMap = new HashMap<String,String>();
	
//		（2）	业务类型：05投连险转换，06投连险部分领取，07犹豫期撤保，09 满期给付，10退保， 
	
	public static final String EDR_XQ_BLC_TYPE = "999" ;//银行给出业务类型。先使用自定义的业务类型标识
	
	/**
	 * 保全项目对账标识 ，对账时特别区分犹豫期退保和退保
	 */	
	static{		
		
		icbcBlcEdorTypeMap.put("10",EDR_TYPE_TB) ;
		icbcBlcEdorTypeMap.put("07", EDR_TYPE_WT) ;
		icbcBlcEdorTypeMap.put("09", EDR_TYPE_MQ) ;
		icbcBlcEdorTypeMap.put(EDR_XQ_BLC_TYPE, EDR_TYPE_XQ) ;
	}
	
}
