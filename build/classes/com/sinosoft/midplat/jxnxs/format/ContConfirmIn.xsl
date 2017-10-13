<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUAFFIRM">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="MAIN/TRANSRTIME"/></TranTime>
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
				<xsl:value-of select="APPLNO" />
			</ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo>
				<xsl:value-of select="BD_PRINT_NO" />
			</ContPrtNo>
			<!-- ǩ��������ˮ�� -->
			<OrigTranNo>
				<xsl:value-of select="REQSRNO" />
			</OrigTranNo>
			<ContNo></ContNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>