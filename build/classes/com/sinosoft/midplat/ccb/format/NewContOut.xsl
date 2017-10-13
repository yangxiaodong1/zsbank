<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
	
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
	<xsl:variable name="tPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>

	<PbSlipNumb><xsl:value-of select="$MainRisk/Mult"/></PbSlipNumb>
	<PiStartDate><xsl:value-of select="$MainRisk/CValiDate"/></PiStartDate>
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="$tPrem"/></BkTxAmt>
	<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
	
	<!-- 在建行端以非套餐形式出单，才有附加险，有附加险时才填充BkNum1的值 -->
	<xsl:if test="ContPlan/ContPlanCode = ''">
		<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
	</xsl:if>
	<xsl:if test="ContPlan/ContPlanCode != ''">
		<BkNum1>0</BkNum1>
	</xsl:if>

	<!-- 附加险信息 -->
	<Appd_List>
		<xsl:if test="ContPlan/ContPlanCode = ''">
		<!-- 在建行端以非套餐形式出单，才有附加险 -->
			<xsl:for-each select="Risk[RiskCode!=MainRiskCode]">
				<Appd_Detail>
					<LiAppdInsuType>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="RiskCode" />
						</xsl:call-template>
					</LiAppdInsuType>	
					<LiAppdInsuExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></LiAppdInsuExp>
				</Appd_Detail>
			</xsl:for-each>
		</xsl:if>
	</Appd_List>

	<PbPayPerAmt><xsl:value-of select="$tPrem"/></PbPayPerAmt>
	<PbPayFre><xsl:apply-templates select="$MainRisk/PayIntv"/></PbPayFre>

	<PbPayDeadLine>
		<xsl:for-each select="$MainRisk">
			<xsl:choose>
				<xsl:when test="PayIntv = 0">一次交清</xsl:when>
				<xsl:when test="PayEndYearFlag = 'Y'">
					<xsl:value-of select="concat(PayEndYear, '年')"/>
				</xsl:when>
				<xsl:when test="PayEndYearFlag = 'M'">
					<xsl:value-of select="concat(PayEndYear, '月')"/>
				</xsl:when>
				<xsl:when test="PayEndYearFlag = 'D'">
					<xsl:value-of select="concat(PayEndYear, '天')"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>	
	</PbPayDeadLine>

</xsl:template>
<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">2001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122002'">2002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122003'">2003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122004'">2004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122005'">2005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122006'">2006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122008'">2008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122009'">2009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122010'">2010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">2035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<!-- 安邦长寿智赢1号年金保险计划,2014-08-29停售 -->
		<!-- 
		<xsl:when test="$riskcode=50006">2052</xsl:when>
		-->
		<xsl:when test="$riskcode='L12052'">2052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 转账频率、缴费频次  -->
<xsl:template match="PayIntv">
	<xsl:choose>
		<xsl:when test=".=0">一次交清</xsl:when>		
		<xsl:when test=".=1">月交</xsl:when>
		<xsl:when test=".=3">季交</xsl:when>
		<xsl:when test=".=6">半年交</xsl:when>
		<xsl:when test=".=12">年交</xsl:when>
		<xsl:when test=".=-1">不定期交</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

