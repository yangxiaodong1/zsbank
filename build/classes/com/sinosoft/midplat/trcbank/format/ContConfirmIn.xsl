<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TXLife">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<!-- 报文头 -->
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

	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
		<Body>
			
			<!-- 投保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="PolHNo" />
			</ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo>
				<xsl:value-of select="PolPrintNo" />
			</ContPrtNo>
			<ContNo></ContNo>
			<!-- 签单交易流水号 -->
			<OrigTranNo>
				<xsl:value-of select="OriginalTranNo" />
			</OrigTranNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>