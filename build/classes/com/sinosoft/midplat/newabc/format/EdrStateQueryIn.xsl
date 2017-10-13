<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

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
				<xsl:value-of select="Tlid" />
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
			<!-- YBT组织的节点信息 -->
			<xsl:copy-of select="../Head/*" />
			</Head>
	</xsl:template>
	
	<!--报文体信息-->
	<xsl:template match="App/Req">
		<Body>
			<!-- 保单号 -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>
			<EdorType>
				<xsl:apply-templates select="BusinType" />
			</EdorType>
		</Body>
	</xsl:template>
	
	<xsl:template match="BusinType">
		<xsl:choose>
			<xsl:when test=".='01'">WT</xsl:when>	<!-- 犹豫期退保 -->
			<xsl:when test=".='02'">MQ</xsl:when>	<!-- 满期给付 -->
			<xsl:when test=".='03'">CT</xsl:when>	<!-- 退保 -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
