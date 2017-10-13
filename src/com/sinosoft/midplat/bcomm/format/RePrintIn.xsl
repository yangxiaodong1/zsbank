<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="RMBP/K_TrList"/>
		
			<Body>
				<!-- ������ -->
				<ContNo><xsl:value-of select="RMBP/K_TrList/KR_Idx1" /></ContNo>
				<!-- Ͷ�����ţ�������ͨ��־���в�ѯ-->
				<ProposalPrtNo />
				<!-- �±�����ͬӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="RMBP/K_Invoice/InvInfo[K_Type=100]/K_NewInvCode" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>
	
	
	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="K_TrList">
		<Head>
			<TranDate>
				<xsl:value-of select="KR_TrDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="KR_TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="KR_TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="KR_SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="KR_AreaNo"/><xsl:value-of select="KR_BankNo"/>
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
</xsl:stylesheet>	