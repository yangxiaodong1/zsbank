<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
    <xsl:template match="/TranData"><!-- 匹配数据转换 -->
		<TranData>
			<xsl:apply-templates select="Head"/><!-- 标识head -->
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head"> <!-- 和head匹配 -->
		<Head>
			<!-- 0表示成功，1表示失败 -->
			<Flag>
				<xsl:value-of select="Flag" /> <!-- 匹配flag的值 -->
			</Flag>
			<!-- 失败时，返回错误信息 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body"> <!-- 应答的包体内容 -->
		<Body>
			<!-- 保单主信息 -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- 保险单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- 投保单(印刷)号 -->
			<Prem>
				<xsl:value-of select="ActSumPrem"/>
			</Prem>
			<!-- 总保费 -->
		</Body>
	</xsl:template>

</xsl:stylesheet>