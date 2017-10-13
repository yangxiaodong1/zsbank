<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- 新契约对账 -->
	<TranData>
		<!-- 报文头 -->
		<Head>
			<xsl:copy-of select="TranData/Head/*" />
		</Head>
		<Body>
		
			<Count><xsl:value-of select="count(//Detail[ORG_TX_ID='P53819146'])" /></Count> 
			
			<xsl:for-each select="//Detail[ORG_TX_ID='P53819146']">
				<Detail>
					<TranNo><xsl:value-of select="RqPtTcNum" /></TranNo>
					<ProposalPrtNo><xsl:value-of select="ProposalPrtNo" /></ProposalPrtNo>
				</Detail>
			</xsl:for-each>
			
		</Body>
	</TranData>
</xsl:template>

</xsl:stylesheet>