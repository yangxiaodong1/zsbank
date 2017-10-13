<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

	<TranData>
		<xsl:apply-templates select="TranData/Head" />
		<xsl:apply-templates select="TranData/Body" /> 												
	</TranData>

</xsl:template>

<!-- 报文头 -->
	<xsl:template name="Head" match="Head">
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
			<TellerNo>sys</TellerNo>
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
			<SourceType>1</SourceType><!-- 0=银保通柜面、1=网银、8=自助终端 -->
			<xsl:copy-of select="../Head/*" />
		</Head>
</xsl:template>	

<xsl:template name="Body" match="Body" >	
	<Body>
		<!-- 保险单号码 -->
		<ContNo><xsl:value-of select="ContNo" /></ContNo>
		<!-- 保全申请日期 (yyyy-mm-dd)-->
		<EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(EdorAppDate)" /></EdorAppDate>
		<!-- 保全申请号 -->
		<EdorAppNo />
		<!-- 业务金额（元） -->
		<TranMoney><xsl:value-of select="LoanMoney" /></TranMoney>
		<!-- 业务类型: CT=退保，WT=犹退，CA=修改客户信息，MQ=满期，XQ=续期, PN=提款 -->
		<EdorType>PJ</EdorType>
	</Body>
</xsl:template>
	
</xsl:stylesheet>
