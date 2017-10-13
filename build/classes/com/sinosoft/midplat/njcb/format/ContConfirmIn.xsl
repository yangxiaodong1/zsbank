<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
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
			<!-- 交易日期（yyyymmdd） -->
			<xsl:copy-of select="TranDate" />
			<!-- 交易时间（hhmmss）-->
			<xsl:copy-of select="TranTime" />
			<!-- 柜员编码 -->
			<xsl:copy-of select="TellerNo" />
			<!-- 交易流水号 -->
			<xsl:copy-of select="TranNo" />
			<!-- 地区码+网点码-->
			<NodeNo>
				<!-- 南京银行不需要地区码
				<xsl:value-of select="ZoneNo" />
				<-->
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<!-- 银保通交易码-->
			<xsl:copy-of select="FuncFlag" />
			<!-- 交易银行-->
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 签单交易流水号 -->
			<OrigTranNo>
				<xsl:value-of select="OrigTranNo" />
			</OrigTranNo>
			<!-- 保险单号 -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- 投保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo" />
			</ContPrtNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>