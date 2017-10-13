<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<!-- 报文头 -->
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="//Head/*"/>
		</Head>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 贷款生效日[yyyyMMdd] -->
			<EdorValidDate>
				<xsl:value-of select="EdorValidDate"/>
			</EdorValidDate>
			<!-- 批单号 -->
			<EdorNo>
				<xsl:value-of select="EdorNo"/>
			</EdorNo>
			<!-- 贷款金额，单位是分 -->
			<LoanMoney>
				<xsl:value-of select="LoanMoney"/>
			</LoanMoney>
		</Body>
	</xsl:template>
	
</xsl:stylesheet>
