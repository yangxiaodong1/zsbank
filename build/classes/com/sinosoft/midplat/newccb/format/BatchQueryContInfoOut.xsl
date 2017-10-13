<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
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
						<xsl:value-of select="TranData/Body/FILE_NAME" />
					</FILE_NAME>
					<FILE_PATH>
						<xsl:value-of select="TranData/Body/FILE_PATH" />
					</FILE_PATH>
				</FILE_INFO>
			</FILE_LIST_PACK>
		</COMMON>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>

<xsl:template match="Body">

	<!-- 代理保险批量包名称 -->
	<AgIns_BtchBag_Nm><xsl:value-of select="AgIns_BtchBag_Nm" /></AgIns_BtchBag_Nm>
	<!-- 当前批明细总笔数 -->
	<Cur_Btch_Dtl_TDnum><xsl:value-of select="Cur_Btch_Dtl_TDnum" /></Cur_Btch_Dtl_TDnum>
				
</xsl:template>

</xsl:stylesheet>

