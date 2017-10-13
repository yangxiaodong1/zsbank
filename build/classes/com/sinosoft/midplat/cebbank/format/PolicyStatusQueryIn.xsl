<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<Count><xsl:value-of select="count(TranData/Body/Detail)" /></Count>
				<!-- 查询保单 -->
				<NoType>2</NoType>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>
	
	<xsl:template match="Detail">
		<Detail>
			<No><xsl:value-of select="Column[2]" /></No>
		</Detail>
	</xsl:template>
</xsl:stylesheet>
