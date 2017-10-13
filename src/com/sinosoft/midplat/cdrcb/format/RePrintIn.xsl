<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/INSU">
<TranData>
	<xsl:apply-templates select="MAIN" />
	
	<Body>		
		<ContNo><xsl:value-of select="MAIN/POLICY"/></ContNo> <!-- 保单号码  -->
		<ProposalPrtNo><xsl:value-of select="MAIN/APPLNO"/></ProposalPrtNo> <!-- 投保单(印刷)号  -->
		<ContPrtNo><xsl:value-of select="MAIN/BD_PRINT_NO"/></ContPrtNo> <!-- 保单合同印刷号 -->
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="MAIN">
	<Head>
		<TranDate><xsl:value-of select="TRANSRDATE"/></TranDate>
	    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
	    <TellerNo><xsl:value-of select="TELLER_NO"/></TellerNo>
	    <TranNo><xsl:value-of select="TRANSRNO"/></TranNo>
	    <NodeNo><xsl:value-of select="BRACH_NO"/></NodeNo>
	    <xsl:copy-of select="../Head/*"/>
	    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	</Head>
</xsl:template>

</xsl:stylesheet>
