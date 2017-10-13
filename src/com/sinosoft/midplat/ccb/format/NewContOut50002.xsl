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
	<xsl:variable name="tActSumPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	
	<!-- 非标准报文产品组合份数返回值取标准报报文的产品组合节点下的份数，因risk节点下的份数不准确 -->
	<PbSlipNumb><xsl:value-of select="ContPlan/ContPlanMult"/></PbSlipNumb>
	
	<PiStartDate><xsl:value-of select="$MainRisk/CValiDate"/></PiStartDate>
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="$tActSumPrem"/></BkTxAmt>
	<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
	<BkNum1><xsl:value-of select="0"/></BkNum1>
	<!-- 
	<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
	 -->
	<Appd_List>
	<!-- 
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
	 -->
	</Appd_List>

	<PbPayPerAmt><xsl:value-of select="$tActSumPrem"/></PbPayPerAmt>
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
	<xsl:when test="$riskcode=122001">2001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122002">2002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122003">2003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122004">2004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122005">2005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122006">2006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122008">2008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122009">2009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122010">2010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122035">2035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	
	<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
	<xsl:when test="$riskcode=50002">2046</xsl:when>
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
