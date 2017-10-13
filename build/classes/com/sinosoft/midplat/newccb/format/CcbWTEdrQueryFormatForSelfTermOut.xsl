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

	<xsl:variable name="MainRisk" select="PubContInfo/Risk[RiskCode=MainRiskCode]" />
	
	<Lv1_Br_No><xsl:value-of select="PubContInfo/SubBankCode" /></Lv1_Br_No>
	<ActCashPymt_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></ActCashPymt_Amt>
	<!-- ���˺������ -->
	<ATEndOBns_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(0)" /></ATEndOBns_Amt>
	<Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</Cvr_ID>
	<InsPolcy_No><xsl:value-of select="PubContInfo/ContNo" /></InsPolcy_No>
	<Plchd_Nm><xsl:value-of select="PubContInfo/AppntName" /></Plchd_Nm>
	<Plchd_Crdt_No><xsl:value-of select="PubContInfo/AppntIDNo" /></Plchd_Crdt_No>
	<Plchd_Crdt_TpCd>
		<xsl:call-template name="tran_IDType">
			<xsl:with-param name="idtype" select="PubContInfo/AppntIDType" />
		</xsl:call-template>
	</Plchd_Crdt_TpCd>
	<!-- �˱����ʹ���, 1-��ԥ�ڣ�2-����ԥ�� -->
	<CnclIns_TpCd>1</CnclIns_TpCd>
	<!-- �����˸��� -->
	<Rcgn_Num>1</Rcgn_Num>
	<RcgnNm_List>
		<RcgnNm_Detail>
			<Rcgn_Nm><xsl:value-of select="PubContInfo/InsuredName" /></Rcgn_Nm>
		</RcgnNm_Detail>
	</RcgnNm_List>
	<CnclIns_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></CnclIns_Amt>
	<!-- ������ -->
	<Btch_BillNo></Btch_BillNo>
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	
</xsl:template>

<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- ���ڲ� -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		
		<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<!-- <xsl:when test="$riskcode='122046'">50002</xsl:when> -->	<!-- �������Ӯ���ռƻ��������ͣ� -->
       
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>

