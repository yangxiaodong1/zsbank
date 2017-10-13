<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="TranData/BaseInfo" />
	
	<!--报文体信息-->
			<Body>
				<!-- 保单号码 -->
				<ContNo>
					<xsl:value-of select="TranData/LCCont/ContNo" />
				</ContNo>
				<!-- 投保单号 -->
				<ProposalPrtNo>
					
				</ProposalPrtNo>
				<!-- 保单印刷号码 -->
				<ContPrtNo />
				<OldLogNo><xsl:value-of select="TranData/LCCont/OriginalTranNo" /></OldLogNo>
			</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="BaseInfo">
<Head>
	<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(BankDate)"/></TranDate>
	<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
	<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
	<TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="TransrNo"/></TranNo>
	<NodeNo>
		<xsl:value-of select="ZoneNo"/>
		<xsl:value-of select="BrNo"/>
	</NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>
</xsl:stylesheet>
