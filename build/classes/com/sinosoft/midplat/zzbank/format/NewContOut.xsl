<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template match="Head">
		<Head>
			<xsl:copy-of select="./*"/>
		</Head>
	</xsl:template>
	
	<xsl:template match="Body">
		<Body>
			<!-- 保险单号 -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- 投保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- 总保费 -->
			<Prem>
				<xsl:value-of select="ActSumPrem"/>
			</Prem>
			<!-- 保额 -->
			<Amnt><xsl:value-of select="Amnt"/></Amnt>
		</Body>
	</xsl:template>
</xsl:stylesheet>
