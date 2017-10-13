<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- 投保单号 -->
	<ProposalPrtNo></ProposalPrtNo>
	<!-- 保单号 寿险保单号标签：ContNo。保单印刷号（单证号）：ContPrtNo-->
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo>
	<!-- 单证号 -->
	<!-- 代理保险凭证类型代码:AgIns_Vchr_TpCd 1=保单，2=现金价值单，3=批单，4=发票，5=代理凭证，6=投保单，7=客户权益保障确认书 -->
	<ContPrtNo><xsl:value-of select="Detail_List/Detail[AgIns_Vchr_TpCd='1']/Mod_Af_Ins_IBVoch_ID" /></ContPrtNo>
	
	<!-- 新单确认交易的保险公司方流水号 -->
	<OldLogNo><xsl:value-of select="Ins_Co_Jrnl_No"/></OldLogNo>
	
</xsl:template>

</xsl:stylesheet>
