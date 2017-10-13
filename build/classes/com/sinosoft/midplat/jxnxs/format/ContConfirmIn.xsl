<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUAFFIRM">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="MAIN/TRANSRTIME"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
			</Head>
			<!-- 报文体 -->
			<xsl:apply-templates select="MAIN" />
		</TranData>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Body" match="MAIN">
		<Body>
			<!-- 投保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="APPLNO" />
			</ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo>
				<xsl:value-of select="BD_PRINT_NO" />
			</ContPrtNo>
			<!-- 签单交易流水号 -->
			<OrigTranNo>
				<xsl:value-of select="REQSRNO" />
			</OrigTranNo>
			<ContNo></ContNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>