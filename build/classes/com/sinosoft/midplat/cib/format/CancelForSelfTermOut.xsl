<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<RETURN>
			<MAIN>
				<xsl:variable name ="flag" select ="Head/Flag"/>
				<xsl:choose>
					<xsl:when test="$flag=1">
						<!-- 保险公司1失败，0成功 -->
						<OKFLAG>0</OKFLAG><!-- 1 成功，0 失败 -->
						<REJECTNO><xsl:value-of select ="Head/Desc"/></REJECTNO>
					</xsl:when>
					<xsl:otherwise>
						<OKFLAG>1</OKFLAG><!-- 1 成功，0 失败 -->
						<INSURNO><xsl:value-of select ="Body/ContNo"/></INSURNO>
					</xsl:otherwise>
				</xsl:choose>
			</MAIN>
		</RETURN>
	</xsl:template>

</xsl:stylesheet>