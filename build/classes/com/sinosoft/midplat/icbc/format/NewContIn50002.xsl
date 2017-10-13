<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">


	<!-- 组合产品份数 -->
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

	<!-- 险种,此处是产品组合编码 -->
	<xsl:variable name="ContPlanCode">
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy/Life/Coverage[IndicatorCode='1']/ProductCode" />
	</xsl:variable>
	
<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="TXLife/TXLifeRequest" />
	
	<Body>
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
		
		<!-- 投保人 -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=80]" />
		
		<!-- 被保人 -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=81]" />
		
		<!-- 受益人 -->
		<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Relation[RelationRoleCode=82]" />
		
		<!-- 险种 -->
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
	<!--出单网点资格证-->
	<AgentComCertiCode><xsl:value-of select="BankBranchAgentId" /></AgentComCertiCode>
	<!--出单网点名称-->
	<AgentComName><xsl:value-of select="BankBranchName" /></AgentComName>
	<!--出单柜员-->                
	<TellerName><xsl:value-of select="BankManagerName" /></TellerName>
	<!--柜员资格证-->
	<TellerCertiCode><xsl:value-of select="BankManagerAgentId" /></TellerCertiCode>
	<ProposalPrtNo><xsl:value-of select="ApplicationInfo/HOAppFormNumber" /></ProposalPrtNo>
	<ContPrtNo><xsl:value-of select="../../FormInstance[FormName='2']/ProviderFormNumber" /></ContPrtNo>
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ApplicationInfo/SubmissionDate)" /></PolApplyDate>
	<HealthNotice><xsl:value-of select="OLifEExtension/HealthIndicator" /></HealthNotice>
	
	<!-- 产品组合 -->
	<ContPlan>
		<!-- 产品组合编码 -->
		<ContPlanCode><xsl:value-of select="$ContPlanCode" /></ContPlanCode>
		<!-- 产品组合份数 -->
		<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
	</ContPlan>
</xsl:template>

<!-- 投保人 -->
<xsl:template name="Appnt" match="Relation[RelationRoleCode=80]">
<xsl:variable name="PartyID" select="@RelatedObjectID" />
<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />

<AccName><xsl:value-of select="$PartyNode/FullName" /></AccName>	<!-- 工行不传账户名，取投保人 -->
<AccNo><xsl:value-of select="../Holding/Banking/AccountNumber" /></AccNo>

<Appnt>
	<Name><xsl:value-of select="$PartyNode/FullName" /></Name>
	<Sex><xsl:apply-templates select="$PartyNode/Person/Gender" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($PartyNode/Person/BirthDate)" /></Birthday>
	<IDType><xsl:apply-templates select="$PartyNode/GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="$PartyNode/GovtID" /></IDNo>	
	<JobCode>4030111</JobCode>
	<!-- 投保人年收入，银行方单位:分，核心端单位：分 -->
	<Salary>
		<xsl:value-of select="$PartyNode/Person/EstSalary" />
	</Salary>
	<!-- 投保人家庭年收入，银行方单位:分，核心端单位：分 -->	
	<FamilySalary>
		<xsl:value-of select="$PartyNode/Person/FamilyEstSalary" />
	</FamilySalary>
	<!-- 投保人所属区域 1：城镇，2：农村-->
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

<!-- 被保人 -->
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

<!-- 受益人 -->
<xsl:template name="Bnf" match="Relation[RelationRoleCode=82]">
<xsl:variable name="PartyID" select="@RelatedObjectID" />
<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />

<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
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

<!-- 险种 -->
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
	
	<!-- 保终身, 组合产品50002，银行端传递保险年期为：终身，但是核心端校验认为保险年期为：5年-->
	<xsl:choose>
		<xsl:when test="OLifEExtension/DurationMode=5">	<!-- 保终身 -->
			<InsuYearFlag>Y</InsuYearFlag>
			<InsuYear>5</InsuYear>
			<!-- 
			<InsuYearFlag>A</InsuYearFlag>
			<InsuYear>106</InsuYear>
			 -->
		</xsl:when>
		<xsl:otherwise>	<!-- 其他 -->
			<InsuYearFlag><xsl:apply-templates select="OLifEExtension/DurationMode" /></InsuYearFlag>
			<InsuYear><xsl:value-of select="OLifEExtension/Duration" /></InsuYear>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="OLifEExtension/PaymentDurationMode=5">	<!-- 趸交 -->
			<PayEndYearFlag>Y</PayEndYearFlag>
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- 其他 -->
			<PayEndYearFlag><xsl:apply-templates select="OLifEExtension/PaymentDurationMode" /></PayEndYearFlag>
			<PayEndYear><xsl:value-of select="OLifEExtension/PaymentDuration" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode>
		<xsl:choose>
			<!-- 黄金鼎5长寿6 -->
			<xsl:when test="ProductCode='011' or ProductCode='012' ">
				<xsl:call-template name="tran_BonusGetMode_2">
					<xsl:with-param name="divtype" select="../DivType" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><!-- 其他 -->
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="divtype" select="../DivType" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</BonusGetMode>
</Risk>
</xsl:template>

