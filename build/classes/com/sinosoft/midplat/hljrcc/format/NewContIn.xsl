<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Head" />
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<xsl:copy-of select="TranDate" />
			<!-- 交易时间（hhmmss）-->
			<xsl:copy-of select="TranTime" />
			<!-- 柜员编码 -->
			<xsl:copy-of select="TellerNo" />
			<!-- 交易流水号 -->
			<xsl:copy-of select="TranNo" />
			<!-- 地区码+网点码-->
			<NodeNo>
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<!-- 银保通交易码-->
			<xsl:copy-of select="FuncFlag" />
			<!-- 交易银行-->
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
	
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<!-- 投保单号 -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- 保单印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
		<!-- 投保日期 -->
		<PolApplyDate>
			<xsl:value-of select="PolApplyDate" />
		</PolApplyDate>
		<!-- 首期保费账户名 -->
		<AccName><xsl:value-of select="AccName" /></AccName>
		<!-- 首期保费账户号 -->
		<AccNo><xsl:value-of select="AccNo" /></AccNo>
		<!-- 保单领取方式 -->
		<GetPolMode/>
		<!-- 职业告知 -->
		<JobNotice>
			<xsl:value-of select="JobNotice" />
		</JobNotice>
		<!-- 健康告知 -->
		<HealthNotice>
			<xsl:value-of select="HealthNotice" />
		</HealthNotice>
		
		<!--出单网点名称-->
		<AgentComName>
			<xsl:value-of select="AgentComName" />
		</AgentComName>
		<AgentComCertiCode>
			<xsl:value-of select="AgentComCertiCode" />
		</AgentComCertiCode>
		<!--银行销售人员名称-->
		<TellerName>
			<xsl:value-of select="TellerName" />
		</TellerName>
		<!--银行销售人员工号-->
		<SellerNo>
			<xsl:value-of select="SellerNo" />
		</SellerNo>
		<!-- 从业资格证号 -->
		<TellerCertiCode>
			<xsl:value-of select="TellerCertiCode" />
		</TellerCertiCode>
		  
		<!-- 未成年人累计身故保额标志 -->
		<PolicyIndicator>N</PolicyIndicator>
		<!-- 未成年人累计身故保额（单位是百元） -->
		<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
		<!-- 社保标志 -->
		<SocialInsure></SocialInsure>
		<!-- 公费医疗标志 -->
		<FreeMedical></FreeMedical>
		<!-- 其他医疗标志 -->
		<OtherMedical></OtherMedical>
		<!-- 产品组合 -->
		<ContPlan>
			<!-- 产品组合编码 -->
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="$MainRisk/RiskCode" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:value-of select="$MainRisk/Mult" />
			</ContPlanMult>
		</ContPlan>
				
		<!-- 投保人 -->
		<Appnt>
			<xsl:call-template name="Appnt" />
		</Appnt>
		<!-- 被保人 -->
		<Insured>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="Insured/Name" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="Insured/Sex" />
			</Sex>
			<!-- 出生日期 -->
			<Birthday>
				<xsl:value-of select="Insured/Birthday" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:value-of select="Insured/IDType" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="Insured/IDNo" />
			</IDNo>
			<!-- 证件有效起期 -->
			<IDTypeStartDate>
				<xsl:value-of select="Insured/IDTypeStartDate" />
			</IDTypeStartDate>
			<!-- 证件有效止期 -->
			<IDTypeEndDate>
				<xsl:value-of select="Insured/IDTypeEndDate" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:value-of select="Insured/JobCode" />
			</JobCode>
			<!-- 国籍 -->
			<Nationality>
				<xsl:value-of select="Insured/Nationality" />
			</Nationality>
			<!-- 国籍 -->
			<Stature>
				<xsl:value-of select="Insured/Stature" />
			</Stature>
			<!-- 体重（kg） -->
			<Weight>
				<xsl:value-of select="Insured/Weight" />
			</Weight>
			<!-- 婚姻状态 -->
			<MaritalStatus>
				<xsl:value-of select="Insured/MaritalStatus" />
			</MaritalStatus>
			<!-- 联系地址 -->
			<Address>
				<xsl:value-of select="Insured/Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="Insured/ZipCode" />
			</ZipCode>
			<!-- 手机号 -->
			<Mobile>
				<xsl:value-of select="Insured/Mobile" />
			</Mobile>
			<!-- 电话 -->
			<Phone>
				<xsl:value-of select="Insured/Phone" />
			</Phone>
			<!-- 邮箱 -->
			<Email>
				<xsl:value-of select="Insured/Email" />
			</Email>
		</Insured>
		<!-- 受益人 -->
		<xsl:for-each select="Bnf">
			<Bnf>
				<!-- 受益人类型 农信社不传-->
				<Type>1</Type>
				<!-- 受益人顺序 -->
				<Grade>
					<xsl:value-of select="Grade" />
				</Grade>
				<!-- 姓名 -->
				<Name>
					<xsl:value-of select="Name" />
				</Name>
				<!-- 性别 -->
				<Sex>
					<xsl:value-of select="Sex" />
				</Sex>
				<!-- 出生日期 -->
				<Birthday>
					<xsl:value-of select="Birthday" />
				</Birthday>
				<!-- 证件类型 -->
				<IDType>
					<xsl:value-of select="IDType" />
				</IDType>
				<!-- 证件号码 -->
				<IDNo>
					<xsl:value-of select="IDNo" />
				</IDNo>
				<!-- 受益人与被保人关系 -->
				<RelaToInsured>
					<xsl:value-of select="RelaToInsured" />
				</RelaToInsured>
				<!-- 分配比例（整数 不带%） -->
				<Lot>
					<xsl:value-of select="Lot" />
				</Lot>
			</Bnf>
		</xsl:for-each>

		<xsl:for-each select="Risk">
			<Risk>
				<!-- 险种编号-->
				<RiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskcode"
							select="RiskCode" />
					</xsl:call-template>
				</RiskCode>
				<!-- 主险号 -->
				<MainRiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
				</MainRiskCode>
				<!-- 保额（分） -->
				<Amnt>
					<xsl:value-of select="Amnt" />
				</Amnt>
				<!-- 保费（分） -->
				<Prem>
					<xsl:value-of select="Mult*100000" />
				</Prem>
				<!-- 份数 -->
				<Mult>
					<xsl:value-of select="Mult" />
				</Mult>
				<!-- 缴费方式 -->
				<PayMode/>
				<!-- 缴费频率 -->
				<PayIntv>
					<xsl:value-of select="PayIntv" />
				</PayIntv>
				<!-- 保险年期年龄标志 -->
				<InsuYearFlag>
					<xsl:value-of select="InsuYearFlag" />
					<!-- 
					<xsl:call-template name="tran_InsuYearFlag">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</InsuYearFlag>
				<!-- 保险年期 -->
				<InsuYear>
					<xsl:value-of select="InsuYear" />
					<!-- 
					<xsl:call-template name="tran_InsuYear">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</InsuYear>
				<!-- 缴费年期年龄标志 -->
				<PayEndYearFlag>
					<xsl:value-of select="PayEndYearFlag" />
					<!-- 
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</PayEndYearFlag>
				<!-- 缴费年期年龄 -->
				<PayEndYear>
					<xsl:value-of select="PayEndYear" />
					<!-- 
					<xsl:call-template name="tran_PayEndYear">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</PayEndYear>
				<!-- 红利领取方式 -->
				<BonusGetMode>
					<xsl:value-of select="BonusGetMode" />
				</BonusGetMode>
				<!-- 满期领取方式 -->
				<FullBonusGetMode>
					<xsl:value-of select="FullBonusGetMode" />
				</FullBonusGetMode>
				<!-- 领取年期年龄标志 -->
				<GetYearFlag>
					<xsl:value-of select="GetYearFlag" />
				</GetYearFlag>
				<!-- 领取年期年龄 -->
				<GetYear>
					<xsl:value-of select="GetYear" />
				</GetYear>
				<!-- 领取频率 -->
				<GetIntv>
					<xsl:value-of select="GetIntv" />
				</GetIntv>
				<GetBankCode>
					<xsl:value-of select="GetBankCode" />
				</GetBankCode>
				<GetBankAccNo>
					<xsl:value-of select="GetBankAccNo" />
				</GetBankAccNo>
				<GetAccName>
					<xsl:value-of select="GetAccName" />
				</GetAccName>
				<AutoPayFlag>
					<xsl:value-of select="AutoPayFlag" />
				</AutoPayFlag>
			</Risk>
		</xsl:for-each>
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="Appnt">
		<!-- 姓名 -->
		<Name>
			<xsl:value-of select="Appnt/Name" />
		</Name>
		<!-- 性别 -->
		<Sex>
			<xsl:value-of select="Appnt/Sex" />
		</Sex>
		<!-- 出生日期 -->
		<Birthday>
			<xsl:value-of select="Appnt/Birthday" />
		</Birthday>
		<!-- 证件类型 -->
		<IDType>
			<xsl:value-of select="Appnt/IDType" />
		</IDType>
		<!-- 证件编号 -->
		<IDNo>
			<xsl:value-of select="Appnt/IDNo" />
		</IDNo>
		<!-- 证件有效起期 -->
		<IDTypeStartDate>
			<xsl:value-of select="Appnt/IDTypeStartDate" />
		</IDTypeStartDate>
		<!-- 证件有效止期 -->
		<IDTypeEndDate>
			<xsl:value-of select="Appnt/IDTypeEndDate" />
		</IDTypeEndDate>
		<!-- 职业代码 -->
		<JobCode>
			<xsl:value-of select="Appnt/JobCode" />
		</JobCode>
		<!-- 被保人家庭收入 -->
		<Salary><xsl:value-of select="Appnt/Salary" /></Salary>
		<!-- 投保人家庭收入 -->
		<FamilySalary><xsl:value-of select="Appnt/FamilySalary" /></FamilySalary>
		<!-- 居住地区 -->
		<LiveZone><xsl:value-of select="Appnt/LiveZone" /></LiveZone>
		<!-- 投保人主要收入来源 -->
		<SalarySource><xsl:value-of select="Appnt/SalarySource" /></SalarySource>
		<!-- 投保人家庭年收入主要来源 -->
		<FamilySalarySource><xsl:value-of select="Appnt/FamilySalarySource" /></FamilySalarySource>
		<!--  投保人保费预算，单位：分 -->
		<PremBudget><xsl:value-of select="Appnt/PremBudget" /></PremBudget>
		<!-- 国籍 -->
		<Nationality>
			<xsl:value-of select="Appnt/Nationality" />
		</Nationality>
		<!-- 身高（cm） -->
		<Stature>
			<xsl:value-of select="Appnt/Stature" />
		</Stature>
		<!-- 体重（kg） -->
		<Weight>
			<xsl:value-of select="Appnt/Weight" />
		</Weight>
		<!-- 婚姻状态 -->
		<MaritalStatus>
			<xsl:value-of select="Appnt/MaritalStatus" />
		</MaritalStatus>
		<!-- 联系地址 -->
		<Address>
			<xsl:value-of select="Appnt/Address" />
		</Address>
		<!-- 邮编 -->
		<ZipCode>
			<xsl:value-of select="Appnt/ZipCode" />
		</ZipCode>
		<!-- 手机号 -->
		<Mobile>
			<xsl:value-of select="Appnt/Mobile" />
		</Mobile>
		<!-- 电话号 -->
		<Phone>
			<xsl:value-of select="Appnt/Phone" />
		</Phone>
		<!-- 邮箱 -->
		<Email>
			<xsl:value-of select="Appnt/Email" />
		</Email>
		<!-- 投保人与被保人关系 -->
		<RelaToInsured>
			<xsl:value-of select="Appnt/RelaToInsured" />
		</RelaToInsured>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , 122048-安邦长寿添利终身寿险（万能型）-->
			<!-- 50015-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , L12081-安邦长寿添利终身寿险（万能型）-->
			<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='122010'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>	 <!-- 安邦长寿稳赢保险计划 -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期类型 -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">Y</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='122010'">A</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">A</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			<xsl:when test="$riskcode='L12089'">A</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款 --> 
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期 -->
	<xsl:template name="tran_InsuYear">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">5</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='122010'">106</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">106</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			<xsl:when test="$riskcode='L12089'">106</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期类型 -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">Y</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='122010'">Y</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">Y</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期 -->
	<xsl:template name="tran_PayEndYear">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">1000</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode='122010'">1000</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">1000</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
