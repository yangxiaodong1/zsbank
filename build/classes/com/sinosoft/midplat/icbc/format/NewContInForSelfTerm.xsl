<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

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
	<!--�������� 8Ϊ�����ն�-->
	<SourceType>8</SourceType>
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
	<!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
	<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
	<PolicyIndicator><xsl:apply-templates select="OLifEExtension/PolicyIndicator" /></PolicyIndicator><!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
	 <!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
	<xsl:variable name="RegionCode" select="../../../OLifEExtension/RegionCode" />
	<xsl:variable name="Teller" select="../../../OLifEExtension/Teller" />
	<xsl:variable name="SpecialProduct"  select="java:com.sinosoft.midplat.icbc.IcbcUtil.zjCheck($RegionCode,$Teller)"/>
	<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
	<!-- ��Ʒ��� -->
	<ContPlan>
		<xsl:choose>
			<xsl:when test="$SpecialProduct=1">	<!-- �㽭����ר����Ʒ -->
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode></ContPlanCode>
			</xsl:when>
			<xsl:otherwise>	<!-- ���� -->
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode>
					<xsl:apply-templates select="//Coverage[IndicatorCode=1]/ProductCode" mode="contplan"/>
				</ContPlanCode>
			</xsl:otherwise>
		</xsl:choose>
		
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
	<IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/GovtTermDate)" /></IDTypeEndDate>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
	<JobCode><xsl:value-of select="$PartyNode/Person/OccupationType" /></JobCode>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
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
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
	<Nationality><xsl:apply-templates select="$PartyNode/Person/Nationality" /></Nationality>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
    <ZipCode><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Zip" /></ZipCode>
    <Mobile><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='3']/DialNumber" /></Mobile>
    <Phone><xsl:value-of select="$PartyNode/Phone[PhoneTypeCode='1']/DialNumber" /></Phone>
    <Email><xsl:value-of select="$PartyNode/EMailAddress/AddrLine" /></Email>
    <Address><xsl:value-of	select="$PartyNode/Address[AddressTypeCode='1']/Line1" /></Address>
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
	<IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/GovtTermDate)" /></IDTypeEndDate>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
	<JobCode><xsl:value-of select="$PartyNode/Person/OccupationType" /></JobCode>
	<Nationality><xsl:apply-templates select="$PartyNode/Person/Nationality" /></Nationality>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
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
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
	<Nationality><xsl:apply-templates select="$PartyNode/Person/Nationality" /></Nationality>
	<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
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
	<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
	<xsl:variable name="RegionCode" select="../../../../../OLifEExtension/RegionCode" />
	<xsl:variable name="Teller" select="../../../../../OLifEExtension/Teller" />
	<xsl:variable name="SpecialProduct"  select="java:com.sinosoft.midplat.icbc.IcbcUtil.zjCheck($RegionCode,$Teller)"/>
	<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
	<xsl:choose>
		<xsl:when test="$SpecialProduct=1">	<!-- �㽭����ר����Ʒ -->
			<RiskCode><xsl:apply-templates select="ProductCode" mode="riskSpecialProduct" /></RiskCode>
			<MainRiskCode><xsl:apply-templates select="../Coverage[IndicatorCode=1]/ProductCode" mode="riskSpecialProduct" /></MainRiskCode>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<RiskCode><xsl:apply-templates select="ProductCode" mode="riskNoSpecialProduct"  /></RiskCode>
			<MainRiskCode><xsl:apply-templates select="../Coverage[IndicatorCode=1]/ProductCode" mode="riskNoSpecialProduct"  /></MainRiskCode>
		</xsl:otherwise>
	</xsl:choose>
	<Amnt><xsl:value-of select="InitCovAmt" /></Amnt>
	<Prem><xsl:value-of select="ModalPremAmt" /></Prem>
    <Mult><xsl:value-of select="IntialNumberOfUnits" /></Mult>
	<PayIntv><xsl:apply-templates select="../../PaymentMode" /></PayIntv>
	<xsl:choose>
		<xsl:when test="OLifEExtension/DurationMode=5">	<!-- ������ -->
			<InsuYearFlag>A</InsuYearFlag>
			<InsuYear>106</InsuYear>
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
	<BonusGetMode/>
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

<!-- δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� -->
<xsl:template match="PolicyIndicator">
<xsl:choose>
	<xsl:when test=".='0'">N</xsl:when>	<!-- �� -->
	<xsl:when test=".='1'">Y</xsl:when>	<!-- �� -->
	<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �������ͷ�ʽ  ����ϵͳ��������������1��ֽ�Ʊ���2�����ӱ��� -->
