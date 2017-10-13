<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TXLife>
	</xsl:template>

	<xsl:template name="Body" match="Body">		
		<!--投保单号-->
		<PolHNo>
			<xsl:value-of select="ProposalPrtNo" />
		</PolHNo>
		<!--总保费-->
		<Premium>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
		</Premium>
		<!--总保额-->
		<TotleAmnt>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
		</TotleAmnt>
		<!--保额(中文大写)-->
		<PremiumC>
			<xsl:value-of select="AmntText" />
		</PremiumC>
		<!--保费(中文大写)-->
		<TotleAmntC>
			<xsl:value-of select="ActSumPremText" />
		</TotleAmntC>
	</xsl:template>

</xsl:stylesheet>
