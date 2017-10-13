<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TXLife>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="./*"/>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 保单号 -->
			<PolicyNo>
				<xsl:value-of select="ContNo"/>
			</PolicyNo>
			<!-- 保险产品信息 -->	
			<PlanCodeInfo>	
				<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />			
			</PlanCodeInfo>
			<AccStat><xsl:apply-templates select="ContState" /></AccStat><!-- 保单状态信息 -->
			
		</Body>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">
		<GetBankInfo><!-- 满期领取信息 -->
			<GetBankCode><xsl:value-of select="GetBankCode "/></GetBankCode><!-- 满期领取银行机构号 -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo "/></GetBankAccNo><!-- 满期领取银行账户 -->
			<GetAccName><xsl:value-of select="GetAccName "/></GetAccName><!-- 满期领取账户名称 -->
			<InsureDate><xsl:value-of select="PolApplyDate "/></InsureDate><!-- 投保日期（只限保单查询交易用） -->
			<TotlePremium><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)"/></TotlePremium><!-- 基本保费（只限保单查询交易用） -->
			<TotleAmnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)"/></TotleAmnt><!-- 基本保额（只限保单查询交易用） -->
			<Assumpsit><xsl:value-of select="SpecContent  "/></Assumpsit><!-- 特别约定?(只限保单查询交易用) -->
		</GetBankInfo>
		<MCount>1</MCount>
		<PClist>
			<PCCategory>
				<PCInfo>
					<PCIsMajor>Y</PCIsMajor><!-- 是否主险（Y/N） -->
					<xsl:choose>
						<xsl:when test="../ContPlan/ContPlanCode=''">
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- 所属主险代码 -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- 险种代码  -->
			                <PCName><xsl:value-of select="RiskName"/></PCName><!-- 险种名称 -->
			                <PCNumber><xsl:value-of select="Mult"/></PCNumber><!-- 投保份数 -->
						</xsl:when>
						<xsl:otherwise>
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- 所属主险代码 -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- 险种代码  -->
			                <PCName><xsl:value-of select="../ContPlan/ContPlanName"/></PCName><!-- 险种名称 -->
			                <PCNumber><xsl:value-of select="../ContPlan/ContPlanMult"/></PCNumber><!-- 投保份数 -->
						</xsl:otherwise>
					</xsl:choose>
					<PCType></PCType><!-- 险种类型 0 传统险 1 分红险 2 投连险 3 万能险 -->	
					<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)"/></Amnt><!-- 保险金额（保额） -->
					<Premium><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)"/></Premium><!-- 基本保费 -->
					<OthAmnt></OthAmnt><!-- 额外保额 -->
					<OthPremium></OthPremium><!-- 额外保费 -->
					<StableBenifit></StableBenifit><!-- 满期返回固定收益 -->
					<InitFeeRate></InitFeeRate><!-- 初始费用比例 -->
					<Rate></Rate><!-- 费率或缴费标准（精确到%号后两位） -->
					<BonusPayMode></BonusPayMode><!-- 红利分配方式 -->
					<BonusAmnt></BonusAmnt><!-- 累计红利 -->
					<xsl:choose>
						<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'">
							<PayTermType>1</PayTermType><!-- 缴费年期类型 -->
							<PayYear>0</PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:when>
						<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'">
							<PayTermType>4</PayTermType><!-- 缴费年期类型 -->
							<PayYear>0</PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:when>
						<xsl:otherwise>
							<PayTermType><xsl:apply-templates select="PayEndYearFlag"/></PayTermType><!-- 缴费年期类型 -->
							<PayYear><xsl:value-of select="PayEndYear"/></PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:otherwise>
					</xsl:choose>
					<PayPeriodType></PayPeriodType><!-- 缴费年限类型 -->
					<FIRST_PAYWAY></FIRST_PAYWAY><!-- 首期交费形式 -->
					<NEXT_PAYWAY></NEXT_PAYWAY><!-- 续期交费形式 -->
					<LoanTerm></LoanTerm><!-- 贷款期间 -->
					<InsuranceTerm></InsuranceTerm><!-- 保险期间 -->
					<xsl:choose>
						<xsl:when test="InsuYearFlag ='A' and InsuYear ='106'">
							<CovPeriodType>1</CovPeriodType><!-- 保险年龄年期标志 -->
							<InsuYear>0</InsuYear><!-- 保险年龄年期 -->
						</xsl:when>
						<xsl:otherwise>
							<CovPeriodType><xsl:apply-templates select="InsuYearFlag"/></CovPeriodType><!-- 保险年龄年期标志 -->
							<InsuYear><xsl:value-of select="InsuYear "/></InsuYear><!-- 保险年龄年期 -->
						</xsl:otherwise>
					</xsl:choose>
					<FullBonusGetFlag></FullBonusGetFlag><!-- 满期领取保险金标记（是否能够领取保险金，需同步）（Y/N） -->
					<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->
					<FullBonusPeriod></FullBonusPeriod><!-- 满期领取年期年龄(0-99) -->
					<RenteGetMode></RenteGetMode><!-- 年金领取方式 -->
					<RentePeriod></RentePeriod><!-- 年金领取年期年龄(0-99) -->
					<SurBnGetMode></SurBnGetMode><!-- 生存金领取方式 -->
					<SurBnPeriod></SurBnPeriod><!-- 生存金领取年期年领(0-99) -->
					<AutoPayFlag></AutoPayFlag><!-- 自动垫交标记（Y/N） -->
					<SubFlag></SubFlag><!-- 减额缴清标记（Y/N） -->
					<Address></Address><!-- 保险财产坐落地址(只产险共赢3号产品火灾责任用) -->
					<PostCode></PostCode><!-- 保险财产坐落地址邮编(只产险共赢3号产品火灾责任用) -->
					<HouseStru></HouseStru><!-- 房屋结构(只产险共赢3号产品火灾责任用) -->
					<HousePurp></HousePurp><!-- 房屋用途 -->
				</PCInfo>
			</PCCategory>
		</PClist>
	</xsl:template>
	
	
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode"/>
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50015</xsl:when>
			<!-- 组合产品 50015-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成 -->
			
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when> <!-- 安邦东风9号两全保险（万能型） -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- PayEndYearFlag缴费年期  -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 缴至某年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ContState 保单状态 -->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='B'">2</xsl:when><!-- 已承保未生效 -->
			<xsl:when test=".='00'">3</xsl:when><!-- 已承保已生效 -->
			<xsl:when test=".='C'">5</xsl:when><!-- 已撤单 -->
			<xsl:when test=".='01'">6</xsl:when><!-- 已满期 -->
			<xsl:when test=".='04'">7</xsl:when><!-- 理赔终止 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
