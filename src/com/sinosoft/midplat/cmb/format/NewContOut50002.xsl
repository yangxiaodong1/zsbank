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
				<!-- ������Ϣ -->
				<Policy>
					<!-- ���մ��룬�˴����Ʒ��ϱ��� -->
					<ProductCode>
						<xsl:value-of select="$ContPlan/ContPlanCode" />
					</ProductCode>
					<!--���ڱ���-->
					<PaymentAmt>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
					</PaymentAmt>
					<Life>
						<!-- ��ϲ�Ʒ��ֻ�������յ�risk��ǩ��������ϲ�Ʒ����ʽ�����������յ�risk��ǩ���� -->
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
					</Life>
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
			<Coverage>
				<xsl:attribute name="id">
					<xsl:value-of select="$RiskId" />
				</xsl:attribute>
				<!-- ���ִ��� -->
				<ProductCode>
					<xsl:value-of select="$ContPlan/ContPlanCode" />
				</ProductCode>
				<xsl:choose>
					<!-- �����ձ�־ -->
					<xsl:when test="RiskCode=MainRiskCode">
						<IndicatorCode tc="1">1</IndicatorCode>
					</xsl:when>
					<xsl:otherwise>
						<IndicatorCode tc="2">2</IndicatorCode>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Ͷ����� -->
				<InitCovAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)" />
				</InitCovAmt>
				<!-- Ͷ���ݶ� -->
				<IntialNumberOfUnits>
					<xsl:value-of select="$ContPlan/ContPlanMult" />
				</IntialNumberOfUnits>
				<!-- ���ֱ��� -->
				<ChargeTotalAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>

</xsl:stylesheet>
