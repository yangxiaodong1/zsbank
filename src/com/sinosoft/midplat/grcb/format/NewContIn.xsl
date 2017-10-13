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
		  	<xsl:choose>
		  		<xsl:when test="HealthNotice='N'">N</xsl:when>
		  		<xsl:otherwise>Y</xsl:otherwise>
		  	</xsl:choose>
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
					<!-- ֤������ת�� -->
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
			<!-- ֤������ת�� -->
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
			<!-- ֤������ת�� -->
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

	<!-- ֤������ת�� -->
	<xsl:template name="tran_IDType">
		<xsl:param name="bankIDType" />
		<xsl:choose>		
			<xsl:when test="$bankIDType='0'">0</xsl:when> <!-- 0���֤ to: 0�������֤ -->
			<xsl:when test="$bankIDType='1'">1</xsl:when> <!-- 1���� to: 1���� -->
			<xsl:when test="$bankIDType='2'">2</xsl:when> <!-- 2����֤ to: 2����֤ -->
			<xsl:when test="$bankIDType='3'">8</xsl:when> <!-- 3ʿ��֤ to: 8���� -->
			<xsl:when test="$bankIDType='4'">8</xsl:when> <!-- 4�۰�̨ͨ��֤ to: 8���� -->
			<xsl:when test="$bankIDType='5'">5</xsl:when> <!-- 5���ڱ� to: 5���ڲ� -->
			<xsl:when test="$bankIDType='6'">1</xsl:when> <!-- 6������� to: 1���� -->
			<xsl:when test="$bankIDType='7'">8</xsl:when> <!-- 7���� to: 8���� -->
			<xsl:when test="$bankIDType='8'">8</xsl:when> <!-- 8��ְ֤ to: 8���� -->
			<xsl:when test="$bankIDType='9'">8</xsl:when> <!-- 9����֤ to: 8���� -->
			<xsl:when test="$bankIDType='A'">8</xsl:when> <!-- A�����ල�ִ��� to: 8���� -->
			<xsl:when test="$bankIDType='B'">8</xsl:when> <!-- BӪҵִ�� to: 8���� -->
			<xsl:when test="$bankIDType='C'">8</xsl:when> <!-- C�������� to: 8���� -->
			<xsl:when test="$bankIDType='D'">8</xsl:when> <!-- D������� to: 8���� -->
			<xsl:when test="$bankIDType='E'">8</xsl:when> <!-- E���� to: 8���� -->
			<xsl:when test="$bankIDType='F'">8</xsl:when> <!-- F�侯 to: 8���� -->
			<xsl:when test="$bankIDType='G'">8</xsl:when> <!-- G�������� to: 8���� -->
			<xsl:when test="$bankIDType='H'">8</xsl:when> <!-- H����� to: 8���� -->
			<xsl:when test="$bankIDType='I'">8</xsl:when> <!-- I���� to: 8���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , 122048-����������������գ������ͣ�-->
			<!-- PBKINSR-703 ����ũ����50002���� -->
			<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<!-- PBKINSR-703 ����ũ����50002���� -->
			<xsl:when test="$riskCode=50002">50015</xsl:when><!-- �������Ӯ���ռƻ� -->			
			<xsl:when test="$riskCode=122036">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��-->
			<!-- add PBKINSR-1309 ʢ��5�š�ʢ��9�� 2016-05-20 begin  -->
			<xsl:when test="$riskCode='L12073'">L12073</xsl:when><!-- ����ʢ��5���������գ������ͣ�-->
			<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�-->
			<!-- add PBKINSR-1309 ʢ��5�š�ʢ��9�� 2016-05-20 end  -->
			<!-- PBKINSR-1300 zx add  -->
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�-->
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
	
	
	
	<!-- ��������ת��������1����,0ũ�� �����ģ�1����,2ũ�� -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when>
			<xsl:when test=".='0'">2</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
