<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head" />  <!-- 还是不太清楚这样的关系 -->
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<!-- 报文头 -->
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<!-- 0表示成功，1表示失败 -->
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag>
			<!-- 失败时，返回错误信息 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc>
		</Head>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<!-- 保险单号 -->
		  	<ContNo>
		  		<xsl:value-of select="ContNo" />
		  	</ContNo>
		  	<!-- 投保单(印刷)号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- 保单合同印刷号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo" />
			</ContPrtNo>
			<!-- 总保费(分) -->
			<Prem>
				<xsl:value-of select="Prem" />
			</Prem>
			<!-- 总保费大写 -->
			<PremText>
				<xsl:value-of select="PremText" />
			</PremText>
			<!--实收保费-->
			<ActSumPrem>
				<xsl:value-of select="ActSumPrem" />
			</ActSumPrem>
			<!--实收保费大写-->
			<ActSumPremText>
				<xsl:value-of select="ActSumPremText" />
			</ActSumPremText>
			<!-- 代理人编00码 -->
			<AgentCode>
				<xsl:value-of select="AgentCode" />
			</AgentCode>
			<!-- 代理人姓名 -->
			<AgentName>
				<xsl:value-of select="AgentName" />
			</AgentName>
			<!-- 代理人资格证 -->
			<AgentCertiCode>
				<xsl:value-of select="AgentCertiCode" />
			</AgentCertiCode>
			<!-- 代理人组别编码 -->
			<AgentGrpCode>
				<xsl:value-of select="AgentGrpCode" />
			</AgentGrpCode>
			<!-- 代理人组别 -->
			<AgentGrpName>
				<xsl:value-of select="AgentGrpName" />
			</AgentGrpName>
			<!-- 代理机构编码 -->
			<AgentCom>
				<xsl:value-of select="AgentCom" />
			</AgentCom>
			<!-- 代理机构名称 -->
			<AgentComName>
				<xsl:value-of select="AgentComName" />
			</AgentComName>
			<!-- 代理机构资格证 -->
			<AgentComCertiCode>
				<xsl:value-of select="AgentComCertiCode" />
			</AgentComCertiCode>
			<!-- 承保公司编码 -->
			<ComCode>
				<xsl:value-of select="ComCode" />
			</ComCode>
			<!-- 承保公司地址 -->
			<ComLocation>
				<xsl:value-of select="ComLocation" />
			</ComLocation>
			<!-- 承保公司名称 -->
			<ComName>
				<xsl:value-of select="ComName" />
			</ComName>
			<!-- 承保公司邮编 -->
			<ComZipCode>
				<xsl:value-of select="ComZipCode" />
			</ComZipCode>
			<!-- 承保公司电话 -->
			<ComPhone>
				<xsl:value-of select="ComPhone" />
			</ComPhone>
			<!-- 柜员工号 -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!--银行销售人员工号 -->
			<SellerNo>
				<xsl:value-of select="SellerNo" />
			</SellerNo>
			<!--银行销售人员名称 -->
			<TellerName>
				<xsl:value-of select="TellerName" />
			</TellerName>
			<!--银行销售人员资格证 -->
			<TellerCertiCode>
				<xsl:value-of select="TellerCertiCode" />
			</TellerCertiCode>
			<!--银行保险业务负责人工号 -->
			<AgentManageNo>
				<xsl:value-of select="AgentManageNo" />
			</AgentManageNo>
			<!--银行保险业务负责人名称 -->
			<AgentManageName>
				<xsl:value-of select="AgentManageName" />
			</AgentManageName>
			<SpecContent>
				<xsl:value-of select="SpecContent" />
			</SpecContent>
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
		  	
		  	<!--保单状态-->
		  	<ContState>
		  		<xsl:value-of select="ContState" />
		  	</ContState>
		  	<!--保单业务类型--> 
			<BusinessTypes> 
				<!--具体保单业务类型--> 
				<BusinessType><xsl:value-of select="BusinessType" /></BusinessType> 
			</BusinessTypes>
			<EdorInfos>
				<EdorInfo>
					<!-- 保全类型-->
					<EdorType>
						<xsl:value-of select="EdorType" />
					</EdorType>
					<EdorAppDate>
						<xsl:value-of select="EdorAppDate" />
					</EdorAppDate>
					<EdorValidDate>
						<xsl:value-of select="EdorValidDate" />
					</EdorValidDate>
					<!--保全申请状态 -->
					<EdorState>
						<xsl:value-of select="EdorState" /><!--保全状态-->
					</EdorState>
				</EdorInfo>
			</EdorInfos>
			<!--保单质押状态： 0未质押，1质押-->
			<MortStatu>
				<xsl:value-of select="MortStatu" />
			</MortStatu> 
			<!-- 退保 -->
			<Surr> 
				 <!--保单价值（按日查询）：单位是人民币分-->
				 <CashvalueD>
				 	<xsl:value-of select="CashvalueD" />
				 </CashvalueD> 
				 <!--保单价值（万能险至结息日账户价值）：单位是人民币分-->
				 <CashvalueIntD>
				 	<xsl:value-of select="CashvalueIntD" />
				 </CashvalueIntD> 
				 <!--退保可返还金额：单位是人民币分-->
				 <GetMoney>
				 	<xsl:value-of select="GetMoney" />
				 </GetMoney>
				 <!--退保手续费：单位是人民币分--> 
				 <GetCharge>
				 	<xsl:value-of select="GetCharge" />
				 </GetCharge> 
			</Surr>
		</Body>
	</xsl:template>
	<!-- 投保人 -->
	<xsl:template name="Appnt" match="Appnt">
		<Appnt>
			<!-- 客户号 -->
		    <CustomerNo>
		    	<xsl:value-of select="CustomerNo" />
		    </CustomerNo>
		    <!-- 姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
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
			<!-- 职业类别 -->
			<JobType>
				<xsl:value-of select="JobType" />
			</JobType>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- 职业名称 -->
			<JobName>
				<xsl:value-of select="JobName" />
			</JobName>
			<!-- 国籍-->
			<Nationality>
				<xsl:value-of select="Nationality" />
			</Nationality>
			<!-- 身高(cm) -->
			<Stature>
				<xsl:value-of select="Stature" />
			</Stature>
			<!-- 体重(g) -->
			<Weight>
				<xsl:value-of select="Weight" />
			</Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus>
				<xsl:value-of select="MaritalStatus" />
			</MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- 电子邮件-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:value-of select="RelaToInsured" />
			</RelaToInsured>
		 </Appnt>
	</xsl:template>
	<!-- 被保险人 -->
	<xsl:template name="Insured" match="Insured">
		<Insured>
			<!-- 客户号 -->
		    <CustomerNo>
		    	<xsl:value-of select="CustomerNo" />
		    </CustomerNo>
		    <!-- 姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
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
			<!-- 职业类别 -->
			<JobType>
				<xsl:value-of select="JobType" />
			</JobType>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- 职业名称 -->
			<JobName>
				<xsl:value-of select="JobName" />
			</JobName>
			<!-- 身高(cm)-->
			<Stature>
				<xsl:value-of select="Stature" />
			</Stature>
			<!-- 国籍-->
			<Nationality>
				<xsl:value-of select="Nationality" />
			</Nationality>
			<!-- 体重(g) -->
			<Weight>
				<xsl:value-of select="Weight" />
			</Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus>
				<xsl:value-of select="MaritalStatus" />
			</MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- 电子邮件-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
		 </Insured>
	</xsl:template>
	<!-- 受益人 -->
	<xsl:template name="Bnf" match="Bnf">		
		  <Bnf>
		  	<!-- 受益人类别 -->
		    <Type>
		    	<xsl:value-of select="Type" />
		    </Type>
		    <!-- 受益顺序 -->
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
			<!-- 出生日期(yyyyMMdd) -->
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
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:value-of select="RelaToInsured" />
			</RelaToInsured>
			<!-- 受益比例(整数，百分比)  -->
			<Lot>
				<xsl:value-of select="Lot" />
			</Lot>
		  </Bnf>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">		
		 <Risk>
		 	<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<!-- 险种代码 -->
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode>
				    <!-- 险种名称 -->
					<RiskName>
						<xsl:value-of select="../ContPlan/ContPlanName" />
					</RiskName>
					<!-- 主险代码 -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>	
					<!-- 保额(分) -->
					<Amnt>
						<xsl:value-of select="../Amnt" />
					</Amnt>
					<!-- 保险费(分) -->
					<Prem>
						<xsl:value-of select="../ActSumPrem" />
					</Prem>
					<!-- 投保份数 -->		
					<Mult>
						<xsl:value-of select="../ContPlan/ContPlanMult" />
					</Mult>		
				</xsl:when>
				<xsl:otherwise>
					<!-- 险种代码 -->
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="RiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode>
				    <!-- 险种名称 -->
					<RiskName>
						<xsl:value-of select="RiskName" />
					</RiskName>
					<!-- 主险代码 -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="MainRiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>
					<!-- 保额(分) -->
					<Amnt>
						<xsl:value-of select="../Amnt" />
					</Amnt>
					<!-- 保险费(分) -->
					<Prem>
						<xsl:value-of select="../ActSumPrem" />
					</Prem>
					<!-- 投保份数 -->
					<Mult>
						<xsl:value-of select="Mult" />
					</Mult>
				</xsl:otherwise>
			</xsl:choose>		
		    <!-- 缴费频次 -->
			<PayIntv>
				<xsl:value-of select="PayIntv" />
			</PayIntv>
			<!-- 缴费形式 -->
			<PayMode>
				<xsl:value-of select="PayMode" />
			</PayMode>
			<!-- 投保日期(yyyyMMdd) -->
			<PolApplyDate>
				<xsl:value-of select="PolApplyDate" />
			</PolApplyDate>
			<!-- 承保日期(yyyyMMdd) -->
			<SignDate>
				<xsl:value-of select="SignDate" />
			</SignDate>
			<!-- 起保日期(yyyyMMdd) -->
			<CValiDate>
				<xsl:value-of select="CValiDate" />
			</CValiDate>
			<!-- 保险年龄年期标志 -->
			<InsuYearFlag>
				<xsl:value-of select="InsuYearFlag" />
			</InsuYearFlag>
			<!-- 保险年龄年期 -->
			<InsuYear>
				<xsl:value-of select="InsuYear" />
			</InsuYear>
			<!-- 保险责任终止日期 -->
			<InsuEndDate>
				<xsl:value-of select="InsuEndDate" />
			</InsuEndDate>
			<!-- 保险期间 -->
			<Years>
				<xsl:value-of select="Years" />
			</Years>
			<!-- 缴费年期类型 -->
			<PayEndYearFlag>
				<xsl:value-of select="PayEndYearFlag" />
			</PayEndYearFlag>
			<!-- 缴费年期 -->
			<PayEndYear>
				<xsl:value-of select="PayEndYear" />
			</PayEndYear>
			<!-- 终缴日期 -->
			<PayEndDate>
				<xsl:value-of select="PayEndDate" />
			</PayEndDate>
			<!-- 扣款间隔 -->
			<CostIntv>
				<xsl:value-of select="CostIntv" />
			</CostIntv>
			<!-- 扣款时间 -->
			<CostDate>
				<xsl:value-of select="CostDate" />
			</CostDate>
			<!-- 交至日期(yyyyMMdd) -->
			<PayToDate>
				<xsl:value-of select="PayToDate" />
			</PayToDate>
			<!-- 领取年龄年期标志 -->
			<GetYearFlag>
				<xsl:value-of select="GetYearFlag" />
			</GetYearFlag>
			<!-- 起领日期(yyyyMMdd) -->
			<GetStartDate>
				<xsl:value-of select="GetStartDate" />
			</GetStartDate>
			<!-- 领取年龄 -->
			<GetYear>
				<xsl:value-of select="GetYear" />
			</GetYear>
			<!-- 领取方式 -->
			<GetIntv>
				<xsl:value-of select="GetIntv" />
			</GetIntv>
			<!-- 领取银行编码 -->
			<GetBankCode>
				<xsl:value-of select="GetBankCode" />
			</GetBankCode>
			<!-- 领取银行账户 -->
			<GetBankAccNo>
				<xsl:value-of select="GetBankAccNo" />
			</GetBankAccNo>
			<!-- 领取银行户名 -->
			<GetAccName>
				<xsl:value-of select="GetAccName" />
			</GetAccName>
			<!-- 自动垫交标志 -->
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag>
			<!-- 红利领取方式 -->
			<BonusGetMode>
				<xsl:value-of select="BonusGetMode" />
			</BonusGetMode>
			<!-- 减额交清标志 -->
			<SubFlag>
				<xsl:value-of select="SubFlag" />
			</SubFlag>
			<!-- 满期领取金领取方式 -->
			<FullBonusGetMode>
				<xsl:value-of select="FullBonusGetMode" />
			</FullBonusGetMode>
		
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
            <xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when>  --><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
			<xsl:when test=".='50002'">50015</xsl:when>  <!-- 安邦长寿稳赢保险计划  -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- 安邦盛世1号终身寿险（万能型） -->
			<!--<xsl:when test=".='L12089'">L12089</xsl:when>-->  <!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型） 主险 -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款-->
			<xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>