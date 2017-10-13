<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head"/>
			<xsl:apply-templates select="TranData/Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag"/>
			</Flag>
			<!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Desc>
				<xsl:value-of select="Desc"/>
			</Desc>
			<!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<Prem>			    
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			</Prem>
			<!-- ���Ѻϼ� -->
		</Body>
	</xsl:template>
</xsl:stylesheet>
