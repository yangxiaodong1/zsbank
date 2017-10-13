<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<Rsp>
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>

	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 ，3转非实时-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>

	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
			<PrdList>				
				<Count>1</Count>
				<PrdItem>
					<!-- 险种代码 -->
					<PrdId>
					<xsl:choose>
						<xsl:when test="ContPlan/ContPlanCode !=''">
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="ContPlan/ContPlanCode" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="$MainRisk/RiskCode" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>	
					</PrdId>				
					<!-- 是否为主险 -->
					<IsMain>1</IsMain>
					<!-- 险种类型（如何给值？） -->
					<PrdType></PrdType>
					<!-- 风险等级 1.7已经去掉
					<RiskLevel></RiskLevel>  -->
					<!-- 投保份数 -->
					<xsl:choose>
						<xsl:when test="ContPlan/ContPlanMult=''">
							<Units><xsl:value-of select="$MainRisk/Mult" /></Units>
						</xsl:when>
						<xsl:otherwise>
							<Units><xsl:value-of select="ContPlan/ContPlanMult" /></Units>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- 首期缴费金额 -->
					<InitAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></InitAmt>
					<!-- 每期缴费金额 -->
					<TermAmt></TermAmt>
					<!-- 续期总期数 -->
					<TermNum></TermNum>
					<!-- 缴费金额 -->
					<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
					<!-- 缴费期数 -->
					<PayNum></PayNum>
					<!-- 已缴保费 -->
					<PaidAmt></PaidAmt>
					<!-- 已缴期数 -->
					<PaidNum></PaidNum>
					<!-- 总保费 -->
					<PremAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PremAmt>
					<!-- 总保额 -->
					<CovAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></CovAmt>
					<!-- 缴费方式 趸缴-->
					<PremType><xsl:apply-templates select="$MainRisk/PayIntv" /></PremType>
					<!-- 缴费年期类型 趸缴 -->
					<xsl:choose>
						<xsl:when test="$MainRisk/PayEndYearFlag='Y' and $MainRisk/PayEndYear=1000">
							<PremTermType>01</PremTermType>
							<!-- 缴费年期 -->
							<PremTerm>0</PremTerm>
						</xsl:when>
						<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear=106">
							<PremTermType>04</PremTermType>
							<!-- 缴费年期 -->
							<PremTerm>99</PremTerm>
						</xsl:when>
						<xsl:otherwise>
							<PremTermType><xsl:apply-templates select="$MainRisk/PayEndYearFlag" /></PremTermType>
							<!-- 缴费年期 -->
							<PremTerm><xsl:value-of select="$MainRisk/PayEndYear" /></PremTerm>
						</xsl:otherwise>
					</xsl:choose>
					
					
					<!-- 保险年期类型 按年限保 -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
							<CovTermType>01</CovTermType>
						</xsl:when>
						<xsl:otherwise>
							<CovTermType><xsl:apply-templates select="$MainRisk/InsuYearFlag" /></CovTermType>
						</xsl:otherwise>
					</xsl:choose>
					<!-- 保险年期 -->
					<CovTerm><xsl:value-of select="$MainRisk/InsuYear" /></CovTerm>					
					<!-- 领取年期类型 一次性领取02 -->
					<DrawTermType></DrawTermType>
					<!-- 领取年期 -->
					<DrawTerm></DrawTerm>
					<!-- 领取起始年龄 -->
					<DrawStartAge></DrawStartAge>
					<!-- 领取终止年龄 -->
					<DrawEndAge></DrawEndAge>
					<!-- 生效日期 -->
					<ValiDate><xsl:value-of select="$MainRisk/CValiDate" /></ValiDate>
					<!-- 终止日期:若为终身，则填写99991231 -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
							<InvaliDate>99991231</InvaliDate>
						</xsl:when>
						<xsl:otherwise>
							<InvaliDate><xsl:value-of select="$MainRisk/InsuEndDate" /></InvaliDate>
						</xsl:otherwise>
					</xsl:choose>					
					<!-- 万能险特有项 -->
					<OmnPrdItem />
					<!-- 投连险特有项 -->
					<InvPrdItem />
					<!-- 财产险特有项 -->
					<PropPrdItem />
					<!-- 借意险特有项 -->
					<SudPrdItem />
					<!-- 险种共有扩展项 -->
					<ExtItem />
				</PrdItem>
			</PrdList>
			<PolItem>
				<!-- 投保单号 -->
				<ApplyNo><xsl:value-of select="ProposalPrtNo" /></ApplyNo>
				<!-- 每期缴费金额 -->
				<TermAmt></TermAmt>
				<!-- 续期总期数 -->
				<TermNum></TermNum>
				<!-- 缴费金额 -->
				<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
				<!-- 缴费期数 -->
				<PayNum></PayNum>
				<!-- 已缴保费 -->
				<PaidAmt></PaidAmt>
				<!-- 已缴期数 -->
				<PaidNum></PaidNum>
				<!-- 总保费 -->
				<PremAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PremAmt>
				<!-- 总保额 -->
				<CovAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></CovAmt>
			</PolItem>
			<PrtList />
		</Body>
	</xsl:template>
	<!-- 缴费方式 -->
	<xsl:template name="PayIntv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='0'">01</xsl:when>	<!-- 趸缴     -->
			<xsl:when test=".='1'">02</xsl:when>	<!-- 月缴     -->
			<xsl:when test=".='3'">03</xsl:when>	<!-- 季缴     -->
			<xsl:when test=".='6'">04</xsl:when>	<!-- 半年缴    -->        
			<xsl:when test=".='12'">05</xsl:when>	<!-- 年缴     -->
			<xsl:when test=".='-1'">06</xsl:when>	<!-- 不定期缴按月 -->
		</xsl:choose>
	</xsl:template>
	<!-- 缴费年期类型 -->
	<xsl:template name="PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">02</xsl:when>	<!-- 按年     -->
			<xsl:when test=".='A'">03</xsl:when>	<!-- 到某确定年龄     -->
			<xsl:when test=".='M'">06</xsl:when>	<!-- 按月     -->
		</xsl:choose>
	</xsl:template>
	<!-- 保险年期类型 -->
	<xsl:template name="InsuYearFlag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">02</xsl:when>	<!-- 按年限保     -->
			<xsl:when test=".='A'">03</xsl:when>	<!-- 到某确定年龄     -->
			<xsl:when test=".='M'">05</xsl:when>	<!-- 按月     -->
			<xsl:when test=".='D'">06</xsl:when>	<!-- 按日     -->
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50012'">50012</xsl:when> <!--安邦长寿安享5号保险计划-->
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when> <!--  东风五号  -->
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when> <!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='50001'">50001</xsl:when><!-- 安邦长寿稳赢1号两全保险  -->
			<xsl:when test="$riskCode='50002'">122046</xsl:when><!-- 安邦长寿稳赢1号两全保险  -->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>