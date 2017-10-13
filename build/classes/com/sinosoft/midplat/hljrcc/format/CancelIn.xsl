<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="TranData/Head" />
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<xsl:copy-of select="TranDate" />
			<!-- ����ʱ�䣨hhmmss��-->
			<xsl:copy-of select="TranTime" />
			<!-- ��Ա���� -->
			<xsl:copy-of select="TellerNo" />
			<!-- ������ˮ�� -->
			<xsl:copy-of select="TranNo" />
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<!-- ����ͨ������-->
			<xsl:copy-of select="FuncFlag" />
			<!-- ��������-->
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>			
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Body">
		<!-- ������ -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- Ͷ������ -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- ����ӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
	</xsl:template>

</xsl:stylesheet>
