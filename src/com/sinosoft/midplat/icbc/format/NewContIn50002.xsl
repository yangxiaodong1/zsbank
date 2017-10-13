<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">


	<!-- ��ϲ�Ʒ���� -->
	<xsl:variable name="ContPlanMult">
		<xsl:choose>
			<xsl:when test="TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits=''">
				<xsl:value-of select="TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits,'#')" />				
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>

	<!-- ����,�˴��ǲ�Ʒ��ϱ��� -->
	<xsl:variable name="ContPlanCode">
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/ProductCode" />
	</xsl:variable>
	
<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="TXLife/TXLifeRequest" />
	
	<Body>
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
		
		<!-- Ͷ���� -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=80]" />
		
		<!-- ������ -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=81]" />
		
		<!-- ������ -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=82]" />
		
		<!-- ���� -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="TXLifeRequest">
<Head>
	<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)"/></TranDate>
	<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)"/></TranTime>
	<TellerNo><xsl:value-of select="OLifEExtension/Teller"/></TellerNo>
	<TranNo><xsl:value-of select="TransRefGUID"/></TranNo>
	<NodeNo>
		<xsl:value-of select="OLifEExtension/RegionCode"/>
		<xsl:value-of select="OLifEExtension/Branch"/>
	</NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	<SourceType><xsl:value-of select="OLifEExtension/SourceType"/></SourceType>
</Head>
</xsl:template>

<xsl:template name="Body" match="Policy">
	<!--���������ʸ�֤-->
	<AgentComCertiCode><xsl:value-of select="BankBranchAgentId" /></AgentComCertiCode>
	<!--������������-->
	<AgentComName><xsl:value-of select="BankBranchName" /></AgentComName>
	<!--������Ա-->                
	<TellerName><xsl:value-of select="BankManagerName" /></TellerName>
	<!--��Ա�ʸ�֤-->
	<TellerCertiCode><xsl:value-of select="BankManagerAgentId" /></TellerCertiCode>
	<ProposalPrtNo><xsl:value-of select="ApplicationInfo/HOAppFormNumber" /></ProposalPrtNo>
	<ContPrtNo><xsl:value-of select="../../FormInstance[FormName='2']/ProviderFormNumber" /></ContPrtNo>
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ApplicationInfo/SubmissionDate)" /></PolApplyDate>
	<HealthNotice><xsl:value-of select="OLifEExtension/HealthIndicator" /></HealthNotice>
	
	<!-- ��Ʒ��� -->
	<ContPlan>
		<!-- ��Ʒ��ϱ��� -->
		<ContPlanCode><xsl:value-of select="$ContPlanCode" /></ContPlanCode>
		<!-- ��Ʒ��Ϸ��� -->
		<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
	</ContPlan>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt" match="Relation[RelationRoleCode=80]">
<xsl:variable name="PartyID" select="@RelatedObjectID" />
<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />

<AccName><xsl:value-of select="$PartyNode/FullName" /></AccName>	<!-- ���в����˻�����ȡͶ���� -->
<AccNo><xsl:value-of select="../Holding/Banking/AccountNumber" /></AccNo>

<Appnt>
	<Name><xsl:value-of select="$PartyNode/FullName" /></Name>
	<Sex><xsl:apply-templates select="$PartyNode/Person/Gender" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/Person/BirthDate)" /></Birthday>
	<IDType><xsl:apply-templates select="$PartyNode/GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="$PartyNode/GovtID" /></IDNo>	
	<JobCode>4030111</JobCode>
	<!-- Ͷ���������룬���з���λ:�֣����Ķ˵�λ���� -->
	<Salary>
		<xsl:value-of select="$PartyNode/Person/EstSalary" />
	</Salary>
	<!-- Ͷ���˼�ͥ�����룬���з���λ:�֣����Ķ˵�λ���� -->	
	<FamilySalary>
		<xsl:value-of select="$PartyNode/Person/FamilyEstSalary" />
	</FamilySalary>
	<!-- Ͷ������������ 1������2��ũ��-->
	<LiveZone><xsl:value-of select="$PartyNode/Person/LiveZone" /></LiveZone>
	
	<Nationality>CHN</Nationality>
	<Address><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Line1" /></Address>
    <ZipCode><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Zip" /></ZipCode>
    <Mobile><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='3']/DialNumber" /></Mobile>
    <Phone><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='1']/DialNumber" /></Phone>
    <Email><xsl:value-of select="$PartyNode/EMailAddress/AddrLine" /></Email>
    <RelaToInsured>
		<xsl:variable name="InsuredPartyID"	select="../Relation[RelationRoleCode='81']/@RelatedObjectID" />
		<xsl:apply-templates select="../Relation[@OriginatingObjectID=$InsuredPartyID and @RelatedObjectID=$PartyID]/RelationRoleCode" />
    </RelaToInsured>
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured" match="Relation[RelationRoleCode=81]">
<xsl:variable name="PartyID" select="@RelatedObjectID" />
<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />

