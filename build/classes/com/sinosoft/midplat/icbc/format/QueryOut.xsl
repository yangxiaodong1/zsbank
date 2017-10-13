<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID></TransRefGUID>
				<TransType>1010</TransType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body" />
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">

		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />

		<OLifE>
			<Holding id="cont">
				<CurrencyTypeCode>001</CurrencyTypeCode>
				<!-- ������Ϣ -->
				<Policy>
					<!--  ������ -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!--  ���մ��� -->
					<ProductCode>
						<xsl:apply-templates
							select="$MainRisk/RiskCode" />
					</ProductCode>
					<!-- ����״̬ -->
					<PolicyStatus></PolicyStatus>
					<!--  �ɷѷ�ʽ -->
					<PaymentMode>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
					</PaymentMode>
					<!--  �ɷ���ʽ -->
					<PaymentMethod>1</PaymentMethod>
					<!--  ���ڱ���-->
					<PaymentAmt>
						<xsl:value-of select="ActSumPrem" />
					</PaymentAmt>
					<!--  �����ʻ�20�ֽ� -->
					<AccountNumber></AccountNumber>
					<!--  �ʻ�����10�ֽ� -->
					<AcctHolderName></AcctHolderName>
					<!--  �ʻ����� -->
					<BankAcctType></BankAcctType>
					<!--  ���б���10�ֽ� -->
					<BankName></BankName>
					<Life>
						<!--  �潻��־/������־ ��ʾ�ǵ潻 -->
						<PremOffsetMethod />
						<!--  ������ȡ��ʽ -->
						<DivType>
							<xsl:apply-templates
								select="$MainRisk/BonusGetMode" />
						</DivType>
						<xsl:choose>
							<xsl:when test="ContPlan/ContPlanCode=''">
								<!--  ���ֳ���-->
								<!--  ����ѭ������-->
								<CoverageCount>
									<xsl:value-of select="count(Risk)" />
								</CoverageCount>
								<!--  ������Ϣ-->
								<xsl:apply-templates select="Risk" />
							</xsl:when>
							<xsl:otherwise>
								<!--  �ײͳ���-->
								<!--  ����ѭ������-->
								<CoverageCount>1</CoverageCount>
								<!--  ������Ϣ-->
								<xsl:apply-templates
									select="Risk[RiskCode=MainRiskCode]" />
							</xsl:otherwise>
						</xsl:choose>
					</Life>

					<!--������Ϣ-->
					<ApplicationInfo>
						<!--Ͷ�����-->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo" />
						</HOAppFormNumber>
						<!--  Ͷ������8�ֽ�  -->
						<SubmissionDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/PolApplyDate)" />
						</SubmissionDate>
					</ApplicationInfo>

					<OLifEExtension>
						<!-- ���պ�ͬ��Ч���� -->
						<ContractEffDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)" />
						</ContractEffDate>
						<!-- ���պ�ͬ�������� -->
						<ContractEndDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/InsuEndDate)" />
						</ContractEndDate>
						<!-- �������� -->
						<CovType></CovType>
						<!-- �������� -->
						<CovArea></CovArea>
						<!-- �������ޣ��죩 -->
						<CovPeriod></CovPeriod>
						<!-- �ܱ��� -->
						<GrossPremAmt>
							<xsl:value-of select="ActSumPrem" />
						</GrossPremAmt>
					</OLifEExtension>
				</Policy>
			</Holding>

			<!-- Ͷ������Ϣ -->
			<xsl:apply-templates select="Appnt" />
			<!-- ��������Ϣ -->
			<xsl:apply-templates select="Insured" />
			<!-- ��������Ϣ -->
			<xsl:apply-templates select="Bnf" />

			<!-- ��������Ϣ -->
			<Party id="agent">
				<FullName>
					<xsl:value-of select="//Body/AgentName" />
				</FullName>
				<Person />
				<Producer />
			</Party>

			<!-- 84�����˹�ϵ -->
			<Relation OriginatingObjectID="cont" RelatedObjectID="agent"
				id="r_cont_agent">
				<OriginatingObjectType>4</OriginatingObjectType>
				<RelatedObjectType>6</RelatedObjectType>
				<RelationRoleCode tc="84">84</RelationRoleCode>
			</Relation>

			<!-- ���չ�˾��Ϣ -->
			<Party id="com">
				<!-- ���չ�˾���� -->
				<FullName>
					<xsl:value-of select="ComName" />
				</FullName>
				<!-- ���չ�˾��ַ -->
				<Address>
					<AddressTypeCode tc="2">2</AddressTypeCode>
					<Line1>
						<xsl:value-of select="ComLocation" />
					</Line1>
					<Zip>
						<xsl:value-of select="ComZipCode" />
					</Zip>
				</Address>
				<!-- ���չ�˾�绰 -->
				<Phone>
					<PhoneTypeCode tc="2">2</PhoneTypeCode>
					<DialNumber>95569</DialNumber>
				</Phone>
				<!-- ��˾���� -->
				<Carrier>
					<CarrierCode>044</CarrierCode>
				</Carrier>
			</Party>

			<!-- 85�а���˾��ϵ -->
			<Relation OriginatingObjectID="cont" RelatedObjectID="com"
				id="r_cont_com">
				<OriginatingObjectType>4</OriginatingObjectType>
				<RelatedObjectType>6</RelatedObjectType>
				<RelationRoleCode tc="85">85</RelationRoleCode>
			</Relation>
		</OLifE>

	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('risk_', string(position()))" />
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode=''">
					<!--  ���ֳ���-->
					<!-- �������� -->
					<PlanName>
						<xsl:value-of select="RiskName" />
					</PlanName>
				</xsl:when>
				<xsl:otherwise>
					<!--  �ײͳ���-->
					<!-- �������� -->
					<PlanName>
						<xsl:value-of select="../ContPlan/ContPlanName" />
					</PlanName>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ���ִ��� -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode" />
			</ProductCode>
			<!-- �������� -->
			<LifeCovTypeCode>9</LifeCovTypeCode>
			<!-- �����ձ�־ -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when>
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise>
			</xsl:choose>
			<!--  �ɷѷ�ʽ  -->
			<PaymentMode>
				<xsl:apply-templates select="PayIntv" />
			</PaymentMode>
			<!-- Ͷ����� -->
			<InitCovAmt>
				<xsl:value-of select="Amnt" />
			</InitCovAmt>
			<!-- Ͷ���ݶ� -->
			<IntialNumberOfUnits>
				<xsl:value-of select="Mult" />
			</IntialNumberOfUnits>
			<!-- ���ֱ��� -->
			<ModalPremAmt>
				<xsl:value-of select="ActPrem" />
			</ModalPremAmt>
			<!-- ������ -->
			<EffDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)" />
			</EffDate>
			<!-- ��ֹ���� -->
			<TermDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(InsuEndDate)" />
			</TermDate>
			<!-- �ɷ���ֹ���� -->
			<FinalPaymentDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(PayEndDate)" />
			</FinalPaymentDate>
			<BenefitPeriod tc="1" />
			<BenefitMode tc="1"></BenefitMode>
			<Duration></Duration>
			<!-- �ɷ�����/�������� -->
			<OLifEExtension>
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<!-- ���� -->
						<PaymentDurationMode>5</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when>
					<xsl:otherwise>
						<!-- ������ -->
						<PaymentDurationMode>
							<xsl:apply-templates
								select="PayEndYearFlag" />
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear" />
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>
				<!-- ��ȡ��ʼ���� -->
				<PayoutStart></PayoutStart>
				<!-- ��ȡ��ֹ����  -->
				<PayoutEnd />
				<!-- �����ڼ� -->
				<xsl:choose>
					<xsl:when
						test="(InsuYear= 106) and (InsuYearFlag = 'A')">
						<!-- ������ -->
						<DurationMode>5</DurationMode>
						<Duration>999</Duration>
					</xsl:when>
					<xsl:otherwise>
						<!-- �Ǳ����� -->
						<DurationMode>
							<xsl:apply-templates select="InsuYearFlag" />
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear" />
						</Duration>
					</xsl:otherwise>
				</xsl:choose>

				<!--  �����ӷ�  -->
				<HealthPrem></HealthPrem>
				<!--  ְҵ�ӷ�  -->
				<JobPrem></JobPrem>
				<!--  �������� -->
				<BonusAmnt></BonusAmnt>
				<!--  ���շ���  -->
				<PremRate></PremRate>
			</OLifEExtension>
		</Coverage>
	</xsl:template>

	<xsl:template match="Appnt">
		<!-- Ͷ������Ϣ -->
		<Party id="appnt">
			<!-- Ͷ�������� -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- Ͷ����֤������ -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<!-- Ͷ����֤���� -->
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- Ͷ�����Ա� -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- Ͷ���˳������� -->
				<BirthDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)" />
				</BirthDate>
			</Person>
			<!-- Ͷ���˾�ס�ص�ַ -->
			<Address>
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<!-- ��ͥ�绰 -->
			<Phone>
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<!-- �ƶ��绰 -->
			<Phone>
				<PhoneTypeCode tc="3">3</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
		</Party>

		<!-- Ͷ���˹�ϵ -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="appnt"
			id="r_cont_appnt">
			<OriginatingObjectType>4</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode tc="80">80</RelationRoleCode>
		</Relation>

		<!-- Ͷ�����뱻���˵Ĺ�ϵ -->
		<Relation OriginatingObjectID="insured" RelatedObjectID="appnt"
			id="r_insured_appnt">
			<OriginatingObjectType>6</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:value-of select="RelaToInsured" />
			</RelationRoleCode>
		</Relation>
	</xsl:template>


	<xsl:template match="Insured">
		<!-- ��������Ϣ -->
		<Party id="insured">
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<BirthDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)" />
				</BirthDate>
			</Person>
			<Address><!-- �ʼĵ�ַ -->
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone><!-- ��ͥ�绰 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone><!-- �ƶ��绰 -->
				<PhoneTypeCode tc="3">3</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
		</Party>

		<!-- �����˹�ϵ -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="insured"
			id="r_cont_insured">
			<OriginatingObjectType>4</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode tc="81">81</RelationRoleCode>
		</Relation>
	</xsl:template>

	<xsl:template match="Bnf">
		<xsl:variable name="BnfId"
			select="concat('bnf_', string(position()))" />
		<!-- ��������Ϣ -->
		<Party>
			<xsl:attribute name="id"><xsl:value-of select="$BnfId" />
			</xsl:attribute>
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<BirthDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)" />
				</BirthDate>
			</Person>
		</Party>

		<!-- �����˹�ϵ -->
		<Relation OriginatingObjectID="cont">
			<xsl:attribute name="RelatedObjectID"><xsl:value-of
					select="$BnfId" />
			</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('r_cont_', $BnfId)" />
			</xsl:attribute>
			<OriginatingObjectType>4</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode tc="82">82</RelationRoleCode>
			<Sequence>
				<xsl:value-of select="Grade" />
			</Sequence>
			<InterestPercent>
				<xsl:value-of select="Lot" />
			</InterestPercent>
		</Relation>

		<!-- �������뱻���˹�ϵ -->
		<Relation OriginatingObjectID="insured">
			<xsl:attribute name="RelatedObjectID"><xsl:value-of
					select="$BnfId" />
			</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('r_insured_', $BnfId)" />
			</xsl:attribute>
			<OriginatingObjectType>6</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:value-of select="RelaToInsured" />
			</RelationRoleCode>
		</Relation>

	</xsl:template>

	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- �� -->
			<xsl:when test=".='1'">2</xsl:when><!-- Ů -->
			<xsl:when test=".='2'">3</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������-->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='5'">6</xsl:when><!-- ���ڲ�  -->
			<xsl:when test=".='8'">7</xsl:when><!-- ����  -->
			<xsl:when test=".='9'">0</xsl:when><!-- �쳣���֤  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ϵ -->
	<xsl:template name="tran_RelationRoleCode" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='02'">1</xsl:when><!-- ��ż -->
			<xsl:when test=".='01'">2</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='03'">3</xsl:when><!-- ��Ů -->
			<xsl:when test=".='00'">8</xsl:when><!-- ���� -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122001'">001</xsl:when><!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122002'">002</xsl:when><!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122004'">101</xsl:when><!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122003'">003</xsl:when><!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122006'">004</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122008'">005</xsl:when><!-- ���������1���������գ������ͣ� -->
			<xsl:when test=".='122009'">006</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122011'">007</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test=".='122012'">008</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122010'">009</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122029'">010</xsl:when><!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".='122020'">011</xsl:when><!-- �����6����ȫ���գ��ֺ��ͣ�  -->
			<xsl:when test=".='122036'">012</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			<!-- <xsl:when test=".='122046'">013</xsl:when> --><!-- �������Ӯ1��  -->  
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->	
			<xsl:when test=".='L12079'">008</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12100'">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">014</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='122046'">013</xsl:when>	<!-- �������Ӯ��122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����  -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
			<xsl:when test=".='L12077'">008</xsl:when> 	<!-- �㽭����ר����Ʒ������������ʢ��2���������գ������ͣ� -->
			<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
			<!-- PBKINSR-925 ���������ն������²�Ʒ�������Ӯ2�������A� -->
			<xsl:when test=".='L12084'">015</xsl:when>	<!-- �����Ӯ2�������A��  -->
			<xsl:when test=".='L12086'">018</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12102'">014</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12093'">017</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ�  -->
			<xsl:when test=".='L12088'">L12088</xsl:when>	<!-- �����9����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">2</xsl:when><!-- �½� -->
			<xsl:when test=".='6'">3</xsl:when><!-- ����� -->
			<xsl:when test=".='3'">4</xsl:when><!-- ���� -->
			<xsl:when test=".='0'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='-1'">6</xsl:when><!-- ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ս����ڱ�־��ת�� -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">4</xsl:when><!-- �� -->
			<xsl:when test=".='M'">3</xsl:when><!-- �� -->
			<xsl:when test=".='Y'">2</xsl:when><!-- �� -->
			<xsl:when test=".='A'">1</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when><!-- ����ĳȷ������  -->
			<xsl:when test=".='Y'">2</xsl:when><!-- �걣  -->
			<xsl:when test=".='M'">3</xsl:when><!-- �±�  -->
			<xsl:when test=".='D'">4</xsl:when><!-- �ձ�  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ��ת�� -->
	<xsl:template match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='3'">3</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".='1'">1</xsl:when><!-- �ֽ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
