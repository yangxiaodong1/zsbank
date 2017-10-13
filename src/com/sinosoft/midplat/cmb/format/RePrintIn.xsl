<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- 保单号 -->
				<ContNo>
					<xsl:value-of select="//Policy/PolNumber" />
				</ContNo>
				<!-- 投保单号 -->
				<ProposalPrtNo>
					<xsl:value-of
						select="//ApplicationInfo/HOAppFormNumber" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of
						select="//FormInstance[FormName='PolicyPrintNumber']/ProviderFormNumber" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
</xsl:stylesheet>

