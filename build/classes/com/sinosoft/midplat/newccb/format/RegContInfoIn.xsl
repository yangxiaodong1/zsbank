<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TX">
	 <TranData>
		<Head>
			<xsl:copy-of select="Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="APP_ENTITY">
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo> <!-- 保险单号 必填 -->
	<ProposalPrtNo /> <!-- 投保单(印刷)号 -->
	<EdorType /> <!-- 投保单(印刷)号 WT/CT/MQ -->
</xsl:template>

</xsl:stylesheet>
