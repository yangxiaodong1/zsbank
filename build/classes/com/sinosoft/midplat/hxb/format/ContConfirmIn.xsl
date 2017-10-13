<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/INSU">
		<TranData>
			<!-- ������ͷ -->
			<xsl:apply-templates select="MAIN" />
			<Body>
				<!-- ���յ��� -->
				<ContNo>
					<xsl:value-of select="MAIN/POLICYNO" />
				</ContNo>
				<!-- Ͷ����(ӡˢ)�� -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLYNO" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ����ת�� -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="BANK_DATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/>
			</TranTime>
			<!-- ��Ա-->
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<!-- ��ˮ��-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- ���б�ţ����Ķ��壩-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

</xsl:stylesheet>
