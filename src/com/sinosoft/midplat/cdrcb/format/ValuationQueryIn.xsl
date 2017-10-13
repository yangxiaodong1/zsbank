<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/Transaction">
<TranData>
	<xsl:apply-templates select="TransHeader" />
	<xsl:apply-templates select="TransBody/Request" />
</TranData>
</xsl:template>

<xsl:template name="Body" match="Request">
	<Body>		
		<IDType><xsl:apply-templates select="CAppCertfCls"/></IDType><!-- 投保人证件类型 -->
		<IDNo><xsl:value-of select="CAppCertfCde"/></IDNo> <!-- 投保人证件号 -->
	</Body>
</xsl:template>

<xsl:template name="Head" match="TransHeader">
	<Head>
		<TranDate><xsl:value-of select="CTransactionDate"/></TranDate>
	    <TranTime><xsl:value-of select="CTransactionTime"/></TranTime>
	    <TellerNo>sys</TellerNo>
	    <TranNo><xsl:value-of select="MessageId"/></TranNo>
	    <!-- <NodeNo><xsl:value-of select="../TransBody/Request/OrgNo"/></NodeNo> -->
		    <NodeNo>02100000</NodeNo>
	    <xsl:copy-of select="../Head/*"/>
	    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	    <SourceType>z</SourceType> <!-- 0=银保通柜面、1=网银、8=自助终端、z-直销银行 -->
	</Head>
</xsl:template>

<!-- 证件类型 -->
	<xsl:template name="CAppCertfCls" match="CAppCertfCls">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='02'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='03'">2</xsl:when><!-- 军人证 -->
			<xsl:when test=".='201'">6</xsl:when><!-- 港澳证 -->
			<xsl:when test=".='202'">7</xsl:when><!-- 台胞证 -->
			<xsl:when test=".='99'">8</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
