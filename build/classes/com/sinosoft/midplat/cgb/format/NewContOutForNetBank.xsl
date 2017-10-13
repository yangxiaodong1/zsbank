<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<MAIN>
			<TRANSRNO></TRANSRNO><!-- 交易流水号 -->
			<TRANSRDATE></TRANSRDATE><!-- 交易日期 -->
			<INSUID></INSUID><!-- 保险公司代码 -->
			<!--投保单号-->
			<APPLNO><xsl:value-of select="ProposalPrtNo" /></APPLNO>
			<!-- 保单号  -->
			<POLICYNO><xsl:value-of select="ContNo" /></POLICYNO>
			<!--保费总额,以分为单位-->
			<PREMIUM>
				<xsl:value-of select="ActSumPrem" />
			</PREMIUM>
			<!--总保额,以分为单位-->
			<AMOUNT><xsl:value-of select="Amnt" /></AMOUNT>
		</MAIN>
		<PRODUCTS>
			<PRODUCT>
				<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
				<!-- 险种代码 -->
				<PRODUCTID>
					<xsl:choose>
						<xsl:when test="ContPlan/ContPlanCode !=''">
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="ContPlan/ContPlanCode" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="$MainRisk/RiskCode" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>	
				</PRODUCTID>
				<INSU_PREMIUM><xsl:value-of select="ActSumPrem" /></INSU_PREMIUM><!-- 险种保费 -->
				<INSU_AMOUNT><xsl:value-of select="Amnt" /></INSU_AMOUNT><!-- 险种保额 -->
			</PRODUCT>
		</PRODUCTS>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50015'">50002</xsl:when>  <!-- 安邦长寿稳赢保险计划  -->
			<xsl:when test="$riskCode='L12079'">122012</xsl:when> <!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskCode='L12098'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='L12089'">L12089</xsl:when><!-- 安邦盛世1号B款终身寿险（万能型）-->
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款-->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>