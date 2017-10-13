<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="//Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template match="Detail">
		<Detail>
			<CardType>1099</CardType>
			<!--��֤��ʼ����-->
			<StartNo>
				<xsl:value-of select="Column[4]" />
			</StartNo>
			<!-- ��֤��ֹ���� -->
			<EndNo>
				<xsl:value-of select="Column[5]" />
			</EndNo>
			<!--��֤״̬ -->
			<CardState>
				<xsl:call-template name="card_state">
					<xsl:with-param name="state">
						<xsl:value-of select="Column[6]" />
					</xsl:with-param>
				</xsl:call-template>
			</CardState>
		</Detail>
	</xsl:template>
	
	<!-- ��֤״̬ -->
    <xsl:template name="card_state">
        <xsl:param name="state"></xsl:param>  
        <xsl:choose>
            <xsl:when test=".=1">21</xsl:when><!-- ʹ�� -->
            <xsl:when test=".=2">42</xsl:when><!-- ���� -->
            <xsl:otherwise>12</xsl:otherwise><!-- δʹ�� -->
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
