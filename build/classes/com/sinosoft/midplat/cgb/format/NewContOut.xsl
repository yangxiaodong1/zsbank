<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/"> <!-- ����match �κε��𣿣�����ɶ����˼���� -->
		<TranData>
			<xsl:copy-of select="TranData/Head" /> <!-- ͷ�ļ�  -->
			<MAIN>
				<!--�˺Ŵ���-->
				<ACC_CODE></ACC_CODE>
				<!--�����ܶ�,�Է�Ϊ��λ-->
				<AMT_PREMIUM>
					<xsl:value-of select="TranData/Body/ActSumPrem" />
				</AMT_PREMIUM>
			</MAIN>
		</TranData>
	</xsl:template>

</xsl:stylesheet>