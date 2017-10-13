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
			<!--单证起始号码-->
			<StartNo>
				<xsl:value-of select="Column[4]" />
			</StartNo>
			<!-- 单证终止号码 -->
			<EndNo>
				<xsl:value-of select="Column[5]" />
			</EndNo>
			<!--单证状态 -->
			<CardState>
				<xsl:call-template name="card_state">
					<xsl:with-param name="state">
						<xsl:value-of select="Column[6]" />
					</xsl:with-param>
				</xsl:call-template>
			</CardState>
		</Detail>
	</xsl:template>
	
	<!-- 单证状态 -->
    <xsl:template name="card_state">
        <xsl:param name="state"></xsl:param>  
        <xsl:choose>
            <xsl:when test=".=1">21</xsl:when><!-- 使用 -->
            <xsl:when test=".=2">42</xsl:when><!-- 作废 -->
            <xsl:otherwise>12</xsl:otherwise><!-- 未使用 -->
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
