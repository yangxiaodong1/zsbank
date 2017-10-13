<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
			</Head>
			<Body>
			    <Count><xsl:value-of select="Body/Count" /></Count>
                <Prem><xsl:value-of select="Body/Prem" /></Prem>
			    <xsl:apply-templates select="(//Body/Detail[FuncFlag='580001'])"/>
		   </Body>
		</TranData>
	</xsl:template>
    <xsl:template name="Body" match="Detail">
	    <Detail>
		   <TranDate><xsl:value-of select="TranDate" /></TranDate>
           <NodeNo><xsl:value-of select="NodeNo" /></NodeNo>
           <TranNo><xsl:value-of select="TranNo" /></TranNo>
           <ContNo><xsl:value-of select="ContNo" /></ContNo>
           <Prem><xsl:value-of select="Prem" /></Prem>
	    </Detail>
    </xsl:template>
    <!-- 交易渠道 -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 柜面 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 网银 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>