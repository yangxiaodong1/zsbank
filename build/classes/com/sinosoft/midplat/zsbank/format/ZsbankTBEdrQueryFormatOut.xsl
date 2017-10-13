<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="//Head/*"/>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 保险单号,必填项 -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- 可退金额,必填项 -->
			<FinActivityGrossAmt>
				<xsl:value-of select="FinActivityGrossAmt"/>
			</FinActivityGrossAmt>
		</Body>
	</xsl:template>
	
</xsl:stylesheet>
