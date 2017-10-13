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
public class IcbcCodeMapping {
	
	/**
	 * 银行的身份证件类型对应到核心
	 * 身份证类型转为核心
	 * @param idType 银行的身份证类型
	 * @return 		 核心身份证类型
	 */
	public static String idTypeToPGI(String idType){
		if ("0".equals(idType)) {
		    //身份证
		    return "0";
		}else if("1".equals(idType)) {
		    //护照
		    return "1";
		}else if("2".equals(idType)) {
		    //军官证
		    return "2";
		}else if("3".equals(idType)) {
		    //士兵证
		    return "2";
		}else if("5".equals(idType)) {
		    //临时身份证
		    return "0";
		}else if("6".equals(idType)) {
		    //户口本
		    return "5";
		}else if("9".equals(idType)) {
		    //警官证
		    return "2";
		}else{
		    //其他
		    return "8";
		}		    

	}
	
	/**
	 * 核心的ID类型对应到银行
	 * @param pgiIdType
	 * @return
	 */
	public static String idTypeFromPGI(String pgiIdType){
		switch (Integer.valueOf(pgiIdType)) {
		case 0:
			return "0";//身份证
		case 1:
			return "1";//护照
		case 2:
			return "2";//军官证
		case 5:
			return "6";//户口簿
		default:
			return "7"; //其他
		}
	}
	
	/**
	 * 缴费频次，核心到银行
	 * @param pgiPayIntv  核心系统表示的缴费频次
	 * @return	银行表示的缴费频次
	 */
	public static String payIntvFromPGI(String pgiPayIntv){
		switch (Integer.valueOf(pgiPayIntv)) {
		case 12:
			return "1";//年交
		case 1:
			return "2";//月交
		case 6:
			return "3";//半年交
		case 3:
			return "4";//季交
		case 0:
			return "5";//趸交
		case -1:
			return "6";//不定期交
		default:
			return "9";//其他
		}
	}
	
	/**
	 * 缴费期间类型，核心到银行
	 * @param pgiPayEndYearFlag
	 * @return
	 */
	public static String payEndYearFlagFromPGI(String pgiPayEndYearFlag){
		if("A".equals(pgiPayEndYearFlag)){
			return "1";//缴至某确定年龄
		}
		else if("Y".equals(pgiPayEndYearFlag)){
			return "2";//按年
		}
		else if("M".equals(pgiPayEndYearFlag)){
			return "3";//按月
		}
		else if("D".equals(pgiPayEndYearFlag)){
			return "4";//按日
		}
		else
			return "9";//其他
	}
	
	/**
	 * 保险期间类型，核心到银行
	 * @param pgiInsuYearFlag	核心保险期间
	 * @return					银行保险期间
	 */	
	public static String insuYearFlagFromPGI(String pgiInsuYearFlag){
		if("A".equals(pgiInsuYearFlag)){
			return "1";//保至某确定年龄
		}
		else if("Y".equals(pgiInsuYearFlag)){
			return "2";//年保
		}
		else if("M".equals(pgiInsuYearFlag)){
			return "3";//月保
		}
		else if("D".equals(pgiInsuYearFlag)){
			return "4";//日保保终身
		}else{
			return "9";//其他
		}
	}
	
	/**
	 * 核保结论,核心到银行
	 * @param pgiUWResult
	 * @return
	 */
	public static String uwResultFromPGI(String pgiUWResult){
        if ("9".equals(pgiUWResult)) {
            //核心 标准承保
            return "0"; //工行 标体通过 
        }else if("4".equals(pgiUWResult)) {
            //核心 次标准体
            return "1"; //工行 有条件承保
            
        }else if("1".equals(pgiUWResult)) {
            //核心 拒保
            return "3"; //工行 拒保
            
        }else if("2".equals(pgiUWResult)) {
            //核心 延期
            return "5"; //工行 延期
            
        }else if("a".equals(pgiUWResult)) {
            //核心 撤单
            return "4"; //工行 客户取消投保
        }else{
            //其他
            return ""; 
        }
	}
	
	/**
	 * 核保结论状态，核心到银行
	 * @param pgiUWResultState
	 * @return
	 */
	public static String uwResultStateFromPGI(String pgiUWResultState){
		if ("9".equals(pgiUWResultState)) {
		    //核心 标准承保
		    return "01"; //工行 标体通过 
		}else if("4".equals(pgiUWResultState)) {
		    //核心 次标准体
		    return "55"; //工行 其它承保
		    
		}else if("1".equals(pgiUWResultState)) {
		    //核心 拒保
		    return "56"; //工行 拒保
		    
		}else if("2".equals(pgiUWResultState)) {
		    //核心 延期
		    return "58"; //工行 延期
		    
		}else if("a".equals(pgiUWResultState)) {
		    //核心 撤单
		    return "57"; //工行 客户取消投保
		}else{
		    //其他
		    return ""; 
		}
	}
	
