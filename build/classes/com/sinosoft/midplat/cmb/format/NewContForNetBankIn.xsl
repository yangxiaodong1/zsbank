<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<!-- ����������Ϣ -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Holding/Policy" />

				<!-- Ͷ���� -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=25]" />

				<!-- ������ -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=32]" />

				<!-- ������ (�Ƿ����ǲŽ���)-->
				<xsl:if test="TXLife/TXLifeRequest/OLife/Holding/Policy/OLifeExtension/BeneficiaryIndicator != 'Y'">
					<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=34]" />
				</xsl:if>
				<!-- ���� -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
			<SourceType>
				<xsl:apply-templates select="OLifeExtension/TransChannel" />
			</SourceType>
		</Head>
	</xsl:template>

	<!-- ����������Ϣ -->
	<xsl:template name="Body" match="Policy">
		<xsl:variable name="insuredPartyID" select="../../Relation[RelationRoleCode=32]/@RelatedObjectID" />
		<xsl:variable name="tellInfos" select="../../OLifeExtension/TellInfos" />
		<!-- Ͷ������ -->
		<ProposalPrtNo>
			<xsl:value-of select="ApplicationInfo/HOAppFormNumber" />
		</ProposalPrtNo>
		<!-- ����ӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="../../FormInstance[FormName='PolicyPrintNumber']/ProviderFormNumber" />
		</ContPrtNo>
		
		<!-- ����Ա���� -->
		<SellerNo>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" />
		</SellerNo>
		<!-- �����Ƽ���Ա�������� -->
		<BankSaler><xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" /></BankSaler>
		<!-- ����Ա������ -->
		<TellerName>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='002']/TellContent" />
		</TellerName>
		<!-- ����Ա������ -->
		<TellerCertiCode>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='003']/TellContent" />
		</TellerCertiCode>
		<!-- �������� -->
		<AgentComName>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='004']/TellContent" />
		</AgentComName>
		
		<!-- Ͷ������ -->
		<PolApplyDate>
			<xsl:value-of select="ApplicationInfo/SubmissionDate" />
		</PolApplyDate>
		<!-- ������֪ -->
		<HealthNotice>
			<xsl:apply-templates select="OLifeExtension/HealthIndicator" />
		</HealthNotice>
		<!-- �˻��� -->
		<AccName>
			<xsl:value-of select="AcctHolderName" />
		</AccName>
		<!-- �˻��� -->
		<AccNo>
			<xsl:value-of select="AccountNumber" />
		</AccNo>
		<!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
		<PolicyDeliveryMethod>
			<xsl:apply-templates select="OLifeExtension/PolicyDeliveryMethod" />
		</PolicyDeliveryMethod>
		
		<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
		<PolicyIndicator></PolicyIndicator>
		<!--�ۼ�Ͷ����ʱ���-->
		<xsl:choose>
			<xsl:when
				test="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='002']/TellContent > 0">
				<InsuredTotalFaceAmount>
					<xsl:value-of
						select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='002']/TellContent*0.01" />
				</InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount />
			</xsl:otherwise>
		</xsl:choose>
		<!--�籣��֪-->
		<SocialInsure>
			<xsl:value-of
				select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='003']/TellContent" />
		</SocialInsure>
		<!--����ҽ�Ƹ�֪-->
    	<FreeMedical>
			<xsl:value-of
				select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='004']/TellContent" />
    	</FreeMedical>
		<!--����ҽ�Ƹ�֪-->
    	<OtherMedical>
			<xsl:value-of
				select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='005']/TellContent" />
    	</OtherMedical>
    	
    	<!-- ��Ʒ��� -->
		<ContPlan>
			<!-- ��Ʒ��ϱ��� -->
			<ContPlanCode><xsl:apply-templates select="//Coverage[IndicatorCode='1']/ProductCode"  mode="contplan"/></ContPlanCode>
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult><xsl:value-of select="format-number(//Coverage[IndicatorCode='1']/IntialNumberOfUnits,'#')" /></ContPlanMult>
		</ContPlan>
	</xsl:template>

	<!-- Ͷ���� -->
	<xsl:template name="Appnt" match="Relation[RelationRoleCode='25']">
		<!-- Ͷ����id -->
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<!-- Ͷ���˽ڵ� -->
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<!-- ������id -->
		<xsl:variable name="InsuredPartyID"
			select="../Relation[RelationRoleCode='32']/@RelatedObjectID" />
		<!-- �����˽ڵ� -->
		<xsl:variable name="InsuredPartyNode"
			select="../Party[@id=$InsuredPartyID]" />

		<Appnt>
			<!-- ͨ��ģ�����Ͷ������Ϣ -->
			<xsl:apply-templates select="$PartyNode" />
			<!-- ���Ӿ�ס���� liying -->
			<LiveZone>
				<xsl:value-of
							select="../OLifeExtension/TellInfos/TellInfo[@TellInfoKey=$PartyID and TellCode='TWN']/TellContent" />
			</LiveZone>
			
			<!-- Ͷ���˺ͱ���������Ϣ -->
			<!-- �˴���Ҫע��һ�£����������������и���Ͷ���������˹�ϵ���ڹ�̨�и���RelatedObjectID��OriginatingObjectID��ֵ�෴����Щȡֵ���̨��ȡֵ��һ�� -->
			<!-- ������������Ը�bug���е����������е�������˾�������¸��Ĳ��� -->
			
			<RelaToInsured>
				<xsl:call-template name="tran_RelaToInsured">
					<xsl:with-param name="rela">
					<!-- �˴���Ҫע��$PartyID��$InsuredPartyID��ֵ����̨������OriginatingObjectID="Party_1" RelatedObjectID="Party_2"
						 ������ȴ�ǣ�OriginatingObjectID="Party_2" RelatedObjectID="Party_1"��
						 �������������ȡֵ����Ϊ����������Ტ�棬�������л��޸�˳�����˾�޷�����
						 -->
						<xsl:value-of
							select="../Relation[@RelatedObjectID=$PartyID and @OriginatingObjectID=$InsuredPartyID]/RelationRoleCode" />
						<xsl:value-of
							select="../Relation[@RelatedObjectID=$InsuredPartyID and @OriginatingObjectID=$PartyID]/RelationRoleCode" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
			
		</Appnt>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Insured"
		match="Relation[RelationRoleCode=32]">
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<Insured>
			<!-- ͨ��ģ�������������Ϣ -->
			<xsl:apply-templates select="$PartyNode" />
		</Insured>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Bnf" match="Relation[RelationRoleCode=34]">
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<!-- ������id -->
		<xsl:variable name="InsuredPartyID" select="../Relation[RelationRoleCode='32']/@RelatedObjectID" />
		<!-- �����˽ڵ� -->
		<xsl:variable name="InsuredPartyNode" select="../Party[@id=$InsuredPartyID]" />
		<Bnf>
			<Type>1</Type>
			<!-- ͨ��ģ�������������Ϣ -->
			<xsl:apply-templates select="$PartyNode" />
			<!--  ˳��  -->
			<Grade>
				<xsl:value-of select="Sequence" />
			</Grade>
			<!-- ������� -->
			<Lot>
				<xsl:value-of select="InterestPercent" />
			</Lot>
			<!--  �������뱻���˹�ϵ  -->
			<RelaToInsured>
				<xsl:call-template name="tran_BnfRelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="../Relation[@RelatedObjectID=$PartyID and @OriginatingObjectID=$InsuredPartyID]/RelationRoleCode" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Bnf>
	</xsl:template>

	<!-- ͨ����Աģ�� -->
	<xsl:template name="common_person" match="Party">
		<!-- ����-->
		<Name>
			<xsl:value-of select="FullName" />
		</Name>
		<!-- �Ա�-->
		<Sex>
			<xsl:apply-templates select="Person/Gender" />
		</Sex>
		<!-- ����-->
		<Birthday>
			<xsl:value-of select="Person/BirthDate" />
		</Birthday>
		<!-- ֤������-->
		<IDType>
			<xsl:apply-templates select="GovtIDTC" />
		</IDType>
		<!-- ֤����-->
		<IDNo>
			<xsl:value-of select="GovtID" />
		</IDNo>
		<!-- ְҵ����-->
		<JobCode>
			<xsl:apply-templates select="Person/OccupClass" />
		</JobCode>
		<!-- ����-->
		<Nationality>
			<xsl:apply-templates select="Person/Citizenship" />
		</Nationality>
		<!-- ���(cm)  ��ֵ-->
		<Stature><xsl:apply-templates select="Person/Height/MeasureValue" /></Stature>
		<!-- ����(Kg)  ��ֵ-->
		<Weight><xsl:apply-templates select="Person/Weight/MeasureValue" /></Weight>
		<!-- ������ -->
		<Salary>
			<xsl:choose>
				<xsl:when test="Person/EstSalary=''"><xsl:value-of select="Person/EstSalary" /></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Person/EstSalary)" />
				</xsl:otherwise>
			</xsl:choose>
		</Salary>
		<!-- ֤����Ч���� -->
		<IDTypeStartDate></IDTypeStartDate>
		<!-- ֤����Чֹ�� -->
		<xsl:choose>
			<xsl:when test="Person/VisaExpDate > 0">
				<IDTypeEndDate>
					<xsl:value-of select="Person/VisaExpDate" />
				</IDTypeEndDate>
			</xsl:when>
			<xsl:otherwise>
				<IDTypeEndDate/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- ���  ��ֵ-->
		<MaritalStatus></MaritalStatus>
		<!-- ��ַ-->
		<Address>
			<xsl:value-of select="Address[AddressTypeCode='1']/Line1" />
		</Address>
		<!-- �ʱ�-->
		<ZipCode>
			<xsl:value-of select="Address[AddressTypeCode='1']/Zip" />
		</ZipCode>
		<!-- �ֻ�-->
		<Mobile>
			<xsl:value-of select="Phone[PhoneTypeCode='12']/DialNumber" />
		</Mobile>
		<!-- ����-->
		<Phone>
			<xsl:choose>
 			<xsl:when test="Phone[PhoneTypeCode='1']/DialNumber != ''">
					<xsl:value-of select="Phone[PhoneTypeCode='1']/DialNumber" />
				</xsl:when>	<!--  Ͷ����סլ�绰���̻���  -->
				<xsl:otherwise>
					<xsl:value-of select="Phone[PhoneTypeCode='7']/DialNumber" />
				</xsl:otherwise><!--  Ͷ���˰칫�绰  -->
			</xsl:choose>

		</Phone>
		<!-- email-->
		<Email>
			<xsl:value-of select="EMailAddress/AddrLine" />
		</Email>
	</xsl:template>

	<!-- ���� -->
	<xsl:template name="Risk" match="Coverage">
		<Risk>
			<!-- ���ֺ� -->
			<RiskCode>
				<xsl:apply-templates select="ProductCode"   mode="risk"/>
			</RiskCode>
			<!-- ���պ� -->
			<MainRiskCode>
				<xsl:apply-templates select="../Coverage[IndicatorCode='1']/ProductCode"   mode="risk"/>
			</MainRiskCode>
			<!--  ��������  -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InitCovAmt)" />
			</Amnt>
			<!--  ��������  -->
			<Prem>
				<xsl:variable name="Prem" select="ChargeTotalAmt" />
				<xsl:variable name="Mult" select="IntialNumberOfUnits" />
				<xsl:choose>
					<xsl:when test="$Prem=0.00 or $Prem=''">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Mult * 1000 )" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Prem)" />
					</xsl:otherwise>
				</xsl:choose>
			</Prem>
			<!--  Ͷ������  -->
			<Mult>
				<xsl:value-of select="format-number(IntialNumberOfUnits,'#')" />
			</Mult>
			<!--  ���ѷ�ʽ  -->
			<PayIntv>
				<xsl:apply-templates select="PaymentMode" />
			</PayIntv>
			<PayMode></PayMode>

			<xsl:choose>
				<!-- ������ -->
				<xsl:when test="OLifeExtension/DurationMode='Y' and OLifeExtension/Duration=100">
					<InsuYearFlag>A</InsuYearFlag>
					<InsuYear>106</InsuYear>
				</xsl:when>
				<xsl:otherwise>
					<!--  ��������/�����־  -->
					<InsuYearFlag>
						<xsl:apply-templates select="OLifeExtension/DurationMode" />
					</InsuYearFlag>
					<!--  ��������  -->
					<InsuYear>
						<xsl:value-of select="OLifeExtension/Duration" />
					</InsuYear>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<!-- ���� -->
				<xsl:when test="PaymentMode='0'">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise><!-- ���� -->
					<!--  ��������/��������  -->
					<PayEndYearFlag>
						<xsl:apply-templates select="OLifeExtension/PaymentDurationMode" />
					</PayEndYearFlag>
					<!--  ��������/����  -->
					<PayEndYear>
						<xsl:value-of select="OLifeExtension/PaymentDuration" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<!--  ������ȡ��ʽ  -->
			<BonusGetMode>
				<xsl:apply-templates select="../DivType" />
			</BonusGetMode>
			<SpecContent></SpecContent>
			<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ ����-->
			<GetYearFlag></GetYearFlag><!-- ��ȡ�������ڱ�־����-->
			<GetYear></GetYear><!-- ��ȡ���� ����-->
			<GetIntv></GetIntv>
			<GetBankCode></GetBankCode><!-- ��ȡ���б��� ����-->
			<GetBankAccNo></GetBankAccNo><!-- ��ȡ�����˻� ����-->
			<GetAccName></GetAccName><!-- ��ȡ���л���  ����-->
			<AutoPayFlag></AutoPayFlag><!-- �Զ��潻��־ ����-->
		</Risk>
	</xsl:template>


	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Gender">
		<xsl:choose>
			<xsl:when test=".='M'">0</xsl:when><!-- �� -->
			<xsl:when test=".='F'">1</xsl:when><!-- Ů -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ְҵ���� -->
	<xsl:template name="tran_jobCode" match="OccupClass">
		<xsl:choose>
			<xsl:when test=".='01'">4030111</xsl:when><!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".='02'">2050101</xsl:when><!-- ����רҵ������Ա                       -->
			<xsl:when test=".='03'">2070109</xsl:when><!-- ����ҵ����Ա                           -->
			<xsl:when test=".='04'">2080103</xsl:when><!-- ����רҵ��Ա                           -->
			<xsl:when test=".='05'">2090104</xsl:when><!-- ��ѧ��Ա                               -->
			<xsl:when test=".='06'">2100106</xsl:when><!-- ���ų��漰��ѧ����������Ա             -->
			<xsl:when test=".='07'">2130101</xsl:when><!-- �ڽ�ְҵ��                             -->
			<xsl:when test=".='08'">3030101</xsl:when><!-- �����͵���ҵ����Ա                     -->
			<xsl:when test=".='09'">4010101</xsl:when><!-- ��ҵ������ҵ��Ա                       -->
			<xsl:when test=".='10'">5010107</xsl:when><!-- ũ���֡������桢ˮ��ҵ������Ա         -->
			<xsl:when test=".='11'">6240105</xsl:when><!-- ������Ա                               -->
			<xsl:when test=".='12'">2020103</xsl:when><!-- ��ַ��̽��Ա                           -->
			<xsl:when test=".='13'">2020906</xsl:when><!-- ����ʩ����Ա                           -->
			<xsl:when test=".='14'">6050611</xsl:when><!-- �ӹ����졢���鼰������Ա               -->
			<xsl:when test=".='15'">7010103</xsl:when><!-- ����                                   -->
			<xsl:when test=".='16'">8010101</xsl:when><!-- ��ҵ                                   -->
			<xsl:when test=".='17'">8010104</xsl:when><!-- ��ͥ����                               -->
			<xsl:when test=".='18'">8010102</xsl:when><!-- ��������Ա���޼�ְ��                   -->
			<xsl:when test=".='19'">2090114</xsl:when><!-- һ��ѧ��                               -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="GovtIDTC">
		<xsl:choose>
			<xsl:when test=".='P01'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='P03'">9</xsl:when><!-- ��ʱ���֤  -->
			<xsl:when test=".='P04'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='P08'">8</xsl:when><!-- ����  -->
			<xsl:when test=".='P16'">5</xsl:when><!-- ���ڱ�  -->
			<xsl:when test=".='P18'">8</xsl:when><!-- ͨ��֤  -->
			<xsl:when test=".='P19'">8</xsl:when><!-- ����֤  -->
			<xsl:when test=".='P31'">1</xsl:when><!-- ���� -->
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:when test=".='P20'">6</xsl:when><!-- �۰Ļ���֤ -->
			<xsl:when test=".='P21'">7</xsl:when><!-- ̨��֤ -->
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ϵ �����Ǳ���������Ͷ���˵�ĳĳ-->
	<xsl:template name="tran_RelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='1'">00</xsl:when><!-- ���� -->
			<xsl:when test="$rela='2'">03</xsl:when><!-- ��ĸ -->
			<xsl:when test="$rela='3'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$rela='4'">01</xsl:when><!-- ��Ů -->
			<xsl:when test="$rela='5'">04</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- �������뱻�����˵Ĺ�ϵ-->
	<xsl:template name="tran_BnfRelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='1'">00</xsl:when><!-- ���� -->
			<xsl:when test="$rela='2'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$rela='3'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$rela='4'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$rela='5'">04</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>


	<!-- ���ִ��� -->
	<xsl:template match="ProductCode"  mode="risk">
		<xsl:choose>
		
		<!-- <xsl:when test=".='L12089'">L12089</xsl:when> --><!-- ����ʢ��1���������գ������ͣ�B��  -->		
		<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
		<!-- PBKINSR-1358 zx add -->
		<!-- <xsl:when test=".='L12087'">L12087</xsl:when> --><!-- �����5����ȫ���գ������ͣ�  -->
		<!-- PBKINSR- zx add -->
		<!--<xsl:when test=".='L12086'">L12086</xsl:when> --> <!-- �����3����ȫ���գ������ͣ�  -->
		<!-- PBKINSR-1531 ������������9�� L12088 zx add 20160805 -->
		<!--<xsl:when test=".='L12088'">L12088</xsl:when>-->
		
		<xsl:when test=".='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
		<!-- PBKINSR-518 �����������߻ƽ�5�Ų�Ʒ���ݲ����� -->
		<!-- �ݲ�����	<xsl:when test=".='122009'">122009</xsl:when>--><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->	
		<!-- PBKINSR-518 �����������߻ƽ�5�Ų�Ʒ -->	
		<!-- PBKINSR-517 ������������ʢ9 -->
			<xsl:when test=".='122035'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<!-- PBKINSR-517 ������������ʢ9 -->
		<!-- PBKINSR-514 ������������ʢ3 -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
		<!-- PBKINSR-514 ������������ʢ3 -->
		<!--add 20160105 PBKINSR-1012  ��������������Ʒ��������Ӯ begin -->
		<xsl:when test=".='50002'">50015</xsl:when><!-- �������Ӯ1����ȫ����-->
		<!--add 20160105 PBKINSR-1012  ��������������Ʒ��������Ӯ end-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template  match="ProductCode" mode="contplan">
	    <xsl:choose>
	       <!--add 20160105 PBKINSR-1012  ��������������Ʒ��������Ӯ begin -->
	       <xsl:when test=".='50002'">50015</xsl:when><!-- �������Ӯ1����ȫ����-->
	       <!--add 20160105 PBKINSR-1012  ��������������Ʒ��������Ӯ end-->
	       <xsl:otherwise></xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<xsl:template name="tran_payintv" match="PaymentMode">
		<xsl:choose>
			<xsl:when test=".='12'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�����/�������� -->
	<xsl:template name="tran_payendyearflag"
		match="PaymentDurationMode">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='M'">M</xsl:when><!-- �� -->
			<xsl:when test=".='D'">D</xsl:when><!-- �� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag" match="DurationMode">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- �걣 -->
			<xsl:when test=".='M'">M</xsl:when><!-- �±� -->
			<xsl:when test=".='D'">D</xsl:when><!-- �ձ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ��ת�� -->
	<xsl:template name="tran_BonusGetMode" match="DivType">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".='2'">2</xsl:when><!-- ��ȡ�ֽ� -->
			<xsl:when test=".='3'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='5'">5</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������֪ -->
	<xsl:template match="HealthIndicator">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ����ת�� -->
	<xsl:template match="Citizenship">
		<xsl:choose>
			<xsl:when test=".='HUN'">HU</xsl:when><!--	������     -->
			<xsl:when test=".='USA'">US</xsl:when><!--	����     -->
			<xsl:when test=".='THA'">TH</xsl:when><!--	̩��     -->
			<xsl:when test=".='SGP'">SG</xsl:when><!--	�¼���   -->
			<xsl:when test=".='IND'">IN</xsl:when><!--  ӡ��   -->
			<xsl:when test=".='BEL'">BE</xsl:when><!--	����ʱ     -->
			<xsl:when test=".='NLD'">NL</xsl:when><!--	����     -->
			<xsl:when test=".='MYS'">MY</xsl:when><!--	�������� -->
			<xsl:when test=".='KOR'">KR</xsl:when><!--	����     -->
			<xsl:when test=".='JPN'">JP</xsl:when><!--	�ձ�     -->
			<xsl:when test=".='AUT'">AT</xsl:when><!--	�µ���   -->
			<xsl:when test=".='FRA'">FR</xsl:when><!--	����     -->
			<xsl:when test=".='ESP'">ES</xsl:when><!--	������   -->
			<xsl:when test=".='GBR'">GB</xsl:when><!--	Ӣ��     -->
			<xsl:when test=".='CAN'">CA</xsl:when><!--	���ô�   -->
			<xsl:when test=".='AUS'">AU</xsl:when><!--	�Ĵ����� -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	�й�     -->
			<xsl:otherwise>OTH</xsl:otherwise><!--	����     -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������ȡ����ת�� -->
	<xsl:template match="PolicyDeliveryMethod">
		<xsl:choose>
			<xsl:when test=".='5'">2</xsl:when><!--	���ӱ��� -->
			<xsl:otherwise>1</xsl:otherwise><!-- ֽ�ʱ��� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ���б�����������: 0=���棬1=������8=�����ն� -->
	<xsl:template match="TransChannel">
		<xsl:choose>
			<xsl:when test=".='DSK'">0</xsl:when><!--	����ͨ���� -->
			<xsl:when test=".='INT'">1</xsl:when><!--	���� -->
			<xsl:when test=".='IEX'">1</xsl:when><!--	���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
