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

	<xsl:variable name="tContPlanCode">
		<xsl:value-of select="ContPlan/ContPlanCode" />
	</xsl:variable>
	
	<xsl:variable name="tMainRiskCode">
		<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode" />
	</xsl:variable>
	
	<!-- 建行代理标志:1=建行渠道出的保单，0=非建行出的保单 -->
	<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
	<!-- 一级分行号 -->
	<Lv1_Br_No><xsl:value-of select="SubBankCode" /></Lv1_Br_No>
	<!-- 代理保险缴费业务细分代码 -->
	<AgInsPyFBsnSbdvsn_Cd>
		<xsl:call-template name="tran_AgentPayType">
			<xsl:with-param name="agentPayType" select="AgentPayType" />
		</xsl:call-template>
	</AgInsPyFBsnSbdvsn_Cd>
	<!--modify 20150820 投保单号 新一代2.2版本需求要返回投保单号
	<Ins_BillNo></Ins_BillNo>
	-->
	<Ins_BillNo></Ins_BillNo>
	<!--add 20150820 新一代2.2版本增加套餐名称 -->
	<Pkg_Nm></Pkg_Nm>
	<!-- 非组合产品 -->					
	<xsl:if test="$tContPlanCode = ''">
		<Cvr_ID>
			<xsl:call-template name="tran_Riskcode">
				<xsl:with-param name="riskcode" select="$tMainRiskCode" />
			</xsl:call-template>
		</Cvr_ID>
	    <!--add 20150820 新一代2.2版本增加险种名称 -->
	    <Cvr_Nm><xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName" /></Cvr_Nm>
	</xsl:if>
	<!-- 组合产品 -->
	<xsl:if test="$tContPlanCode != ''">
		<Cvr_ID>
			<xsl:call-template name="tran_ContPlanCode">
				<xsl:with-param name="contPlanCode" select="$tContPlanCode" />
			</xsl:call-template>
		</Cvr_ID>
		<!--add 20150820 新一代2.2版本增加险种名称 -->
	    <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>
	</xsl:if>
	
	<!-- 套餐编码 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!--modify 20150820 保单号码 新一代2.2版本需求要返回保单号
	<InsPolcy_No></InsPolcy_No>
	--> 
	<InsPolcy_No></InsPolcy_No>	
	<!-- 投保人名称 -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- 续期应缴日期 -->
	<Rnew_Pbl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Risk[RiskCode=MainRiskCode]/StartPayDate)" /></Rnew_Pbl_Dt>
	<!-- 保险缴费金额 -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- 续期应缴期数 -->
	<Rnew_Pbl_Prd_Num><xsl:value-of select="(Risk[RiskCode=MainRiskCode]/PayTotalCount)-(Risk[RiskCode=MainRiskCode]/PayCount) " /></Rnew_Pbl_Prd_Num>
				
</xsl:template>


<!-- 代理保险缴费业务细分代码 01-实时投保缴费 02-非实时投保缴费 03-续期交费 -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- 实时投保缴费 -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- 非实时投保缴费 -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- 续期交费 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

		
<!-- 险种代码 -->
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
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  end -->
		<!-- 险种代码并存 -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型）-->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<xsl:when test="$contPlanCode=50012">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  end -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>

