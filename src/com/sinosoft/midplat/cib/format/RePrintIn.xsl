<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/RP_PRINT">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/BANK_DATE"/></TranDate>
				<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
			</Head>
			<!-- ������ -->
			<xsl:apply-templates select="MAIN" />
		</TranData>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Body" match="MAIN">
		<Body>
			<!-- Ͷ������ -->
			<ProposalPrtNo>
				<xsl:value-of select="APPLYNO" />
			</ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo>
				<xsl:value-of select="BD_PRINT_NO" />
			</ContPrtNo>
			<!-- ������ -->
			<ContNo>
				<xsl:value-of select="POLICY" />
			</ContNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>
