<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/INSU">
		<TranData>
			<!-- 请求报文头 -->
			<xsl:apply-templates select="MAIN" />
			<Body>
				<!-- 保险单号 -->
				<ContNo>
					<xsl:value-of select="MAIN/POLICYNO" />
				</ContNo>
				<!-- 投保单(印刷)号 -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLYNO" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头内容转换 -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<TranDate>
				<xsl:value-of select="BANK_DATE" />
			</TranDate>
			<!-- 交易时间 （hhmmss）-->
			<TranTime>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/>
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
