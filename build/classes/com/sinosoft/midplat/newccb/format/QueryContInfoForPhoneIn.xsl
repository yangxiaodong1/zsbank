<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
			<SourceType>
				<xsl:apply-templates select="TX/TX_BODY/ENTITY/COM_ENTITY/TXN_ITT_CHNL_CGY_CODE" />
			</SourceType>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- 投保单号 -->
	<ProposalPrtNo><xsl:value-of select="Ins_BillNo" /></ProposalPrtNo>
	<!-- 保单号 寿险保单号标签：ContNo。保单印刷号（单证号）：ContPrtNo-->
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo>
	<EdorType />
	
</xsl:template>
<!-- 银行保单销售渠道: 10010003=企业网银，10010001=个人网银，10010002=私人银行网上银行 10030006：手机银行-->
	<xsl:template match="TXN_ITT_CHNL_CGY_CODE">
		<xsl:choose>
			<xsl:when test=".='10010003'">1</xsl:when><!-- 企业网银:网银 -->
			<xsl:when test=".='10010001'">1</xsl:when><!-- 个人网银:网银 -->
			<xsl:when test=".='10010002'">1</xsl:when><!-- 私人银行网上银行:网银 -->
			<xsl:when test=".='10030006'">17</xsl:when><!-- 手机银行 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
