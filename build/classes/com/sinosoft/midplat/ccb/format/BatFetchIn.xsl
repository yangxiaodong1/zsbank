<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
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
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
	<DealType>
		<xsl:call-template name="tran_type">
			<xsl:with-param name="type">
				<xsl:value-of select="substring(BkFileName, 3, 1)" />
			</xsl:with-param>
		</xsl:call-template>
	</DealType><!-- 处理类型  S-代收  F-代付-->
	<BatchDate><xsl:value-of select="substring(BkFileName, 10, 8)" /></BatchDate><!-- 批量交易日期 -->
	<FileName><xsl:value-of select="BkFileName"/></FileName><!-- 建行批量包名称 -->
</xsl:template>

<xsl:template name="tran_type">
	<xsl:param name="type">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$type = 0">S</xsl:when>
		<xsl:when test="$type = 1">F</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
