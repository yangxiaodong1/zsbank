<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 保险单号 -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- 投保单(印刷)号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo" />
			</ContPrtNo>
			
			<!-- 主险险种代码 -->
			<!-- 主险险种名称 -->
			<xsl:choose>
				<xsl:when
					test="ContPlan/ContPlanCode != ''">
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
							<xsl:with-param name="riskcode"
								select="ContPlan/ContPlanCode" />
						</xsl:call-template>
					</MainRiskCode>
					<MainRiskName>
						<xsl:value-of
							select="ContPlan/ContPlanName" />
					</MainRiskName>
				</xsl:when>
				<xsl:otherwise>
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
							<xsl:with-param name="riskcode"
								select="Risk[RiskCode=MainRiskCode]/RiskCode" />
						</xsl:call-template>
					</MainRiskCode>
					<MainRiskName>
						<xsl:value-of
							select="Risk[RiskCode=MainRiskCode]/RiskName" />
					</MainRiskName>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- 保费(分)【主险+附加险】 -->
			<Prem>
				<xsl:value-of select="ActSumPrem" />
			</Prem>
		</Body>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50015'">50002</xsl:when>	 <!-- 安邦长寿稳赢保险计划 -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
