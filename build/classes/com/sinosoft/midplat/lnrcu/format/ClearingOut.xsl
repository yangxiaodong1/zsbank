<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<TXLife>
	<!-- 交易返回码 -->
	<ResultCode>
	  	<xsl:if test="Head/Flag='0'">00</xsl:if>
	  	<xsl:if test="Head/Flag='1'">AA</xsl:if>
	</ResultCode>
	<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
	<TotalFee><xsl:value-of select ="Body/TotalFee"/></TotalFee>
	<TotalNum><xsl:value-of select ="count(Body/CountyDetail)"/></TotalNum>
	<xsl:for-each select="Body/CountyDetail">
	<CountyDetail>
		<!-- 县区联社标识(4位) -->
		<County><xsl:value-of select ="County"/></County>
		<!-- 县区联社手续费(以元为单位) -->
		<CountyFee><xsl:value-of select ="CountyFee"/></CountyFee>
		<!-- 当月保单出单数目 -->  
		<PolNum><xsl:value-of select ="PolNum"/></PolNum>
	</CountyDetail>
	</xsl:for-each>
</TXLife>
</xsl:template>
</xsl:stylesheet>