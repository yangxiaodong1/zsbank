<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="RMBP/K_TrList" />

			<Body>
				<!-- 投保单号 -->
				<ProposalPrtNo>
					<xsl:value-of select="RMBP/K_TrList/KR_Idx" />
				</ProposalPrtNo>
				<!-- 保单印刷号 -->
				<ContPrtNo></ContPrtNo>
				<!-- 投保日期 -->
				<PolApplyDate>
					<xsl:value-of select="RMBP/K_TrList/KR_TrDate" />
				</PolApplyDate>
				
				<!--出单网点名称-->
				<AgentComName><xsl:value-of select="RMBP/K_TrList/KR_BankName"/></AgentComName>
				<!-- 网点资质编号 -->
				<AgentComCertiCode><xsl:value-of select="RMBP/K_TrList/KR_BankCertNo" /></AgentComCertiCode>
				<!--银行销售人员工号-->
				<SellerNo><xsl:value-of select="RMBP/K_TrList/KR_SellNo"/></SellerNo>
				<!--银行销售人员名称-->
				<TellerName><xsl:value-of select="RMBP/K_TrList/KR_SellName"/></TellerName>
				<!--银行销售人员资格证-->
				<TellerCertiCode><xsl:value-of select="RMBP/K_TrList/KR_SellCode"/></TellerCertiCode>
								
				<!-- 职业告知 -->
				<JobNotice>
					<xsl:value-of select="RMBP/K_BI/Info/Private/WorkFlag" />
				</JobNotice>
				<!-- 健康告知 -->
				<HealthNotice>
					<xsl:value-of select="RMBP/K_BI/Info/Health" />
				</HealthNotice>
				<!-- 账户名 -->
				<AccName>
					<xsl:value-of select="RMBP/K_BI/App/AppName" />
				</AccName>
				<!-- 账户号 -->
				<AccNo>
					<xsl:value-of select="RMBP/K_BI/Info/OpenAct" />
				</AccNo>
				
				<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
				<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="RMBP/K_BI/Ins/InsCovSumAmt*0.0001"/></xsl:variable>
				<PolicyIndicator>
					<xsl:choose>
						<xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</PolicyIndicator>
				<!--累计投保身故保额, 单位是：百元-->
				<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
				<!--社保告知-->
				<SocialInsure></SocialInsure>
				<!--公费医疗告知-->
				<FreeMedical></FreeMedical>
				<!--其它医疗告知-->
				<OtherMedical></OtherMedical>
				<ContPlan>
					<!--组合产品编码-->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode" select="RMBP/K_TrList/KR_IdxType" />
						</xsl:call-template>
					</ContPlanCode>
					<!--组合产品份数-->
					<ContPlanMult>
						<xsl:value-of select="number(RMBP/K_BI/Info/Unit)" />
					</ContPlanMult>
				</ContPlan>

				<!-- 投保人 -->
				<xsl:apply-templates select="RMBP/K_BI/App" />

				<!-- 被保人 -->
				<xsl:apply-templates select="RMBP/K_BI/Ins" />

				<!-- 受益人 -->
				<xsl:apply-templates select="RMBP/K_BI/Benefit" />

				<!-- 险种 银行只传主险-->
				<xsl:apply-templates select="RMBP/K_BI/Info" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="K_TrList">
		<Head>
			<TranDate>
				<xsl:value-of select="KR_TrDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="KR_TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="KR_TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="KR_SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="KR_AreaNo" />
				<xsl:value-of select="KR_BankNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="Appnt" match="App">
		<Appnt>
			<Name>
				<xsl:value-of select="AppName" />
			</Name>
			<Sex>
				<xsl:value-of select="AppSex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="AppBirthday" />
			</Birthday>
			<IDType>
				<xsl:apply-templates select="AppIdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="AppIdNo" />
			</IDNo>
			<JobCode>
				<xsl:apply-templates select="AppWork" />
			</JobCode>
			
			<!-- 投保人年收入，银行单位万元，保险公司单位分 -->
			<Salary>
				<xsl:choose>
					<xsl:when test="AppYearSalary=''">
						<xsl:value-of select="AppYearSalary" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AppYearSalary)*10000"/>
					</xsl:otherwise>
				</xsl:choose>
			</Salary>
			<!-- 家庭年收入 -->
			<FamilySalary>
				<xsl:choose>
					<xsl:when test="../Info/Private/HomeYearSalary=''">
						<xsl:value-of select="../Info/Private/HomeYearSalary" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(../Info/Private/HomeYearSalary)*10000"/>
					</xsl:otherwise>
				</xsl:choose>
			</FamilySalary>
			<!-- 客户类型 -->
			<LiveZone>
				<xsl:apply-templates select="../Info/Private/CusSource" />
			</LiveZone>
		
			<Nationality>
				<xsl:apply-templates select="AppCountry" />
			</Nationality>
			<Stature>
				<xsl:value-of select="AppHeight" />
			</Stature><!-- 身高(cm) -->
			<Weight>
				<xsl:value-of select="AppWeight" />
			</Weight><!-- 体重(g)-->
			<!-- 婚否 -->
			<MaritalStatus>
				<xsl:apply-templates select="AppMarStat" />
			</MaritalStatus>
			<Address>
				<xsl:value-of select="AppOfficAddr" />
			</Address>
			<ZipCode>
				<xsl:value-of select="AppOfficPost" />
			</ZipCode>
			<Mobile>
				<xsl:value-of select="AppMobile" />
			</Mobile>
			<Phone>
				<xsl:value-of select="AppOfficPhone" />
			</Phone>
			<Email>
				<xsl:value-of select="AppEmail" />
			</Email>
			<IDTypeStartDate></IDTypeStartDate>
			<IDTypeEndDate>
				<xsl:value-of select="AppIdExpDate" />
			</IDTypeEndDate>
			<!-- 和被保险人关系 -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation" select="../Info/Rela" />
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- 被保人 -->
	<xsl:template name="Insured" match="Ins">
		<Insured>
			<Name>
				<xsl:value-of select="InsName" />
			</Name>
			<Sex>
				<xsl:value-of select="InsSex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="InsBirthday" />
			</Birthday>
			<IDType>
				<xsl:apply-templates select="InsIdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="InsIdNo" />
			</IDNo>
			<IDTypeStartDate></IDTypeStartDate>
			<IDTypeEndDate>
				<xsl:value-of select="InsIdExpDate" />
			</IDTypeEndDate>
			<JobCode>
				<xsl:apply-templates select="InsWork" />
			</JobCode>
			<Nationality>
				<xsl:apply-templates select="InsCountry" />
			</Nationality>
			<Stature>
				<xsl:value-of select="InsHeight" />
			</Stature><!-- 身高(cm) -->
			<Weight>
				<xsl:value-of select="InsWeight" />
			</Weight><!-- 体重(g)-->
			<!-- 婚否 -->
			<MaritalStatus>
				<xsl:apply-templates select="InsMarStat" />
			</MaritalStatus>
			<Address>
				<xsl:value-of select="InsOfficAddr" />
			</Address>
			<ZipCode>
				<xsl:value-of select="InsOfficPost" />
			</ZipCode>
			<Mobile>
				<xsl:value-of select="InsMobile" />
			</Mobile>
			<Phone>
				<xsl:value-of select="InsOfficPhone" />
			</Phone>
			<Email>
				<xsl:value-of select="InsEmail" />
			</Email>
		</Insured>
	</xsl:template>

	<!-- 受益人 -->
	<xsl:template name="Bnf" match="Benefit">
		<Bnf>
			<Type>
				<xsl:apply-templates select="BeneType" />
			</Type>
			<!--  顺序  -->
			<Grade>
				<xsl:value-of select="BeneDisMode" />
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
				<xsl:apply-templates select="IdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="IdNo" />
			</IDNo>
			<!-- 受益比例 -->
			<Lot>
				<xsl:value-of select="DisRate" />
			</Lot>
			<!--  受益人与被保人关系  -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation" select="Rela" />
				</xsl:call-template>
			</RelaToInsured>
		</Bnf>
	</xsl:template>

	<!-- 险种 -->
	<xsl:template name="mainRisk" match="Info">
		<xsl:variable name="mainRiskCode" select="/RMBP/K_TrList/KR_IdxType" />
		<xsl:variable name="PayIntv"><xsl:apply-templates select="PremType" /></xsl:variable>
		<Risk>
			<!-- 险种号 -->
			<RiskCode>
				<xsl:apply-templates select="$mainRiskCode" />
			</RiskCode>
			<!-- 主险号 -->
			<MainRiskCode>
				<xsl:apply-templates select="$mainRiskCode" />
			</MainRiskCode>
			<!--  基本保额  -->
			<Amnt>
				<xsl:value-of select="number(BaseAmt)" />
			</Amnt>
			<Prem>
				<xsl:value-of select="number(Premium)" />
			</Prem><!-- 保险费(分) -->
			<Mult>
				<xsl:value-of select="number(Unit)" />
			</Mult><!-- 投保份数 -->
			<PayMode></PayMode><!-- 缴费形式 -->
			<PayIntv>
				<xsl:value-of select="$PayIntv" />
			</PayIntv><!-- 缴费频次 -->
			<InsuYearFlag>
				<xsl:apply-templates select="CoverageType" />
			</InsuYearFlag><!-- 保险年期年龄标志 -->
			<InsuYear>
				<xsl:value-of select="Coverage" />
			</InsuYear><!-- 保险年期年龄 -->
			<PayEndYearFlag>
				<xsl:apply-templates select="PremTermType" />
			</PayEndYearFlag><!-- 缴费年期年龄标志 -->
			<PayEndYear>
				<xsl:choose>
					<xsl:when test="$PayIntv=0">1000</xsl:when>
					<xsl:otherwise><xsl:value-of select="PremTerm" /></xsl:otherwise>
				</xsl:choose>
			</PayEndYear><!-- 缴费年期年龄 -->
			<BonusGetMode>
				<xsl:apply-templates select="DividMethod" />
			</BonusGetMode><!-- 红利领取方式 -->
			<SpecContent></SpecContent>
			<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 传空-->
			<GetYearFlag>
				<xsl:apply-templates select="Private/PayM" />
			</GetYearFlag><!-- 领取年龄年期标志 -->
			<GetYear>
				<xsl:value-of select="Private/PayD" />
			</GetYear><!-- 领取年龄 -->
			<GetIntv></GetIntv>
			<GetBankCode></GetBankCode><!-- 领取银行编码 传空-->
			<GetBankAccNo></GetBankAccNo><!-- 领取银行账户 传空-->
			<GetAccName></GetAccName><!-- 领取银行户名  传空-->
			<AutoPayFlag></AutoPayFlag><!-- 自动垫交标志 传空-->
		</Risk>
	</xsl:template>


	<!-- 保单传送方式 -->
	<xsl:template name="tran_GetPolMode" match="Deliver">
		<xsl:choose>
			<xsl:when test=".=0">2</xsl:when><!-- 银行领取 -->
			<xsl:when test=".=1">1</xsl:when><!-- 邮寄或传递 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="tran_idtype"
		match="AppIdType | InsIdType | IdType">
		<xsl:choose>
			<xsl:when test=".=15">0</xsl:when><!-- 居民身份证 -->
			<xsl:when test=".=16">9</xsl:when><!-- 临时身份证 -->
			<xsl:when test=".=17">2</xsl:when><!-- 军人身份证件  -->
			<xsl:when test=".=18">8</xsl:when><!-- 武警身份证件  -->
			<xsl:when test=".=19">8</xsl:when><!-- 通行证  -->
			<xsl:when test=".=20">1</xsl:when><!-- 护照  -->
			<xsl:when test=".=21">8</xsl:when><!-- 其他  -->
			<xsl:when test=".=22">8</xsl:when><!-- 临时户口  -->
			<xsl:when test=".=23">5</xsl:when><!-- 户口簿  -->
			<xsl:when test=".=24">8</xsl:when><!-- 边境证  -->
			<xsl:when test=".=25">8</xsl:when><!-- 外国人居留证  -->
			<xsl:when test=".=26">8</xsl:when><!-- 身份证明  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 职业代码 -->
	<xsl:template name="tran_Job" match="AppWork | InsWork">
		<xsl:choose>
			<xsl:when test=".=1">3010101</xsl:when><!-- 单位文职内勤 -->
			<xsl:when test=".=2">3010102</xsl:when><!-- 外勤商旅餐饮 -->
			<xsl:when test=".=3">6230608</xsl:when><!-- 农牧钢塑装潢 -->
			<xsl:when test=".=4">5030206</xsl:when><!-- 渔港采砂水泥 -->
			<xsl:when test=".=5">6230902</xsl:when><!-- 电力建筑机械 -->
			<xsl:when test=".=6">6230618</xsl:when><!-- 高空海上航空 -->
			<xsl:when test=".=7">2021305</xsl:when><!-- 海渔航运出国 -->
			<xsl:when test=".=8">6051302</xsl:when><!-- 潜水爆破赛车 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 婚姻状况 -->
	<xsl:template name="tran_marStat" match="AppMarStat | InsMarStat">
		<xsl:choose>
			<xsl:when test=".=5">N</xsl:when><!-- 未婚 -->
			<xsl:when test=".=1">Y</xsl:when><!-- 已婚 -->
			<xsl:when test=".=6"></xsl:when><!-- 丧偶 -->
			<xsl:when test=".=2"></xsl:when><!-- 离婚 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 与被保险人的关系-->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation='1'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relation='2'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relation='3'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relation='4'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relation='5'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relation='6'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relation='7'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relation='45'">04</xsl:when><!-- 其他 -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 安邦长寿稳赢保险计划  -->
			<!-- 因银行停售50002，开售50001，但银行不调整产品代码，故需要银保通进行代码转换。 
			<xsl:when test="$contPlanCode='50002'">50002</xsl:when>
			-->
			<xsl:when test="$contPlanCode='50002'">50001</xsl:when><!-- 安邦长寿稳赢保险计划  -->
			<!-- add 20150819 PBKINSR-852  增加安享5号产品  begin -->
			<xsl:when test="$contPlanCode='50012'">50012</xsl:when><!-- 安邦长寿安享5号保险计划  -->
			<!-- add 20150819 PBKINSR-852  增加安享5号产品  end -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode" match="KR_IdxType">
		<xsl:choose>
			<!-- 安邦长寿稳赢保险计划  -->
			<!-- 因银行停售50002，开售50001，但银行不调整产品代码，故需要银保通进行代码转换。
			<xsl:when test="$riskCode='50002'">50002</xsl:when>
			 -->
			<xsl:when test=".='50002'">50001</xsl:when><!-- 安邦长寿稳赢1号两全保险  -->
			<xsl:when test=".='50012'">50012</xsl:when><!-- 安邦长寿安享5号保险计划  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保单的缴费间隔/频次 -->
	<xsl:template name="tran_payintv" match="PremType">
		<xsl:choose>
			<xsl:when test=".=0"></xsl:when><!-- 无关 -->
			<xsl:when test=".=1">0</xsl:when><!-- 趸缴 -->
			<xsl:when test=".=2">1</xsl:when><!-- 月交 -->
			<xsl:when test=".=3">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".=4">6</xsl:when><!-- 半年交 -->
			<xsl:when test=".=5">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".=7">-1</xsl:when><!-- 不定期缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期类型 -->
	<xsl:template name="tran_PremTermType" match="PremTermType">
		<xsl:choose>
			<xsl:when test=".=0"></xsl:when><!-- 无关 -->
			<xsl:when test=".=1">Y</xsl:when><!-- 趸缴 -->
			<xsl:when test=".=2">Y</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".=3">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".=4">A</xsl:when><!-- 终生缴费 -->
			<xsl:when test=".=5"></xsl:when><!-- 不定期缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期标志 -->
	<xsl:template name="tran_CoverageType" match="CoverageType ">
		<xsl:choose>
			<xsl:when test=".=5">D</xsl:when><!-- 按天保 -->
			<xsl:when test=".=4">M</xsl:when><!-- 按月保 -->
			<xsl:when test=".=2">Y</xsl:when><!-- 按年限保 -->
			<xsl:when test=".=3">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".=1">A</xsl:when><!-- 保终身 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 红利领取方式 -->
	<xsl:template name="tran_DividMethod" match="DividMethod">
		<xsl:choose>
			<xsl:when test=".=2">1</xsl:when><!-- 累积生息 -->
			<xsl:when test=".=4">4</xsl:when><!-- 领取现金 -->
			<xsl:when test=".=1">3</xsl:when><!-- 抵缴保费 -->
			<xsl:when test=".=3">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise>4</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 国籍转换 -->
	<xsl:template match="AppCountry | InsCountry">
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
	
	<!-- 居民来源 -->
	<xsl:template match="CusSource">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!--	城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!--	农村 -->
			<xsl:otherwise></xsl:otherwise><!--	其他 -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
