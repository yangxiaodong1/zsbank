<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
    <xsl:template match="/TranData"><!-- ƥ������ת�� -->
		<TranData>
			<xsl:apply-templates select="Head"/><!-- ��ʶhead -->
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head"> <!-- ��headƥ�� -->
		<Head>
			<!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Flag>
				<xsl:value-of select="Flag" /> <!-- ƥ��flag��ֵ -->
			</Flag>
			<!-- ʧ��ʱ�����ش�����Ϣ -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body"> <!-- Ӧ��İ������� -->
		<Body>
			<!-- ��������Ϣ -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- ���յ��� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<Prem>
				<xsl:value-of select="ActSumPrem"/>
			</Prem>
			<!-- �ܱ��� -->
		</Body>
	</xsl:template>

</xsl:stylesheet>