<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
	<xsl:if test="ContPlan/ContPlanCode = ''">
		<PbSlipNumb><xsl:value-of select="$MainRisk/Mult"/></PbSlipNumb>
	</xsl:if>
	<xsl:if test="ContPlan/ContPlanCode != ''">
	    <PbSlipNumb><xsl:value-of select="ContPlan/ContPlanMult"/></PbSlipNumb>
	</xsl:if>
	<PiStartDate><xsl:value-of select="$MainRisk/CValiDate"/></PiStartDate><!--疑问点 起始日期取生效日期?  -->
	<PiSsDate><xsl:value-of select="$MainRisk/CValiDate"/></PiSsDate><!-- 中信 生效日期 -->
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></BkTxAmt>
	<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
	
	<!-- 在中信银行端以非套餐形式出单，才有附加险，有附加险时才填充BkNum1的值 -->
	<xsl:if test="ContPlan/ContPlanCode = ''">
		<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
	</xsl:if>
	<xsl:if test="ContPlan/ContPlanCode != ''">
		<BkNum1>0</BkNum1>
	</xsl:if>
	
	<Appd_List>
		<!-- 在中信银行端以非套餐形式出单，才有附加险 -->
		<xsl:if test="ContPlan/ContPlanCode = ''">
			<xsl:for-each select="Risk[RiskCode!=MainRiskCode]">
			<Appd_Detail>
				<LiAppdInsuType>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
				</LiAppdInsuType>	
				<LiAppdInsuExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></LiAppdInsuExp>
			</Appd_Detail>
			</xsl:for-each>
		</xsl:if>
	</Appd_List>
</xsl:template>
<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=L12079">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） PBKINSR-1283 -->
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型）-->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