<xsl:template name="tran_PolicyDeliveryMethod" match="PolicyDeliveryMethod">
	<xsl:choose>
		<xsl:when test=".=1">1</xsl:when>	<!-- ���ŷ��� -->
		<xsl:when test=".=2">1</xsl:when>	<!-- �ʼĻ�ר�� -->
		<xsl:when test=".=3">1</xsl:when>	<!-- ���ŵ��� -->
		<xsl:when test=".=4">1</xsl:when>	<!-- ������ȡ -->
		<xsl:when test=".=5">1</xsl:when>	<!-- ���������������г��� -->
		<xsl:when test=".=6">1</xsl:when>	<!-- ���������������չ�˾���� -->
		<xsl:when test=".=7">1</xsl:when>	<!-- �����ṩ���ӱ��� -->
		<xsl:when test=".=8">2</xsl:when>	<!-- ��˾�ṩ���ӱ��� -->
		<xsl:when test=".=9">1</xsl:when>	<!-- ���� -->
		<xsl:otherwise>1</xsl:otherwise>
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
<xsl:template match="ProductCode"  mode="riskNoSpecialProduct" >
<xsl:choose>
	<xsl:when test=".='006'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->	
	<!-- PBKINSR-473 ���������ն�����ʢ2��ʢ3 -->
	<xsl:when test=".=008">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
	<xsl:when test=".=009">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
	<!-- PBKINSR-473 ���������ն�����ʢ2��ʢ3 -->
	<!-- ���������������նˣ�������Ӯ�ݲ����ߣ����þɲ�Ʒ���룬������ʾ����ѡ��Ʒ��ϲ��������ڼ�! -->
	<xsl:when test=".='013'">50002</xsl:when>	<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
	<!-- PBKINSR-739 ���У������նˣ�ʢ��9���²�Ʒ�������� -->
	<xsl:when test=".=014">L12074</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ�  -->
	<!-- PBKINSR-739 ���У������նˣ�ʢ��9���²�Ʒ�������� -->
	<!-- PBKINSR-925 ���������ն������²�Ʒ�������Ӯ2�������A�-->
	<xsl:when test=".=015">L12084</xsl:when>	<!-- �����Ӯ2�������A��  -->
	<xsl:when test=".=016">L12089</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�B��  -->
	<xsl:when test=".='018'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
	<xsl:when test=".='017'">L12093</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ� -->
	<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
	<!--  <xsl:when test=".='L12088'">L12088</xsl:when>-->	<!-- �����9����ȫ���գ������ͣ� -->
	<!--  <xsl:when test=".='L12085'">L12085</xsl:when>-->	<!-- �����2����ȫ���գ������ͣ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���㹤��ר����Ʒ���ִ��� -->
<!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
<xsl:template match="ProductCode"  mode="riskSpecialProduct">
<xsl:choose>
	<xsl:when test=".=008">L12077</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
	<!-- PBKINSR-1327 �㽭����������C�ʢ��9�ţ���Ŀ 2016-06-18  -->
	<xsl:when test=".=014">L12102</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ�  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϴ��� -->
<xsl:template match="ProductCode"  mode="contplan">
	<xsl:choose>
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
		<!-- ���������������նˣ�������Ӯ�ݲ����ߣ����þɲ�Ʒ���룬������ʾ����ѡ��Ʒ��ϲ��������ڼ�! -->
		<xsl:when test=".='013'">50002</xsl:when>
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<xsl:otherwise></xsl:otherwise>
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
<!-- PBKINSR-590 ���������������ն˵Ĺ�����ְҵ�������� -->
<!-- ���� -->
<xsl:template name="tran_nationality" match="Nationality">
<xsl:choose>
	<xsl:when test=".=156">CHN</xsl:when>	<!-- �й�       -->
	<xsl:when test=".=158">CHN</xsl:when>	<!-- �й�̨��   -->
	<xsl:when test=".=344">CHN</xsl:when>	<!-- �й����   -->
	<xsl:when test=".=446">CHN</xsl:when>	<!-- �й�����   -->     
	<xsl:when test=".=392">JP</xsl:when>	<!-- �ձ�       -->	
	<xsl:when test=".=840">US</xsl:when>	<!-- ����       -->
	<xsl:when test=".=643">RU</xsl:when>	<!-- ����˹     -->
	<xsl:when test=".=826">GB</xsl:when>	<!-- Ӣ��       -->
	<xsl:when test=".=250">FR</xsl:when>	<!-- ����       -->
	<xsl:when test=".=276">DE</xsl:when>	<!-- �¹�       -->
	<xsl:when test=".=410">KR</xsl:when>	<!-- ����       -->
	<xsl:when test=".=702">SG</xsl:when>	<!-- �¼���     -->
	<xsl:when test=".=360">ID</xsl:when>	<!-- ӡ�������� -->
	<xsl:when test=".=356">IN</xsl:when>	<!-- ӡ��       -->
	<xsl:when test=".=380">IT</xsl:when>	<!-- �����     -->
	<xsl:when test=".=458">MY</xsl:when>	<!-- ��������   -->
	<xsl:when test=".=764">TH</xsl:when>	<!-- ̩��       -->
	<xsl:when test=".=124">CA</xsl:when>	<!-- ���ô�     -->
	<xsl:when test=".=999">OTH</xsl:when>	<!-- ����       -->
	<xsl:otherwise>OTH</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