	/**
	 * 受理状态，核心到银行
	 * @param pgiProcessState	核心受理状态
	 * @return					银行受理状态
	 */
	public static String processStateFromPGI(String pgiProcessState) {
        if ("00".equals(pgiProcessState)) {
            // 核心 未处理
            return "01";// 工行 录入中
        } else if ("01".equals(pgiProcessState)) {
            // 核心 录入中
            return "01";// 工行 录入中
        } else if ("02".equals(pgiProcessState)) {
            // 核心 核保中
            return "12";// 工行 核保通知书
        } else if ("03".equals(pgiProcessState)) {
            // 核心 照会中
            return "09";// 工行 照会中
        } else if ("04".equals(pgiProcessState)) {
            // 核心 核保通过待收费
            return "10";// 工行 核保通过待收费
        } else {
            return "01"; // 工行 录入中
        }
    }

	/**
	 * 险种代码映射，核心到银行
	 * @param riskCode	险种代码
	 * @return					工行端定义的险种代码
	 */
	public static String riskCodeFromPGI(String riskCode) {
	     if ("122001".equals(riskCode)) {
            // 安邦黄金鼎1号两全保险（分红型）A款
            return "001";
        } else if ("122002".equals(riskCode)) {
            // 安邦黄金鼎2号两全保险（分红型）A款
            return "002";
        } else if ("122004".equals(riskCode)) {
            // 安邦附加黄金鼎2号两全保险（分红型）A款
            return "101";
        } else if ("122003".equals(riskCode)) {
            // 安邦聚宝盆1号两全保险（分红型）A款
            return "003";
        } else if ("122006".equals(riskCode)) {
            // 安邦聚宝盆2号两全保险（分红型）A款
            return "004";
        } else if ("122008".equals(riskCode)) {
            // 安邦白玉樽1号终身寿险（万能型）
            return "005";
        } else if ("122009".equals(riskCode)) {
            // 安邦黄金鼎5号两全保险（分红型）A款
            return "006";
        } else if ("122011".equals(riskCode)) {
            // 安邦盛世1号终身寿险（万能型）
            return "007";
        } else if ("122012".equals(riskCode)) {
            // 安邦盛世2号终身寿险（万能型）
            return "008";
        } else if ("122010".equals(riskCode)) {
            // 安邦盛世3号终身寿险（万能型）
            return "009";
        } else if ("122029".equals(riskCode)) {
            // 安邦盛世5号终身寿险（万能型）
            return "010";
        } else if ("122020".equals(riskCode)) {
            //安邦长寿6号两全保险（分红型）
            return "011";
        } else if ("122036".equals(riskCode)) {
            //安邦黄金鼎6号两全保险（分红型）A款 
            return "012";
        } else if("50002".equals(riskCode)){
        	// 50002-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成
        	return "013";
//        } else if("122038".equals(riskCode)){
//        	// 安邦价值增长8号终身寿险（分红型）A款
//        	return "014";
        	//PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级
        }  else if("L12079".equals(riskCode)){
        	// 安邦盛世2号终身寿险（万能型）
        	return "008";
        } else if("L12078".equals(riskCode)){
        	// 安邦盛世3号终身寿险（万能型）
        	return "009";
        } else if("L12100".equals(riskCode)){
        	// 安邦盛世3号终身寿险（万能型）
        	return "009";
        } else if("L12074".equals(riskCode)){
        	// 安邦盛世9号两全保险（万能型）
        	return "014";
        } else if("50015".equals(riskCode)){
        	// 50015-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成
        	return "013";
        } else if("L12084".equals(riskCode)){
        	// PBKINSR-923 工行银保通上线新产品（安邦汇赢2号年金保险A款）
        	return "015";
        } else if("L12089".equals(riskCode)){
        	// PBKINSR-1023  工行新产品盛世1号银保通需求(安邦盛世1号终身寿险（万能型）B款)
        	return "016";
        } else if("L12093".equals(riskCode)){
        	// PBKINSR-1235 工行银保通柜面新产品-盛世9号B款
        	return "017";
        } else {
            return "";
        }
	}
	
}
