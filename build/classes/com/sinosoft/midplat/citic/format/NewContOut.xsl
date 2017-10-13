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
	
	<PbSlipNumb><xsl:value-of select="$MainRisk/Mult"/></PbSlipNumb>
	<PiStartDate><xsl:value-of select="$MainRisk/SignDate"/></PiStartDate><!-- 合同成立日期  -->
	<PiValidate><xsl:value-of select="$MainRisk/CValiDate"/></PiValidate><!-- 合同生效日期  -->
	<PiSsDate><xsl:value-of select="$MainRisk/CValiDate"/></PiSsDate><!-- 中信 生效日期 -->
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></BkTxAmt>
	<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
	
	<!-- 在中信银行端以非套餐形式出单，才有附加险，有附加险时才填充BkNum1的值 -->
	<xsl:if test="ContPlan/ContPlanCode = ''">
		<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
	</xsl:if>
	<xsl:if test="ContPlan/ContPlanCode != ''">
		<BkNum1>0</BkNum1>
	</xsl:if>
	
	<Appd_List>
		<!-- 在中信银行端以非套餐形式出单，才有附加险 -->
		<xsl:if test="ContPlan/ContPlanCode = ''">
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
</xsl:template>
<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when> <!-- 安邦盛世1号终身寿险（万能型）-->
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型） -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	
	<xsl:when test="$riskcode=50006">50006</xsl:when>	<!-- 安邦长寿智赢1号年金保险计划 -->
	<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）B款-->
	
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型）-->
	<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型）-->
	
	<!-- PBKINSR-1469 中信柜面东风9号 L12088 zx add 20160808 -->
	<xsl:when test="$riskcode='L12088'">L12088</xsl:when>
	<!-- PBKINSR-1458 中信柜面东风2号 L12085 zx add 20160808 -->
	<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
