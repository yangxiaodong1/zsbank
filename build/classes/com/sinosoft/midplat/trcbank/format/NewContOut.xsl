<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
<xsl:template match="/TranData">
		<TXLife>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<xsl:copy-of select="./*"/>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
		<!-- ���յ��� -->
		<ContNo>
		    <xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- Ͷ����(ӡˢ)�� -->
        <ProposalPrtNo>
           <xsl:value-of select="ContNo"/>
        </ProposalPrtNo>
        <!-- ����(��)������+�����ա� -->
        <Prem>
            <xsl:value-of select="Prem"/>
        </Prem>
		</Body>
	</xsl:template>
</xsl:stylesheet>
