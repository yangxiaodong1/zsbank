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
	
	<QueryFlag>1</QueryFlag>  <!-- 1传递所有当天状态变化的保单号数量, 2传递所有当天状态变化的保单信息 必填 -->
	<EdorCTDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Enqr_Dt)" /></EdorCTDate> <!-- 查询日期 必填 -->
	<BusinessTypes><!-- 查询保全类型 -->
		<BusinessType>CT</BusinessType><!-- 退保 目前建行支持 -->
		<BusinessType>WT</BusinessType><!-- 犹退 目前建行支持 -->
		<BusinessType>CA</BusinessType><!-- 犹退 目前建行支持 -->
	</BusinessTypes>
	
</xsl:template>

</xsl:stylesheet>
