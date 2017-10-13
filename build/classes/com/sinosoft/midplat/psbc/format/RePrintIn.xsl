<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="INSU">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
				<TranDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</TranDate>
				<TranTime>
					<xsl:value-of select="MAIN/TRANSRTIME" />
				</TranTime>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO" />
					<xsl:value-of select="MAIN/BRNO" />
				</NodeNo>
				<TellerNo>
					<xsl:value-of select="MAIN/TELLERNO" />
				</TellerNo>
				<TranNo>
					<xsl:value-of select="MAIN/TRANSRNO" />
				</TranNo>
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
			</Head>
			<Body>
				<ContNo></ContNo>
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>