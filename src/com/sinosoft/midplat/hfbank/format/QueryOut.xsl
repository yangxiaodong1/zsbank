<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
		  	<ContNo><xsl:value-of select="ContNo" /></ContNo><!-- 保险单号 -->
			<ProposalPrtNo><xsl:value-of select="ProposalPrtNo" /></ProposalPrtNo><!-- 投保单(印刷)号 -->
			<ContPrtNo><xsl:value-of select="ContPrtNo" /></ContPrtNo><!-- 保单合同印刷号 -->
			<AccNo><xsl:value-of select="AccNo" /></AccNo><!-- 银行账户 -->
			<Prem><xsl:value-of select="Prem" /></Prem><!-- 总保费(分) -->
			<PremText><xsl:value-of select="PremText" /></PremText><!-- 总保费大写 -->
			<ActSumPrem><xsl:value-of select="ActSumPrem" /></ActSumPrem><!--实收保费-->
			<ActSumPremText><xsl:value-of select="ActSumPremText" /></ActSumPremText><!--实收保费大写-->
			<EFMoney><xsl:value-of select="EFMoney" /></EFMoney><!--满期金，组合产品50015时使用-->
			<AgentCode><xsl:value-of select="AgentCode" /></AgentCode><!-- 代理人编00码 -->
			<AgentName><xsl:value-of select="AgentName" /></AgentName><!-- 代理人姓名 -->
			<AgentCertiCode><xsl:value-of select="AgentCertiCode" /></AgentCertiCode><!-- 代理人资格证 -->
			<AgentGrpCode><xsl:value-of select="AgentGrpCode" /></AgentGrpCode><!-- 代理人组别编码 -->
			<AgentGrpName><xsl:value-of select="AgentGrpName" /></AgentGrpName><!-- 代理人组别 -->
			<AgentCom><xsl:value-of select="AgentCom" /></AgentCom><!-- 代理机构编码 -->
			<AgentComName><xsl:value-of select="AgentComName" /></AgentComName><!-- 代理机构名称 -->
			<AgentComCertiCode><xsl:value-of select="AgentComCertiCode" /></AgentComCertiCode><!-- 代理机构资格证 -->
			<ComCode><xsl:value-of select="ComCode" /></ComCode><!-- 承保公司编码 -->
			<ComLocation><xsl:value-of select="ComLocation" /></ComLocation><!-- 承保公司地址 -->
			<ComName><xsl:value-of select="ComName" /></ComName><!-- 承保公司名称 -->
			<ComZipCode><xsl:value-of select="ComZipCode" /></ComZipCode><!-- 承保公司邮编 -->
			<ComPhone><xsl:value-of select="ComPhone" /></ComPhone><!-- 承保公司电话 -->
			<SellerNo><xsl:value-of select="SellerNo" /></SellerNo><!--银行销售人员工号 -->
			<TellerName><xsl:value-of select="TellerName" /></TellerName><!--银行销售人员名称 -->
			<TellerCertiCode><xsl:value-of select="TellerCertiCode" /></TellerCertiCode><!--银行销售人员资格证 -->
			<AgentManageNo><xsl:value-of select="AgentManageNo" /></AgentManageNo><!--银行保险业务负责人工号 -->
			<AgentManageName><xsl:value-of select="AgentManageName" /></AgentManageName><!--银行保险业务负责人名称 -->
			<SubBankCode><xsl:value-of select="SubBankCode" /></SubBankCode>
			<!--代理保险缴费业务细分代码 01-实时投保缴费 02-非实时投保缴费 03-续期交费-->
			<AgentPayType><xsl:value-of select="AgentPayType" /></AgentPayType>
			<SpecContent><xsl:value-of select="SpecContent" /></SpecContent>
			<!--组合产品-->
		  	<ContPlan>
		   		<!--组合产品代码-->
		    	<ContPlanCode></ContPlanCode>
		   		<!--组合产品名称-->
		     	<ContPlanName></ContPlanName>
		   		<!--组合产品份数-->
		     	<ContPlanMult></ContPlanMult>
		  	</ContPlan>
		  	<!-- 投保人 -->
		  	<xsl:apply-templates select="Appnt" />
		  	<!-- 被保人 -->
		  	<xsl:apply-templates select="Insured" />
		  	<!-- 受益人 -->
		  	<xsl:apply-templates select="Bnf" />
		  	<!-- 险种信息 -->
		  	<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
		</Body>
	</xsl:template>
	<!-- 投保人 -->
	<xsl:template name="Appnt" match="Appnt">
		<Appnt>
		    <CustomerNo><xsl:value-of select="CustomerNo" /></CustomerNo><!-- 客户号 -->
			<Name><xsl:value-of select="Name" /></Name><!-- 姓名 -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- 性别 -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- 出生日期(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- 证件类型 -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- 证件号码 -->
			<JobType><xsl:value-of select="JobType" /></JobType><!-- 职业类别 -->
			<JobCode><xsl:value-of select="JobCode" /></JobCode><!-- 职业代码 -->
			<JobName><xsl:value-of select="JobName" /></JobName><!-- 职业名称 -->
			<Nationality><xsl:value-of select="Nationality" /></Nationality><!-- 国籍-->
			<Stature><xsl:value-of select="Stature" /></Stature><!-- 身高(cm) -->
			<Weight><xsl:value-of select="Weight" /></Weight><!-- 体重(g) -->
			<MaritalStatus><xsl:value-of select="MaritalStatus" /></MaritalStatus><!-- 婚否(N/Y) -->
			<Address><xsl:value-of select="Address" /></Address><!-- 地址 -->
			<ZipCode><xsl:value-of select="ZipCode" /></ZipCode><!-- 邮编 -->
			<Mobile><xsl:value-of select="Mobile" /></Mobile><!-- 移动电话 -->
			<Phone><xsl:value-of select="Phone" /></Phone><!-- 固定电话 -->
			<Email><xsl:value-of select="Email" /></Email><!-- 电子邮件-->
			<RelaToInsured><xsl:value-of select="RelaToInsured" /></RelaToInsured><!-- 与被保人关系 -->
		 </Appnt>
	</xsl:template>
	<!-- 被保险人 -->
	<xsl:template name="Insured" match="Insured">
		<Insured>
		    <CustomerNo><xsl:value-of select="CustomerNo" /></CustomerNo><!-- 客户号 -->
			<Name><xsl:value-of select="Name" /></Name><!-- 姓名 -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- 性别 -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- 出生日期(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- 证件类型 -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- 证件号码 -->
			<JobType><xsl:value-of select="JobType" /></JobType><!-- 职业类别 -->
			<JobCode><xsl:value-of select="JobCode" /></JobCode><!-- 职业代码 -->
			<JobName><xsl:value-of select="JobName" /></JobName><!-- 职业名称 -->
			<Stature><xsl:value-of select="Stature" /></Stature><!-- 身高(cm)-->
			<Nationality><xsl:value-of select="Nationality" /></Nationality><!-- 国籍-->
			<Weight><xsl:value-of select="Weight" /></Weight><!-- 体重(g) -->
			<MaritalStatus><xsl:value-of select="MaritalStatus" /></MaritalStatus><!-- 婚否(N/Y) -->
			<Address><xsl:value-of select="Address" /></Address><!-- 地址 -->
			<ZipCode><xsl:value-of select="ZipCode" /></ZipCode><!-- 邮编 -->
			<Mobile><xsl:value-of select="Mobile" /></Mobile><!-- 移动电话 -->
			<Phone><xsl:value-of select="Phone" /></Phone><!-- 固定电话 -->
			<Email><xsl:value-of select="Email" /></Email><!-- 电子邮件-->
		 </Insured>
	</xsl:template>
	<!-- 受益人 -->
	<xsl:template name="Bnf" match="Bnf">		
		  <Bnf>
		    <Type><xsl:value-of select="Type" /></Type><!-- 受益人类别 -->
			<Grade><xsl:value-of select="Grade" /></Grade><!-- 受益顺序 -->
			<Name><xsl:value-of select="Name" /></Name><!-- 姓名 -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- 性别 -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- 出生日期(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- 证件类型 -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- 证件号码 -->
			<RelaToInsured><xsl:value-of select="RelaToInsured" /></RelaToInsured><!-- 与被保人关系 -->
			<Lot><xsl:value-of select="Lot" /></Lot><!-- 受益比例(整数，百分比)  -->
		  </Bnf>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">		
		 <Risk>
		 	<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode><!-- 险种代码 -->
					<RiskName><xsl:value-of select="../ContPlan/ContPlanName" /></RiskName><!-- 险种名称 -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>		
					<Mult><xsl:value-of select="../ContPlan/ContPlanMult" /></Mult><!-- 投保份数 -->			
				</xsl:when>
				<xsl:otherwise>
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="RiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode><!-- 险种代码 -->
					<RiskName><xsl:value-of select="RiskName" /></RiskName><!-- 险种名称 -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="MainRiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>
					<Mult><xsl:value-of select="Mult" /></Mult><!-- 投保份数 -->
				</xsl:otherwise>
			</xsl:choose>		
		    
			<RiskType><xsl:value-of select="RiskType" /></RiskType><!-- 其中1-传统险2-分红3-投连4-万能5-其他 -->
			<Amnt><xsl:value-of select="../Amnt" /></Amnt><!-- 保额(分) -->
			<Prem><xsl:value-of select="../ActSumPrem" /></Prem><!-- 保险费(分) -->
			
			<PayIntv><xsl:value-of select="PayIntv" /></PayIntv><!-- 缴费频次 -->
			<PayMode><xsl:value-of select="PayMode" /></PayMode><!-- 缴费形式 -->
			<PolApplyDate><xsl:value-of select="PolApplyDate" /></PolApplyDate><!-- 投保日期(yyyyMMdd) -->
			<SignDate><xsl:value-of select="SignDate" /></SignDate><!-- 承保日期(yyyyMMdd) -->
			<CValiDate><xsl:value-of select="CValiDate" /></CValiDate><!-- 起保日期(yyyyMMdd) -->
			<InsuYearFlag><xsl:value-of select="InsuYearFlag" /></InsuYearFlag><!-- 保险年龄年期标志 -->
			<InsuYear><xsl:value-of select="InsuYear" /></InsuYear><!-- 保险年龄年期 -->
			<InsuEndDate><xsl:value-of select="InsuEndDate" /></InsuEndDate><!-- 保险责任终止日期 -->
			<Years><xsl:value-of select="Years" /></Years><!-- 保险期间 -->
			<PayEndYearFlag><xsl:value-of select="PayEndYearFlag" /></PayEndYearFlag><!-- 缴费年期类型 -->
			<PayEndYear><xsl:value-of select="PayEndYear" /></PayEndYear><!-- 缴费年期 -->
			<PayEndDate><xsl:value-of select="PayEndDate" /></PayEndDate><!-- 终缴日期 -->
			<CostIntv><xsl:value-of select="CostIntv" /></CostIntv><!-- 扣款间隔 -->
			<CostDate><xsl:value-of select="CostDate" /></CostDate><!-- 扣款时间 -->
			<PayToDate><xsl:value-of select="PayToDate" /></PayToDate><!-- 交至日期(yyyyMMdd) -->
			<GetYearFlag><xsl:value-of select="GetYearFlag" /></GetYearFlag><!-- 领取年龄年期标志 -->
			<GetStartDate><xsl:value-of select="GetStartDate" /></GetStartDate><!-- 起领日期(yyyyMMdd) -->
			<GetYear><xsl:value-of select="GetYear" /></GetYear><!-- 领取年龄 -->
			<GetIntv><xsl:value-of select="GetIntv" /></GetIntv><!-- 领取方式 -->
			<GetBankCode><xsl:value-of select="GetBankCode" /></GetBankCode><!-- 领取银行编码 -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo" /></GetBankAccNo><!-- 领取银行账户 -->
			<GetAccName><xsl:value-of select="GetAccName" /></GetAccName><!-- 领取银行户名 -->
			<AutoPayFlag><xsl:value-of select="AutoPayFlag" /></AutoPayFlag><!-- 自动垫交标志 -->
			<BonusGetMode><xsl:value-of select="BonusGetMode" /></BonusGetMode><!-- 红利领取方式 -->
			<SubFlag><xsl:value-of select="SubFlag" /></SubFlag><!-- 减额交清标志 -->
			<FullBonusGetMode><xsl:value-of select="FullBonusGetMode" /></FullBonusGetMode><!-- 满期领取金领取方式 -->
			<PayNum><xsl:value-of select="PayNum" /></PayNum><!-- 保费缴费期数-->
			<HsitPrd><xsl:value-of select="HsitPrd" /></HsitPrd><!-- 保单犹豫期数 -->
			<StartPayDate><xsl:value-of select="StartPayDate" /></StartPayDate><!-- 续期应缴日期YYYY-MM-DD  -->
			<PayTotalCount><xsl:value-of select="PayTotalCount" /></PayTotalCount><!-- 续期应缴期数 -->
			<PayCount><xsl:value-of select="PayCount" /></PayCount><!-- 当期期数-->
		
		    <!-- 交费账户 -->
		    <Account>
		      <AccNo /> <!-- 账户编码 -->
		      <AccMoney /> <!-- 账户金额 -->
		      <AccRate /> <!-- 账户比率 -->
		    </Account>
		    
		    <!-- 现金价值表 -->
		    <CashValues>
		      <CashValue>
		        <EndYear></EndYear> <!-- 年度 -->
		        <Cash></Cash> <!-- 现金价值-->
		      </CashValue>
		    </CashValues>
		    
		    <!-- 红利保额保单年度末利益价值表 -->
		    <BonusValues>
		      <BonusValue>
		        <EndYear /> <!-- 年度 -->
		        <EndYearCash /> <!-- 利益价值-->
		      </BonusValue>
		    </BonusValues>
		    <SpecContent /> <!-- 特别约定 -->
		  </Risk>
	</xsl:template>
	<!-- 险种代码 -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>        	
            <xsl:when test="$riskCode='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->
            <xsl:otherwise>--</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>