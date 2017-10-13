<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="Transaction/Transaction_Header"/>
			<Body>
				<xsl:apply-templates select="Transaction/Transaction_Body"/>
			</Body>
		</TranData>
	</xsl:template>
	<xsl:template name="Head" match="Transaction_Header">
		<Head>
			<TranDate>
				<xsl:value-of select="BkPlatDate"/>
			</TranDate>
			<TranTime>
				<xsl:value-of select="BkPlatTime"/>
			</TranTime>
			<TellerNo>
				<xsl:value-of select="BkTellerNo"/>
			</TellerNo>
			<TranNo>
				<xsl:value-of select="BkPlatSeqNo"/>
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BkBrchNo"/>
			</NodeNo>
			<xsl:copy-of select="../Head/*"/>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode"/>
			</BankCode>
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Transaction_Body">
		<ContNo>
			<xsl:value-of select="PbInsuSlipNo"/>
		</ContNo>
		<AccNo>
			<xsl:value-of select="BkAcctNo1"/>
		</AccNo>
		<AccName>
			<xsl:value-of select="PbHoldName"/>
		</AccName>
		<SFFlag>
			<xsl:call-template name="tran_Flag">
				<xsl:with-param name="Flag" select="BkTxType"/>
			</xsl:call-template>
		</SFFlag>
		<EdorAppNo>
			<xsl:value-of select="LiRatifyPrtId"/>
		</EdorAppNo>
	</xsl:template>
	<!-- 代发代扣标志 -->
	<xsl:template name="tran_Flag">
		<xsl:param name="Flag"/>
		<xsl:choose>
			<xsl:when test="$Flag=1">F</xsl:when>
			<xsl:when test="$Flag=2">S</xsl:when>
			<xsl:when test="$Flag=3">S/F</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
