<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
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
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<ProposalPrtNo><xsl:value-of select="ProposalPrtNo" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="ContPrtNo" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="PolApplyDate" /></PolApplyDate>
		<AccName><xsl:value-of select="AccName" /></AccName>
		<AccNo><xsl:value-of select="AccNo" /></AccNo>
		<GetPolMode><xsl:value-of select="GetPolMode" /></GetPolMode>
		<JobNotice><xsl:value-of select="JobNotice" /></JobNotice>
		<HealthNotice><xsl:value-of select="HealthNotice" /></HealthNotice>
		<PolicyIndicator><xsl:value-of select="PolicyIndicator" /></PolicyIndicator>
		<AgentComName><xsl:value-of select="AgentComName" /></AgentComName>
		<AgentComCertiCode><xsl:value-of select="AgentComCertiCode" /></AgentComCertiCode>
		<TellerName><xsl:value-of select="TellerName" /></TellerName>
		<TellerCertiCode><xsl:value-of select="TellerCertiCode" /></TellerCertiCode>
		<!-- 产品组合 -->
        <ContPlan>
        	<!-- 产品组合编码 -->
        	<xsl:variable name="mainRiskCode" select="$MainRisk/RiskCode"/>
			<ContPlanCode>
				<!-- 银行传来的代码是50002 -->
				<xsl:if test="$mainRiskCode = 50002">
					<xsl:apply-templates select="$mainRiskCode" />
				</xsl:if>
				<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 begin -->
				<xsl:if test="$mainRiskCode = 50012">
					<xsl:apply-templates select="$mainRiskCode" />
				</xsl:if>
				<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 end -->
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:if test="$mainRiskCode = 50002">
					<xsl:value-of select="format-number($MainRisk/Mult,'#')" />
				</xsl:if>
				<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 begin -->
				<xsl:if test="$mainRiskCode = 50012">
					<xsl:value-of select="format-number($MainRisk/Mult,'#')" />
				</xsl:if>
				<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 end -->
			</ContPlanMult>
        </ContPlan>
        <Appnt><xsl:apply-templates select="Appnt" /></Appnt>
        <Insured><xsl:apply-templates select="Insured" /></Insured>
        <xsl:for-each select="Bnf">
        	<Bnf>
        		<Type><xsl:value-of select="Type" /></Type>
        		<Grade><xsl:value-of select="Grade" /></Grade>
        		<Name><xsl:value-of select="Name" /></Name>
        		<Sex><xsl:value-of select="Sex" /></Sex>
        		<Birthday><xsl:value-of select="Birthday" /></Birthday>
        		<IDType><xsl:value-of select="IDType" /></IDType>
        		<IDNo><xsl:value-of select="IDNo" /></IDNo>
        		<IDTypeEndDate><xsl:value-of select="IDTypeEndDate" /></IDTypeEndDate>
        		<RelaToInsured><xsl:value-of select="RelaToInsured" /></RelaToInsured>
        		<Lot><xsl:value-of select="Lot" /></Lot>
        	</Bnf>
        </xsl:for-each>
        <xsl:for-each select="Risk">
        	<Risk>
        		<RiskCode><xsl:apply-templates select="RiskCode" /></RiskCode>
        		<MainRiskCode ><xsl:apply-templates select="MainRiskCode" /></MainRiskCode >
        		<Amnt><xsl:value-of select="Amnt" /></Amnt>
        		<Prem><xsl:value-of select="Prem" /></Prem>
        		<Mult><xsl:value-of select="format-number(Mult,'#')" /></Mult>
        		<PayMode><xsl:value-of select="PayMode" /></PayMode>
        		<PayIntv><xsl:value-of select="PayIntv" /></PayIntv>
        		<InsuYearFlag><xsl:value-of select="InsuYearFlag" /></InsuYearFlag>
        		<InsuYear><xsl:value-of select="InsuYear" /></InsuYear>
        		<PayEndYearFlag><xsl:value-of select="PayEndYearFlag" /></PayEndYearFlag>
        		<PayEndYear><xsl:value-of select="PayEndYear" /></PayEndYear>
        		<BonusGetMode><xsl:value-of select="BonusGetMode" /></BonusGetMode>
        		<FullBonusGetMode><xsl:value-of select="FullBonusGetMode" /></FullBonusGetMode>
        		<GetYearFlag><xsl:value-of select="GetYearFlag" /></GetYearFlag>
        		<GetYear><xsl:value-of select="GetYear" /></GetYear>
        		<GetIntv><xsl:value-of select="GetIntv" /></GetIntv>
        		<GetBankCode><xsl:value-of select="GetBankCode" /></GetBankCode>
        		<GetBankAccNo><xsl:value-of select="GetBankAccNo" /></GetBankAccNo>
        		<GetAccName><xsl:value-of select="GetAccName" /></GetAccName>
        		<AutoPayFlag><xsl:value-of select="AutoPayFlag" /></AutoPayFlag>
        	</Risk>
        </xsl:for-each>
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
			<xsl:value-of select="IDType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		
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
		<RiskAssess>
			<xsl:value-of select="RiskAssess" />
		</RiskAssess>
		
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
	<!-- 被保险人 -->
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
			<xsl:value-of select="IDType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		
		<IDTypeEndDate>
			<xsl:value-of select="IDTypeEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:value-of select="JobCode" />
		</JobCode>
		<Nationality>
			<xsl:value-of  select="Nationality" />
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
	
	
	<!-- LiveZone -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='0'">2</xsl:when><!-- 农村 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 城镇 -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="RiskCode | MainRiskCode">
		<xsl:choose>
			<xsl:when test=".='50002'">50015</xsl:when>  <!-- 安邦长寿稳赢保险计划 -->
			<xsl:when test=".='L12052'">L12052</xsl:when><!-- 安邦长寿智赢1号年金保险 -->
			<xsl:when test=".='L12080'">L12080</xsl:when> <!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<!-- 万通险改造暂不上线鼎5 -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 begin -->
			<xsl:when test=".='50012'">50012</xsl:when>  <!-- 安邦长寿安享5号保险计划 -->
			<xsl:when test=".='L12070'">L12070</xsl:when><!-- 安邦长寿安享5号年金保险 -->
			<xsl:when test=".='L12071'">L12071</xsl:when><!-- 安邦附加长寿添利5号两全保险（万能型） -->
			<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 end -->
			
			<!-- guoxl 2016.6.15 开始 -->
			<xsl:when test=".='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
			<!-- guoxl 2016.6.15 结束 -->
			
			<xsl:when test=".='L12085'">L12085</xsl:when> 	<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test=".='L12086'">L12086</xsl:when> 	<!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test=".='L12088'">L12088</xsl:when> 	<!-- 安邦东风9号两全保险（万能型） -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
