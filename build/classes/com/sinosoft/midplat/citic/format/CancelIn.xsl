<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	<SourceType><xsl:apply-templates select="BkChnlNo" /></SourceType>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
	<ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo>
	<ProposalPrtNo></ProposalPrtNo>
	<ContPrtNo></ContPrtNo>
	<Prem><xsl:value-of select="BkTotAmt"/></Prem>	<!-- 交易金额 -->
	<OldLogNo><xsl:value-of select="BkOthOldSeq"/></OldLogNo>	<!-- 原交易保险公司流水号 -->
	
	<!-- 疑问：我方文档的该交易的报文为ContNo，ProposalPrtNo，ContPrtNo；但是建行的当日撤单交易中还有Prem(BkTotAmt*100?做单位转换么？)，OldLogNo -->
</xsl:template>


<!-- 销售渠道关系映射 -->
<xsl:template match="BkChnlNo">
	<xsl:choose>
		<xsl:when test=".='2'">1</xsl:when><!-- 网银 -->
		<xsl:when test=".='3'">17</xsl:when><!-- 手机银行 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

