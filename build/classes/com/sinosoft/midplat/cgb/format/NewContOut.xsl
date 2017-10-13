<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/"> <!-- 可以match 任何的吗？？？？啥个意思嘛嘛 -->
		<TranData>
			<xsl:copy-of select="TranData/Head" /> <!-- 头文件  -->
			<MAIN>
				<!--账号代码-->
				<ACC_CODE></ACC_CODE>
				<!--保费总额,以分为单位-->
				<AMT_PREMIUM>
					<xsl:value-of select="TranData/Body/ActSumPrem" />
				</AMT_PREMIUM>
			</MAIN>
		</TranData>
	</xsl:template>

</xsl:stylesheet>