<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Transaction_Body" match="Body">
		<MAIN>
			<TRANSRNO></TRANSRNO><!-- 交易流水号 -->
			<TRANSRDATE></TRANSRDATE><!-- 交易日期 -->
			<INSUID></INSUID><!-- 保险公司代码 -->
		 	<!--投保单号-->
		 	<APPLNO>
		 		<xsl:value-of select="ProposalPrtNo" />
		 	</APPLNO>
		 	<!--投保日期-->
		 	<ACCEPT_DATE>
		 		<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
		 	</ACCEPT_DATE>
		 	<!-- 投保申请交易流水号 -->
		 	<REQSRNO></REQSRNO>
		 	<!-- 保险单号  -->
		 	<POLICYNO><xsl:value-of select="ContNo" /></POLICYNO>
		 	<!-- 保单下载地址 -->
		 	<POLICYADDR></POLICYADDR>
		 </MAIN>
	
	</xsl:template>
 
</xsl:stylesheet>
