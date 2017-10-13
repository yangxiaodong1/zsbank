<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">
		<xsl:output indent='yes' />
		
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<xsl:template match="Body">
		<App>
			<Ret>
				<!-- 险种名称 -->
				<InsuName><xsl:apply-templates select="PubContInfo" /></InsuName>
				<!-- 保单号 -->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
				<!-- 拟领取金额 -->
				<OccurBala><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></OccurBala>
				<!-- 保单生效日 -->
				<ValidDate><xsl:value-of select="PubContInfo/ContValidDate" /></ValidDate>
				<!-- 保单到期日 -->
				<ExpireDate><xsl:value-of select="PubContInfo/ContExpireDate" /></ExpireDate>
				<!-- 逐行打印行数,逐行打印行数n，目前支持n<=5 -->
				<PrntCount>0</PrntCount>
				<Prnt1></Prnt1>
				<Prnt2></Prnt2>
				<Prnt3></Prnt3>
				<Prnt4></Prnt4>
				<Prnt5></Prnt5>
			</Ret>
		</App>
	</xsl:template>
	
	
	<!-- 险种信息 -->
	<xsl:template name="PubContInfo" match="PubContInfo">
		<xsl:if test="ContPlanCode!=''">
			<xsl:value-of select="ContPlanName" />
		</xsl:if>
		<xsl:if test="ContPlanCode=''">
			<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName" />
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>

