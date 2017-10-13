<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				  <StartDate><xsl:value-of select="TranData/Head/TranDate"/></StartDate>
				  <EndDate><xsl:value-of select="TranData/Head/TranDate"/></EndDate>
				
				<!--<StartDate>20160201</StartDate>-->
				<!--<EndDate>20160301</EndDate>-->
				
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
