<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- 投保单号 -->
	<ProposalPrtNo><xsl:value-of select="Ins_BillNo" /></ProposalPrtNo>
	<!-- 保单号 -->
	<ContNo />
	<!-- 保单合同印刷号 -->
	<ContPrtNo />
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName> <!-- 首期保费账户名-->
	<AccNo><xsl:value-of select="CCB_AccNo" /></AccNo> <!-- 首期保费账户号-->
	
	<!-- 保险公司流水号 -->
	<OldLogNo><xsl:value-of select="Ins_Co_Jrnl_No"/></OldLogNo>
</xsl:template>

</xsl:stylesheet>
