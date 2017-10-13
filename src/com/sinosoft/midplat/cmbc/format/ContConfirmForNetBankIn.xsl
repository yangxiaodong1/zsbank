<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(MAIN/TRANSRTIME)"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<!-- ����� -->
				<NodeNo>
					<xsl:value-of select="MAIN/BRNO1"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
				<!-- �������� -->
				<SourceType><xsl:apply-templates select="MAIN/CHNL_CODE" /></SourceType>
			</Head>
			
			<!-- ������ -->
			<xsl:apply-templates select="MAIN" />
		</TranData>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Body" match="MAIN">
		<Body>
			<!-- Ͷ������ -->
			<ProposalPrtNo></ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo><xsl:value-of select="PRINT_NO" /></ContPrtNo>
			<ContNo><xsl:value-of select="APPNO" /></ContNo>
		</Body>
	</xsl:template>
	
	
	<!-- ����������ϵӳ�� -->
	<xsl:template match="CHNL_CODE">
		<xsl:choose>
			<xsl:when test=".='1101'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1103'">17</xsl:when><!-- �ֻ����� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>