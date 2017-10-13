<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<xsl:apply-templates select="Head" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头信息 -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- 交易日期[yyyyMMdd] -->
			<TranDate>
				<xsl:value-of select="TranDate" />
			</TranDate>
			<!-- 交易时间[hhmmss] -->
			<TranTime>
				<xsl:value-of select="TranTime" />
			</TranTime>
			<!-- 柜员代码 -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!-- 交易流水号 -->
			<TranNo>
				<xsl:value-of select="TranNo" />
			</TranNo>
			<!-- 银行网点 哈行没有地区码 -->
			<NodeNo>
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- 报文体信息 -->
	<xsl:template name="Body" match="Body">
		<!-- 保险单号 -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- 投保单(印刷)号 -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- 保单合同印刷号 -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<ContPrtNo></ContPrtNo>
	</xsl:template>

</xsl:stylesheet>
