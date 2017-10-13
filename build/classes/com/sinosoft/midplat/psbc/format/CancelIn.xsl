<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="FEETRANSCANC">
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
				<ContNo>
					<xsl:value-of select="MAIN/POLICY" />
				</ContNo>
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<ContPrtNo>
					<xsl:value-of select="MAIN/CORTRANSRNO" />
				</ContPrtNo><!--待冲正交易流水号，借用此字段-->
				<Prem>
					<xsl:value-of select="MAIN/PREMIUM" />
				</Prem>
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>