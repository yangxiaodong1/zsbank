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

	<xsl:template name="OLife" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="Holding_1">
				<!-- ������Ϣ -->
				<Policy>
					<!-- ���մ��� -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--���ڱ���-->
					<PaymentAmt>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
					</PaymentAmt>
					<Life>
						<xsl:apply-templates select="Risk" />
					</Life>
					
					<ApplicationInfo>
						<HOAppFormNumber><xsl:value-of select="ProposalPrtNo" /></HOAppFormNumber>
						<SubmissionDate><xsl:value-of select="$MainRisk/PolApplyDate" /></SubmissionDate>
					</ApplicationInfo>
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
					<xsl:apply-templates select="RiskCode" />
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
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</InitCovAmt>
				<!-- Ͷ���ݶ� -->
				<IntialNumberOfUnits>
					<xsl:value-of select="Mult" />
				</IntialNumberOfUnits>
				<!-- ���ֱ��� -->
				<ChargeTotalAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template match="RiskCode">
		<xsl:choose>
		
		<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ�B��  -->		
		<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
		<!-- PBKINSR-1358 zx add -->
		<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
		<!-- PBKINSR- zx add -->
		<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
		<!-- PBKINSR-1531 ������������9�� L12088 zx add 20160805 -->
		<xsl:when test=".='L12088'">L12088</xsl:when>
		
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
		<!-- PBKINSR-518 �����������߻ƽ�5�Ų�Ʒ���ݲ����� -->
		<!-- �ݲ�����	<xsl:when test=".='122009'">122009</xsl:when>--><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->	
		<!-- PBKINSR-518 �����������߻ƽ�5�Ų�Ʒ -->	
		<!-- PBKINSR-517 ������������ʢ9 -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<!-- PBKINSR-517 ������������ʢ9 -->
		<!-- PBKINSR-514 ������������ʢ3 -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
		<!-- PBKINSR-514 ������������ʢ3 -->
		<!-- add 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ  begin -->
		<xsl:when test=".='122046'">50002</xsl:when><!-- �������Ӯ1����ȫ����-->
		<!-- add 20160105 PBKINSR-1012 ��������������Ʒ��������Ӯ  end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