<!-- 性别 -->
<xsl:template name="tran_sex" match="Gender">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- 男 -->
	<xsl:when test=".=2">1</xsl:when>	<!-- 女 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 证件类型 -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=0">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test=".=1">1</xsl:when>	<!-- 护照 -->
	<xsl:when test=".=2">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test=".=3">2</xsl:when>	<!-- 士兵证 -->
	<xsl:when test=".=5">0</xsl:when>	<!-- 临时身份证 -->
	<xsl:when test=".=6">5</xsl:when>	<!-- 户口本  -->
	<xsl:when test=".=9">2</xsl:when>	<!-- 警官证  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 关系 -->
<xsl:template name="tran_relation" match="RelationRoleCode">
<xsl:choose>
	<xsl:when test=".=1">02</xsl:when>	<!-- 配偶 -->
	<xsl:when test=".=2">01</xsl:when>	<!-- 父母 -->
	<xsl:when test=".=3">03</xsl:when>	<!-- 子女 -->
	<xsl:when test=".=8">00</xsl:when>	<!-- 本人 -->
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_RiskCode" match="ProductCode">
<xsl:choose>
	<xsl:when test=".=001">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
	<xsl:when test=".=002">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test=".=101">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test=".=003">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	<xsl:when test=".=004">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test=".=005">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test=".=006">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
	<xsl:when test=".=007">122011</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）  -->
	<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
	<xsl:when test=".=008">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
	<xsl:when test=".=009">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
	<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
	<xsl:when test=".=010">122029</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型）  -->
	<xsl:when test=".=011">122020</xsl:when>	<!-- 安邦长寿6号两全保险（分红型）  -->
	<xsl:when test=".=012">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
	<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
	<xsl:when test=".=013">50015</xsl:when>		<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成  -->
	<xsl:when test=".=014">L12074</xsl:when>	<!-- 安邦盛世9号终身寿险（万能型）  -->
	<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
	<!-- PBKINSR-923 工行银保通上线新产品（安邦汇赢2号年金保险A款） -->
	<xsl:when test=".=015">L12084</xsl:when>	<!-- 安邦汇赢2号年金保险A款  -->
	<xsl:when test=".=017">L12093</xsl:when>	<!-- 安邦盛世9号两全保险B款（万能型）  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费频次 -->
<xsl:template name="tran_payintv" match="PaymentMode">
<xsl:choose>
	<xsl:when test=".=1">12</xsl:when>	<!-- 年缴 -->
	<xsl:when test=".=2">1</xsl:when>	<!-- 月缴 -->
	<xsl:when test=".=3">6</xsl:when>	<!-- 半年缴 -->
	<xsl:when test=".=4">3</xsl:when>	<!-- 季缴 -->
	<xsl:when test=".=5">0</xsl:when>	<!-- 趸缴 -->
	<xsl:when test=".=6">-1</xsl:when>	<!-- 不定期 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 终交年期标志的转换 -->
<xsl:template name="tran_payendyearflag" match="PaymentDurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- 缴至某确定年龄 -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- 年 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- 月 -->
	<xsl:when test=".=4">D</xsl:when>	<!-- 日 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 保险年龄年期标志 -->
<xsl:template name="tran_InsuYearFlag" match="DurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- 保至某确定年龄 -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- 年保 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- 月保 -->
	<xsl:when test=".=4">D</xsl:when>	<!-- 日保 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取方式的转换 -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype=1">1</xsl:when>	<!-- 累积生息 -->
	<xsl:when test="$divtype=3">3</xsl:when>	<!-- 抵交保费 -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- 红利领取方式的转换 黄金鼎5长寿6-->
<xsl:template name="tran_BonusGetMode_2">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype='1'">1</xsl:when>	<!-- 累积生息 -->
	<xsl:when test="$divtype='3'">3</xsl:when>	<!-- 抵交保费 -->
	<xsl:when test="$divtype=''"></xsl:when>	<!-- 默认 -->
	<xsl:otherwise>9</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
