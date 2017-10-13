package com.sinosoft.midplat.common;

public interface AblifeCodeDef extends CodeDef {
    /** 银保普通出单网点 */
    int NodeType_Bank_Sale = 0;
    /** 银保新单对账网点 */
    int NodeType_Bank_Bat = 1;
    /** 银保退保信息传递网点 */
    int NodeType_Bank_EdorCTInfo = 2;
    
    /** 银保保单 **/
    int ContType_Bank = 0;
    
    /** 录单 **/
    int ContState_Input = 1;
    /** 签单 **/
    int ContState_Sign = 2;
    /** 当日撤单 **/
    int ContState_Cancel = 3;
    /** 对账一致 **/
    int ContState_BlcOK = 10;
    /** 对账问题单 **/
    int ContState_BlcERROR = 11;
    
    /** 银保录单核保 **/
    String SID_Bank_ContInput = "0";
    /** 银保收费签单 * */
    String SID_Bank_ContConfirm = "1";
    /** 银保新单回滚  **/
    String SID_Bank_ContRollback = "2";
    /** 银保保单重打  **/
    String SID_Bank_ContRePrint = "3";
    /** 银保保单查询  **/
    String SID_Bank_ContQuery = "4";
    /** 银保当日撤单 **/
    String SID_Bank_ContCancel = "5";
    /** 银保新单日结  **/
    String SID_Bank_NewContBlc = "6";
    /** 单证(保险单)对账  **/
    String SID_Bank_ContCardBlc = "7";
    /** 银保退保信息传递  **/
    String SID_Bank_EdorCTInfo = "8";
    /** 银保批量查询  **/
    String SID_Bank_BatQuery = "10";
    /** 银保客户签约  **/
    String SID_Bank_ClientConTract = "11";
    /** 银保客户解约  **/
    String SID_Bank_ClientDeConTract = "12";
    /** 银保批量代收报盘  **/
    String SID_Bank_BatFetch_InCome = "13";
    /** 银保批量代收回盘  **/
    String SID_Bank_BatDeliver_InCome = "14";
    /** 银保批量代付报盘  **/
    String SID_Bank_BatFetch_Pay = "15";
    /** 银保批量代付回盘  **/
    String SID_Bank_BatDeliver_Pay = "16";
    /** 证件号查询  **/
    String SID_Bank_ContQueryByID = "17";
    /** 重空核对 **/
    String SID_Bank_CardCheck = "18";   
    /** 新单核保，没有保单印刷号 */
    String SID_Bank_NewContInputNoPrtNo = "19"; 
    /** 犹豫期退保应答 */
    String SID_Bank_EdorCTInfoReturn = "20";    
    /** 签约解约对账*/
    String SID_Bank_ClinentConTractBlc = "21";  
    /** 工行网银录单核保*/
    String SID_Bank_ContInput_IcbcNet = "26";  
    /** 工行网银收费签单*/
    String SID_Bank_ContConfirm_IcbcNet = "27";
    
    /**
     * 保全时调用核心的webservice的编号
     */ 
    String SID_BANK_EDR_SERVICE = "30" ;
    /**
     * 保全对账调用核心的webservice编号
     */
    String SID_BANK_EDR_BAL_SERVICE = "31" ;
    /**
     * 保全取消交易调用webservice编号
     */
    String SID_BANK_EDR_CANCEL_SERVICE = "32" ;
    
    String SID_BANK_CUSTOMER_SERVICE = "601";
    
    /**
     * 非实时核保
     */
    String SID_BANK_NOREALTIME_BLC = "33";
    
    /**
     * 核保结果文件
     */
    String SID_BANK_BLC_RESULT_FILE = "34";
    
    /**
     * 核保状态变更通知文件
     */
    String SID_BANK_BLC_STATE_MODIFY = "35";
    
    /**
     * 核保超时提醒
     */
    String SID_BANK_BLC_TIMEOUT_REMIND = "36";
    
    /**
     * 手续费清分
     */
    String SID_BANK_CLEARING = "37";

    /**
     * 保单状态变更查询
     */
    String SID_Bank_PolicyStatus_Query = "38";
    
    /**
     * 保单综合查询
     */
    String SID_Bank_CompContQuery = "39";
    
    /**
     * 保单状态变回传
     */
    String SID_Bank_PolicyStatus_Feedback = "40";
    
    /**
     * 非实时投保申请
     */
    String SID_Bank_NoRealTime_ContInput = "41";
    
    /**
     * 非实时核保结果回盘
     */
    String SID_Bank_NoRealTime_UWResultBack = "42";
    
