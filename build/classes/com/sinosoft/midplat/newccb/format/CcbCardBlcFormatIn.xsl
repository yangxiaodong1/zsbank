<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- 新契约对账 -->
	<TranData>
		<!-- 报文头 -->
		<xsl:copy-of select="TranData/Head" />
		
		<Body>
			<xsl:apply-templates select="TranData/DetailList/Detail" />
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="Detail">
<Detail>
	<CardType>1099</CardType>
	<CardNo><xsl:value-of select="Ins_IBVoch_ID"/></CardNo>
	<CardState><xsl:apply-templates select="IpOpR_Crcl_StCd" /></CardState>
</Detail>	
</xsl:template>

<xsl:template match="IpOpR_Crcl_StCd">
<xsl:choose>
	<xsl:when test=".='01'">12</xsl:when>	<!-- 正常（未使用） -->
	<xsl:when test=".='02'">12</xsl:when>	<!-- 领入 -->
	<xsl:when test=".='03'">21</xsl:when>	<!-- 使用 -->
	<xsl:when test=".='04'">42</xsl:when>	<!-- 作废 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>


