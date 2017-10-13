<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife" match="Body">
		<xsl:variable name="ContPlan" select="ContPlan" />
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="cont">
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- 主险代码 -->
					<ProductCode>
						<xsl:value-of select="$ContPlan/ContPlanCode" />
					</ProductCode>
					<!--  保单状态  -->
					<PolicyStatus>A</PolicyStatus>
					<!--  保单现金价值（预留，如取不到值请返回零）  -->
					<PolicyValue>0.00</PolicyValue>
					<!--  交费方式  -->
					<PaymentMode>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
					</PaymentMode>
					<!-- 保险合同生效日期 -->
					<EffDate>
						<xsl:value-of select="$MainRisk/CValiDate" />
					</EffDate>
					<!-- 承保日期 -->
					<IssueDate>
						<xsl:value-of select="$MainRisk/SignDate" />
					</IssueDate>
					<!--  中止日期  -->
					<TermDate>
						<xsl:value-of select="$MainRisk/InsuEndDate" />
					</TermDate>
					<!--  交费终止日期  -->
					<FinalPaymentDate>
						<xsl:value-of select="$MainRisk/PayEndDate" />
					</FinalPaymentDate>
					<!--首期保费-->
					<PaymentAmt>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
					</PaymentAmt>
					<!--  交费形式（T：转账）  -->
					<PaymentMethod tc="T">T</PaymentMethod>
					<!--  银行付款账户  -->
					<AccountNumber></AccountNumber>
					<!--  户名  -->
					<AcctHolderName></AcctHolderName>
					<Life>
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
					</Life>
					<ApplicationInfo>
						<!--  投保单号  -->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo" />
						</HOAppFormNumber>
						<!--  投保日期（8位数字格式YYYYMMDD，不能为空）  -->
						<SubmissionDate>
							<xsl:value-of select="$MainRisk/PolApplyDate" />
						</SubmissionDate>
					</ApplicationInfo>
					<OLifeExtension>
						<!--  受益人是否为法定标志  -->
						<BeneficiaryIndicator>
							<xsl:choose>
								<xsl:when test="count(Bnf) = 0">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</BeneficiaryIndicator>
						<!--  投资时间选择（预留）  -->
						<InvestDateInd />
					</OLifeExtension>
				</Policy>
			</Holding>

			<!--  投保人信息  -->
			<xsl:apply-templates select="Appnt" />

			<!--  被保人信息  -->
			<xsl:apply-templates select="Insured" />

			<!--  受益人信息  -->
			<xsl:apply-templates select="Bnf" />

		</OLife>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
		<xsl:variable name="ContPlan" select="../ContPlan" />
		<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="$RiskId" /></xsl:attribute>
			<!-- 险种名称 -->
			<PlanName>
				<!-- 
				<xsl:value-of select="RiskName" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanName" />
			</PlanName>
			<!-- 险种代码 -->
			<ProductCode>
				<!-- 
				<xsl:value-of select="RiskCode" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanCode" />
			</ProductCode>
			<!-- 主副险标志 -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when><!-- 主险标志 -->
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise><!-- 副险标志 -->
			</xsl:choose>
			<!-- 缴费方式 频次 -->
			<PaymentMode>
				<xsl:apply-templates select="PayIntv" />
			</PaymentMode>
			<!-- 投保金额 -->
			<InitCovAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</InitCovAmt>
			<!-- 投保份额 -->
			<IntialNumberOfUnits>
				<!-- 
				<xsl:value-of select="Mult" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanMult" />
			</IntialNumberOfUnits>
			<!-- 险种保费 -->
			<ChargeTotalAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
			</ChargeTotalAmt>
			<OLifeExtension>
				<!--  交费年期/年龄类型  -->
				<!--  交费年期/年龄（数字类型，不能为空）  -->
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<PaymentDurationMode>Y</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when><!--  趸交  -->
					<xsl:otherwise>
						<PaymentDurationMode>
							<xsl:apply-templates
								select="PayEndYearFlag" />
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear" />
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>

				<!-- 保险期间 需要特殊转换-->
				<!-- 保终身-->
				<DurationMode>Y</DurationMode>
				<Duration>100</Duration>
				<!--  领取年期/年龄类型  -->
				<PayoutDurationMode></PayoutDurationMode>
				<!--  领取年期/年龄（数字类型，不能为空）  -->
				<PayoutDuration>0</PayoutDuration>
				<!--  领取起始年龄（数字类型，不能为空） -->
				<PayoutStart>0</PayoutStart>
				<!--  领取终止年龄（数字类型，不能为空） -->
				<PayoutEnd>0</PayoutEnd>

				<!-- 现金价值表（没有的话整个节点不返回） -->
				<xsl:if test="count(CashValues/CashValue) > 0">
					<CashValues>
						<xsl:for-each select="CashValues/CashValue">
							<CashValue>
								<!-- 年末（数字类型，不能为空） -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- 年末现金价值（数字类型，不能为空） -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" />
								</Cash>
							</CashValue>
						</xsl:for-each>
					</CashValues>
				</xsl:if>

				<!-- 红利保额保单年度末现金价值表（没有的话整个节点不返回） -->
				<xsl:if test="count(BonusValues/BonusValue) > 0">
					<BonusValues>
						<xsl:for-each select="BonusValues/BonusValue">
							<BonusValue>
								<!-- 年末（数字类型，不能为空） -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- 年末现金价值（数字类型，不能为空） -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)" />
								</Cash>
							</BonusValue>
						</xsl:for-each>
					</BonusValues>
				</xsl:if>
			</OLifeExtension>
		</Coverage>
	</xsl:template>


	<xsl:template match="Insured">
		<!-- 被保人 -->
		<Party id="insured">
			<!-- 投保人姓名10字节 -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- 投保人证件类型1字节 -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- 性别 -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- 出生日期 YYYYMMDD-->
				<BirthDate>
					<xsl:value-of select="Birthday" />
				</BirthDate>
				<MarStat />
				<!--  被保人婚姻状况 -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  国籍 -->
				<VisaExpDate>0</VisaExpDate>
				<!--  签证到期日（8位数字格式YYYYMMDD，不能为空） -->
			</Person>
			<Address  id="Address_Insured">
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone  id="Phone_Insured_Home"><!-- 家庭电话 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone  id="Phone_Insured_Mobile"><!-- 移动电话 -->
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress id="EMailAddress_Insured">
				<AddrLine />
				<!--  被保人电子邮件地址  -->
			</EMailAddress>
		</Party>

		<!-- 被保人关系 -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="insured"
			id="r_cont_insured">
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="32">32</RelationRoleCode>
		</Relation>
	</xsl:template>

	<xsl:template match="Appnt">
		<!-- 投保人信息 -->
		<Party id="appnt">
			<!-- 投保人姓名10字节 -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- 投保人证件类型1字节 -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- 性别 -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- 出生日期 YYYYMMDD-->
				<BirthDate>
					<xsl:value-of select="Birthday" />
				</BirthDate>
				<MarStat />
				<!--  被保人婚姻状况 -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  国籍 -->
				<VisaExpDate>0</VisaExpDate>
				<!--  签证到期日（8位数字格式YYYYMMDD，不能为空） -->
			</Person>
			<Address  id="Address_Appnt">
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone  id="Phone_Appnt_Home"><!-- 家庭电话 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone  id="Phone_Appnt_Mobile"><!-- 移动电话 -->
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress id="EMailAddress_Appnt">
				<AddrLine />
				<!--  被保人电子邮件地址  -->
			</EMailAddress>
		</Party>

		<!-- 投保人关系 -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="appnt"
			id="r_cont_appnt">
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="25">25</RelationRoleCode>
		</Relation>

		<!-- 投保人与被保人的关系 -->
		<Relation OriginatingObjectID="appnt" RelatedObjectID="insured"
			id="r_insured_appnt">
			<OriginatingObjectType tc="6">6</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:call-template name="tran_RelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="RelaToInsured" />
					</xsl:with-param>
				</xsl:call-template>
			</RelationRoleCode>
		</Relation>
	</xsl:template>


	<xsl:template match="Bnf">
		<xsl:variable name="BnfId"
			select="concat('bnf_', string(position()))" />
		<!-- 受益人信息 -->
		<Party>
			<xsl:attribute name="id"><xsl:value-of select="$BnfId" />
			</xsl:attribute>
			<!-- 投保人姓名10字节 -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- 投保人证件类型1字节 -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- 性别 -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- 出生日期 YYYYMMDD 默认为0-->
				<BirthDate>0</BirthDate>
				<MarStat />
				<!--  被保人婚姻状况 -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  国籍 -->
				<VisaExpDate>0</VisaExpDate>
				<!--  签证到期日（8位数字格式YYYYMMDD，不能为空） -->
			</Person>
			<Address>
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Address_', $BnfId)" />
			</xsl:attribute>
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone><!-- 家庭电话 -->
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Phone_Home_', $BnfId)" />
			</xsl:attribute>
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone><!-- 移动电话 -->
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Phone_Mobile_', $BnfId)" />
			</xsl:attribute>
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress>
				<xsl:attribute name="id"><xsl:value-of
						select="concat('EMailAddress_', $BnfId)" />
			</xsl:attribute>
				<AddrLine>
					<xsl:value-of select="Email" />
				</AddrLine>
				<!--  被保人电子邮件地址  -->
			</EMailAddress>
		</Party>

		<!-- 受益人关系 -->
		<Relation OriginatingObjectID="cont">
			<xsl:attribute name="RelatedObjectID"><xsl:value-of
					select="$BnfId" />
			</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('r_cont_', $BnfId)" />
			</xsl:attribute>
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="34">34</RelationRoleCode>
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
			<OriginatingObjectType tc="6">6</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:call-template name="tran_BnfRelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="RelaToInsured" />
					</xsl:with-param>
				</xsl:call-template>
			</RelationRoleCode>
		</Relation>

	</xsl:template>

	<!-- 返回缴费方式 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 月缴 -->
			<xsl:when test=".='0'">0</xsl:when><!-- 趸缴 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期/年龄类型 -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年保 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月保 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日保 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">P01</xsl:when><!-- 身份证 -->
			<xsl:when test=".='9'">P03</xsl:when><!-- 临时身份证  -->
			<xsl:when test=".='2'">P04</xsl:when><!-- 军官证 -->
			<xsl:when test=".='5'">P16</xsl:when><!-- 户口本  -->
			<xsl:when test=".='1'">P31</xsl:when><!-- 护照 -->
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:when test=".='6'">P20</xsl:when><!-- 港澳回乡证 -->
			<xsl:when test=".='7'">P21</xsl:when><!-- 台胞证 -->
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">M</xsl:when><!-- 男 -->
			<xsl:when test=".='1'">F</xsl:when><!-- 女 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 关系 招行是被保险人是投保人的某某-->
	<xsl:template name="tran_RelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='00'">1</xsl:when><!-- 本人 -->
			<xsl:when test="$rela='01'">4</xsl:when><!-- 核心父母 招行子女-->
			<xsl:when test="$rela='02'">3</xsl:when><!-- 配偶 -->
			<xsl:when test="$rela='03'">2</xsl:when><!-- 核心子女 招行父母-->
			<xsl:when test="$rela='04'">5</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 受益人与被保险人的关系-->
	<xsl:template name="tran_BnfRelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='01'">2</xsl:when><!-- 父母 -->
			<xsl:when test="$rela='02'">3</xsl:when><!-- 配偶 -->
			<xsl:when test="$rela='03'">4</xsl:when><!-- 子女 -->
			<xsl:when test="$rela='04'">5</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 国籍转换 -->
	<xsl:template match="Nationality">
		<xsl:choose>
			<xsl:when test=".='HU'">HUN</xsl:when><!--	匈牙利     -->
			<xsl:when test=".='US'">USA</xsl:when><!--	美国     -->
			<xsl:when test=".='TH'">THA</xsl:when><!--	泰国     -->
			<xsl:when test=".='SG'">SGP</xsl:when><!--	新加坡   -->
			<xsl:when test=".='IN'">IND</xsl:when><!--  印度   -->
			<xsl:when test=".='BE'">BEL</xsl:when><!--	比利时     -->
			<xsl:when test=".='NL'">NLD</xsl:when><!--	荷兰     -->
			<xsl:when test=".='MY'">MYS</xsl:when><!--	马来西亚 -->
			<xsl:when test=".='KR'">KOR</xsl:when><!--	韩国     -->
			<xsl:when test=".='JP'">JPN</xsl:when><!--	日本     -->
			<xsl:when test=".='AT'">AUT</xsl:when><!--	奥地利   -->
			<xsl:when test=".='FR'">FRA</xsl:when><!--	法国     -->
			<xsl:when test=".='ES'">ESP</xsl:when><!--	西班牙   -->
			<xsl:when test=".='GB'">GBR</xsl:when><!--	英国     -->
			<xsl:when test=".='CA'">CAN</xsl:when><!--	加拿大   -->
			<xsl:when test=".='AU'">AUS</xsl:when><!--	澳大利亚 -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	中国     -->
			<xsl:otherwise></xsl:otherwise><!--	其他     -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
