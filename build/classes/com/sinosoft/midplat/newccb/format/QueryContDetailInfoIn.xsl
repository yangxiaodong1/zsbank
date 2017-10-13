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
	
	<!-- 代理保险批量包名称 -->
	<AgIns_BtchBag_Nm><xsl:value-of select="AgIns_BtchBag_Nm" /></AgIns_BtchBag_Nm>
	<!-- 当前批明细总笔数 -->
	<Cur_Btch_Dtl_TDnum></Cur_Btch_Dtl_TDnum>
	
</xsl:template>

</xsl:stylesheet>
