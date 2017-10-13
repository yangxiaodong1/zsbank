<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="TranData">
<TX>
	<xsl:copy-of select="Head" />
	<TX_BODY>
		<COMMON>
			<FILE_LIST_PACK>
				<FILE_NUM></FILE_NUM>
				<FILE_MODE>0</FILE_MODE>
				<FILE_NODE></FILE_NODE>
				<FILE_NAME_PACK></FILE_NAME_PACK>
				<FILE_PATH_PACK></FILE_PATH_PACK>
				<FILE_INFO>
					<FILE_NAME>
						<xsl:value-of select="Body/FILE_NAME" />
					</FILE_NAME>
					<FILE_PATH>
						<xsl:value-of select="Body/FILE_PATH" />
					</FILE_PATH>
				</FILE_INFO>
			</FILE_LIST_PACK>
		</COMMON>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">
	<!-- 循环记录条数 -->
	<NRlTmInsPlyDtlTot_Num><xsl:value-of select="Count" /></NRlTmInsPlyDtlTot_Num>
</xsl:template>

</xsl:stylesheet>


