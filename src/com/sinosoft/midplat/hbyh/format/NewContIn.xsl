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
		  <!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
		  <GetPolMode><xsl:value-of select="GetPolMode" /></GetPolMode>
		  <JobNotice>
		  	<xsl:value-of select="JobNotice" />
		  </JobNotice>
		  <HealthNotice>
		  	<xsl:value-of select="HealthNotice" />
		  </HealthNotice>
		  
			<!-- ��Ʒ��� -->
			<ContPlan>
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode>
					<xsl:call-template name="tran_ContPlanCode">
						<xsl:with-param name="contPlanCode">
							<xsl:value-of select="$MainRisk/RiskCode" />
						</xsl:with-param>
					</xsl:call-template>
				</ContPlanCode>
				<!-- ��Ʒ��Ϸ��� -->
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
		  <!--����������Ա����-->
		  <SellerNo>
		  	<xsl:value-of select="SellerNo" />
		  </SellerNo>
		  <TellerCertiCode>
		  	<xsl:value-of select="TellerCertiCode" />
		  </TellerCertiCode>
		  <TellerEmail>
		  	<xsl:value-of select="TellerEmail" />
		  </TellerEmail>
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
				<xsl:choose>
					<xsl:when test="PayEndYearFlag = 'Z'">
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
		<LiveZone>
			<xsl:apply-templates select="LiveZone" />
		</LiveZone>
		<!-- �Ƿ��ѽ��з��������ʾ���� -->
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

	<!-- �������ߣ�ֻ��ʢ2��������Ʒ�ݲ����ߣ�20150416�汾 -->
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<xsl:when test="$contPlanCode=''"></xsl:when>   
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , 122048-����������������գ������ͣ�-->
			<!-- 50015-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , L12081-����������������գ������ͣ�-->
		    <xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
		<!-- �������ߣ�ֻ��ʢ2��������Ʒ�ݲ����ߣ�20150416�汾 -->
		  	<xsl:when test="$riskCode=50002">50015</xsl:when><!-- �������Ӯ���ռƻ� --> 
			<xsl:when test="$riskCode=122012">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ� B��-->
		 	<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
		<!-- 	<xsl:when test="$riskCode=122009">122009</xsl:when>--><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:otherwise>--</xsl:otherwise>
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
	
	<!-- ��������ת��������1����,0ũ�� �����ģ�1����,2ũ�� -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when>
			<xsl:when test=".='0'">2</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
