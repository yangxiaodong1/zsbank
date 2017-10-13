<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<package>
			<xsl:copy-of select="Head" />

			<ans>
				<!-- ���չ�˾�������� -->
				<transexedate><xsl:value-of select="Body/EdorAppDate" /></transexedate>
				<!-- ���չ�˾����ʱ�� -->
				<transexetime></transexetime>
				<!-- ������ˮ�� -->
				<transrefguid></transrefguid>
				<!-- �����˻� -->
				<accountnumber></accountnumber>
				<!-- �����,���Ľ��ĵ�λ�Ƿ֣����еĽ�λ��Ԫ -->
				<amount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/TranMoney)" /></amount>
				<!-- ������ -->
				<bachidno></bachidno>
				
			</ans>
		</package>
	</xsl:template>

</xsl:stylesheet>
