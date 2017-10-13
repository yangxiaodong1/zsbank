<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="INSUAFFIRM">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- ������ -->
			<Body>
				<!-- ������ -->
				<ContNo><xsl:value-of select="MAIN/POLICYNO" /></ContNo>
				<!-- Ͷ������ -->
				<ProposalPrtNo><xsl:value-of select="MAIN/APPLNO" /></ProposalPrtNo>
				<!-- ����ӡˢ�� -->
				<ContPrtNo></ContPrtNo>
				<!-- ���㽻����ˮ�� -->
				<OldTranNo>
					<xsl:value-of select="MAIN/REQSRNO" />
				</OldTranNo>
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
			<TellerNo>sys</TellerNo>
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
			<SourceType>1</SourceType> <!-- 0=����ͨ���桢1=������8=�����ն� -->
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
</xsl:stylesheet>