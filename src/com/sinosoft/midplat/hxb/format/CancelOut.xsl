<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<RETURN>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<MAIN>
				<!-- ���յ��� -->
				<INSURNO></INSURNO>
				<!-- Ͷ������ -->
				<APPLYNO></APPLYNO>
			</MAIN>
		</RETURN>
	</xsl:template>			
</xsl:stylesheet>