<Insured>
	<Name><xsl:value-of select="$PartyNode/FullName" /></Name>
	<Sex><xsl:apply-templates select="$PartyNode/Person/Gender" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/Person/BirthDate)" /></Birthday>
	<IDType><xsl:apply-templates select="$PartyNode/GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="$PartyNode/GovtID" /></IDNo>	
	<JobCode>4030111</JobCode>
	<Nationality>CHN</Nationality>
	<Address><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Line1" /></Address>
    <ZipCode><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Zip" /></ZipCode>
    <Mobile><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='3']/DialNumber" /></Mobile>
    <Phone><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='1']/DialNumber" /></Phone>
    <Email><xsl:value-of select="$PartyNode/EMailAddress/AddrLine" /></Email>
</Insured>
</xsl:template>

<!-- ������ -->
<xsl:template name="Bnf" match="Relation[RelationRoleCode=82]">
<xsl:variable name="PartyID" select="@RelatedObjectID" />
<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />

<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="Sequence" /></Grade>
	<Name><xsl:value-of select="$PartyNode/FullName" /></Name>
	<Sex><xsl:apply-templates select="$PartyNode/Person/Gender" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/Person/BirthDate)" /></Birthday>
	<IDType><xsl:apply-templates select="$PartyNode/GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="$PartyNode/GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>	
	<RelaToInsured>
		<xsl:variable name="InsuredPartyID" select="../Relation[RelationRoleCode='81']/@RelatedObjectID" />
		<xsl:apply-templates select="../Relation[@OriginatingObjectID=$InsuredPartyID and @RelatedObjectID=$PartyID]/RelationRoleCode" />
	</RelaToInsured>
</Bnf>
</xsl:template>

<!-- ���� -->
<xsl:template name="Risk" match="Coverage">

<Risk>
	<RiskCode><xsl:apply-templates select="ProductCode" /></RiskCode>
	<MainRiskCode><xsl:apply-templates select="../Coverage[IndicatorCode=1]/ProductCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="InitCovAmt" /></Amnt>
	<Prem>
		<xsl:choose>
			<xsl:when test="ModalPremAmt=''">
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($ContPlanMult*1000)" />	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="ModalPremAmt" />
			</xsl:otherwise>
		</xsl:choose>
	</Prem>
    <Mult><xsl:value-of select="IntialNumberOfUnits" /></Mult>
	<PayIntv><xsl:apply-templates select="../../PaymentMode" /></PayIntv>
	
	<!-- ������, ��ϲ�Ʒ50002�����ж˴��ݱ�������Ϊ���������Ǻ��Ķ�У����Ϊ��������Ϊ��5��-->
	<xsl:choose>
		<xsl:when test="OLifEExtension/DurationMode=5">	<!-- ������ -->
			<InsuYearFlag>Y</InsuYearFlag>
			<InsuYear>5</InsuYear>
			<!-- 
			<InsuYearFlag>A</InsuYearFlag>
			<InsuYear>106</InsuYear>
			 -->
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<InsuYearFlag><xsl:apply-templates select="OLifEExtension/DurationMode" /></InsuYearFlag>
			<InsuYear><xsl:value-of select="OLifEExtension/Duration" /></InsuYear>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="OLifEExtension/PaymentDurationMode=5">	<!-- ���� -->
			<PayEndYearFlag>Y</PayEndYearFlag>
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<PayEndYearFlag><xsl:apply-templates select="OLifEExtension/PaymentDurationMode" /></PayEndYearFlag>
			<PayEndYear><xsl:value-of select="OLifEExtension/PaymentDuration" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode>
		<xsl:choose>
			<!-- �ƽ�5����6 -->
			<xsl:when test="ProductCode='011' or ProductCode='012' ">
				<xsl:call-template name="tran_BonusGetMode_2">
					<xsl:with-param name="divtype" select="../DivType" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><!-- ���� -->
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="divtype" select="../DivType" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</BonusGetMode>
</Risk>
</xsl:template>

