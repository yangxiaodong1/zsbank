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
	<xsl:variable name="tMainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<!-- 代理保险套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>

	<!-- 非组合产品 -->					
	<xsl:if test="$tContPlanCode = ''">
	<!-- 险种个数,建行端以非套餐形式出单，才统计险种个数，有附加险时才填充险种个数 -->
	<Cvr_Num><xsl:value-of select="count(Risk)"/></Cvr_Num>
	<Bu_List>
		<xsl:for-each select="Risk">
			<Bu_Detail>
				<!-- 险种编号 -->
				<Cvr_ID>
					<xsl:call-template name="tran_Riskcode">
						<xsl:with-param name="riskcode" select="RiskCode" />
					</xsl:call-template>
				</Cvr_ID>
				<!-- 主附险标志 FIXME 确定该标签填写值-->
				<MainAndAdlIns_Ind>1</MainAndAdlIns_Ind>
				<InsPrem_Amt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				</InsPrem_Amt>
			</Bu_Detail>
		</xsl:for-each>
	</Bu_List>
	</xsl:if>
	<!-- 组合产品 -->
	<xsl:if test="$tContPlanCode != ''">
	<!-- 险种个数,建行端以非套餐形式出单，才统计险种个数，有附加险时才填充险种个数 -->
	<Cvr_Num>1</Cvr_Num>
	<Bu_List>
		<Bu_Detail>
			<Cvr_ID>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode" select="$tContPlanCode" />
				</xsl:call-template>
			</Cvr_ID>
			<!-- 主附险标志 FIXME 确定该标签填写值-->
			<MainAndAdlIns_Ind>1</MainAndAdlIns_Ind>
			<InsPrem_Amt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
			</InsPrem_Amt>
		</Bu_Detail>
	</Bu_List>
	</xsl:if>
	<!-- 投保单号 -->
	<Ins_BillNo>
		<xsl:value-of select="ProposalPrtNo" />
	</Ins_BillNo>
	<!-- 总保费金额 -->
	<Tot_InsPrem_Amt>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	</Tot_InsPrem_Amt>
	<!-- 首期缴费金额 -->
	<Init_PyF_Amt>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	</Init_PyF_Amt>
	<!-- 投保保额 -->
	<Ins_Cvr><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></Ins_Cvr>
	<!-- 保险公司派驻人员姓名 -->
	<Ins_Co_Acrdt_Stff_Nm></Ins_Co_Acrdt_Stff_Nm>
	<!-- 保险公司派驻人员从业资格证书编号 -->
	<InsCoAcrStCrQuaCtf_ID></InsCoAcrStCrQuaCtf_ID>
	<!-- 保费缴费方式代码 -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$tMainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- 代理保险期缴代扣账号 -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo"/></AgInsRgAutoDdcn_AccNo>
	<!-- 每期缴费金额信息 -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- 保费缴费期数,FIXME 这个地方以主险信息为准，需要和核心确认 -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="($tMainRisk/PayTotalCount)-($tMainRisk/PayCount)"/></InsPrem_PyF_Prd_Num>
	<!-- 保费缴费周期代码 -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$tMainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
</xsl:template>
		
<!-- 险种代码 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>		
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<!-- add 20151229 PBKINSR-1004 建行网银上线盛1 begin -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）B -->
		<!-- add 20151229 PBKINSR-1004 建行网银上线盛1 end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
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
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

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

