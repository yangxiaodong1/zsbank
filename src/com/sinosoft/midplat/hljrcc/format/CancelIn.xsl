<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="TranData/Head" />
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
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
				<xsl:value-of select="ZoneNo" />
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

	<xsl:template name="Body" match="Body">
		<!-- 保单号 -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- 投保单号 -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- 保单印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
	</xsl:template>

</xsl:stylesheet>
