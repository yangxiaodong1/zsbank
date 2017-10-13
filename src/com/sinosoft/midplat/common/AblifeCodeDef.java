package com.sinosoft.midplat.common;

public interface AblifeCodeDef extends CodeDef {
    /** ������ͨ�������� */
    int NodeType_Bank_Sale = 0;
    /** �����µ��������� */
    int NodeType_Bank_Bat = 1;
    /** �����˱���Ϣ�������� */
    int NodeType_Bank_EdorCTInfo = 2;
    
    /** �������� **/
    int ContType_Bank = 0;
    
    /** ¼�� **/
    int ContState_Input = 1;
    /** ǩ�� **/
    int ContState_Sign = 2;
    /** ���ճ��� **/
    int ContState_Cancel = 3;
    /** ����һ�� **/
    int ContState_BlcOK = 10;
    /** �������ⵥ **/
    int ContState_BlcERROR = 11;
    
    /** ����¼���˱� **/
    String SID_Bank_ContInput = "0";
    /** �����շ�ǩ�� * */
    String SID_Bank_ContConfirm = "1";
    /** �����µ��ع�  **/
    String SID_Bank_ContRollback = "2";
    /** ���������ش�  **/
    String SID_Bank_ContRePrint = "3";
    /** ����������ѯ  **/
    String SID_Bank_ContQuery = "4";
    /** �������ճ��� **/
    String SID_Bank_ContCancel = "5";
    /** �����µ��ս�  **/
    String SID_Bank_NewContBlc = "6";
    /** ��֤(���յ�)����  **/
    String SID_Bank_ContCardBlc = "7";
    /** �����˱���Ϣ����  **/
    String SID_Bank_EdorCTInfo = "8";
    /** ����������ѯ  **/
    String SID_Bank_BatQuery = "10";
    /** �����ͻ�ǩԼ  **/
    String SID_Bank_ClientConTract = "11";
    /** �����ͻ���Լ  **/
    String SID_Bank_ClientDeConTract = "12";
    /** �����������ձ���  **/
    String SID_Bank_BatFetch_InCome = "13";
    /** �����������ջ���  **/
    String SID_Bank_BatDeliver_InCome = "14";
    /** ����������������  **/
    String SID_Bank_BatFetch_Pay = "15";
    /** ����������������  **/
    String SID_Bank_BatDeliver_Pay = "16";
    /** ֤���Ų�ѯ  **/
    String SID_Bank_ContQueryByID = "17";
    /** �ؿպ˶� **/
    String SID_Bank_CardCheck = "18";   
    /** �µ��˱���û�б���ӡˢ�� */
    String SID_Bank_NewContInputNoPrtNo = "19"; 
    /** ��ԥ���˱�Ӧ�� */
    String SID_Bank_EdorCTInfoReturn = "20";    
    /** ǩԼ��Լ����*/
    String SID_Bank_ClinentConTractBlc = "21";  
    /** ��������¼���˱�*/
    String SID_Bank_ContInput_IcbcNet = "26";  
    /** ���������շ�ǩ��*/
    String SID_Bank_ContConfirm_IcbcNet = "27";
    
    /**
     * ��ȫʱ���ú��ĵ�webservice�ı��
     */ 
    String SID_BANK_EDR_SERVICE = "30" ;
    /**
     * ��ȫ���˵��ú��ĵ�webservice���
     */
    String SID_BANK_EDR_BAL_SERVICE = "31" ;
    /**
     * ��ȫȡ�����׵���webservice���
     */
    String SID_BANK_EDR_CANCEL_SERVICE = "32" ;
    
    String SID_BANK_CUSTOMER_SERVICE = "601";
    
    /**
     * ��ʵʱ�˱�
     */
    String SID_BANK_NOREALTIME_BLC = "33";
    
    /**
     * �˱�����ļ�
     */
    String SID_BANK_BLC_RESULT_FILE = "34";
    
    /**
     * �˱�״̬���֪ͨ�ļ�
     */
    String SID_BANK_BLC_STATE_MODIFY = "35";
    
    /**
     * �˱���ʱ����
     */
    String SID_BANK_BLC_TIMEOUT_REMIND = "36";
    
    /**
     * ���������
     */
    String SID_BANK_CLEARING = "37";

    /**
     * ����״̬�����ѯ
     */
    String SID_Bank_PolicyStatus_Query = "38";
    
    /**
     * �����ۺϲ�ѯ
     */
    String SID_Bank_CompContQuery = "39";
    
    /**
     * ����״̬��ش�
     */
    String SID_Bank_PolicyStatus_Feedback = "40";
    
    /**
     * ��ʵʱͶ������
     */
    String SID_Bank_NoRealTime_ContInput = "41";
    
    /**
     * ��ʵʱ�˱��������
     */
    String SID_Bank_NoRealTime_UWResultBack = "42";
    
    /**
     * ��ʵʱ�˱��̳�����
     */
    String SID_Bank_NoRealTime_EdrCTWTDataBack = "43";
    
