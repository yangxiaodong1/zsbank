<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Body/Insured/Sex"/>
	
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:copy-of select="Head" />
			
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
			
		</RETURN>
	</xsl:template>

	<xsl:template name="TRAN_BODY" match="Body">
			<xsl:variable name ="MainRisk" select ="Risk[RiskCode=MainRiskCode]"/>
			<MAIN>
				<!-- 投保单号 -->
				<APPLNO><xsl:value-of select="ProposalPrtNo" /></APPLNO>
				<!-- 保险单号 -->
				<POLICY_NO><xsl:value-of select="ContNo" /></POLICY_NO>
				<!-- 投保日期 -->
				<TB_DATE><xsl:value-of select="$MainRisk/PolApplyDate" /></TB_DATE>
				<!-- 总保费 -->
				<TOT_PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TOT_PREM>
				<!-- 首期保费 -->
				<INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></INIT_PREM_AMT>
				<!-- 首期保费, 大写 -->
				<INIT_PREM_TXT><xsl:value-of select="ActSumPremText" /></INIT_PREM_TXT>
				<!-- 生效日期 -->
				<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
				<!-- 保险终止日期 -->
				<CONTENDDATE><xsl:value-of select="$MainRisk/InsuEndDate" /></CONTENDDATE>
				<!-- 银行账户 -->
				<BANKACC><xsl:value-of select="AccNo" /></BANKACC>
				<!-- 缴费方式 -->
				<PAYMETHOD><xsl:apply-templates select="$MainRisk/PayIntv" /></PAYMETHOD>
				<!-- 缴费方式(汉字) -->
				<PAY_METHOD></PAY_METHOD>
				<!-- 缴费日期 -->
				<PAYDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></PAYDATE>
				<!-- 承保公司 -->
				<ORGAN><xsl:value-of select="ComName" /></ORGAN>
				<!-- 公司地址 -->
				<LOC><xsl:value-of select="ComLocation" /></LOC>
				<!-- 公司电话 -->
				<TEL>95569</TEL>
				<!-- 代理机构编码 -->
				<BRNO></BRNO>
				<!-- 专管员姓名 -->
				<AGENT_PSN_NAME></AGENT_PSN_NAME>
			</MAIN>
			
			<!-- 险种信息 -->
			<PRODUCTS>
				<!-- 险种数量 -->
				<RiskCount><xsl:value-of select="count(Risk)" /></RiskCount>
				<xsl:for-each select="Risk">
					<PRODUCT>
						<POLICY_NO><xsl:value-of select="../ContNo" /></POLICY_NO>
						<AMT_UNIT><xsl:value-of select="Mult" /></AMT_UNIT>
						<!-- 0:主险  1:附加险 -->
						<MAIN_SUB_FLG>
							<xsl:if test="RiskCode=MainRiskCode">0</xsl:if>
							<xsl:if test="RiskCode!=MainRiskCode">1</xsl:if>
						</MAIN_SUB_FLG>
						
						<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></AMT>
						<PREMIUM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></PREMIUM>
						<AMOUNT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></AMOUNT>
						<PRODUCTID>
							<xsl:call-template name="tran_risk">
								<xsl:with-param name="riskcode" select="RiskCode" />
							</xsl:call-template>
						</PRODUCTID>
						<NAME><xsl:value-of select="RiskName" /></NAME>
						
						<COVERAGE_PERIOD></COVERAGE_PERIOD>
						<INSU_DUR><xsl:value-of select="InsuYear" /></INSU_DUR>
						
						<xsl:choose>
							<xsl:when test="PayIntv='0'" >
								<!-- 趸交 -->
								<PAY_TYPE>1</PAY_TYPE>
							</xsl:when>
							<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'" >
								<PAY_TYPE>6</PAY_TYPE>
								<!-- FIXME 终身缴费是该字段的值是什么 -->
							</xsl:when>
							<xsl:otherwise>
								<PAY_TYPE><xsl:apply-templates select="PayEndYearFlag" /></PAY_TYPE>
							</xsl:otherwise>
						</xsl:choose>
						<PAY_YEAR><xsl:value-of select="PayEndYear" /></PAY_YEAR>
						
						<DRAW_FST></DRAW_FST>
						<DRAW_LST></DRAW_LST>						
					</PRODUCT>
				</xsl:for-each>
			</PRODUCTS>
			
	</xsl:template>
	

	<!-- 险种代码 -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）产品 -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test="$riskcode='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费频次 -->
	<!-- <xsl:template match="PayIntv"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='12'">1</xsl:when> --><!-- 年缴 -->
	<!-- 		<xsl:when test=".='6'">2</xsl:when> --><!-- 半年交 -->
	<!-- 		<xsl:when test=".='3'">3</xsl:when> --><!-- 季交-->
	<!-- 		<xsl:when test=".='1'">4</xsl:when> --><!-- 月交 -->
	<!-- 		<xsl:when test=".='0'">6</xsl:when> --><!-- 趸交 -->
	<!-- 		<xsl:when test=".='-1'">0</xsl:when> --><!-- 不定期缴 -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">2</xsl:when><!-- 年缴 -->
			<xsl:when test=".='6'">3</xsl:when><!-- 半年交 -->
			<xsl:when test=".='3'">4</xsl:when><!-- 季交-->
			<xsl:when test=".='1'">5</xsl:when><!-- 月交 -->
			<xsl:when test=".='0'">1</xsl:when><!-- 趸交 -->
			<xsl:when test=".='-1'">6</xsl:when><!-- 不定期缴 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期年龄标志 -->
	<!-- 银行：3	缴至确定年龄,4 终生缴费,7 月,8 日,9 年,10 趸缴 -->
	<!-- <xsl:template match="PayEndYearFlag"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='Y'">9</xsl:when> --><!-- 按年限缴 -->
	<!-- 		<xsl:when test=".='M'">7</xsl:when> --><!-- 按月限缴 -->
			<!-- <xsl:when test=".='Y'">10</xsl:when> 趸缴 -->
	<!-- 		<xsl:when test=".='A'">3</xsl:when> --><!-- 缴至某确定年龄 -->
			<!-- <xsl:when test=".='A'">4</xsl:when> 终生缴费 -->
	<!-- 		<xsl:when test=".='D'">8</xsl:when> --><!-- 日缴费 -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- 银行：0	缴至确定年龄,6 终生缴费,5 月,8 日,2 年,1 趸缴 -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".='M'">5</xsl:when><!-- 按月限缴 -->
			<!-- <xsl:when test=".='Y'">1</xsl:when> 趸缴 -->
			<xsl:when test=".='A'">0</xsl:when><!-- 缴至某确定年龄 -->
			<!-- <xsl:when test=".='A'">6</xsl:when> 终生缴费 -->
			<xsl:when test=".='D'">8</xsl:when><!-- 日缴费 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>


