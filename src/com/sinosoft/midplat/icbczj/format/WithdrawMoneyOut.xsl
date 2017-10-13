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
				<transexedate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></transexedate>
				<!-- ���չ�˾����ʱ�� -->
				<transexetime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></transexetime>
				<!-- ������ˮ�� -->
				<transrefguid></transrefguid>
				<!-- �����˻� -->
				<accountnumber><xsl:value-of select="Body/PubContInfo/BankAccNo" /></accountnumber>
				<!-- �����,���Ľ��ĵ�λ�Ƿ֣����еĽ�λ��Ԫ -->
				<amount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/PubContInfo/FinActivityGrossAmt)" /></amount>
				<!-- ������ -->
				<bachidno><xsl:value-of select="Body/PubEdorConfirm/FormNumber" /></bachidno>
				
			</ans>
		</package>
	</xsl:template>

</xsl:stylesheet>
