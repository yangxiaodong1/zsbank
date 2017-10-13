<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="INSUAFFIRM">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
				<TranDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</TranDate>
				<TranTime>
					<xsl:value-of select="MAIN/TRANSRTIME" />
				</TranTime>
				<TranNo>
					<xsl:value-of select="MAIN/TRANSRNO" />
				</TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO" />
					<xsl:value-of select="MAIN/BRNO" />
				</NodeNo>
				<TellerNo>
					<xsl:value-of select="MAIN/TELLERNO" />
				</TellerNo>
				<xsl:copy-of select="Head/*" />
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<SourceType><xsl:apply-templates select="MAIN/SOURCETYPE" /></SourceType>
			</Head>

			<Body>
				<ContNo></ContNo>
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
				<OldTranNo>
					<xsl:value-of select="MAIN/REQSRNO" />
				</OldTranNo>
			</Body>
		</TranData>
	</xsl:template>

    <!-- 交易渠道 -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 柜面 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 网银 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>