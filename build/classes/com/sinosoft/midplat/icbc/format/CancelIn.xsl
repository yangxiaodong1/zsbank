<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
 	<xsl:apply-templates select="TXLife/TXLifeRequest" />
	
	<Body>
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="TXLifeRequest">
<Head>
	<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)"/></TranDate>
	<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)"/></TranTime>
	<TellerNo><xsl:value-of select="OLifEExtension/Teller"/></TellerNo>
	<TranNo><xsl:value-of select="TransRefGUID"/></TranNo>
	<NodeNo>
		<xsl:value-of select="OLifEExtension/RegionCode"/>
		<xsl:value-of select="OLifEExtension/Branch"/>
	</NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	<SourceType><xsl:apply-templates select="OLifEExtension/SourceType"/></SourceType>
</Head>
</xsl:template>

<xsl:template name="Body" match="Policy">
<ContNo><xsl:value-of select="PolNumber"/></ContNo>
<ProposalPrtNo></ProposalPrtNo>
<ContPrtNo></ContPrtNo>
<Prem></Prem>
</xsl:template>

<!-- 渠道类型 -->
	<xsl:template  match="SourceType">
	<xsl:choose>
		<xsl:when test=".=0">0</xsl:when>	<!-- 银保通柜台出单 -->
		<xsl:when test=".=1">1</xsl:when>	<!-- 网银 -->
		<xsl:when test=".=8">8</xsl:when>	<!-- 自助终端 -->
		<!-- 浙江工行手机渠道采用的是网银渠道出单，此处不需要增加手机渠道 -->
		<!-- <xsl:when test=".=5">17</xsl:when> -->	<!-- 手机 -->		
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
	</xsl:template>		
</xsl:stylesheet>