<!-- �Ա� -->
<xsl:template name="tran_sex" match="Gender">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- �� -->
	<xsl:when test=".=2">1</xsl:when>	<!-- Ů -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=0">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
	<xsl:when test=".=2">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test=".=3">2</xsl:when>	<!-- ʿ��֤ -->
	<xsl:when test=".=5">0</xsl:when>	<!-- ��ʱ���֤ -->
	<xsl:when test=".=6">5</xsl:when>	<!-- ���ڱ�  -->
	<xsl:when test=".=9">2</xsl:when>	<!-- ����֤  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϵ -->
<xsl:template name="tran_relation" match="RelationRoleCode">
<xsl:choose>
	<xsl:when test=".=1">02</xsl:when>	<!-- ��ż -->
	<xsl:when test=".=2">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test=".=3">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test=".=8">00</xsl:when>	<!-- ���� -->
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_RiskCode" match="ProductCode">
<xsl:choose>
	<xsl:when test=".=001">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=002">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=101">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=003">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=004">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=005">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test=".=006">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
	<xsl:when test=".=007">122011</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�  -->
	<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
	<xsl:when test=".=008">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
	<xsl:when test=".=009">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
	<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
	<xsl:when test=".=010">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ�  -->
	<xsl:when test=".=011">122020</xsl:when>	<!-- �����6����ȫ���գ��ֺ��ͣ�  -->
	<xsl:when test=".=012">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
	<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
	<xsl:when test=".=013">50015</xsl:when>		<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
	<xsl:when test=".=014">L12074</xsl:when>	<!-- ����ʢ��9���������գ������ͣ�  -->
	<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
	<!-- PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A� -->
	<xsl:when test=".=015">L12084</xsl:when>	<!-- �����Ӯ2�������A��  -->
	<xsl:when test=".=017">L12093</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ�  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷ�Ƶ�� -->
<xsl:template name="tran_payintv" match="PaymentMode">
<xsl:choose>
	<xsl:when test=".=1">12</xsl:when>	<!-- ��� -->
	<xsl:when test=".=2">1</xsl:when>	<!-- �½� -->
	<xsl:when test=".=3">6</xsl:when>	<!-- ����� -->
	<xsl:when test=".=4">3</xsl:when>	<!-- ���� -->
	<xsl:when test=".=5">0</xsl:when>	<!-- ���� -->
	<xsl:when test=".=6">-1</xsl:when>	<!-- ������ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ս����ڱ�־��ת�� -->
<xsl:template name="tran_payendyearflag" match="PaymentDurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- ����ĳȷ������ -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- �� -->
	<xsl:when test=".=3">M</xsl:when>	<!-- �� -->
	<xsl:when test=".=4">D</xsl:when>	<!-- �� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �����������ڱ�־ -->
<xsl:template name="tran_InsuYearFlag" match="DurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- ����ĳȷ������ -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- �걣 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- �±� -->
	<xsl:when test=".=4">D</xsl:when>	<!-- �ձ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ��ת�� -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype=1">1</xsl:when>	<!-- �ۻ���Ϣ -->
	<xsl:when test="$divtype=3">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- ������ȡ��ʽ��ת�� �ƽ�5����6-->
<xsl:template name="tran_BonusGetMode_2">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype='1'">1</xsl:when>	<!-- �ۻ���Ϣ -->
	<xsl:when test="$divtype='3'">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:when test="$divtype=''"></xsl:when>	<!-- Ĭ�� -->
	<xsl:otherwise>9</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
