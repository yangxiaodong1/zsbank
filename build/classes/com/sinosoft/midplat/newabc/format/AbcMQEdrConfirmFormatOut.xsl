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
				<xsl:variable name="appDate"><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PubContInfo/EdorAppDate, 'yyyy-MM-dd'),'yyyy年MM月dd日')" /></xsl:variable>
				<!-- 险种名称 -->
				<InsuName><xsl:apply-templates select="PubContInfo" /></InsuName>
				<!-- 保单号 -->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
				<!-- 拟领取金额 -->
				<OccurBala><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></OccurBala>
				<!-- 保全生效日 -->
				<BQValidDate><xsl:value-of select="PubContInfo/EdorValidDate" /></BQValidDate>
				<!-- 逐行打印行数,逐行打印行数n，目前支持n<=5 -->
				<PrntCount>5</PrntCount>
				<Prnt1>　　　满期金给付受理回执</Prnt1>
                <!-- <Prnt2>　　　保险单号：<xsl:value-of select="PubContInfo/ContNo" />    申请日期：<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PubContInfo/EdorAppDate, 'yyyy-MM-dd'),'yyyy/MM/dd')" /></Prnt2> -->
                <Prnt2>　　　经投保人<xsl:value-of select="PubContInfo/AppntName" />申请，自<xsl:value-of select="$appDate" />起<xsl:value-of select="PubContInfo/ContNo" />号保险合同效力终止。</Prnt2>
                <Prnt3>　　　此变更自<xsl:value-of select="$appDate" />起生效，退费将在五个工作日内到账，如您对产品或服务有建议，可拨打95569或通过官方微信</Prnt3>
                <Prnt4>　　　Anbanglife进行咨询。</Prnt4>
                <Prnt5>　　　经办：                    <xsl:value-of select="$appDate" /></Prnt5>
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

