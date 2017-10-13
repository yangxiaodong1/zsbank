<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
		    <TranDate><xsl:value-of select="TranDate"/></TranDate><!-- 交易日期[yyyyMMdd] -->
            <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TranTime)" /></TranTime><!-- 交易时间[hhmmss] -->            <TranCom outcode="08"><xsl:value-of select="TranCom"/></TranCom><!-- 交易单位(银行/农信社/经代公司) -->            
            <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="NodeNo"/></NodeNo><!-- 地区代码 +银行网点 -->
            <TellerNo><xsl:value-of select="TellerNo"/></TellerNo><!-- 柜员代码 -->
            <TranNo><xsl:value-of select="TranNo"/></TranNo><!-- 交易流水号 -->
            <FuncFlag><xsl:value-of select="FuncFlag"/></FuncFlag><!-- 交易类型 -->
			<BankCode><xsl:value-of select="TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- 保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- 投保单(印刷)号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- 保单合同印刷号 -->
		</Body>
	</xsl:template>
</xsl:stylesheet>
