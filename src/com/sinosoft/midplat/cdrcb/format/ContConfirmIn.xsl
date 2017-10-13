<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/INSUREQ">
<TranData>    
	<xsl:apply-templates select="MAIN" />
	
	<Body>
		<ContNo></ContNo>
		<ProposalPrtNo><xsl:value-of select="MAIN/APPLNO"/></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="MAIN/BD_PRINT_NO"/></ContPrtNo>
		<OldLogNo><xsl:value-of select="MAIN/TRANSRNO_ORI"/></OldLogNo>
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
