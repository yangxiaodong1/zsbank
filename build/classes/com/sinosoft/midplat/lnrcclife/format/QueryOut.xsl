<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TXLife>
	</xsl:template>

	<!-- 主信息 -->
	<xsl:template name="MAIN" match="Body">
		<!--保单号-->
		<PolicyNo>
			<xsl:value-of select="ContNo" />
		</PolicyNo>
		<PlanCodeInfo>
			<GetBankInfo>
				<GetBankCode />
				<GetBankAccNo />
				<GetAccName />
			</GetBankInfo>
			<MCount>1</MCount>
			<PClist>
				<PCCategory>
					<xsl:apply-templates select="//Risk[RiskCode=MainRiskCode]" />
				</PCCategory>
			</PClist>
		</PlanCodeInfo>
		<AccStat>
		   <xsl:if test="AppFlag ='1'">001</xsl:if>
		   <xsl:if test="AppFlag !='1'">002</xsl:if>
		</AccStat>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">
		<PCInfo>
			<PCIsMajor>
				<xsl:if test="RiskCode != MainRiskCode">N</xsl:if>
				<xsl:if test="RiskCode = MainRiskCode">Y</xsl:if>
			</PCIsMajor>
			<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<PCCode>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="../ContPlan/ContPlanCode" />
						</xsl:call-template>
					</PCCode>
					<BelongMajor>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="../ContPlan/ContPlanCode" />
						</xsl:call-template>
					</BelongMajor>
					<PCType>3</PCType>
					<PCNumber>
						<xsl:value-of select="../ContPlan/ContPlanMult" />
					</PCNumber>							
				</xsl:when>
				<xsl:otherwise>
					<PCCode>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="RiskCode" />
						</xsl:call-template>
					</PCCode>
					<BelongMajor>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="MainRiskCode" />
						</xsl:call-template>
					</BelongMajor>
					<PCType>3</PCType>
					<PCNumber>
						<xsl:value-of select="Mult" />
					</PCNumber>						
				</xsl:otherwise>
			</xsl:choose>	
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)" />
			</Amnt>
			<Premium>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
			</Premium>
			<OthAmnt></OthAmnt>
			<OthPremium></OthPremium>
			<StableBenifit></StableBenifit>
			<InitFeeRate></InitFeeRate>
			<Rate></Rate>
			<BonusPayMode></BonusPayMode>
			<BonusAmnt></BonusAmnt>
			<!-- 缴费年期类型 -->
			<xsl:choose>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
					<!-- 趸交或交终身 -->
					<PayTermType>1</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear != 1000)">
					<!-- 年缴 -->
					<PayTermType>2</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- 缴至某确定年龄 -->
					<PayTermType>3</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- 终身 -->
					<PayTermType>4</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
			</xsl:choose>
			<PayPeriodType>
			    <xsl:apply-templates  select ="PayIntv"/>
			</PayPeriodType>
			<LoanTerm></LoanTerm>
			<InsuranceTerm></InsuranceTerm>
			<!-- 保险年期类型 -->
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- 终身 -->
					<CovPeriodType>1</CovPeriodType>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他保险年期 -->
					<CovPeriodType><xsl:apply-templates  select ="InsuYearFlag"/></CovPeriodType>
				</xsl:otherwise>
			</xsl:choose>
			<InsuYear></InsuYear>
			<FullBonusGetFlag></FullBonusGetFlag>
			<FullBonusGetMode></FullBonusGetMode>
			<FullBonusPeriod></FullBonusPeriod>
			<RenteGetMode></RenteGetMode>
			<RentePeriod></RentePeriod>
			<SurBnGetMode></SurBnGetMode>
			<SurBnPeriod></SurBnPeriod>
			<AutoPayFlag></AutoPayFlag>
			<SubFlag></SubFlag>
		</PCInfo>
	</xsl:template>

	<!-- 现金价值信息 -->
	<xsl:template name="CashValue" match="CashValue">
		<PolBenefitInfoList>
			<YeadEnd><xsl:value-of select="EndYear" /></YeadEnd>
			<CashValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" /></CashValue>
		</PolBenefitInfoList>
	</xsl:template>
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">身份证</xsl:when>
		<xsl:when test=".=1">护照  </xsl:when>
		<xsl:when test=".=2">军官证</xsl:when>
		<xsl:when test=".=3">驾照  </xsl:when>
		<xsl:when test=".=5">户口簿</xsl:when>
		<xsl:when test=".=6">港澳台通行证</xsl:when>
		<xsl:when test=".=9">临时身份证</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">LNABZX02</xsl:when>
			<xsl:when test="$riskcode='L12079'">LNABZX01</xsl:when>
			<!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保障年期类型0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年限保 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='M'">4</xsl:when><!-- 按月保 -->
			<xsl:when test=".='D'">5</xsl:when><!-- 按天保 -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">0</xsl:when><!-- 年缴 -->
			<xsl:when test=".='6'">1</xsl:when><!-- 半年交 -->
			<xsl:when test=".='3'">2</xsl:when><!-- 季交 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 月交 -->
			<xsl:when test=".='0'">4</xsl:when><!-- 趸交 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
