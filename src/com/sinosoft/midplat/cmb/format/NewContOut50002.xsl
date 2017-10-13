<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:variable name="ContPlan" select="TranData/Body/ContPlan" />

	<xsl:template name="OLife" match="Body">
		<OLife>
			<Holding id="cont">
				<!-- 保单信息 -->
				<Policy>
					<!-- 主险代码，此处存产品组合编码 -->
					<ProductCode>
						<xsl:value-of select="$ContPlan/ContPlanCode" />
					</ProductCode>
					<!--首期保费-->
					<PaymentAmt>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
					</PaymentAmt>
					<Life>
						<!-- 组合产品：只加载主险的risk标签，并以组合产品的形式反馈；附加险的risk标签放弃 -->
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
					</Life>
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
			<Coverage>
				<xsl:attribute name="id">
					<xsl:value-of select="$RiskId" />
				</xsl:attribute>
				<!-- 险种代码 -->
				<ProductCode>
					<xsl:value-of select="$ContPlan/ContPlanCode" />
				</ProductCode>
				<xsl:choose>
					<!-- 主副险标志 -->
					<xsl:when test="RiskCode=MainRiskCode">
						<IndicatorCode tc="1">1</IndicatorCode>
					</xsl:when>
					<xsl:otherwise>
						<IndicatorCode tc="2">2</IndicatorCode>
					</xsl:otherwise>
				</xsl:choose>

				<!-- 投保金额 -->
				<InitCovAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)" />
				</InitCovAmt>
				<!-- 投保份额 -->
				<IntialNumberOfUnits>
					<xsl:value-of select="$ContPlan/ContPlanMult" />
				</IntialNumberOfUnits>
				<!-- 险种保费 -->
				<ChargeTotalAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>

</xsl:stylesheet>
