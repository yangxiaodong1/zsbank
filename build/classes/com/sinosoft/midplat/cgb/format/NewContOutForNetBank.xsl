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
			<TRANSRNO></TRANSRNO><!-- ������ˮ�� -->
			<TRANSRDATE></TRANSRDATE><!-- �������� -->
			<INSUID></INSUID><!-- ���չ�˾���� -->
			<!--Ͷ������-->
			<APPLNO><xsl:value-of select="ProposalPrtNo" /></APPLNO>
			<!-- ������  -->
			<POLICYNO><xsl:value-of select="ContNo" /></POLICYNO>
			<!--�����ܶ�,�Է�Ϊ��λ-->
			<PREMIUM>
				<xsl:value-of select="ActSumPrem" />
			</PREMIUM>
			<!--�ܱ���,�Է�Ϊ��λ-->
			<AMOUNT><xsl:value-of select="Amnt" /></AMOUNT>
		</MAIN>
		<PRODUCTS>
			<PRODUCT>
				<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
				<!-- ���ִ��� -->
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
				<INSU_PREMIUM><xsl:value-of select="ActSumPrem" /></INSU_PREMIUM><!-- ���ֱ��� -->
				<INSU_AMOUNT><xsl:value-of select="Amnt" /></INSU_AMOUNT><!-- ���ֱ��� -->
			</PRODUCT>
		</PRODUCTS>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50015'">50002</xsl:when>  <!-- �������Ӯ���ռƻ�  -->
			<xsl:when test="$riskCode='L12079'">122012</xsl:when> <!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12098'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test="$riskCode='L12089'">L12089</xsl:when><!-- ����ʢ��1��B���������գ������ͣ�-->
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>