    /**
     * 非实时退保犹撤回盘
     */
    String SID_Bank_NoRealTime_EdrCTWTDataBack = "43";
    
    /**
     * 新单确认交易(缴费交易-新单，非实时，续期缴费都掉这个接口)
     */
    String SID_Bank_NewContConfirm = "44";
    
    /**
     * 新_银保新单日结
     */
    String SID_Bank_NewContBlc_New = "45";

    /**
     * 确认当日撤单（建行使用）
     */
    String SID_Bank_NewContCancel = "46";
    
    /**
     * 保单打印（建行新系统新增）
     */
    String SID_Bank_ContPrint = "47";
    
    /**
     * 查询保险公司驻点员信息（建行新系统新增）
     */
    String SID_Bank_QueryAgentInfo = "48";
    
    /**
     * 根据客户查询保单信息（建行新系统新增）
     */
    String SID_Bank_QueryClientCont = "49";
    
    /**
     * 保单回执签收日期更新服务（建行新系统新增）
     */
    String SID_Bank_RegSignDate = "50";
    
    /**
     * 契约撤销服务（建行新系统新增）
     */
    String SID_Bank_RetractCont = "51";
    
    /**
     * 契约撤销对账（建行新增）
     */
    String SID_Bank_RetractContBlc = "52";
    
    
    /**
     * 日终保单详情批量查询（建行新增）
     */
    String SID_Bank_ContInfoQueryBatch = "53";
    
    /**
     * 产品保费试算服务（建行新增）
     */
    String SID_Bank_CcbTrialPremService = "54";
    
    /**
     * 查询保单历史变动信息（建行新增）
     */
    String SID_Bank_QueryContHisInfoService = "55";
    
    /**
     * 建行新系统，缴费冲正交易。
     */
    String SID_Bank_CCbContRollback = "56";
    
    /**
     * 招行影像传递交易。
     */
    String SID_Bank_ImageTrans = "57";
    
    /**
     * 保险公司投保对账交易（浙江工行专属产品）
     */
    String SID_Bank_NewContBlcBack = "58";
    
    /**
     * 保险公司保全对账交易（浙江工行专属产品）
     */
    String SID_BANK_EDR_BAL_BACK_SERVICE = "59" ;
    
    /**
     * 支付入账交易（浙江工行专属产品）
     */
    String SID_BANK_PayFor_SERVICE = "602" ;
    
    /**
     * 保险公司保全对账交易（浙江工行专属产品）
     */
    String SID_BANK_ProductNetQuery_SERVICE = "60" ;
    
    /**
     * 建行代理保险售后提醒查询
     */
    String SID_BANK_InsuranceRemind_SERVICE = "61" ;
    
    /**
     * 非实时核保申请取消交易
     */
    String SID_BANK_NoTimeNewContCancel_SERVICE = "62" ;
    
    /**
     * 非实时核保查询
     */
    String SID_BANK_SGDTB_SERVICE = "63" ;

    /**
     * 全委托结算数据传递
     */
    String SID_BANK_QWTPAY_INFOTRANS = "64" ;
    
    /**
     * 保全查询
     */
    String SID_BANK_QWTPAY_SERVICE = "65" ;
    
    /**
     * 转非实时标志，该标志由核心系统返回3
     * 且tranlog表中recode=3对应非实时
     */
    public static final int RCode_NoRealTime = 3;
    /**
     * 非实时投保数据回传（北京银行）
     */
    String NoRealTimeContInfo_SERVICE = "24";
    
    /** -保留域- */
    int TranCom_NULL = 1;
    /** 中国工商银行 */
    int TranCom_ICBC = 1;
    /** 中国银行 */
    int TranCom_BOC = 2;
    /** 中国建设银行 */
    int TranCom_CCB = 3;
    /** 中国农业银行 */
    int TranCom_ABC = 4;
    /** 中国交通银行 */
    int TranCom_BCM = 5;
    /** 中国邮政储蓄银行 */
    int TranCom_PSBC = 6;
    
    /**
     *  保全项目  -- 退保
     */
    String EDR_TYPE_TB = "CT" ;
    /**
     * 保全项目 -- 满期
     */
    String EDR_TYPE_MQ = "MQ" ;
    /**
     * 保全项目 -- 续期
     */
    String EDR_TYPE_XQ = "XQ" ; 
    /**
     * 保全项目 -- 犹豫期退保
     */
    String EDR_TYPE_WT = "WT" ;
    /**
     * 保全交易类型:1查询,2确认
     */
    String EDR_FLAG_QUERY = "1" ;
    /**
     * 保全交易类型:1查询,2确认
     */
    String EDR_FLAG_COMFIRM = "2" ; 
}
