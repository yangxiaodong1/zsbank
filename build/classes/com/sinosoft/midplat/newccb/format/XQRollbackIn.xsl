<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="APP_ENTITY">

	<!--保单号-->
	<ContNo>
		<xsl:value-of select="InsPolcy_No" />
	</ContNo>
	<EdorAppDate>
		<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
	</EdorAppDate>
	<EdorAppNo></EdorAppNo>
	<TranMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TxnAmt)" /></TranMoney>
	<EdorType>XQ</EdorType>
</xsl:template>

</xsl:stylesheet>
