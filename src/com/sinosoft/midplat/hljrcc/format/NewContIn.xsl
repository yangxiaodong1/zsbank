<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Head" />
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<xsl:copy-of select="TranDate" />
			<!-- ����ʱ�䣨hhmmss��-->
			<xsl:copy-of select="TranTime" />
			<!-- ��Ա���� -->
			<xsl:copy-of select="TellerNo" />
			<!-- ������ˮ�� -->
			<xsl:copy-of select="TranNo" />
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="NodeNo" />
			</NodeNo>
			<!-- ����ͨ������-->
			<xsl:copy-of select="FuncFlag" />
			<!-- ��������-->
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Body" match="Body">
	
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<!-- Ͷ������ -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- ����ӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
		<!-- Ͷ������ -->
		<PolApplyDate>
			<xsl:value-of select="PolApplyDate" />
		</PolApplyDate>
		<!-- ���ڱ����˻��� -->
		<AccName><xsl:value-of select="AccName" /></AccName>
		<!-- ���ڱ����˻��� -->
		<AccNo><xsl:value-of select="AccNo" /></AccNo>
		<!-- ������ȡ��ʽ -->
		<GetPolMode/>
		<!-- ְҵ��֪ -->
		<JobNotice>
			<xsl:value-of select="JobNotice" />
		</JobNotice>
		<!-- ������֪ -->
		<HealthNotice>
			<xsl:value-of select="HealthNotice" />
		</HealthNotice>
		
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
		<!-- ��ҵ�ʸ�֤�� -->
		<TellerCertiCode>
			<xsl:value-of select="TellerCertiCode" />
		</TellerCertiCode>
		  
		<!-- δ�������ۼ���ʱ����־ -->
		<PolicyIndicator>N</PolicyIndicator>
		<!-- δ�������ۼ���ʱ����λ�ǰ�Ԫ�� -->
		<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
		<!-- �籣��־ -->
		<SocialInsure></SocialInsure>
		<!-- ����ҽ�Ʊ�־ -->
		<FreeMedical></FreeMedical>
		<!-- ����ҽ�Ʊ�־ -->
		<OtherMedical></OtherMedical>
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
				
		<!-- Ͷ���� -->
		<Appnt>
			<xsl:call-template name="Appnt" />
		</Appnt>
		<!-- ������ -->
		<Insured>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="Insured/Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Insured/Sex" />
			</Sex>
			<!-- �������� -->
			<Birthday>
				<xsl:value-of select="Insured/Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:value-of select="Insured/IDType" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="Insured/IDNo" />
			</IDNo>
			<!-- ֤����Ч���� -->
			<IDTypeStartDate>
				<xsl:value-of select="Insured/IDTypeStartDate" />
			</IDTypeStartDate>
			<!-- ֤����Чֹ�� -->
			<IDTypeEndDate>
				<xsl:value-of select="Insured/IDTypeEndDate" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="Insured/JobCode" />
			</JobCode>
			<!-- ���� -->
			<Nationality>
				<xsl:value-of select="Insured/Nationality" />
			</Nationality>
			<!-- ���� -->
			<Stature>
				<xsl:value-of select="Insured/Stature" />
			</Stature>
			<!-- ���أ�kg�� -->
			<Weight>
				<xsl:value-of select="Insured/Weight" />
			</Weight>
			<!-- ����״̬ -->
			<MaritalStatus>
				<xsl:value-of select="Insured/MaritalStatus" />
			</MaritalStatus>
			<!-- ��ϵ��ַ -->
			<Address>
				<xsl:value-of select="Insured/Address" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="Insured/ZipCode" />
			</ZipCode>
			<!-- �ֻ��� -->
			<Mobile>
				<xsl:value-of select="Insured/Mobile" />
			</Mobile>
			<!-- �绰 -->
			<Phone>
				<xsl:value-of select="Insured/Phone" />
			</Phone>
			<!-- ���� -->
			<Email>
				<xsl:value-of select="Insured/Email" />
			</Email>
		</Insured>
		<!-- ������ -->
		<xsl:for-each select="Bnf">
			<Bnf>
				<!-- ���������� ũ���粻��-->
				<Type>1</Type>
				<!-- ������˳�� -->
				<Grade>
					<xsl:value-of select="Grade" />
				</Grade>
				<!-- ���� -->
				<Name>
					<xsl:value-of select="Name" />
				</Name>
				<!-- �Ա� -->
				<Sex>
					<xsl:value-of select="Sex" />
				</Sex>
				<!-- �������� -->
				<Birthday>
					<xsl:value-of select="Birthday" />
				</Birthday>
				<!-- ֤������ -->
				<IDType>
					<xsl:value-of select="IDType" />
				</IDType>
				<!-- ֤������ -->
				<IDNo>
					<xsl:value-of select="IDNo" />
				</IDNo>
				<!-- �������뱻���˹�ϵ -->
				<RelaToInsured>
					<xsl:value-of select="RelaToInsured" />
				</RelaToInsured>
				<!-- ������������� ����%�� -->
				<Lot>
					<xsl:value-of select="Lot" />
				</Lot>
			</Bnf>
		</xsl:for-each>

		<xsl:for-each select="Risk">
			<Risk>
				<!-- ���ֱ��-->
				<RiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskcode"
							select="RiskCode" />
					</xsl:call-template>
				</RiskCode>
				<!-- ���պ� -->
				<MainRiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
				</MainRiskCode>
				<!-- ����֣� -->
				<Amnt>
					<xsl:value-of select="Amnt" />
				</Amnt>
				<!-- ���ѣ��֣� -->
				<Prem>
					<xsl:value-of select="Mult*100000" />
				</Prem>
				<!-- ���� -->
				<Mult>
					<xsl:value-of select="Mult" />
				</Mult>
				<!-- �ɷѷ�ʽ -->
				<PayMode/>
				<!-- �ɷ�Ƶ�� -->
				<PayIntv>
					<xsl:value-of select="PayIntv" />
				</PayIntv>
				<!-- �������������־ -->
				<InsuYearFlag>
					<xsl:value-of select="InsuYearFlag" />
					<!-- 
					<xsl:call-template name="tran_InsuYearFlag">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</InsuYearFlag>
				<!-- �������� -->
				<InsuYear>
					<xsl:value-of select="InsuYear" />
					<!-- 
					<xsl:call-template name="tran_InsuYear">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</InsuYear>
				<!-- �ɷ����������־ -->
				<PayEndYearFlag>
					<xsl:value-of select="PayEndYearFlag" />
					<!-- 
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</PayEndYearFlag>
				<!-- �ɷ��������� -->
				<PayEndYear>
					<xsl:value-of select="PayEndYear" />
					<!-- 
					<xsl:call-template name="tran_PayEndYear">
						<xsl:with-param name="riskcode"
							select="MainRiskCode" />
					</xsl:call-template>
					-->
				</PayEndYear>
				<!-- ������ȡ��ʽ -->
				<BonusGetMode>
					<xsl:value-of select="BonusGetMode" />
				</BonusGetMode>
				<!-- ������ȡ��ʽ -->
				<FullBonusGetMode>
					<xsl:value-of select="FullBonusGetMode" />
				</FullBonusGetMode>
				<!-- ��ȡ���������־ -->
				<GetYearFlag>
					<xsl:value-of select="GetYearFlag" />
				</GetYearFlag>
				<!-- ��ȡ�������� -->
				<GetYear>
					<xsl:value-of select="GetYear" />
				</GetYear>
				<!-- ��ȡƵ�� -->
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
		<!-- ���� -->
		<Name>
			<xsl:value-of select="Appnt/Name" />
		</Name>
		<!-- �Ա� -->
		<Sex>
			<xsl:value-of select="Appnt/Sex" />
		</Sex>
		<!-- �������� -->
		<Birthday>
			<xsl:value-of select="Appnt/Birthday" />
		</Birthday>
		<!-- ֤������ -->
		<IDType>
			<xsl:value-of select="Appnt/IDType" />
		</IDType>
		<!-- ֤����� -->
		<IDNo>
			<xsl:value-of select="Appnt/IDNo" />
		</IDNo>
		<!-- ֤����Ч���� -->
		<IDTypeStartDate>
			<xsl:value-of select="Appnt/IDTypeStartDate" />
		</IDTypeStartDate>
		<!-- ֤����Чֹ�� -->
		<IDTypeEndDate>
			<xsl:value-of select="Appnt/IDTypeEndDate" />
		</IDTypeEndDate>
		<!-- ְҵ���� -->
		<JobCode>
			<xsl:value-of select="Appnt/JobCode" />
		</JobCode>
		<!-- �����˼�ͥ���� -->
		<Salary><xsl:value-of select="Appnt/Salary" /></Salary>
		<!-- Ͷ���˼�ͥ���� -->
		<FamilySalary><xsl:value-of select="Appnt/FamilySalary" /></FamilySalary>
		<!-- ��ס���� -->
		<LiveZone><xsl:value-of select="Appnt/LiveZone" /></LiveZone>
		<!-- Ͷ������Ҫ������Դ -->
		<SalarySource><xsl:value-of select="Appnt/SalarySource" /></SalarySource>
		<!-- Ͷ���˼�ͥ��������Ҫ��Դ -->
		<FamilySalarySource><xsl:value-of select="Appnt/FamilySalarySource" /></FamilySalarySource>
		<!--  Ͷ���˱���Ԥ�㣬��λ���� -->
		<PremBudget><xsl:value-of select="Appnt/PremBudget" /></PremBudget>
		<!-- ���� -->
		<Nationality>
			<xsl:value-of select="Appnt/Nationality" />
		</Nationality>
		<!-- ��ߣ�cm�� -->
		<Stature>
			<xsl:value-of select="Appnt/Stature" />
		</Stature>
		<!-- ���أ�kg�� -->
		<Weight>
			<xsl:value-of select="Appnt/Weight" />
		</Weight>
		<!-- ����״̬ -->
		<MaritalStatus>
			<xsl:value-of select="Appnt/MaritalStatus" />
		</MaritalStatus>
		<!-- ��ϵ��ַ -->
		<Address>
			<xsl:value-of select="Appnt/Address" />
		</Address>
		<!-- �ʱ� -->
		<ZipCode>
			<xsl:value-of select="Appnt/ZipCode" />
		</ZipCode>
		<!-- �ֻ��� -->
		<Mobile>
			<xsl:value-of select="Appnt/Mobile" />
		</Mobile>
		<!-- �绰�� -->
		<Phone>
			<xsl:value-of select="Appnt/Phone" />
		</Phone>
		<!-- ���� -->
		<Email>
			<xsl:value-of select="Appnt/Email" />
		</Email>
		<!-- Ͷ�����뱻���˹�ϵ -->
		<RelaToInsured>
			<xsl:value-of select="Appnt/RelaToInsured" />
		</RelaToInsured>
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
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='122010'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>	 <!-- �������Ӯ���ռƻ� -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������������ -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">Y</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='122010'">A</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">A</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			<xsl:when test="$riskcode='L12089'">A</xsl:when><!-- ����ʢ��1���������գ������ͣ�B�� --> 
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������� -->
	<xsl:template name="tran_InsuYear">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">5</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='122010'">106</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">106</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			<xsl:when test="$riskcode='L12089'">106</xsl:when><!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ��������� -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">Y</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='122010'">Y</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">Y</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����� -->
	<xsl:template name="tran_PayEndYear">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122009'">1000</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode='122010'">1000</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">1000</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