    /**
     * �µ�ȷ�Ͻ���(�ɷѽ���-�µ�����ʵʱ�����ڽɷѶ�������ӿ�)
     */
    String SID_Bank_NewContConfirm = "44";
    
    /**
     * ��_�����µ��ս�
     */
    String SID_Bank_NewContBlc_New = "45";

    /**
     * ȷ�ϵ��ճ���������ʹ�ã�
     */
    String SID_Bank_NewContCancel = "46";
    
    /**
     * ������ӡ��������ϵͳ������
     */
    String SID_Bank_ContPrint = "47";
    
    /**
     * ��ѯ���չ�˾פ��Ա��Ϣ��������ϵͳ������
     */
    String SID_Bank_QueryAgentInfo = "48";
    
    /**
     * ���ݿͻ���ѯ������Ϣ��������ϵͳ������
     */
    String SID_Bank_QueryClientCont = "49";
    
    /**
     * ������ִǩ�����ڸ��·��񣨽�����ϵͳ������
     */
    String SID_Bank_RegSignDate = "50";
    
    /**
     * ��Լ�������񣨽�����ϵͳ������
     */
    String SID_Bank_RetractCont = "51";
    
    /**
     * ��Լ�������ˣ�����������
     */
    String SID_Bank_RetractContBlc = "52";
    
    
    /**
     * ���ձ�������������ѯ������������
     */
    String SID_Bank_ContInfoQueryBatch = "53";
    
    /**
     * ��Ʒ����������񣨽���������
     */
    String SID_Bank_CcbTrialPremService = "54";
    
    /**
     * ��ѯ������ʷ�䶯��Ϣ������������
     */
    String SID_Bank_QueryContHisInfoService = "55";
    
    /**
     * ������ϵͳ���ɷѳ������ס�
     */
    String SID_Bank_CCbContRollback = "56";
    
    /**
     * ����Ӱ�񴫵ݽ��ס�
     */
    String SID_Bank_ImageTrans = "57";
    
    /**
     * ���չ�˾Ͷ�����˽��ף��㽭����ר����Ʒ��
     */
    String SID_Bank_NewContBlcBack = "58";
    
    /**
     * ���չ�˾��ȫ���˽��ף��㽭����ר����Ʒ��
     */
    String SID_BANK_EDR_BAL_BACK_SERVICE = "59" ;
    
    /**
     * ֧�����˽��ף��㽭����ר����Ʒ��
     */
    String SID_BANK_PayFor_SERVICE = "602" ;
    
    /**
     * ���չ�˾��ȫ���˽��ף��㽭����ר����Ʒ��
     */
    String SID_BANK_ProductNetQuery_SERVICE = "60" ;
    
    /**
     * ���д������ۺ����Ѳ�ѯ
     */
    String SID_BANK_InsuranceRemind_SERVICE = "61" ;
    
    /**
     * ��ʵʱ�˱�����ȡ������
     */
    String SID_BANK_NoTimeNewContCancel_SERVICE = "62" ;
    
    /**
     * ��ʵʱ�˱���ѯ
     */
    String SID_BANK_SGDTB_SERVICE = "63" ;

    /**
     * ȫί�н������ݴ���
     */
    String SID_BANK_QWTPAY_INFOTRANS = "64" ;
    
    /**
     * ��ȫ��ѯ
     */
    String SID_BANK_QWTPAY_SERVICE = "65" ;
    
    /**
     * ת��ʵʱ��־���ñ�־�ɺ���ϵͳ����3
     * ��tranlog����recode=3��Ӧ��ʵʱ
     */
    public static final int RCode_NoRealTime = 3;
    /**
     * ��ʵʱͶ�����ݻش����������У�
     */
    String NoRealTimeContInfo_SERVICE = "24";
    
    /** -������- */
    int TranCom_NULL = 1;
    /** �й��������� */
    int TranCom_ICBC = 1;
    /** �й����� */
    int TranCom_BOC = 2;
    /** �й��������� */
    int TranCom_CCB = 3;
    /** �й�ũҵ���� */
    int TranCom_ABC = 4;
    /** �й���ͨ���� */
    int TranCom_BCM = 5;
    /** �й������������� */
    int TranCom_PSBC = 6;
    
    /**
     *  ��ȫ��Ŀ  -- �˱�
     */
    String EDR_TYPE_TB = "CT" ;
    /**
     * ��ȫ��Ŀ -- ����
     */
    String EDR_TYPE_MQ = "MQ" ;
    /**
     * ��ȫ��Ŀ -- ����
     */
    String EDR_TYPE_XQ = "XQ" ; 
    /**
     * ��ȫ��Ŀ -- ��ԥ���˱�
     */
    String EDR_TYPE_WT = "WT" ;
    /**
     * ��ȫ��������:1��ѯ,2ȷ��
     */
    String EDR_FLAG_QUERY = "1" ;
    /**
     * ��ȫ��������:1��ѯ,2ȷ��
     */
    String EDR_FLAG_COMFIRM = "2" ; 
}
