<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TXLife>
			<xsl:copy-of select="Head" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<TotleFee><xsl:value-of select ="format-number(TotalFee, '#.00')"/></TotleFee>
		<TotleCount><xsl:value-of select ="count(CountyDetail)"/></TotleCount>
		<FeeList>
			<xsl:for-each select="CountyDetail">
			<FeeInfo>
				<!-- 手续费区域信息 -->
				<FeeCounty><xsl:value-of select ="County"/></FeeCounty>
				<!-- 手续费 -->
				<FeeNum><xsl:value-of select ="format-number(CountyFee, '#.00')"/></FeeNum>
				<!-- 出单笔数 -->  
				<PolNum><xsl:value-of select ="PolNum"/></PolNum>
			</FeeInfo>
			</xsl:for-each>
		</FeeList>
	</xsl:template>

</xsl:stylesheet>