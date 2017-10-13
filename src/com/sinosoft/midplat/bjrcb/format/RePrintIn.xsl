<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TXLife">
		<TranData>
			<xsl:apply-templates select="Head" />

			<!--报文体信息-->
			<Body>
				<!-- 保单号码 -->
				<ContNo>
					<xsl:value-of select="Body/PolicyNo" />
				</ContNo>
				<!-- 投保单号码 -->
				<ProposalPrtNo>
					<xsl:value-of select="Body/PolHNo" />
				</ProposalPrtNo>
				<!-- 新保单册印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="Body/NewPolPrintCode" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template name="pocket" match="Head">
		<Head>
			<TranDate>
				<xsl:value-of select="MsgSendDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="MsgSendTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OperTellerNo" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransSerialCode" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

</xsl:stylesheet>
