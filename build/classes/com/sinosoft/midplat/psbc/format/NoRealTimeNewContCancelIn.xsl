<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/FEETRANSCANC">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />

			<!-- ������ -->
			<Body>
			   <ProposalPrtNo></ProposalPrtNo><!-- Ͷ����(ӡˢ)�� -->
		   </Body>

		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

</xsl:stylesheet>