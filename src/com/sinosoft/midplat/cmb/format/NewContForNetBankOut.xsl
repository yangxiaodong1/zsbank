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
				<!-- 保单信息 -->
				<Policy>
					<!-- 主险代码 -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--首期保费-->
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

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
			<Coverage>
				<xsl:attribute name="id">
					<xsl:value-of select="$RiskId" />
				</xsl:attribute>
				<!-- 险种代码 -->
				<ProductCode>
					<xsl:apply-templates select="RiskCode" />
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
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</InitCovAmt>
				<!-- 投保份额 -->
				<IntialNumberOfUnits>
					<xsl:value-of select="Mult" />
				</IntialNumberOfUnits>
				<!-- 险种保费 -->
				<ChargeTotalAmt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
		
		<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款  -->		
		<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
		<!-- PBKINSR-1358 zx add -->
		<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
		<!-- PBKINSR- zx add -->
		<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
		<!-- PBKINSR-1531 招行网银东风9号 L12088 zx add 20160805 -->
		<xsl:when test=".='L12088'">L12088</xsl:when>
		
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
		<!-- PBKINSR-518 招行网银上线黄金鼎5号产品，暂不上线 -->
		<!-- 暂不上线	<xsl:when test=".='122009'">122009</xsl:when>--><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->	
		<!-- PBKINSR-518 招行网银上线黄金鼎5号产品 -->	
		<!-- PBKINSR-517 招行网银开发盛9 -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
		<!-- PBKINSR-517 招行网银开发盛9 -->
		<!-- PBKINSR-514 招行网银开发盛3 -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
		<!-- PBKINSR-514 招行网银开发盛3 -->
		<!-- add 20160105 PBKINSR-1012 招行网银新增产品—长寿稳赢  begin -->
		<xsl:when test=".='122046'">50002</xsl:when><!-- 安邦长寿稳赢1号两全保险-->
		<!-- add 20160105 PBKINSR-1012 招行网银新增产品—长寿稳赢  end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
