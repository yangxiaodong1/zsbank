<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body/Detail_List/Detail" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Detail">
<Detail>
	<CardType>1099</CardType>
	<CardNo><xsl:value-of select="BkVchNo"/></CardNo>
	<CardState><xsl:apply-templates select="BkFlag2" /></CardState>
	<TranNo><xsl:value-of select="BkSeqNo"/></TranNo>
</Detail>	
</xsl:template>

<xsl:template match="BkFlag2">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- 领入 -->
	<xsl:when test=".=2">2</xsl:when>	<!-- 使用 -->
	<xsl:when test=".=3">4</xsl:when>	<!-- 作废 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
