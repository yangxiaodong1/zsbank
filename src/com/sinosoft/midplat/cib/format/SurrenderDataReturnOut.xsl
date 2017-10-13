<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<!-- 报文体 -->
			<Body>
			    <xsl:copy-of select="TranData/Body" />
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>