<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">


	<!-- 组合产品份数,因招行在传产品份数时带小数点的，需要对数值进行处理 -->
	<xsl:variable name="ContPlanMult">
		<xsl:choose>
			<xsl:when test="TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits=''">
				<xsl:value-of select="TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits" />
			</xsl:when>
			<xsl:otherwise>

				<xsl:value-of select="format-number(TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage[IndicatorCode='1']/IntialNumberOfUnits,'#')" />				
				<!--  因招行银保通出单，银行端页面只录入保费，不可以录入份数；所以这里根据录入的保费反算份数
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage/ChargeTotalAmt) div 100000" />
				 -->
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>

	<!-- 险种,此处是产品组合编码 -->
	<xsl:variable name="ContPlanCode">
		<xsl:value-of select="TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage[IndicatorCode='1']/ProductCode" />
	</xsl:variable>
	
	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<!-- 保单基本信息 -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Holding/Policy" />

				<!-- 投保人 -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=25]" />

				<!-- 被保人 -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=32]" />

				<!-- 受益人 (非法定是才解析)-->
				<xsl:if test="TXLife/TXLifeRequest/OLife/Holding/Policy/OLifeExtension/BeneficiaryIndicator != 'Y'">
					<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Relation[RelationRoleCode=34]" />
				</xsl:if>
				<!-- 险种 -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Holding/Policy/Life/Coverage" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
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
		</Head>
	</xsl:template>
	
	
	<!-- 保单基本信息 -->
	<xsl:template name="Body" match="Policy">
		<xsl:variable name="insuredPartyID" select="../../Relation[RelationRoleCode=32]/@RelatedObjectID" />
		<xsl:variable name="tellInfos" select="../../OLifeExtension/TellInfos" />
		<!-- 投保单号 -->
		<ProposalPrtNo>
			<xsl:value-of select="ApplicationInfo/HOAppFormNumber" />
		</ProposalPrtNo>
		<!-- 保单印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="../../FormInstance[FormName='PolicyPrintNumber']/ProviderFormNumber" />
		</ContPrtNo>
		
		<!-- 销售员工号 -->
		<SellerNo>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" />
		</SellerNo>
		<!-- 销售员工姓名 -->
		<TellerName>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='002']/TellContent" />
		</TellerName>
		<!-- 销售员工资质 -->
		<TellerCertiCode>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='003']/TellContent" />
		</TellerCertiCode>
		<!-- 网点名称 -->
		<AgentComName>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='004']/TellContent" />
		</AgentComName>
		
		
		<!-- 投保日期 -->
		<PolApplyDate>
			<xsl:value-of select="ApplicationInfo/SubmissionDate" />
		</PolApplyDate>
		<!-- 健康告知 -->
		<HealthNotice>
			<xsl:apply-templates select="OLifeExtension/HealthIndicator" />
		</HealthNotice>
		<!-- 账户名 -->
		<AccName>
			<xsl:value-of select="AcctHolderName" />
		</AccName>
		<!-- 账户号 -->
		<AccNo>
			<xsl:value-of select="AccountNumber" />
		</AccNo>
		<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
		<PolicyIndicator></PolicyIndicator>
		<!--累计投保身故保额-->
		<xsl:choose>
			<xsl:when test="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='002']/TellContent > 0">
				<InsuredTotalFaceAmount>
					<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='002']/TellContent*0.01" />
				</InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount />
			</xsl:otherwise>
		</xsl:choose>
		<!--社保告知-->
		<SocialInsure>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='003']/TellContent" />
		</SocialInsure>
		<!--公费医疗告知-->
    	<FreeMedical>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='004']/TellContent" />
    	</FreeMedical>
		<!--其它医疗告知-->
    	<OtherMedical>
			<xsl:value-of select="$tellInfos/TellInfo[@TellInfoKey=$insuredPartyID and TellCode='005']/TellContent" />
    	</OtherMedical>
    	
    	
   		<!-- 产品组合 -->
		<ContPlan>
			<!-- 产品组合编码 -->
			<ContPlanCode><xsl:value-of select="$ContPlanCode" /></ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
		</ContPlan>
    	
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="Appnt" match="Relation[RelationRoleCode=25]">
		<!-- 投保人id -->
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<!-- 投保人节点 -->
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<!-- 被保人id -->
		<xsl:variable name="InsuredPartyID"
			select="../Relation[RelationRoleCode='32']/@RelatedObjectID" />
		<!-- 被保人节点 -->
		<xsl:variable name="InsuredPartyNode"
			select="../Party[@id=$InsuredPartyID]" />

		<Appnt>
			<!-- 通用模版解析投保人信息 -->
			<xsl:apply-templates select="$PartyNode" />

			<!-- 投保人和被保险人信息 -->
			<RelaToInsured>
				<xsl:call-template name="tran_RelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="../Relation[@RelatedObjectID=$InsuredPartyID and @OriginatingObjectID=$PartyID]/RelationRoleCode" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- 被保人 -->
	<xsl:template name="Insured"
		match="Relation[RelationRoleCode=32]">
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<Insured>
			<!-- 通用模版解析被保人信息 -->
			<xsl:apply-templates select="$PartyNode" />
		</Insured>
	</xsl:template>

	<!-- 受益人 -->
	<xsl:template name="Bnf" match="Relation[RelationRoleCode=34]">
		<xsl:variable name="PartyID" select="@RelatedObjectID" />
		<xsl:variable name="PartyNode" select="../Party[@id=$PartyID]" />
		<!-- 被保人id -->
		<xsl:variable name="InsuredPartyID"
			select="../Relation[RelationRoleCode='32']/@RelatedObjectID" />
		<!-- 被保人节点 -->
		<xsl:variable name="InsuredPartyNode"
			select="../Party[@id=$InsuredPartyID]" />
		<Bnf>
			<Type>1</Type>
			<!-- 通用模版解析受益人信息 -->
			<xsl:apply-templates select="$PartyNode" />
			<!--  顺序  -->
			<Grade>
				<xsl:value-of select="Sequence" />
			</Grade>
			<!-- 收益比例 -->
			<Lot>
				<xsl:value-of select="InterestPercent" />
			</Lot>
			<!--  受益人与被保人关系  -->
			<RelaToInsured>
				<xsl:call-template name="tran_BnfRelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="../Relation[@RelatedObjectID=$PartyID and @OriginatingObjectID=$InsuredPartyID]/RelationRoleCode" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Bnf>
	</xsl:template>

	<!-- 通用人员模版 -->
	<xsl:template name="common_person" match="Party">
		<!-- 姓名-->
		<Name>
			<xsl:value-of select="FullName" />
		</Name>
		<!-- 性别-->
		<Sex>
			<xsl:apply-templates select="Person/Gender" />
		</Sex>
		<!-- 生日-->
		<Birthday>
			<xsl:value-of select="Person/BirthDate" />
		</Birthday>
		<!-- 证件类型-->
		<IDType>
			<xsl:apply-templates select="GovtIDTC" />
		</IDType>
		<!-- 证件号-->
		<IDNo>
			<xsl:value-of select="GovtID" />
		</IDNo>
		<!-- 职业代码-->
		<JobCode>
			<xsl:value-of select="Person/OccupClass" />
		</JobCode>
		<!-- 国籍-->
		<Nationality>
			<xsl:apply-templates select="Person/Citizenship" />
		</Nationality>
		<!-- 身高(cm)  空值-->
		<Stature></Stature>
		<!-- 体重(g)  空值-->
		<Weight></Weight>
		<!-- 年收入 -->
		<!-- 年收入 -->
		<Salary>
			<xsl:choose>
				<xsl:when test="Person/EstSalary=''"><xsl:value-of select="Person/EstSalary" /></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Person/EstSalary)" />
				</xsl:otherwise>
			</xsl:choose>
		</Salary>
		<!-- 证件有效起期 -->
		<IDTypeStartDate></IDTypeStartDate>
		<!-- 证件有效止期 -->
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
		<!-- 婚否  空值-->
		<MaritalStatus></MaritalStatus>
		<!-- 地址-->
		<Address>
			<xsl:value-of select="Address[AddressTypeCode='1']/Line1" />
		</Address>
		<!-- 邮编-->
		<ZipCode>
			<xsl:value-of select="Address[AddressTypeCode='1']/Zip" />
		</ZipCode>
		<!-- 手机-->
		<Mobile>
			<xsl:value-of select="Phone[PhoneTypeCode='12']/DialNumber" />
		</Mobile>
		<!-- 座机-->
		<Phone>
			<xsl:choose>
				<xsl:when test="Phone[PhoneTypeCode='1']/DialNumber != ''">
					<xsl:value-of select="Phone[PhoneTypeCode='1']/DialNumber" />
				</xsl:when><!--  投保人住宅电话（固话）  -->
				<xsl:otherwise>
					<xsl:value-of select="Phone[PhoneTypeCode='7']/DialNumber" />
				</xsl:otherwise><!--  投保人办公电话  -->
			</xsl:choose>

		</Phone>
		<!-- email-->
		<Email>
			<xsl:value-of select="EMailAddress/AddrLine" />
		</Email>
	</xsl:template>

	<!-- 险种 -->
	<xsl:template name="Risk" match="Coverage">
		<Risk>
			<!-- 险种号 -->
			<RiskCode>
				<xsl:apply-templates select="ProductCode" />
			</RiskCode>
			<!-- 主险号 -->
			<MainRiskCode>
				<xsl:apply-templates select="../Coverage[IndicatorCode='1']/ProductCode" />
			</MainRiskCode>
			<!--  基本保额  -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InitCovAmt)" />
			</Amnt>
			<!--  基本保费  -->
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($ContPlanMult*1000)" />
			</Prem>
			
			<!--  投保份数  -->
			<Mult>
				<!--
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(IntialNumberOfUnits) div 100" />
				 -->
				<xsl:value-of select="$ContPlanMult" />
			</Mult>
			<!--  交费方式  -->
			<PayIntv>
				<xsl:apply-templates select="PaymentMode" />
			</PayIntv>
			<PayMode></PayMode>

			<xsl:choose>
				<!-- 保终身, 组合产品50002，银行端传递保险年期为：终身，但是核心端校验认为保险年期为：5年-->
				<xsl:when test="OLifeExtension/DurationMode='Y' and OLifeExtension/Duration=100">
					<InsuYearFlag>Y</InsuYearFlag>
					<InsuYear>5</InsuYear>
					<!-- 
					<InsuYearFlag>A</InsuYearFlag>
					<InsuYear>106</InsuYear>
					-->
				</xsl:when>
				<xsl:otherwise>
					<!--  保险年期/年龄标志  -->
					<InsuYearFlag>
						<xsl:apply-templates select="OLifeExtension/DurationMode" />
					</InsuYearFlag>
					<!--  保险年期  -->
					<InsuYear>
						<xsl:value-of select="OLifeExtension/Duration" />
					</InsuYear>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<!-- 趸交 -->
				<xsl:when test="PaymentMode='0'">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise><!-- 其他 -->
					<!--  交费年期/年龄类型  -->
					<PayEndYearFlag>
						<xsl:apply-templates select="OLifeExtension/PaymentDurationMode" />
					</PayEndYearFlag>
					<!--  交费年期/年龄  -->
					<PayEndYear>
						<xsl:value-of select="OLifeExtension/PaymentDuration" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<!--  红利领取方式  -->
			<BonusGetMode>
				<xsl:apply-templates select="../DivType" />
			</BonusGetMode>
			<SpecContent></SpecContent>
			<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 传空-->
			<GetYearFlag></GetYearFlag><!-- 领取年龄年期标志传空-->
			<GetYear></GetYear><!-- 领取年龄 传空-->
			<GetIntv></GetIntv>
			<GetBankCode></GetBankCode><!-- 领取银行编码 传空-->
			<GetBankAccNo></GetBankAccNo><!-- 领取银行账户 传空-->
			<GetAccName></GetAccName><!-- 领取银行户名  传空-->
			<AutoPayFlag></AutoPayFlag><!-- 自动垫交标志 传空-->
		</Risk>
	</xsl:template>


	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Gender">
		<xsl:choose>
			<xsl:when test=".='M'">0</xsl:when><!-- 男 -->
			<xsl:when test=".='F'">1</xsl:when><!-- 女 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="GovtIDTC">
		<xsl:choose>
			<xsl:when test=".='P01'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='P03'">9</xsl:when><!-- 临时身份证  -->
			<xsl:when test=".='P04'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='P08'">8</xsl:when><!-- 其他  -->
			<xsl:when test=".='P16'">5</xsl:when><!-- 户口本  -->
			<xsl:when test=".='P18'">8</xsl:when><!-- 通行证  -->
			<xsl:when test=".='P19'">8</xsl:when><!-- 回乡证  -->
			<xsl:when test=".='P31'">1</xsl:when><!-- 护照 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 关系 招行是被保险人是投保人的某某-->
	<xsl:template name="tran_RelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='1'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$rela='2'">03</xsl:when><!-- 父母 -->
			<xsl:when test="$rela='3'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$rela='4'">01</xsl:when><!-- 子女 -->
			<xsl:when test="$rela='5'">04</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 受益人与被保险人的关系-->
	<xsl:template name="tran_BnfRelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='1'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$rela='2'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$rela='3'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$rela='4'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$rela='5'">04</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>


	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode" match="ProductCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122029'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- 安邦附加安心7号重大疾病保险 -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- 安邦附加盛世安康住院医疗保险A款 -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- 安邦附加盛世安康住院医疗保险B款 -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- 安邦附加盛世安康护理保险 -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- 安邦附加盛世安康防癌疾病保险 -->

			<!-- 招行生成没有上线50001，因此50001的映射是没有必要存在的。 -->			
			<xsl:when test=".='50001'">50001</xsl:when><!-- 50001-安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='122046'">122046</xsl:when><!-- 主险：122046 - 安邦长寿稳赢1号两全保险 -->
			<xsl:when test=".='122047'">122047</xsl:when><!-- 附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、安邦长寿添利终身寿险（万能型）组成 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<xsl:template name="tran_payintv" match="PaymentMode">
		<xsl:choose>
			<xsl:when test=".='12'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 月缴 -->
			<xsl:when test=".='0'">0</xsl:when><!-- 趸缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期/年龄类型 -->
	<xsl:template name="tran_payendyearflag"
		match="PaymentDurationMode">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template name="tran_InsuYearFlag" match="DurationMode">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年保 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月保 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日保 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 红利领取方式的转换 -->
	<xsl:template name="tran_BonusGetMode" match="DivType">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 累积生息 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 领取现金 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='5'">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 健康告知 -->
	<xsl:template match="HealthIndicator">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 国籍转换 -->
	<xsl:template match="Citizenship">
		<xsl:choose>
			<xsl:when test=".='HUN'">HU</xsl:when><!--	匈牙利     -->
			<xsl:when test=".='USA'">US</xsl:when><!--	美国     -->
			<xsl:when test=".='THA'">TH</xsl:when><!--	泰国     -->
			<xsl:when test=".='SGP'">SG</xsl:when><!--	新加坡   -->
			<xsl:when test=".='IND'">IN</xsl:when><!--  印度   -->
			<xsl:when test=".='BEL'">BE</xsl:when><!--	比利时     -->
			<xsl:when test=".='NLD'">NL</xsl:when><!--	荷兰     -->
			<xsl:when test=".='MYS'">MY</xsl:when><!--	马来西亚 -->
			<xsl:when test=".='KOR'">KR</xsl:when><!--	韩国     -->
			<xsl:when test=".='JPN'">JP</xsl:when><!--	日本     -->
			<xsl:when test=".='AUT'">AT</xsl:when><!--	奥地利   -->
			<xsl:when test=".='FRA'">FR</xsl:when><!--	法国     -->
			<xsl:when test=".='ESP'">ES</xsl:when><!--	西班牙   -->
			<xsl:when test=".='GBR'">GB</xsl:when><!--	英国     -->
			<xsl:when test=".='CAN'">CA</xsl:when><!--	加拿大   -->
			<xsl:when test=".='AUS'">AU</xsl:when><!--	澳大利亚 -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	中国     -->
			<xsl:otherwise>OTH</xsl:otherwise><!--	其他     -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50001-安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test="$contPlanCode=50001">50001</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
