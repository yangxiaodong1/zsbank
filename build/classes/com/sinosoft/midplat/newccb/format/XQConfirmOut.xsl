<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<!-- 保单号码 -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- 主险险种编号 -->
	<MainIns_Cvr_ID></MainIns_Cvr_ID>
	<!-- 代理保险套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- 保单犹豫期 -->
	<InsPolcy_HsitPrd></InsPolcy_HsitPrd>
	<!-- 保单生效日期 -->
	<InsPolcy_EfDt></InsPolcy_EfDt>
	<!-- 保单失效日期 -->
	<InsPolcy_ExpDt></InsPolcy_ExpDt>
	<!-- 保单领取日期 -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- 保费缴费方式代码 -->
	<InsPrem_PyF_MtdCd></InsPrem_PyF_MtdCd>
	<!-- 保险缴费金额 -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
</xsl:template>

</xsl:stylesheet>

