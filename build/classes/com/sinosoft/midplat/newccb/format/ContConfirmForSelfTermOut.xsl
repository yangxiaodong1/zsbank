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
	<MainIns_Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</MainIns_Cvr_ID>
	<Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</Cvr_ID>
	<!-- 代理保险套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- 保单失效日期 -->
	<InsPolcy_ExpDt><xsl:value-of select="$MainRisk/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- 保单领取日期 -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- 保单号码 -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- 保险缴费金额 -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- 投保人电子邮件地址 -->
	<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
	<!-- 保单投保日期 -->
	<InsPolcy_Ins_Dt><xsl:value-of select="$MainRisk/PolApplyDate" /></InsPolcy_Ins_Dt>
	<!-- 保单生效日期 -->
	<InsPolcy_EfDt><xsl:value-of select="$MainRisk/CValiDate" /></InsPolcy_EfDt>
	<!-- 代理保险期缴代扣账号 -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo" /></AgInsRgAutoDdcn_AccNo>
	<!-- 每期缴费金额信息 -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- 保费缴费方式代码 -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- 保费缴费期数 -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="($MainRisk/PayTotalCount)-($MainRisk/PayCount)"/></InsPrem_PyF_Prd_Num>
	<!-- 保费缴费周期代码 -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
	<!-- 
	<InsPrem_PyF_Cyc_Cd>
		<xsl:choose>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear='106'" >99</xsl:when>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear!='106'" >98</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$MainRisk/PayIntv" />
			</xsl:otherwise>
		</xsl:choose>
	</InsPrem_PyF_Cyc_Cd>
	-->
	<!-- 保单犹豫期 -->
	<InsPolcy_HsitPrd><xsl:value-of select="$MainRisk/HsitPrd" /></InsPolcy_HsitPrd>
	<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
	<Ret_File_Num>0</Ret_File_Num>
	<!-- <Detail_List></Detail_List> -->
</xsl:template>


<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- 险种转换 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>

		<!-- <xsl:when test="$riskcode='122046'">50002</xsl:when> -->	<!-- 长寿稳赢保险套餐 -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）A -->
				
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 缴费类型 -->
<!-- FIXME 需要和核心，业务确认，银行缴费频次：01=不定期、02=一次、03=按周期、04=至某特定年龄、05=终身 -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	趸交 -->
		<xsl:when test=".='12'">03</xsl:when><!-- 年交 -->
		<xsl:when test=".='1'">03</xsl:when><!--	月交 -->
		<xsl:when test=".='3'">03</xsl:when><!--	季交 -->
		<xsl:when test=".='6'">03</xsl:when><!--	半年交 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- 不定期交 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	季缴 -->
		<xsl:when test=".='6'">0202</xsl:when><!--	半年缴 -->
		<xsl:when test=".='12'">0203</xsl:when><!--	年缴 -->
		<xsl:when test=".='1'">0204</xsl:when><!--	月缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

