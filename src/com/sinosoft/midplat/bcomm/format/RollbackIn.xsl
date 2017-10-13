<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="RMBP/K_TrList" />
			<Body>
				<!-- ������ -->
				<ContNo><xsl:value-of select="RMBP/K_TrList/KR_Idx1" /></ContNo>
				<!-- Ͷ�����ţ�������ͨ��־���в�ѯ-->
				<ProposalPrtNo />
				<!-- ��֤�� -->
				<ContPrtNo />
				<!-- ԭ������ˮ�� -->
				<OldTranNo><xsl:value-of select="RMBP/K_QueryList/KR_SeqNo"/></OldTranNo>
				<!-- ԭ�������� -->
				<OldTranDate><xsl:value-of select="RMBP/K_QueryList/KR_TrDate"/></OldTranDate>
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
			<SourceType><xsl:apply-templates select="ChanNo" /></SourceType>
			<xsl:copy-of select="../Head/*" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<!-- ����������ϵӳ�� -->
	<xsl:template match="ChanNo">
		<xsl:choose>
			<xsl:when test=".='07'">1</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>	