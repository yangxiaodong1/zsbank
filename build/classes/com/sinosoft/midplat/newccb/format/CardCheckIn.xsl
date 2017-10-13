<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="//ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="APP_ENTITY">
	<CardType>1099</CardType>
	<StartCardNo><xsl:value-of select="Ins_IBVoch_Beg_ID"/></StartCardNo>
	<EndCardNo><xsl:value-of select="Ins_IBVoch_End_ID"/></EndCardNo>
</xsl:template>
</xsl:stylesheet>
