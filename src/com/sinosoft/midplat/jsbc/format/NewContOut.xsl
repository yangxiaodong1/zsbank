<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<MAIN>
				<!--账号代码-->
				<ACC_CODE><xsl:value-of select="TranData/Body/AccNo" /></ACC_CODE>
				<!--保费总额,以分为单位-->
				<AMT_PREMIUM>
					<xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(TranData/Body/ActSumPrem)"/>
				</AMT_PREMIUM>
			</MAIN>
		</TranData>
	</xsl:template>

</xsl:stylesheet>