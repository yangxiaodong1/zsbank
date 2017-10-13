<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<!-- ������ -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- ���յ��� -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo" />
			</ContPrtNo>
			
			<!-- �������ִ��� -->
			<!-- ������������ -->
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
			
			<!-- ����(��)������+�����ա� -->
			<Prem>
				<xsl:value-of select="ActSumPrem" />
			</Prem>
		</Body>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50015'">50002</xsl:when>	 <!-- �������Ӯ���ռƻ� -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
