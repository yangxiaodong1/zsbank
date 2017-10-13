<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<BkNum1><xsl:value-of select="TranData/Body/SNum"/></BkNum1><!-- 批量代收包个数 -->
		<BkNum2><xsl:value-of select="TranData/Body/FNum"/></BkNum2><!-- 批量代付包个数 -->	
	</Transaction_Body>
</Transaction>
</xsl:template>

</xsl:stylesheet>
