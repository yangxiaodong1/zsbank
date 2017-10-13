<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="FEETRANSCANC">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- ������ -->
			<Body>
				<!-- ������ -->
				<ContNo>
					<xsl:value-of select="MAIN/POLICY" />
				</ContNo>
				<!-- Ͷ������ -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- ���� -->
				<Prem>
					<xsl:value-of select="MAIN/PREMIUM" />
				</Prem>
				<ContPrtNo></ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ����ͷ -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
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