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
	
	<Count><xsl:value-of select="Rvl_Rcrd_Num" /></Count>
	<!-- 查询类型:1=投保单号，2=保单号 -->
	<NoType>1</NoType>
	<!-- 投保单号 -->
	<xsl:for-each select="Insu_List/Insu_Detail">
		<Detail>
			<No><xsl:value-of select="Ins_BillNo" /></No>
		</Detail>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
