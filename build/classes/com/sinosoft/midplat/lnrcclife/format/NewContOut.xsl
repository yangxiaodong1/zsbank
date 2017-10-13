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
		<!--Ͷ������-->
		<PolHNo>
			<xsl:value-of select="ProposalPrtNo" />
		</PolHNo>
		<!--�ܱ���-->
		<Premium>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
		</Premium>
		<!--�ܱ���-->
		<TotleAmnt>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
		</TotleAmnt>
		<!--����(���Ĵ�д)-->
		<PremiumC>
			<xsl:value-of select="AmntText" />
		</PremiumC>
		<!--����(���Ĵ�д)-->
		<TotleAmntC>
			<xsl:value-of select="ActSumPremText" />
		</TotleAmntC>
	</xsl:template>

</xsl:stylesheet>
