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
				<!-- 保单信息 -->
				<Policy>
					<!--  保单号 -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!--  主险代码 -->
					<ProductCode>
						<xsl:apply-templates
							select="$MainRisk/RiskCode" />
					</ProductCode>
					<!-- 保单状态 -->
					<PolicyStatus></PolicyStatus>
					<!--  缴费方式 -->
					<PaymentMode>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
					</PaymentMode>
					<!--  缴费形式 -->
					<PaymentMethod>1</PaymentMethod>
					<!--  首期保费-->
					<PaymentAmt>
						<xsl:value-of select="ActSumPrem" />
					</PaymentAmt>
					<!--  银行帐户20字节 -->
					<AccountNumber></AccountNumber>
					<!--  帐户姓名10字节 -->
					<AcctHolderName></AcctHolderName>
					<!--  帐户类型 -->
					<BankAcctType></BankAcctType>
					<!--  银行编码10字节 -->
					<BankName></BankName>
					<Life>
						<!--  垫交标志/减额交清标志 表示非垫交 -->
						<PremOffsetMethod />
						<!--  红利领取方式 -->
						<DivType>
							<xsl:apply-templates
								select="$MainRisk/BonusGetMode" />
						</DivType>
						<xsl:choose>
							<xsl:when test="ContPlan/ContPlanCode=''">
								<!--  险种出单-->
								<!--  险种循环次数-->
								<CoverageCount>
									<xsl:value-of select="count(Risk)" />
								</CoverageCount>
								<!--  险种信息-->
								<xsl:apply-templates select="Risk" />
							</xsl:when>
							<xsl:otherwise>
								<!--  套餐出单-->
								<!--  险种循环次数-->
								<CoverageCount>1</CoverageCount>
								<!--  险种信息-->
								<xsl:apply-templates
									select="Risk[RiskCode=MainRiskCode]" />
							</xsl:otherwise>
						</xsl:choose>
					</Life>

					<!--申请信息-->
					<ApplicationInfo>
						<!--投保书号-->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo" />
						</HOAppFormNumber>
						<!--  投保日期8字节  -->
						<SubmissionDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/PolApplyDate)" />
						</SubmissionDate>
					</ApplicationInfo>

					<OLifEExtension>
						<!-- 保险合同生效日期 -->
						<ContractEffDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)" />
						</ContractEffDate>
						<!-- 保险合同到期日期 -->
						<ContractEndDate>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/InsuEndDate)" />
						</ContractEndDate>
						<!-- 保障类型 -->
						<CovType></CovType>
						<!-- 保障区域 -->
						<CovArea></CovArea>
						<!-- 保险期限（天） -->
						<CovPeriod></CovPeriod>
						<!-- 总保费 -->
						<GrossPremAmt>
							<xsl:value-of select="ActSumPrem" />
						</GrossPremAmt>
					</OLifEExtension>
				</Policy>
			</Holding>

			<!-- 投保人信息 -->
			<xsl:apply-templates select="Appnt" />
			<!-- 被保人信息 -->
			<xsl:apply-templates select="Insured" />
			<!-- 受益人信息 -->
			<xsl:apply-templates select="Bnf" />

			<!-- 代理人信息 -->
			<Party id="agent">
				<FullName>
					<xsl:value-of select="//Body/AgentName" />
				</FullName>
				<Person />
				<Producer />
			</Party>

			<!-- 84代理人关系 -->
			<Relation OriginatingObjectID="cont" RelatedObjectID="agent"
				id="r_cont_agent">
				<OriginatingObjectType>4</OriginatingObjectType>
				<RelatedObjectType>6</RelatedObjectType>
				<RelationRoleCode tc="84">84</RelationRoleCode>
			</Relation>

			<!-- 保险公司信息 -->
			<Party id="com">
				<!-- 保险公司名称 -->
				<FullName>
					<xsl:value-of select="ComName" />
				</FullName>
				<!-- 保险公司地址 -->
				<Address>
					<AddressTypeCode tc="2">2</AddressTypeCode>
					<Line1>
						<xsl:value-of select="ComLocation" />
					</Line1>
					<Zip>
						<xsl:value-of select="ComZipCode" />
					</Zip>
				</Address>
				<!-- 保险公司电话 -->
				<Phone>
					<PhoneTypeCode tc="2">2</PhoneTypeCode>
					<DialNumber>95569</DialNumber>
				</Phone>
				<!-- 公司代码 -->
				<Carrier>
					<CarrierCode>044</CarrierCode>
				</Carrier>
			</Party>

			<!-- 85承包公司关系 -->
			<Relation OriginatingObjectID="cont" RelatedObjectID="com"
				id="r_cont_com">
				<OriginatingObjectType>4</OriginatingObjectType>
				<RelatedObjectType>6</RelatedObjectType>
				<RelationRoleCode tc="85">85</RelationRoleCode>
			</Relation>
		</OLifE>

	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('risk_', string(position()))" />
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode=''">
					<!--  险种出单-->
					<!-- 险种名称 -->
					<PlanName>
						<xsl:value-of select="RiskName" />
					</PlanName>
				</xsl:when>
				<xsl:otherwise>
					<!--  套餐出单-->
					<!-- 险种名称 -->
					<PlanName>
						<xsl:value-of select="../ContPlan/ContPlanName" />
					</PlanName>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 险种代码 -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode" />
			</ProductCode>
			<!-- 险种类型 -->
			<LifeCovTypeCode>9</LifeCovTypeCode>
			<!-- 主副险标志 -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when>
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise>
			</xsl:choose>
			<!--  缴费方式  -->
			<PaymentMode>
				<xsl:apply-templates select="PayIntv" />
			</PaymentMode>
			<!-- 投保金额 -->
			<InitCovAmt>
				<xsl:value-of select="Amnt" />
			</InitCovAmt>
			<!-- 投保份额 -->
			<IntialNumberOfUnits>
				<xsl:value-of select="Mult" />
			</IntialNumberOfUnits>
			<!-- 险种保费 -->
			<ModalPremAmt>
				<xsl:value-of select="ActPrem" />
			</ModalPremAmt>
			<!-- 起保日期 -->
			<EffDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)" />
			</EffDate>
			<!-- 终止日期 -->
			<TermDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(InsuEndDate)" />
			</TermDate>
			<!-- 缴费终止日期 -->
			<FinalPaymentDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date8to10(PayEndDate)" />
			</FinalPaymentDate>
			<BenefitPeriod tc="1" />
			<BenefitMode tc="1"></BenefitMode>
			<Duration></Duration>
			<!-- 缴费年期/年龄类型 -->
			<OLifEExtension>
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<!-- 趸交 -->
						<PaymentDurationMode>5</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when>
					<xsl:otherwise>
						<!-- 非趸交 -->
						<PaymentDurationMode>
							<xsl:apply-templates
								select="PayEndYearFlag" />
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear" />
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 领取起始年龄 -->
				<PayoutStart></PayoutStart>
				<!-- 领取终止年龄  -->
				<PayoutEnd />
				<!-- 保险期间 -->
				<xsl:choose>
					<xsl:when
						test="(InsuYear= 106) and (InsuYearFlag = 'A')">
						<!-- 保终身 -->
						<DurationMode>5</DurationMode>
						<Duration>999</Duration>
					</xsl:when>
					<xsl:otherwise>
						<!-- 非保终身 -->
						<DurationMode>
							<xsl:apply-templates select="InsuYearFlag" />
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear" />
						</Duration>
					</xsl:otherwise>
				</xsl:choose>

				<!--  健康加费  -->
				<HealthPrem></HealthPrem>
				<!--  职业加费  -->
				<JobPrem></JobPrem>
				<!--  红利保额 -->
				<BonusAmnt></BonusAmnt>
				<!--  保险费率  -->
				<PremRate></PremRate>
			</OLifEExtension>
		</Coverage>
	</xsl:template>

	<xsl:template match="Appnt">
		<!-- 投保人信息 -->
		<Party id="appnt">
			<!-- 投保人姓名 -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- 投保人证件类型 -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<!-- 投保人证件号 -->
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- 投保人性别 -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- 投保人出生日期 -->
				<BirthDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)" />
				</BirthDate>
			</Person>
			<!-- 投保人居住地地址 -->
			<Address>
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<!-- 家庭电话 -->
			<Phone>
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<!-- 移动电话 -->
			<Phone>
				<PhoneTypeCode tc="3">3</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
		</Party>

		<!-- 投保人关系 -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="appnt"
			id="r_cont_appnt">
			<OriginatingObjectType>4</OriginatingObjectType>
			<RelatedObjectType>6</RelatedObjectType>
			<RelationRoleCode tc="80">80</RelationRoleCode>
		</Relation>

		<!-- 投保人与被保人的关系 -->
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
		<!-- 被保人信息 -->
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
			<Address><!-- 邮寄地址 -->
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone><!-- 家庭电话 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone><!-- 移动电话 -->
				<PhoneTypeCode tc="3">3</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
		</Party>

		<!-- 被保人关系 -->
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
		<!-- 受益人信息 -->
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

		<!-- 受益人关系 -->
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

		<!-- 受益人与被保人关系 -->
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

	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 男 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 女 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 其他 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型-->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='5'">6</xsl:when><!-- 户口簿  -->
			<xsl:when test=".='8'">7</xsl:when><!-- 其他  -->
			<xsl:when test=".='9'">0</xsl:when><!-- 异常身份证  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 关系 -->
	<xsl:template name="tran_RelationRoleCode" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='02'">1</xsl:when><!-- 配偶 -->
			<xsl:when test=".='01'">2</xsl:when><!-- 父母 -->
			<xsl:when test=".='03'">3</xsl:when><!-- 子女 -->
			<xsl:when test=".='00'">8</xsl:when><!-- 本人 -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122001'">001</xsl:when><!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
			<xsl:when test=".='122002'">002</xsl:when><!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
			<xsl:when test=".='122004'">101</xsl:when><!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
			<xsl:when test=".='122003'">003</xsl:when><!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
			<xsl:when test=".='122006'">004</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
			<xsl:when test=".='122008'">005</xsl:when><!-- 安邦白玉樽1号终身寿险（万能型） -->
			<xsl:when test=".='122009'">006</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122011'">007</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test=".='122012'">008</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">009</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122029'">010</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='122020'">011</xsl:when><!-- 安邦长寿6号两全保险（分红型）  -->
			<xsl:when test=".='122036'">012</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			<!-- <xsl:when test=".='122046'">013</xsl:when> --><!-- 安邦长寿稳赢1号  -->  
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->	
			<xsl:when test=".='L12079'">008</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12100'">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">014</xsl:when>	<!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='122046'">013</xsl:when>	<!-- 安邦长寿稳赢：122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成  -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			<xsl:when test=".='L12077'">008</xsl:when> 	<!-- 浙江工地专属产品————安邦盛世2号终身寿险（万能型） -->
			<!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			<!-- PBKINSR-925 工行自助终端上线新产品（安邦汇赢2号年金保险A款） -->
			<xsl:when test=".='L12084'">015</xsl:when>	<!-- 安邦汇赢2号年金保险A款  -->
			<xsl:when test=".='L12086'">018</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test=".='L12102'">014</xsl:when>	<!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12093'">017</xsl:when>	<!-- 安邦盛世9号两全保险B款（万能型）  -->
			<xsl:when test=".='L12088'">L12088</xsl:when>	<!-- 安邦东风9号两全保险（万能型） -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 月缴 -->
			<xsl:when test=".='6'">3</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='3'">4</xsl:when><!-- 季缴 -->
			<xsl:when test=".='0'">5</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='-1'">6</xsl:when><!-- 不定期 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 终交年期标志的转换 -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">4</xsl:when><!-- 日 -->
			<xsl:when test=".='M'">3</xsl:when><!-- 年 -->
			<xsl:when test=".='Y'">2</xsl:when><!-- 月 -->
			<xsl:when test=".='A'">1</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when><!-- 保至某确定年龄  -->
			<xsl:when test=".='Y'">2</xsl:when><!-- 年保  -->
			<xsl:when test=".='M'">3</xsl:when><!-- 月保  -->
			<xsl:when test=".='D'">4</xsl:when><!-- 日保  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 红利领取方式的转换 -->
	<xsl:template match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='3'">3</xsl:when><!-- 累积生息 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 抵交保费 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
