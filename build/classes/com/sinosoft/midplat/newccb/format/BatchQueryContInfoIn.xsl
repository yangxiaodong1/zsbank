<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<TX>
		<Head>
			<xsl:copy-of select="TX/Head/*" />
		</Head>
		<!-- 不转换 -->
		<TX_HEADER>
			<xsl:copy-of select="TX/TX_HEADER/*" />
		</TX_HEADER>
		<TX_BODY>
			<xsl:copy-of select="TX/TX_BODY/*" />
		</TX_BODY>
	</TX>
</xsl:template>

</xsl:stylesheet>