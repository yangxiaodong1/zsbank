<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<xsl:apply-templates select="TranData"/>
</xsl:template>

<xsl:template match="TranData">
<RETURN>
  <MAIN>
    <!--错误码-->
	<RESULTCODE><xsl:apply-templates select="Head/Flag"/></RESULTCODE>
	<!--错误描述-->
	<ERR_INFO>
		<xsl:value-of select="Head/Desc"/>
	</ERR_INFO>
	<!--保费总额-->	
    <AMT_PREMIUM><xsl:value-of select="Body/ActSumPrem"/></AMT_PREMIUM>
  </MAIN>
 </RETURN>
</xsl:template>  
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>