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
	<ProposalPrtNo></ProposalPrtNo>
	<!-- 保单号 寿险保单号标签：ContNo。保单印刷号（单证号）：ContPrtNo-->
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo>
	<!-- 单证号 -->
	<ContPrtNo></ContPrtNo>
	
	<!-- 新单确认交易的保险公司方流水号 -->
	<OldLogNo><xsl:value-of select="Ins_Co_Jrnl_No" /></OldLogNo>
</xsl:template>

</xsl:stylesheet>
