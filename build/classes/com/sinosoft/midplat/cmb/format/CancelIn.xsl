<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLife/Holding/Policy" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
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

	<xsl:template name="Body" match="Policy">
		<!-- ������ -->
		<ContNo>
			<xsl:value-of select="PolNumber" />
		</ContNo>
		<!-- Ͷ������ -->
		<ProposalPrtNo></ProposalPrtNo>
		<!-- ����ӡˢ�� -->
		<ContPrtNo></ContPrtNo>
	</xsl:template>

</xsl:stylesheet>
