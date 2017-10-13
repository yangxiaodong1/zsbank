<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<MAIN>
				<!-- 交易流水号 -->
				<TRANSRNO></TRANSRNO>
				<!--账号代码-->
				<ACC_CODE></ACC_CODE>
			</MAIN>
		</TranData>
	</xsl:template>

</xsl:stylesheet>