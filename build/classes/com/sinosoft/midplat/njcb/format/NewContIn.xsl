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
				<!-- �Ͼ����в���Ҫ������
				<xsl:value-of select="ZoneNo" />
				<-->
				<xsl:value-of select="NodeNo" />
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
		  <!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
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
		  <PolicyIndicator>
		  	<xsl:choose>
		  		<xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
		  		<xsl:otherwise>N</xsl:otherwise>
		  	</xsl:choose>
		  </PolicyIndicator>
		  <InsuredTotalFaceAmount>
		  	<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(InsuredTotalFaceAmount)*0.01" />
		  </InsuredTotalFaceAmount> 
		  <!--������������-->
		  <AgentComName>
		  	<xsl:value-of select="AgentComName" />
		  </AgentComName>
		  <AgentComCertiCode>
		  	<xsl:value-of select="AgentComCertiCode" />
		  </AgentComCertiCode>
		  <!--����������Ա����-->
		  <TellerName>
		  	<xsl:value-of select="TellerName" />
		  </TellerName>
		  <TellerCertiCode>
		  	<xsl:value-of select="TellerCertiCode" />
		  </TellerCertiCode>
		  <TellerEmail>
		  	<xsl:value-of select="TellerEmail" />
		  </TellerEmail>
		  <!-- add liying ����50002��Ʒ -->
		  <!-- ��Ʒ��� -->
			<ContPlan>
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode><xsl:apply-templates select="$MainRisk/MainRiskCode" /></ContPlanCode>
				<!-- ��Ʒ��Ϸ��� -->
				<ContPlanMult><xsl:value-of select="format-number($MainRisk/Mult,'#')" /></ContPlanMult>
			</ContPlan>
		 <!-- add liying end -->
		<!-- Ͷ���� -->
		<Appnt>
			<xsl:apply-templates select="Appnt" />
		</Appnt>
		<!-- ������ -->
		<Insured>
			<xsl:apply-templates select="Insured" />
		</Insured>
			
		<!-- ������ -->
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
					<xsl:value-of select="IDType" />
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
				<PayEndYearFlag>
					<xsl:value-of select="PayEndYearFlag" />
				</PayEndYearFlag>
				<PayEndYear>
					<xsl:value-of select="PayEndYear" />
				</PayEndYear>
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
			<xsl:value-of select="IDType" />
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
			<xsl:apply-templates select="Nationality" />
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
	
	<!-- Ͷ���� -->
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
			<xsl:apply-templates select="Nationality" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Weight" />
		</Weight>
		<!-- Ͷ����������(����Ԫ) -->
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
		<!-- 1.����2.ũ�� -->
		<!-- modify liying ���Ľӿ�����1.����2.ũ�壬���нӿ�����0ũ�塢1���� -->
		<LiveZone>
			<xsl:apply-templates select="LiveZone" />
		</LiveZone>
		<RiskAssess>
			<xsl:apply-templates select="EvalRisk" />
		</RiskAssess>
		<!-- modiby liying end -->
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
	
	<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<!-- PBKINSR-494 �Ͼ���������ͨ����ʢ��2�Ų�Ʒ -->
			<!-- <xsl:when test="$riskCode='L12079'">L12079</xsl:when>  -->
			
			<xsl:when test="$riskCode='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test="$riskCode='50002'">50015</xsl:when><!-- �������Ӯ������ϼƻ� -->
			<!-- <xsl:when test="$riskCode='L12085'">L12085</xsl:when>  --><!-- �����2����ȫ���գ������ͣ� -->
			<!-- <xsl:when test="$riskCode='L12086'">L12086</xsl:when>  --><!-- �����3����ȫ���գ������ͣ� -->
			<!-- <xsl:when test="$riskCode='L12088'">L12088</xsl:when>  --><!-- �����9����ȫ���գ������ͣ� -->
			
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ� -->
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �Ƿ��ѽ��з��������ʾ���� -->
	<xsl:template match="EvalRisk">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:when test=".='0'">N</xsl:when>
		</xsl:choose>
	</xsl:template>
	
		<!-- ��������ת�� -->
	<xsl:template match="Nationality">
		<xsl:choose>
			<xsl:when test=".='AUS'">AU</xsl:when>
			<xsl:when test=".='CHN'">CHN</xsl:when>
			<xsl:when test=".='ENG'">GB</xsl:when>
			<xsl:when test=".='JAN'">JP</xsl:when>
			<xsl:when test=".='RUS'">RU</xsl:when>
			<xsl:when test=".='USA'">US</xsl:when>
			<xsl:when test=".='OTH'">OTH</xsl:when>
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<!-- ��ס��������ת�� -->
		<!-- ���Ľӿ�����1.����2.ũ�壬���нӿ�����0ũ�塢1���� -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='0'">2</xsl:when>
			<xsl:when test=".='1'">1</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ײ����ִ���ת�� -->
	<xsl:template match="MainRiskCode">
		<xsl:choose>
			<xsl:when test=".='50002'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
