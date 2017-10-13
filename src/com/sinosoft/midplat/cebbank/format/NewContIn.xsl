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
		  <GetPolMode>
		  	<xsl:value-of select="AccNo" />
		  </GetPolMode>
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
		  	<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsuredTotalFaceAmount)" />
		  </InsuredTotalFaceAmount>
		  <!--������������-->
		  <AgentComName>
		  	<xsl:value-of select="BANKNAME" />
		  </AgentComName>
		  <!--����������Ա����-->
		  <SellerNo>
		  	<xsl:value-of select="SALESSTAFFID" />
		  </SellerNo>
		  <!--����������Ա����-->
		  <TellerName>
		  	<xsl:value-of select="SALESSTAFFNAME" />
		  </TellerName>
		  <!-- Ͷ���� -->
		<Appnt>
			<xsl:call-template name="Appnt" />
		</Appnt>
		<!-- ������ -->
		<Insured>
			<Name>
				<xsl:value-of select="Insured/Name" />
			</Name>
			<Sex>
				<xsl:value-of select="Insured/Sex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="Insured/Birthday" />
			</Birthday>
			<IDType>
				<xsl:value-of select="Insured/IDType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="Insured/IDNo" />
			</IDNo>
			<IDTypeStartDate>
				<xsl:value-of select="Insured/IDTypeStartDate" />
			</IDTypeStartDate>
			<IDTypeEndDate>
				<xsl:value-of select="Insured/IDTypeEndDate" />
			</IDTypeEndDate>
			<JobCode>
				<xsl:value-of select="Insured/JobCode" />
			</JobCode>
			<Nationality>
				<xsl:value-of select="Insured/Nationality" />
			</Nationality>
			<Stature>
				<xsl:value-of select="Insured/Stature" />
			</Stature>
			<Weight>
				<xsl:value-of select="Insured/Weight" />
			</Weight>
			<MaritalStatus>
				<xsl:value-of select="Insured/MaritalStatus" />
			</MaritalStatus>
			<Address>
				<xsl:value-of select="Insured/Address" />
			</Address>
			<ZipCode>
				<xsl:value-of select="Insured/ZipCode" />
			</ZipCode>
			<Mobile>
				<xsl:value-of select="Insured/Mobile" />
			</Mobile>
			<Phone>
				<xsl:value-of select="Insured/Phone" />
			</Phone>
			<Email>
				<xsl:value-of select="Insured/Email" />
			</Email>
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
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" />
				</Amnt >
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" />
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

	<!-- Ͷ���� -->
	<xsl:template name="Appnt">
		<Name>
			<xsl:value-of select="Appnt/Name" />
		</Name>
		<Sex>
			<xsl:value-of select="Appnt/Sex" />
		</Sex>
		<Birthday>
			<xsl:value-of select="Appnt/Birthday" />
		</Birthday>
		<IDType>
			<xsl:value-of select="Appnt/IDType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="Appnt/IDNo" />
		</IDNo>
		<IDTypeStartDate>
			<xsl:value-of select="Appnt/IDTypeStartDate" />
		</IDTypeStartDate>
		<IDTypeEndDate>
			<xsl:value-of select="Appnt/IDTypeEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:value-of select="Appnt/JobCode" />
		</JobCode>
		<Nationality>
			<xsl:value-of select="Appnt/Nationality" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Appnt/Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Appnt/Weight" />
		</Weight>
		<MaritalStatus>
			<xsl:value-of select="Appnt/MaritalStatus" />
		</MaritalStatus>
		<Address>
			<xsl:value-of select="Appnt/Address" />
		</Address>
		<ZipCode>
			<xsl:value-of select="Appnt/ZipCode" />
		</ZipCode>
		<Mobile>
			<xsl:value-of select="Appnt/Mobile" />
		</Mobile>
		<Phone>
			<xsl:value-of select="Appnt/Phone" />
		</Phone>
		<Email>
			<xsl:value-of select="Appnt/Email" />
		</Email>
		<RelaToInsured>
			<xsl:value-of select="Appnt/RelaToInsured" />
		</RelaToInsured>
		<!-- Ͷ����������(������Ԫ) -->
		<xsl:choose>
			<xsl:when test="TBR_ANNUALINCOME=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_ANNUALINCOME*10000)" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- �Ƿ��ѽ��з��������ʾ���� -->
		<RiskAssess>
			<xsl:apply-templates select="RISKRATING" />
		</RiskAssess>
		<!-- 1.����2.ũ�� -->
		<LiveZone>
			<xsl:value-of select="TBR_RESIDENTS" />
		</LiveZone>

	</xsl:template>

	<!-- �Ƿ��ѽ��з��������ʾ���� -->
	<xsl:template match="RISKRATING">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:when test=".='0'">N</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
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
			<xsl:when test="$riskCode=122003">122003</xsl:when><!-- ����۱���1����ȫ���գ��ֺ��ͣ�A��-->
			<xsl:when test="$riskCode=122006">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��-->
			<xsl:when test="$riskCode=122009">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��-->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�-->
			<xsl:when test="$riskCode='L12089'">L12089</xsl:when><!-- ����ʢ��1��B���������գ������ͣ�-->
			<xsl:when test="$riskCode=122012">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�-->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<!-- <xsl:when test="$riskCode=122010">L12078</xsl:when> --><!-- ����ʢ��3���������գ������ͣ�-->
			<xsl:when test="$riskCode=122010">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�-->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test="$riskCode=50002">50015</xsl:when><!-- �������Ӯ���ռƻ� -->
            <xsl:when test="$riskCode='L12087'">L12087</xsl:when>      <!-- ����5����ȫ���գ������ͣ� ���� add by jbq -->
            <xsl:when test="$riskCode='L12086'">L12086</xsl:when>      <!-- �����3����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$riskCode='L12085'">L12085</xsl:when>	   <!-- �����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$riskCode='L12088'">L12088</xsl:when>	   <!-- �����9����ȫ���գ������ͣ� ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
