<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>

<xsl:template match="Body">

	<!-- ���������������� -->
	<AgIns_BtchBag_Nm><xsl:value-of select="AgIns_BtchBag_Nm" /></AgIns_BtchBag_Nm>
	<!-- ��ǰ����ϸ�ܱ��� -->
	<Cur_Btch_Dtl_TDnum><xsl:value-of select="Cur_Btch_Dtl_TDnum" /></Cur_Btch_Dtl_TDnum>
				
</xsl:template>

</xsl:stylesheet>

