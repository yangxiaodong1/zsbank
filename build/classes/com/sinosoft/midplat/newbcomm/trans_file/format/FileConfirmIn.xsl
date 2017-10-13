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
			<!-- 交易码 -->
		    <CTranscode><xsl:value-of select="../TrCode" /></CTranscode>
			<NodeNo>
				999999
			</NodeNo>
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		
		<!-- 压缩文件名 -->
		<CFileName><xsl:value-of select="FileName" /></CFileName>
		<!-- 创建方批次号 -->
		<CBatNo><xsl:value-of select="BatNo" /></CBatNo> 
	</xsl:template>	
</xsl:stylesheet>
