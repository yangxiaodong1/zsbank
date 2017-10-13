<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>

<PbSlipNumb><xsl:value-of select="ContPlan/ContPlanMult"/></PbSlipNumb><!-- 非标准报文产品组合份数返回值取标准报报文的产品组合节点下的份数，因risk节点下的份数不准确 -->
<PiStartDate><xsl:value-of select="$MainRisk/SignDate"/></PiStartDate><!-- 合同成立日期  -->
<PiValidate><xsl:value-of select="$MainRisk/CValiDate"/></PiValidate><!-- 合同生效日期  -->
<PiSsDate><xsl:value-of select="$MainRisk/CValiDate"/></PiSsDate><!-- 中信 生效日期 -->
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
<BkTotAmt></BkTotAmt>
<BkTxAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></BkTxAmt>
<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
<BkNum1><xsl:value-of select="0"/></BkNum1>
<!-- 
<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
 -->
 
<Appd_List>
<!-- 
<xsl:for-each select="Risk[RiskCode!=MainRiskCode]">
<Appd_Detail>
	<LiAppdInsuType>
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="RiskCode" />
	</xsl:call-template>
	</LiAppdInsuType>	
	<LiAppdInsuExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></LiAppdInsuExp>
</Appd_Detail>
</xsl:for-each>
-->
</Appd_List>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型） -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	
	<xsl:when test="$riskcode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢2号两全保险组合 -->
	<xsl:when test="$riskcode=122046">122046</xsl:when>	<!-- 安邦长寿稳赢1号两全保险 -->
	<xsl:when test="$riskcode=122047">122047</xsl:when>	<!-- 安邦附加长寿稳赢两全保险 -->
	<xsl:when test="$riskcode=122048">122048</xsl:when>	<!-- 安邦长寿添利终身寿险（万能型） -->
	
	<!-- add by duanjz 增加安邦长寿安享5号保险计划50012  begin -->
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- 安邦长寿稳赢2号两全保险组合 -->
	<xsl:when test="$riskcode=L12070">L12070</xsl:when>	<!-- 安邦长寿安享5号年金保险 -->
	<xsl:when test="$riskcode=L12071">L12071</xsl:when>	<!-- 安邦附加长寿添利5号两全保险（万能型） -->
	<!-- add by duanjz 增加安邦长寿安享5号保险计划50012  end -->
	
	<!-- add by duanjz 增加安邦长寿安享3号保险计划50011  begin -->
	<xsl:when test="$riskcode=50011">50011</xsl:when>	<!-- 安邦长寿安享3号保险计划 -->
	<xsl:when test="$riskcode=L12068">L12068</xsl:when>	<!-- 安邦长寿安享3号年金保险 -->
	<xsl:when test="$riskcode=L12069">L12069</xsl:when>	<!-- 安邦附加长寿添利3号两全保险（万能型） -->
	<!-- add by duanjz 增加安邦长寿安享3号保险计划50011  end -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

