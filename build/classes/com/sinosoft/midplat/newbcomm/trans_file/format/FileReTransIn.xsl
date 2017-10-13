<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="TrDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="SubBrchId" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<!-- ������ -->
		<CTranscode><xsl:value-of select="TrCode" /></CTranscode>
		<!-- ѹ���ļ��� -->
		<CFileName><xsl:value-of select="FileName" /></CFileName>
		<!-- ���������κ� -->
		<CBatNo><xsl:value-of select="BatNo" /></CBatNo> 
	</xsl:template>	
</xsl:stylesheet>
