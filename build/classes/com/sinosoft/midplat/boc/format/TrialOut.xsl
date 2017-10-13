<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head"/>
			<xsl:apply-templates select="TranData/Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag"/>
			</Flag>
			<!-- 0表示成功，1表示失败 -->
			<Desc>
				<xsl:value-of select="Desc"/>
			</Desc>
			<!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<Prem>			    
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			</Prem>
			<!-- 保费合计 -->
		</Body>
	</xsl:template>
</xsl:stylesheet>
