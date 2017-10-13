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
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
<xsl:if test="ContPlan/ContPlanCode = ''">
    <PbInsuType>
	   <xsl:call-template name="tran_riskcode">
		  <xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
	   </xsl:call-template>
    </PbInsuType>
</xsl:if>
<xsl:if test="ContPlan/ContPlanCode != ''">
    <PbInsuType>
	   <xsl:call-template name="tran_contPlanCode">
		  <xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
	   </xsl:call-template>
    </PbInsuType>
</xsl:if>
	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>
<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- 中信并不取此处的现价和红利，直接置0 疑问点 -->
<LiBonusValueCount>0</LiBonusValueCount><!-- 中信并不取此处的现价和红利，直接置0 疑问点 -->
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></BkTotAmt>
<LiSureRate></LiSureRate>
<PbBrokId></PbBrokId>
<LiBrokName></LiBrokName>
<LiBrokGroupNo></LiBrokGroupNo>
<BkOthName></BkOthName>
<BkOthAddr></BkOthAddr>
<PiCpicZipcode></PiCpicZipcode>
<PiCpicTelno></PiCpicTelno>
<BkFileNum>0</BkFileNum>
<BkFileNum>0</BkFileNum>
</xsl:template>

<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 --><!-- 疑问点 中信银行的身份证的名字：公民身份证号码，军官证为：军人（武警）身份证件等等 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费间隔  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">一次交清</xsl:when>		
	<xsl:when test=".=1">月交</xsl:when>
	<xsl:when test=".=3">季交</xsl:when>
	<xsl:when test=".=6">半年交</xsl:when>
	<xsl:when test=".=12">年交</xsl:when>
	<xsl:when test=".=-1">不定期交</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">男  </xsl:when>		
	<xsl:when test=".=1">女  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<!-- 20160215 PBKINSR-1086 中信银行手机银行-L12080 盛世1号 begin -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->    
	<!-- 20160215 PBKINSR-1086 中信银行手机银行-L12080 盛世1号 end -->
	<!-- PBKINSR-1272 中信银行手机银行新产品－盛世3号 begin -->
	<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<!-- PBKINSR-1272 中信银行手机银行新产品－盛世3号 end  -->
	<!-- PBKINSR-1278 中信银行手机银行盛世3号-浙江中信专属产品 begin -->
	<xsl:when test="$riskcode='L12090'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<!-- PBKINSR-1278 中信银行手机银行盛世3号-浙江中信专属产品 end  -->
	<xsl:when test="$riskcode='L12098'">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） 中信济南分行专属产品-->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 产品组合编码 -->
<xsl:template name="tran_contPlanCode">
	<xsl:param name="contPlanCode"/>

	<xsl:choose>
		<!-- 安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
		<xsl:when test="$contPlanCode='50015'">50002</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>	
	</xsl:choose>
</xsl:template>

<!-- 红利领取  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">累计生息</xsl:when>
	<xsl:when test=".=2">领取现金</xsl:when>
	<xsl:when test=".=3">抵缴保费</xsl:when>
	<xsl:when test=".=5">增额交清</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
