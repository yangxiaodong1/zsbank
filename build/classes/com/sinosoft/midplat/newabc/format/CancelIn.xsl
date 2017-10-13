<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Header" />

			<!-- ������ -->
			<xsl:apply-templates select="App/Req" />

		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template match="Header">
		<!--������Ϣ-->
		<Head>
			<!-- ���н������� -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- ����ʱ�� ũ�в�������ʱ�� ȡϵͳ��ǰʱ�� -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:if test="Tlid =''">sys</xsl:if>
			    <xsl:if test="Tlid !=''"><xsl:value-of select="Tlid" /></xsl:if>
			</TellerNo>
			<!-- ���н�����ˮ�� -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- ������+������ -->
			<NodeNo>
				<xsl:value-of select="ProvCode" />
				<xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>
				<xsl:apply-templates select="EntrustWay" />
			</SourceType>
			<!-- YBT��֯�Ľڵ���Ϣ -->
			<xsl:copy-of select="../Head/*" />
			</Head>
	</xsl:template>

	<!--��������Ϣ-->
	<xsl:template match="App/Req">
		<Body>
			<!-- ���յ��� -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ProposalPrtNo></ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo></ContPrtNo>
		</Body>
	</xsl:template>
	
	<!-- ���б�����������: 0=���棬1=����-->
	<xsl:template match="EntrustWay">
		<xsl:choose>
			<xsl:when test=".='11'">0</xsl:when><!--	����ͨ���� -->
			<xsl:when test=".='01'">1</xsl:when><!--	���� -->
			<xsl:when test=".='04'">1</xsl:when><!--	�����ն� -->
			<xsl:when test=".='02'">17</xsl:when><!--   �ֻ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>
