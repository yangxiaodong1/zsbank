package com.sinosoft.midplat.icbczj;

/**
 * 浙江工行系统对应的数据字典映射表
 * 命名规则：
 * eg：PGI：核心
 *     类型ToPGI：表示银行映射到核心系统
 *     类型FromPGI:表示核心系统映射到银行
 *     
 * @author liying
 * @date   20150805
 * 
 */
public class IcbcZJCodeMapping {
	
	
	/**
	 * 险种代码映射，核心到银行
	 * @param riskCode	险种代码
	 * @return					工行端定义的险种代码
	 */
	public static String riskCodeFromPGI(String riskCode) {
	     if ("L12077".equals(riskCode)) {
            // 安邦盛世2号终身寿险（万能型）
            return "008";
        }else if("L12102".equals(riskCode)) {//安邦盛世9号两全保险（万能型）
        	return "014";
        }else {
            return "";
        }
	}
	
	/**
	 * 业务类型映射，核心到银行
	 * @param edorType	业务类型
	 * @return  浙江工行定义的业务类型
	 */
	public static String edorTypeFromPGI(String edorType) {
	     if ("WT".equals(edorType)) {
           // 犹退
           return "07";
       }else if ("MQ".equals(edorType)) {
           // 满期
           return "09";
       } else {
           return "";
       }
	}
	
	/**
	 * 交易类型映射，收付到银行--支付入账交易，业务类型关系转换。
	 * @param tranType	交易类型：01犹豫期退保，02满期给付，03提款？
	 * @return  浙江工行定义的交易类型
	 */
	public static String tranTypeFromPGI(String tranType) {
		//目前收付系统传给银保通CT、XT，均代码犹退
	     if ("CT".equals(tranType)) {
           // 犹退
           return "01";
       }else if ("XT".equals(tranType)) {
           // 协议退保
           return "01";
       }else if ("MQ".equals(tranType)) {
           // 满期
           return "02";
       }else if ("PN".equals(tranType)) {
           // 提款
           return "03";
       } else {
           return "";
       }
	}
	
	/**
	 * 交易类型映射，核心到银行--公司保全对账文件批量交易，业务类型关系转换
	 * @param tranType	交易类型：01犹豫期退保，02满期给付，03提款？
	 * @return  浙江工行定义的交易类型
	 */
	public static String tranType1FromPGI(String tranType) {
		//目前收付系统传给银保通CT、XT，均代码犹退
	     if ("WT".equals(tranType)) {
           // 犹退
           return "01";
       }else if ("MQ".equals(tranType)) {
           // 满期
           return "02";
       } else {
           return "";
       }
	}
	
	/**
	 * 销售渠道映射，核心到银行
	 * 银行：销售渠道(3位)：0-柜面;1-网银;2-电银;3-法人营销;5-手机银行; 6-业务中心;7- 理财销售服务终端;8-自助终端;10-个人营销；
	 * 核心：交易渠道：6-柜面，7-网银，8自助终端、M-手机
	 * @param SourceType	销售渠道
	 * @return  浙江工行定义的销售渠道类型
	 */
	public static String sourceTypeFromPGI(String sourceType) {
		if ("6".equals(sourceType)) {
           // 柜面
           return "0";
       }else if ("7".equals(sourceType)) {
           // 网银
           return "1";
       }else if ("8".equals(sourceType)) {
           // 自助终端
           return "8";
       }else if ("M".equals(sourceType)) {
           // 手机
           return "5";
       } else{
           return "";
       }
	}
	
	
	
	/**
	 * 传给收付的浙江工行专属产品产品代码，其中，如果有多个产品时，用","分隔
	 * @return  浙江工行专属产品，核心产品代码列表
	 */
	public static String riskCodes() {
		return "L12077";
	}
	
	/**
	 * 传给收付的浙江工行专属产品产品代码，其中，如果有多个产品时，用","分隔
	 * @return  浙江工行专属产品，核心产品代码列表
	 */
	public static String riskCode_add() {
		return "L12102";
	}
}
