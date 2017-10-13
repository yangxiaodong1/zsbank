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
    <!-- 处理类型  S-代收  F-代付 -->
	<DealType>S</DealType>
	<!-- 批量交易日期 -->
	<BatchDate><xsl:value-of select="./TranDate" /></BatchDate>
	<!-- 批量文件名称  -->
	<FileName><xsl:value-of select="FileName"/></FileName>
</xsl:template>

</xsl:stylesheet>
