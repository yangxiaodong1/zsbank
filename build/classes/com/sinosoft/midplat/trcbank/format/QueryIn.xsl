<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="TXLife">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Head" />

			<!-- ������ -->
			<xsl:apply-templates select="Body" />

		</TranData>
</xsl:template>

	<xsl:template name="Head" match="Head">
		<Head>
			<TranDate><xsl:value-of select="MsgSendDate" /></TranDate>
			<TranTime><xsl:value-of select="MsgSendTime" /></TranTime>
			<TellerNo><xsl:value-of select="OperTellerNo" /></TellerNo>
			<TranNo><xsl:value-of select="TransSerialCode" /></TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="Body">
		<Body>
			
			<!-- Ͷ������ -->
			<ProposalPrtNo>
				<xsl:value-of select="PolHNo" />
			</ProposalPrtNo>
			<!-- ������ -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>			
		</Body>
	</xsl:template>

</xsl:stylesheet>
