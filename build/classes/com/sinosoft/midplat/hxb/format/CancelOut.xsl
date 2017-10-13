<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<RETURN>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<MAIN>
				<!-- 保险单号 -->
				<INSURNO></INSURNO>
				<!-- 投保单号 -->
				<APPLYNO></APPLYNO>
			</MAIN>
		</RETURN>
	</xsl:template>			
</xsl:stylesheet>


