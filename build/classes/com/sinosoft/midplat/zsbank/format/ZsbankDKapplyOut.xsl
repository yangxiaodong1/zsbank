<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<!-- ����ͷ -->
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="//Head/*"/>
		</Head>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- ������Ч��[yyyyMMdd] -->
			<EdorValidDate>
				<xsl:value-of select="EdorValidDate"/>
			</EdorValidDate>
			<!-- ������ -->
			<EdorNo>
				<xsl:value-of select="EdorNo"/>
			</EdorNo>
			<!-- �������λ�Ƿ� -->
			<LoanMoney>
				<xsl:value-of select="LoanMoney"/>
			</LoanMoney>
		</Body>
	</xsl:template>
	
</xsl:stylesheet>
