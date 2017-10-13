<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />

			<!-- 报文体 -->
			<xsl:apply-templates select="App/Req" />

		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template match="Header">
		<!--基本信息-->
		<Head>
			<!-- 银行交易日期 -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- 交易时间 农行不传交易时间 取系统当前时间 -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- 柜员代码 -->
			<TellerNo>
				<xsl:if test="Tlid =''">sys</xsl:if>
			    <xsl:if test="Tlid !=''"><xsl:value-of select="Tlid" /></xsl:if>
			</TellerNo>
			<!-- 银行交易流水号 -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- 地区码+网点码 -->
			<NodeNo>
				<xsl:value-of select="ProvCode" />
				<xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>
				<xsl:apply-templates select="EntrustWay" />
			</SourceType>
			<!-- YBT组织的节点信息 -->
			<xsl:copy-of select="../Head/*" />
			</Head>
	</xsl:template>

	<!--报文体信息-->
	<xsl:template match="App/Req">
		<Body>
			<!-- 保险单号 -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>
			<!-- 投保单(印刷)号 -->
			<ProposalPrtNo></ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo></ContPrtNo>
		</Body>
	</xsl:template>
	
	<!-- 银行保单销售渠道: 0=柜面，1=网银-->
	<xsl:template match="EntrustWay">
		<xsl:choose>
			<xsl:when test=".='11'">0</xsl:when><!--	银保通柜面 -->
			<xsl:when test=".='01'">1</xsl:when><!--	网银 -->
			<xsl:when test=".='04'">1</xsl:when><!--	自助终端 -->
			<xsl:when test=".='02'">17</xsl:when><!--   手机银行 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>
