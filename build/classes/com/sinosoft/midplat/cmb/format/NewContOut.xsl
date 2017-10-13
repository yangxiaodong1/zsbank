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
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="cont">
				<!-- ������Ϣ -->
				<Policy>
					<!-- ���մ��� -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--���ڱ���-->
					<PaymentAmt>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
					</PaymentAmt>
					<Life>
						<xsl:apply-templates select="Risk" />
					</Life>
				</Policy>
			</Holding>
		</OLife>

	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId"
			select="concat('Cov_', string(position()))" />
			<Coverage>
				<xsl:attribute name="id"><xsl:value-of select="$RiskId" />
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
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</InitCovAmt>
				<!-- Ͷ���ݶ� -->
				<IntialNumberOfUnits>
					<xsl:value-of select="Mult" />
				</IntialNumberOfUnits>
				<!-- ���ֱ��� -->
				<ChargeTotalAmt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="RiskCode" >
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<!-- PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ���� -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<!-- PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ���� -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- ����Ӱ���7���ش󼲲����� -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- �����ʢ������סԺҽ�Ʊ���A�� -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- �����ʢ������סԺҽ�Ʊ���B�� -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- �����ʢ�������������� -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- �����ʢ������������������ -->
			<!-- �˴���������50002����Ϊ�����õ����ִ�����50002��������50015 -->
			<xsl:when test=".='122046'">50002</xsl:when><!-- �������Ӯ1����ȫ����-->
			<!-- �������Ӯ1����ȫ���ռƻ�,2014-08-29ͣ�� -->
			<xsl:when test=".='50006'">50006</xsl:when>
			<xsl:when test=".='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  end -->
			<!-- add 20150222 PBKINSR-1071 �����²�Ʒʢ��1��B������  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ� B�� -->
			<!-- add 20160222 PBKINSR-1071 �����²�Ʒʢ��1��B������  end -->
			<!-- PBKINSR-1444 ���й��涫��3�� L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<!-- PBKINSR-1530 ���й��涫��9�� L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>