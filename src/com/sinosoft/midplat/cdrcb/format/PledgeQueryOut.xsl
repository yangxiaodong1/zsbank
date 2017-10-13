<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<xsl:apply-templates select="TranData/Body" />
</Transaction>
</xsl:template>

<xsl:template name="Body" match="Body">
	<TransBody>
		<Response>
			<InsurStatus><xsl:apply-templates select="MortStatu"/></InsurStatus><!-- 保单状态 -->
			<InsurAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></InsurAmount><!-- 保费 -->
			<InsurCurAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)"/></InsurCurAmount><!-- 保单现金价值 -->
			<InsurCorpNo>1</InsurCorpNo><!-- 保险公司编号 -->
			<InsurPhoneNo><xsl:value-of select="Appnt/Mobile"/></InsurPhoneNo><!-- 保单人手机号 -->
			<InsurStartDate><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate"/></InsurStartDate><!-- 保单生效日期 -->
			<InsurEndDate><xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate"/></InsurEndDate><!-- 保单到期日期 -->
			<Assured><xsl:value-of select="Insured/Name"/></Assured><!-- 被保险人 -->
			<AssuredCertType><xsl:apply-templates select="Insured/IDType"/></AssuredCertType><!-- 被保险人证件类型 -->
			<AssuredCertId><xsl:value-of select="Insured/IDNo"/></AssuredCertId><!-- 被保险人证件号码 -->
			<Beneficiary><xsl:value-of select="Bnf/Name"/></Beneficiary><!-- 受益人 -->
			<BeneCertType><xsl:apply-templates select="Bnf/IDType"/></BeneCertType><!-- 受益人证件类型 -->
			<BeneCertId><xsl:value-of select="Bnf/IDNo"/></BeneCertId><!-- 受益人证件号码 -->
			<InsurType>02</InsurType><!-- 保险类型:01-财产保险；02-人寿保险； -->
		</Response>		
	</TransBody>
</xsl:template>
<!-- 保单质押状态： 0未质押，1质押 -->
<xsl:template match="MortStatu">
	<xsl:choose>
		<xsl:when test=".='0'">2</xsl:when><!--	正常 -->
		<xsl:when test=".='1'">1</xsl:when><!--	已质押（冻结） -->
	</xsl:choose>
</xsl:template>

<!-- 证件类型：核心**银行 -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".='0'">0</xsl:when><!--居民身份证**身份证 -->
		<xsl:when test=".='1'">2</xsl:when><!--护照**护照-->
		<xsl:when test=".='2'">3</xsl:when><!--军官证**军官证 -->
		<xsl:when test=".='3'">X</xsl:when><!--驾照**其他个人证件 -->
		<xsl:when test=".='4'">X</xsl:when><!--出生证明**其他个人证件 -->
		<xsl:when test=".='5'">1</xsl:when><!--户口簿**户口簿 -->
		<xsl:when test=".='6'">5</xsl:when><!--港澳居民来往内地通行证**港澳居民来往内地通行证-->
		<xsl:when test=".='7'">6</xsl:when><!--台湾居民来往大陆通行证**台湾居民来往大陆通行证-->
		<xsl:when test=".='8'">X</xsl:when><!--其他**其他个人证件 -->
		<xsl:when test=".='9'">X</xsl:when><!--异常身份证**其他个人证件 -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>