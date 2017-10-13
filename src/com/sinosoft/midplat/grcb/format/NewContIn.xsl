<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<xsl:apply-templates select="Head" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="Head">
		<Head>
		
			<xsl:copy-of select="TranDate" />
			<xsl:copy-of select="TranTime" />
			<xsl:copy-of select="TellerNo" />
			<xsl:copy-of select="TranNo" />
			<NodeNo>
				<xsl:value-of select="ZoneNo" /><xsl:value-of select="NodeNo" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>

		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Body">
		
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		 <ContPrtNo>
		 	<xsl:value-of select="ContPrtNo" />
		 </ContPrtNo>
		 <PolApplyDate>
		 	<xsl:value-of select="PolApplyDate" />
		 </PolApplyDate>
		  <AccName>
		  	<xsl:value-of select="AccName" />
		  </AccName>
		  <AccNo>
		  	<xsl:value-of select="AccNo" />
		  </AccNo>
		  <!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
		  <GetPolMode><xsl:value-of select="GetPolMode" /></GetPolMode>
		  <JobNotice>
		  	<xsl:value-of select="JobNotice" />
		  </JobNotice>
		  <HealthNotice>
		  	<xsl:choose>
		  		<xsl:when test="HealthNotice='N'">N</xsl:when>
		  		<xsl:otherwise>Y</xsl:otherwise>
		  	</xsl:choose>
		  </HealthNotice>
		  
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
		  
		  <PolicyIndicator>
		  	<xsl:choose>
		  		<xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
		  		<xsl:otherwise>N</xsl:otherwise>
		  	</xsl:choose>
		  </PolicyIndicator>
		  <InsuredTotalFaceAmount>
		  	<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(InsuredTotalFaceAmount)*0.01" />
		  </InsuredTotalFaceAmount> 
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
		  <TellerCertiCode>
		  	<xsl:value-of select="TellerCertiCode" />
		  </TellerCertiCode>
		  <TellerEmail>
		  	<xsl:value-of select="TellerEmail" />
		  </TellerEmail>
		<!-- 投保人 -->
		<Appnt>
			<xsl:apply-templates select="Appnt" />
		</Appnt>
		<!-- 被保人 -->
		<Insured>
			<xsl:apply-templates select="Insured" />
		</Insured>
			
		<!-- 受益人 -->
		<xsl:for-each select="Bnf">
			<Bnf>
				<Type>
					<xsl:value-of select="Type" />
				</Type>
				<Grade>
					<xsl:value-of select="Grade" />
				</Grade>
				<Name>
					<xsl:value-of select="Name" />
				</Name>
	
				<Sex>
					<xsl:value-of select="Sex" />
				</Sex>
				<Birthday>
					<xsl:value-of select="Birthday" />
				</Birthday>
	
				<IDType>
					<!-- 证件类型转换 -->
					<xsl:call-template name="tran_IDType">
						<xsl:with-param name="bankIDType">
							<xsl:value-of select="IDType" />
						</xsl:with-param>
					</xsl:call-template>
				</IDType>
	
				<IDNo>
					<xsl:value-of select="IDNo" />
				</IDNo>
				<IDTypeStartDate>
					<xsl:value-of select="IDTypeStartDate" />
				</IDTypeStartDate>
				<IDTypeEndDate>
					<xsl:value-of select="IDTypeEndDate" />
				</IDTypeEndDate>
				<RelaToInsured>
					<xsl:value-of select="RelaToInsured" />
				</RelaToInsured>
				<Lot>
					<xsl:value-of select="Lot" />
				</Lot>
			</Bnf>
		</xsl:for-each>
		<xsl:for-each select="Risk">
			<Risk>
				<RiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="RiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					<!-- 
					<xsl:value-of select="RiskCode" />
					 -->
				</RiskCode>
				<MainRiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="MainRiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					<!-- 
					<xsl:value-of select="MainRiskCode" />
					 -->
				</MainRiskCode>
				<Amnt >
					<xsl:value-of select="Amnt" />
				</Amnt >
				<Prem>
					<xsl:value-of select="Prem" />
				</Prem>
				<Mult>
					<xsl:value-of select="Mult" />
				</Mult>
				<PayMode>
					<xsl:value-of select="PayMode" />
				</PayMode>
				<PayIntv>
					<xsl:value-of select="PayIntv" />
				</PayIntv>
				<InsuYearFlag>
					<xsl:value-of select="InsuYearFlag" />
				</InsuYearFlag>
				<InsuYear>
					<xsl:value-of select="InsuYear" />
				</InsuYear>
				<xsl:choose>
			  		<xsl:when test="PayEndYearFlag='Z'">
			  			<PayEndYearFlag>Y</PayEndYearFlag>
						<PayEndYear>1000</PayEndYear>
			  		</xsl:when>
			  		<xsl:otherwise>
			  			<PayEndYearFlag>
							<xsl:value-of select="PayEndYearFlag" />
						</PayEndYearFlag>
						<PayEndYear>
							<xsl:value-of select="PayEndYear" />
						</PayEndYear>
			  		</xsl:otherwise>
			  	</xsl:choose>
				<BonusGetMode>
					<xsl:value-of select="BonusGetMode" />
				</BonusGetMode>
				<FullBonusGetMode>
					<xsl:value-of select="FullBonusGetMode" />
				</FullBonusGetMode>
				<GetYearFlag>
					<xsl:value-of select="GetYearFlag" />
				</GetYearFlag>
				<GetYear>
					<xsl:value-of select="GetYear" />
				</GetYear>
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

	<xsl:template name="Insured" match='Insured'>
		<Name>
			<xsl:value-of select="Name" />
		</Name>
		<Sex>
			<xsl:value-of select="Sex" />
		</Sex>
		<Birthday>
			<xsl:value-of select="Birthday" />
		</Birthday>
		<IDType>
			<!-- 证件类型转换 -->
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="bankIDType">
					<xsl:value-of select="IDType" />
				</xsl:with-param>
			</xsl:call-template>
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		<IDTypeStartDate>
			<xsl:value-of select="IDTypeStartDate" />
		</IDTypeStartDate>
		<IDTypeEndDate>
			<xsl:value-of select="IDTypeEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:value-of select="JobCode" />
		</JobCode>
		<Nationality>
			<xsl:value-of select="Nationality" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Weight" />
		</Weight>
		<MaritalStatus>
			<xsl:value-of select="MaritalStatus" />
		</MaritalStatus>
		<Address>
			<xsl:value-of select="Address" />
		</Address>
		<ZipCode>
			<xsl:value-of select="ZipCode" />
		</ZipCode>
		<Mobile>
			<xsl:value-of select="Mobile" />
		</Mobile>
		<Phone>
			<xsl:value-of select="Phone" />
		</Phone>
		<Email>
			<xsl:value-of select="Email" />
		</Email>
	</xsl:template>
	
	<!-- 投保人 -->
	<xsl:template name="Appnt" match='Appnt'>
		<Name>
			<xsl:value-of select="Name" />
		</Name>
		<Sex>
			<xsl:value-of select="Sex" />
		</Sex>
		<Birthday>
			<xsl:value-of select="Birthday" />
		</Birthday>
		<IDType>
			<!-- 证件类型转换 -->
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="bankIDType">
					<xsl:value-of select="IDType" />
				</xsl:with-param>
			</xsl:call-template>
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		<IDTypeStartDate>
			<xsl:value-of select="IDTypeStartDate" />
		</IDTypeStartDate>
		<IDTypeEndDate>
			<xsl:value-of select="IDTypeEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:value-of select="JobCode" />
		</JobCode>
		<Nationality>
			<xsl:value-of select="Nationality" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Weight" />
		</Weight>
		<!-- 投保人年收入(银行元) -->
		<xsl:choose>
			<xsl:when test="Salary=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="Salary" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="FamilySalary=''">
				<FamilySalary />
			</xsl:when>
			<xsl:otherwise>
				<FamilySalary>
					<xsl:value-of
						select="FamilySalary" />
				</FamilySalary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 1.城镇，2.农村 -->
		<LiveZone>
			<xsl:apply-templates select="LiveZone" />
		</LiveZone>
		<!-- 是否已进行风险评估问卷调查 -->
		<RiskAssess>
			<xsl:apply-templates select="EvalRisk" />
		</RiskAssess>
		<MaritalStatus>
			<xsl:value-of select="MaritalStatus" />
		</MaritalStatus>
		<Address>
			<xsl:value-of select="Address" />
		</Address>
		<ZipCode>
			<xsl:value-of select="ZipCode" />
		</ZipCode>
		<Mobile>
			<xsl:value-of select="Mobile" />
		</Mobile>
		<Phone>
			<xsl:value-of select="Phone" />
		</Phone>
		<Email>
			<xsl:value-of select="Email" />
		</Email>
		<RelaToInsured>
			<xsl:value-of select="RelaToInsured" />
		</RelaToInsured>
	</xsl:template>

	<!-- 证件类型转换 -->
	<xsl:template name="tran_IDType">
		<xsl:param name="bankIDType" />
		<xsl:choose>		
			<xsl:when test="$bankIDType='0'">0</xsl:when> <!-- 0身份证 to: 0居民身份证 -->
			<xsl:when test="$bankIDType='1'">1</xsl:when> <!-- 1护照 to: 1护照 -->
			<xsl:when test="$bankIDType='2'">2</xsl:when> <!-- 2军官证 to: 2军官证 -->
			<xsl:when test="$bankIDType='3'">8</xsl:when> <!-- 3士兵证 to: 8其他 -->
			<xsl:when test="$bankIDType='4'">8</xsl:when> <!-- 4港澳台通行证 to: 8其他 -->
			<xsl:when test="$bankIDType='5'">5</xsl:when> <!-- 5户口本 to: 5户口簿 -->
			<xsl:when test="$bankIDType='6'">1</xsl:when> <!-- 6外国护照 to: 1护照 -->
			<xsl:when test="$bankIDType='7'">8</xsl:when> <!-- 7其它 to: 8其他 -->
			<xsl:when test="$bankIDType='8'">8</xsl:when> <!-- 8文职证 to: 8其他 -->
			<xsl:when test="$bankIDType='9'">8</xsl:when> <!-- 9警官证 to: 8其他 -->
			<xsl:when test="$bankIDType='A'">8</xsl:when> <!-- A技术监督局代码 to: 8其他 -->
			<xsl:when test="$bankIDType='B'">8</xsl:when> <!-- B营业执照 to: 8其他 -->
			<xsl:when test="$bankIDType='C'">8</xsl:when> <!-- C行政机关 to: 8其他 -->
			<xsl:when test="$bankIDType='D'">8</xsl:when> <!-- D社会团体 to: 8其他 -->
			<xsl:when test="$bankIDType='E'">8</xsl:when> <!-- E军队 to: 8其他 -->
			<xsl:when test="$bankIDType='F'">8</xsl:when> <!-- F武警 to: 8其他 -->
			<xsl:when test="$bankIDType='G'">8</xsl:when> <!-- G下属机构 to: 8其他 -->
			<xsl:when test="$bankIDType='H'">8</xsl:when> <!-- H基金会 to: 8其他 -->
			<xsl:when test="$bankIDType='I'">8</xsl:when> <!-- I其它 to: 8其他 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , 122048-安邦长寿添利终身寿险（万能型）-->
			<!-- PBKINSR-703 广州农商行50002升级 -->
			<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<!-- PBKINSR-703 广州农商行50002升级 -->
			<xsl:when test="$riskCode=50002">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->			
			<xsl:when test="$riskCode=122036">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款-->
			<!-- add PBKINSR-1309 盛世5号、盛世9号 2016-05-20 begin  -->
			<xsl:when test="$riskCode='L12073'">L12073</xsl:when><!-- 安邦盛世5号终身寿险（万能型）-->
			<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）-->
			<!-- add PBKINSR-1309 盛世5号、盛世9号 2016-05-20 end  -->
			<!-- PBKINSR-1300 zx add  -->
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 是否已进行风险评估问卷调查 -->
	<xsl:template match="EvalRisk">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:when test=".='0'">N</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- 居民类型转换：银行1城镇,0农村 ，核心：1城镇,2农村 -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when>
			<xsl:when test=".='0'">2</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
