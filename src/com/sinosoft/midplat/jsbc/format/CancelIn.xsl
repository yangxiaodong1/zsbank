<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="FEETRANSCANC">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- 报文体 -->
			<Body>
				<!-- 保单号 -->
				<ContNo>
					<xsl:value-of select="MAIN/POLICY" />
				</ContNo>
				<!-- 投保单号 -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- 保费 -->
				<Prem>
					<xsl:value-of select="MAIN/PREMIUM" />
				</Prem>
				<ContPrtNo></ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 报文头 -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- 交易时间 （hhmmss）-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- 柜员-->
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<!-- 流水号-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- 地区码+网点码-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- 银行编号（核心定义）-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
</xsl:stylesheet>