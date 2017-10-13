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
		<ContNo><xsl:value-of select="InsurNo"/></ContNo> <!-- 保单号码  -->
		<ProposalPrtNo></ProposalPrtNo> <!-- 投保单(印刷)号  -->
	</Body>
</xsl:template>

<xsl:template name="Head" match="TransHeader">
	<Head>
		<TranDate><xsl:value-of select="TransDate"/></TranDate>
	    <TranTime><xsl:value-of select="TransTime"/></TranTime>
	    <TellerNo><xsl:value-of select="../TransBody/Request/UserNo"/></TellerNo>
	    <TranNo><xsl:value-of select="XDSerialNo"/></TranNo>
	    <!-- <NodeNo><xsl:value-of select="../TransBody/Request/OrgNo"/></NodeNo> -->
		    <NodeNo>02100000</NodeNo>
	    <xsl:copy-of select="../Head/*"/>
	    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	    <SourceType>z</SourceType> <!-- 0=银保通柜面、1=网银、8=自助终端、z-直销银行 -->
	</Head>
</xsl:template>
</xsl:stylesheet>
