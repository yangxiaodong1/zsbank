<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
</xsl:template>


<xsl:template name="Body" match="TranData/Body">
	<DealType>
		<xsl:call-template name="tran_type">
			<xsl:with-param name="type">
				<xsl:value-of select="substring(FileName, 3, 1)" />
			</xsl:with-param>
		</xsl:call-template>
	</DealType><!-- 处理类型  S-代收  F-代付 -->
	<BatchDate><xsl:value-of select="substring(FileName, 10, 8)" /></BatchDate><!-- 批量交易日期 -->
	<FileName><xsl:value-of select="FileName"/></FileName>
</xsl:template>

<xsl:template name="tran_type">
	<xsl:param name="type" />
	<xsl:choose>
		<xsl:when test="$type = 0">S</xsl:when>
		<xsl:when test="$type = 1">F</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
