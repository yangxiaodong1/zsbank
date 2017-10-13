<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="INSU">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- ������ -->
			<Body>
				<!-- ������ -->
				<ContNo></ContNo>
				<!-- Ͷ������ -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- ����ӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
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