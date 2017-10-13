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
				<!-- 保单信息 -->
				<Policy>
					<!-- 主险代码 -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--首期保费-->
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

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId"
			select="concat('Cov_', string(position()))" />
			<Coverage>
				<xsl:attribute name="id"><xsl:value-of select="$RiskId" />
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
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</InitCovAmt>
				<!-- 投保份额 -->
				<IntialNumberOfUnits>
					<xsl:value-of select="Mult" />
				</IntialNumberOfUnits>
				<!-- 险种保费 -->
				<ChargeTotalAmt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
				</ChargeTotalAmt>
			</Coverage>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="RiskCode" >
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- 安邦附加安心7号重大疾病保险 -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- 安邦附加盛世安康住院医疗保险A款 -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- 安邦附加盛世安康住院医疗保险B款 -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- 安邦附加盛世安康护理保险 -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- 安邦附加盛世安康防癌疾病保险 -->
			<!-- 此处还保留成50002，因为银行用的险种代码是50002，而不是50015 -->
			<xsl:when test=".='122046'">50002</xsl:when><!-- 安邦长寿稳赢1号两全保险-->
			<!-- 安邦长寿智赢1号两全保险计划,2014-08-29停售 -->
			<xsl:when test=".='50006'">50006</xsl:when>
			<xsl:when test=".='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  end -->
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型） B款 -->
			<!-- add 20160222 PBKINSR-1071 招行新产品盛世1号B款需求  end -->
			<!-- PBKINSR-1444 招行柜面东风3号 L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<!-- PBKINSR-1530 招行柜面东风9号 L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
