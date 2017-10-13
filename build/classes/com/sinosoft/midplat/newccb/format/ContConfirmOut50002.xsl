<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

	
	<MainIns_Cvr_ID>
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
		</xsl:call-template>
	</MainIns_Cvr_ID>
	<Cvr_ID>
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
		</xsl:call-template>
	</Cvr_ID>
	<!-- �������ײͱ�� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- ����ʧЧ���� -->
	<InsPolcy_ExpDt><xsl:value-of select="$MainRisk/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- ������ȡ���� -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- Ͷ���˵����ʼ���ַ -->
	<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
	<!-- ����Ͷ������ -->
	<InsPolcy_Ins_Dt><xsl:value-of select="$MainRisk/PolApplyDate" /></InsPolcy_Ins_Dt>
	<!-- ������Ч���� -->
	<InsPolcy_EfDt><xsl:value-of select="$MainRisk/CValiDate" /></InsPolcy_EfDt>
	<!-- �������ڽɴ����˺� -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo" /></AgInsRgAutoDdcn_AccNo>
	<!-- ÿ�ڽɷѽ����Ϣ -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- ���ѽɷѷ�ʽ���� -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- ���ѽɷ����� -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="$MainRisk/PayCount"/></InsPrem_PyF_Prd_Num>
	<!-- ���ѽɷ����ڴ��� -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
	<!-- 
	<InsPrem_PyF_Cyc_Cd>
		<xsl:choose>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear='106'" >99</xsl:when>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear!='106'" >98</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$MainRisk/PayIntv" />
			</xsl:otherwise>
		</xsl:choose>
	</InsPrem_PyF_Cyc_Cd>
	-->
	<!-- ������ԥ�� -->
	<InsPolcy_HsitPrd><xsl:value-of select="$MainRisk/HsitPrd" /></InsPolcy_HsitPrd>
	
	<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- ������ֽ��ֵ��ʾ2ҳ -->
		<Ret_File_Num>2</Ret_File_Num>
		<Rvl_Rcrd_Num>2</Rvl_Rcrd_Num>
	</xsl:if>
	<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- ���û���ֽ��ֵ��ʾ1ҳ -->
		<Ret_File_Num>1</Ret_File_Num>
		<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num>
	</xsl:if>
	
	
	<Detail_List>
		<Prmpt_Inf_Dsc>��������</Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd>1</AgIns_Vchr_TpCd>	<!-- �ؿ����� 1=����,2=�ֽ��ֵ��,3=����,4=��Ʊ,5=����ƾ֤,6=Ͷ����,7=�ͻ�Ȩ�汣��ȷ���� -->
		<Rvl_Rcrd_Num></Rvl_Rcrd_Num>	<!-- ���ı��Ĵ�ӡ���� �����գ������渳ֵ�� -->
		<Ins_IBVoch_ID><xsl:value-of select="ContPrtNo" /></Ins_IBVoch_ID>
		<Detail>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
			<xsl:text>                                     ��ֵ��λ�������Ԫ</xsl:text></Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>
				<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
				<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
				<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
			</Ret_Inf>
			<Ret_Inf>
				<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
				<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
				<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
			</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:if test="count(Bnf) = 0">
			<Ret_Inf><xsl:text>��������������ˣ�����                </xsl:text>
					   <xsl:text>����˳��1                   </xsl:text>
					   <xsl:text>���������100%</xsl:text></Ret_Inf>
			</xsl:if>
			<xsl:if test="count(Bnf)>0">
			<xsl:for-each select="Bnf">
			<Ret_Inf>
				<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
				<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
				<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
			</Ret_Inf>
			</xsl:for-each>
			</xsl:if>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��������������</Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf><xsl:text>��������������������                                              �������ս��\</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>����������������������������              �����ڼ�    ��������      �ս�����\     ���շ�    ����Ƶ��</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>��������������������                                                ����\����</xsl:text></Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:for-each select="Risk">
			<xsl:variable name="PayIntv" select="PayIntv"/>
			<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
			<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
			<xsl:choose>
				<xsl:when test="(RiskCode='L12081') or (RiskCode='122048')">
					<Ret_Inf><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
					</Ret_Inf>
				</xsl:when>
				<xsl:otherwise>
					<Ret_Inf><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
										</xsl:when>
										<xsl:when test="InsuYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
											<xsl:text></xsl:text>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="PayIntv = 0">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 10)"/>
										</xsl:when>
										<xsl:when test="PayEndYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',15)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
									<xsl:choose>
										<xsl:when test="PayIntv = 0">
											<xsl:text>����</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 12">
											<xsl:text>���</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 6">
											<xsl:text>�����</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 3">
											<xsl:text>����</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 1">
											<xsl:text>�½�</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = -1">
											<xsl:text>�����ڽ�</xsl:text>
										</xsl:when>
									</xsl:choose>
					</Ret_Inf>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:variable name="SpecContent" select="SpecContent"/>
			<Ret_Inf>���������յ��ر�Լ����</Ret_Inf>
			<xsl:choose>
				<xsl:when test="$SpecContent=''">
					<Ret_Inf><xsl:text>���ޣ�</xsl:text></Ret_Inf>
				</xsl:when>
				<xsl:otherwise>
					<Ret_Inf><xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>�������ֽ��ֵ��</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ������</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>�����������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ���</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>�����������˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text></Ret_Inf>
				</xsl:otherwise>
			</xsl:choose>
			<Ret_Inf>������-------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:if test="AppFlag='1'">
			<Ret_Inf>
				<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Ret_Inf>
			</xsl:if>
			<xsl:if test="AppFlag='B' and AgentPayType='01'">
			<Ret_Inf>
				<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Ret_Inf>
			</xsl:if>
			<xsl:if test="AppFlag='B' and AgentPayType='02'">
			<xsl:variable name="tCurrDate" select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
			<xsl:variable name="tCurrDate4Next" select="java:com.sinosoft.midplat.common.DateTimeUtils.getNext8Day()" />
			<Ret_Inf>
				<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring($tCurrDate,1,4)"/>��<xsl:value-of  select="substring($tCurrDate,5,2)"/>��<xsl:value-of  select="substring($tCurrDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring($tCurrDate4Next,1,4)"/>��<xsl:value-of  select="substring($tCurrDate4Next,5,2)"/>��<xsl:value-of  select="substring($tCurrDate4Next,7,2)"/>��</Ret_Inf>
			</xsl:if>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Ret_Inf>
			<Ret_Inf><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Ret_Inf>
			<Ret_Inf><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 40)"/><xsl:text>ҵ�����֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 0)"/></Ret_Inf>
			<Ret_Inf><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,40)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 0)"/></Ret_Inf>
			<Ret_Inf><xsl:text>������������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,40)"/></Ret_Inf>
	
		</Detail>
	</Detail_List>
	<xsl:if test="$MainRisk/CashValues/CashValue != ''">
	 <Detail_List>
	 	<xsl:variable name="RiskCount" select="count(Risk)"/>
	 	<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
	 	<Prmpt_Inf_Dsc>��������</Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd>1</AgIns_Vchr_TpCd>	<!-- �ؿ����� 1=����,2=�ֽ��ֵ��,3=����,4=��Ʊ,5=����ƾ֤,6=Ͷ����,7=�ͻ�Ȩ�汣��ȷ���� -->
		<Rvl_Rcrd_Num></Rvl_Rcrd_Num>	<!-- ���ı��Ĵ�ӡ���� �����գ������渳ֵ�� -->
		<Ins_IBVoch_ID><xsl:value-of select="ContPrtNo" /></Ins_IBVoch_ID>
		<Detail>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>��������������������<xsl:value-of select="Insured/Name"/></Ret_Inf>
		<xsl:if test="$RiskCount=1">
			<Ret_Inf>
				<xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Ret_Inf>
			<Ret_Inf><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
					   <xsl:text>�ֽ��ֵ</xsl:text></Ret_Inf>
			   	<xsl:variable name="EndYear" select="EndYear"/>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <Ret_Inf><xsl:text/><xsl:text>����������</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Ret_Inf>
				</xsl:for-each>
		 </xsl:if>
		 <xsl:if test="$RiskCount!=1">
		 	<Ret_Inf>
				<xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Ret_Inf>
			<Ret_Inf><xsl:text/>�������������ĩ<xsl:text>                </xsl:text>
					   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></Ret_Inf>
			   	<xsl:variable name="EndYear" select="EndYear"/>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <Ret_Inf>
						  <xsl:text/><xsl:text>������</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,26)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Ret_Inf>
				</xsl:for-each>
		 </xsl:if>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>��</Ret_Inf>
			<Ret_Inf>��������ע��</Ret_Inf>
			<Ret_Inf>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </Ret_Inf>
			<Ret_Inf>������------------------------------------------------------------------------------------------------</Ret_Inf>
	    </Detail>
	</Detail_List>
	</xsl:if>
	
	
</xsl:template>


<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- �ײ�ת�� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		
		<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<!-- 50015:(��������Ʒ) 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ���� -->
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- �������Ӯ���ռƻ��������ͣ� -->
		<xsl:when test="$contPlanCode=50002">50002</xsl:when>	<!-- �������Ӯ���ռƻ��������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- �ɷ����� -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- ��ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- ���ڽ��� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- FIXME ��Ҫ�ͺ��ģ�ҵ��ȷ�ϣ����нɷ�Ƶ�Σ�01=�����ڡ�02=һ�Ρ�03=�����ڡ�04=��ĳ�ض����䡢05=���� -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	���� -->
		<xsl:when test=".='12'">03</xsl:when><!-- �꽻 -->
		<xsl:when test=".='1'">03</xsl:when><!--	�½� -->
		<xsl:when test=".='3'">03</xsl:when><!--	���� -->
		<xsl:when test=".='6'">03</xsl:when><!--	���꽻 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- �����ڽ� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- �ɷ��������� -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	���� -->
		<xsl:when test=".='6'">0202</xsl:when><!--	����� -->
		<xsl:when test=".='12'">0203</xsl:when><!--	��� -->
		<xsl:when test=".='1'">0204</xsl:when><!--	�½� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

