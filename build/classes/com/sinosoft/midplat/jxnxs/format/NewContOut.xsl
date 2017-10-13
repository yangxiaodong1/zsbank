<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
<xsl:template match="/TranData">
		<INSUREQRET>
			<MAIN>
				<TRANSRNO></TRANSRNO>
				<RESULTCODE><xsl:apply-templates select="Head/Flag" /></RESULTCODE><!-- 1 �ɹ���0 ʧ�� -->
				<ERR_INFO><xsl:apply-templates select="Head/Desc" /></ERR_INFO>
				<ACC_CODE><xsl:value-of select ="Body/AccNo"/></ACC_CODE>
				<AMT_PREMIUM><xsl:value-of select ="Body/ActSumPrem"/></AMT_PREMIUM>
			</MAIN>
		</INSUREQRET>
</xsl:template>
	<!-- �ɹ���־λ -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">0000</xsl:when><!-- ���гɹ� -->
			<xsl:when test=".='1'">1111</xsl:when><!-- ����ʧ�� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
