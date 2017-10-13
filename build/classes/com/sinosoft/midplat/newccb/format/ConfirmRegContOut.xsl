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

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<xsl:if test="ContPlan/ContPlanCode = ''">
	   <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- 险种名称 -->
	   <Cvr_Nm><xsl:value-of select="$MainRisk/RiskName" /></Cvr_Nm>
    </xsl:if>
    <xsl:if test="ContPlan/ContPlanCode != ''">
       <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="ContPlan/ContPlanCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- 险种名称 -->
	   <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>    
    </xsl:if>
	<!-- 代理套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- 套餐名称 -->
	<Pkg_Nm></Pkg_Nm>
	
</xsl:template>


<!-- 险种转换 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 end -->
		<!-- add 20151229 PBKINSR-1004 建行网银上线盛1 begin -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型） -->	
		<!-- add 20151229 PBKINSR-1004 建行网银上线盛1 end -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>