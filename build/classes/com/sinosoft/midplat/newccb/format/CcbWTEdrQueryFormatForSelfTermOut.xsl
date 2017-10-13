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
	<!-- 终了红利金额 -->
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
	<!-- 退保类型代码, 1-犹豫期，2-非犹豫期 -->
	<CnclIns_TpCd>1</CnclIns_TpCd>
	<!-- 被保人个数 -->
	<Rcgn_Num>1</Rcgn_Num>
	<RcgnNm_List>
		<RcgnNm_Detail>
			<Rcgn_Nm><xsl:value-of select="PubContInfo/InsuredName" /></Rcgn_Nm>
		</RcgnNm_Detail>
	</RcgnNm_List>
	<CnclIns_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></CnclIns_Amt>
	<!-- 批单号 -->
	<Btch_BillNo></Btch_BillNo>
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	
</xsl:template>

<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- 户口簿 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 险种转换 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		
		<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
		<!-- <xsl:when test="$riskcode='122046'">50002</xsl:when> -->	<!-- 安邦长寿稳赢保险计划（万能型） -->
       
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>

