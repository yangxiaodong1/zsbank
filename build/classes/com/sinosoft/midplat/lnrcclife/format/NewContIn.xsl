<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/Head" />
			<Body>
				<xsl:apply-templates select="TXLife/Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template name="pocket" match="Head">
		<Head>
			<TranDate>
				<xsl:value-of select="MsgSendDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="MsgSendTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OperTellerNo" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransSerialCode" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!--报文体信息-->
	<xsl:template name="Body" match="Body">

		<!-- 基本信息  -->
		<xsl:apply-templates select="PolicyInfo" />

		<!-- 健康告知(N/Y)  -->
		<HealthNotice>
			<xsl:choose>
				<xsl:when test="(PolicyInfo/HealthInf = 'Y') or (HasNotification = 'Y')">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</HealthNotice>
		<!-- 未成年人累计身故风险保额 -->
		<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="//InsuredInFo/DeadInfo*0.01"/></xsl:variable>
		<PolicyIndicator>
			<xsl:choose>
			    <xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
			    <xsl:otherwise>N</xsl:otherwise>
		    </xsl:choose>
		</PolicyIndicator>
		<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
		<!-- 组合产品 -->
		<ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="//PCInfo[BelongMajor=PCCode]/PCCode"/>
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			<ContPlanMult><xsl:value-of select="//PCInfo[BelongMajor=PCCode]/PCNumber" /></ContPlanMult>
		</ContPlan>

		<!-- 投保人信息  -->
		<xsl:apply-templates select="PolicyHolder" />

		<!-- 被保人信息  -->
		<xsl:apply-templates select="InsuredList/InsuredInFo" />

		<!-- 受益人信息 -->
		<xsl:apply-templates select="BeneficiaryList/BeneficiaryInfo" />

		<!-- 险种信息 -->
		<xsl:apply-templates select="//PCInfo" />
	</xsl:template>

	<!--报文头信息-->
	<xsl:template name="PolicyInfo" match="PolicyInfo">
		<!-- 投保单(印刷)号 -->
		<ProposalPrtNo>
			<xsl:value-of select="PolHNo" />
		</ProposalPrtNo>
		<!-- 保单合同印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="PolPrintCode" />
		</ContPrtNo>
		
		<!-- 销售员工号 -->
		<SellerNo><xsl:value-of select="AgentCode" /></SellerNo>
		<!-- 销售员工姓名 -->
		<!--<TellerName><xsl:value-of select="java:com.sinosoft.midplat.lnrcclife.format.Trans_lnrcclife.BankToTellerName(PolHPrintCode)" /></TellerName> -->
		<TellerName><xsl:value-of select="PolHPrintCode" /></TellerName>
		<!-- 网点名称 -->
		<AgentComName><xsl:value-of select="PolAddr" /></AgentComName>
		<!-- 从业资格证号 -->
		<!-- <TellerCertiCode><xsl:value-of select="java:com.sinosoft.midplat.lnrcclife.format.Trans_lnrcclife.BankToTellerCertiCode(PolHPrintCode)" /></TellerCertiCode> -->
		<TellerCertiCode></TellerCertiCode>
		<!-- 投保日期 -->
		<PolApplyDate>
			<xsl:value-of select="InsureDate" />
		</PolApplyDate>
		<!-- 账户姓名 -->
		<AccName>
			<xsl:value-of select="AccName" />
		</AccName>
		<!-- 银行账户 -->
		<AccNo>
			<xsl:value-of select="AccNo" />
		</AccNo>
		<!-- 保单递送方式 -->
		<GetPolMode />
		<!-- 职业告知(N/Y) -->
		<JobNotice />
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="Appnt" match="PolicyHolder">
		<Appnt>
			<xsl:apply-templates select="CustomsGeneralInfo" />

			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation_to_app">
					<xsl:with-param name="relation">
						<xsl:value-of
							select="../InsuredList/InsuredInFo/IsdToPolH" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- 被保人 -->
	<xsl:template name="Insu" match="InsuredList/InsuredInFo">
		<Insured>
			<xsl:apply-templates select="CustomsGeneralInfo" />
		</Insured>
	</xsl:template>

	<!-- 受益人 -->
	<xsl:template name="Bnf" match="BeneficiaryList/BeneficiaryInfo">
		<Bnf>
			<!-- 默认为“1-身故受益人” -->
			<Type>1</Type>
			<!-- 受益顺序 -->
			<Grade>
				<xsl:value-of select="BFSequence" />
			</Grade>
			<!-- 受益人信息 -->
			<xsl:apply-templates select="CustomsGeneralInfo" />
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="BFToIsd" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
			<!-- 受益比例(整数，百分比) -->
			<Lot>
				<xsl:value-of select="BFLot" />
			</Lot>
		</Bnf>
	</xsl:template>

	<!-- 险种信息  -->
	<xsl:template name="Risk" match="PCInfo">
		<Risk>
			<!-- 险种代码 -->
			<RiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PCCode" />
				</xsl:call-template>
			</RiskCode>
			<!-- 主险险种代码 -->
			<MainRiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="BelongMajor" />
				</xsl:call-template>
			</MainRiskCode>
			<!-- 保额(分) -->
			<Amnt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" />
			</Amnt>
			<!-- 保险费(分) -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" />
			</Prem>
			<!-- 投保份数 -->
			<Mult>
				<xsl:value-of select="PCNumber" />
			</Mult>
			<!-- 缴费频次 -->
			<PayIntv>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="payintv">
						<xsl:value-of select="PayPeriodType" />
					</xsl:with-param>
				</xsl:call-template>
			</PayIntv>
			<!-- 缴费形式 -->
			<PayMode></PayMode>
			<!-- 保险年期年龄标志 -->
			<InsuYearFlag>
				<xsl:call-template name="tran_InsuYearFlag">
					<xsl:with-param name="insuyearflag">
						<xsl:value-of select="CovPeriodType" />
					</xsl:with-param>
				</xsl:call-template>
			</InsuYearFlag>
			<!-- 保险年期年龄 -->
			<InsuYear>
				<xsl:if test="CovPeriodType=1">106</xsl:if><!-- 保终身 -->
				<xsl:if test="CovPeriodType!=1">
					<xsl:value-of select="InsuYear" />
				</xsl:if>
			</InsuYear>
			<xsl:if test="PayPeriodType = 4"><!-- 趸交 -->
				<!-- 缴费年期年龄标志 -->
				<PayEndYearFlag>Y</PayEndYearFlag>
				<PayEndYear>1000</PayEndYear>
			</xsl:if>
			<xsl:if test="PayPeriodType != 4">
				<!-- 缴费年期年龄标志 -->
				<PayEndYearFlag>
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="payendyearflag">
							<xsl:value-of select="PayTermType" />
						</xsl:with-param>
					</xsl:call-template>
				</PayEndYearFlag>
				<!-- 缴费年期年龄 -->
				<PayEndYear>
					<xsl:value-of select="PayYear" />
				</PayEndYear>
			</xsl:if>

			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="bonusgetmode"
						select="BonusPayMode" />
				</xsl:call-template>
			</BonusGetMode><!-- 红利领取方式 -->
			<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->
			<GetYearFlag></GetYearFlag><!-- 领取年龄年期标志 -->
			<GetYear>
				<xsl:value-of select="FullBonusPeriod" />
			</GetYear><!-- 领取年龄 -->
			<GetIntv /><!-- 领取方式 -->
			<GetBankCode></GetBankCode><!-- 领取银行编码 -->
			<GetBankAccNo></GetBankAccNo><!-- 领取银行账户 -->
			<GetAccName></GetAccName><!-- 领取银行户名 -->
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag><!-- 自动垫交标志 -->
		</Risk>
	</xsl:template>

	<!--客户信息-->
	<xsl:template name="CustomsGeneralInfo"
		match="CustomsGeneralInfo">
		<!-- 姓名 -->
		<Name>
			<xsl:value-of select="CusName" />
		</Name>
		<!-- 性别 -->
		<Sex>
			<xsl:call-template name="tran_sex">
				<xsl:with-param name="sex">
					<xsl:value-of select="CusGender" />
				</xsl:with-param>
			</xsl:call-template>
		</Sex>
		<!-- 出生日期(yyyyMMdd) -->
		<Birthday>
			<xsl:value-of select="CusBirthDay" />
		</Birthday>
		<!-- 证件类型 -->
		<IDType>
			<xsl:call-template name="tran_idtype">
				<xsl:with-param name="idtype">
					<xsl:value-of select="CusCerType" />
				</xsl:with-param>
			</xsl:call-template>
		</IDType>
		<!-- 证件号码 -->
		<IDNo>
			<xsl:value-of select="CusCerNo" />
		</IDNo>
		<!-- 证件有效启期 -->
		<IDTypeStartDate>
			<xsl:value-of select="CusCerStartDate" />
		</IDTypeStartDate>
		<!-- 证件有效止期 -->
		<IDTypeEndDate>
			<xsl:value-of select="CusCerEndDate" />
		</IDTypeEndDate>
		<!-- 职业代码 -->
		<JobCode>
			<xsl:value-of select="CusJobCode" />
		</JobCode>
		<!-- 年收入 -->
		<Salary></Salary>
		<!-- <Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CusAnnualIncome)" /></Salary>-->
		<!-- 家庭年收入 -->
		<FamilySalary></FamilySalary>
		<!-- <FamilySalary><xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CusAnnualIncome)" /></FamilySalary>-->
		<!-- 客户类型 -->
		<LiveZone></LiveZone>
		<!-- 国籍 -->
		<Nationality>
			<xsl:value-of select="CusCty" />
		</Nationality>
		<!-- 身高(cm) -->
		<Stature></Stature>
		<!-- 体重(kg) -->
		<Weight></Weight>
		<!-- 婚否(N/Y) -->
		<MaritalStatus></MaritalStatus>
		<!-- 地址 -->
		<Address>
		    <xsl:if test="CusPostAddr !=''">
			  <xsl:value-of select="CusPostAddr" />
			</xsl:if>
			<xsl:if test="CusPostAddr =''">
			  <xsl:value-of select="CusAddr" />
			</xsl:if>
		</Address>
		<!-- 邮编 -->
		<ZipCode>
		    <xsl:if test="CusPostCode !=''">
			  <xsl:value-of select="CusPostCode" />
			</xsl:if>
			<xsl:if test="CusPostCode =''">
			  <xsl:value-of select="CusHomePostCode" />
			</xsl:if>
		</ZipCode>
		<!-- 移动电话 -->
		<Mobile>
			<xsl:value-of select="CusCPhNo" />
		</Mobile>
		<!-- 固定电话 -->
		<Phone>
			<xsl:if test="CusFmyPhNo != ''">
				<xsl:value-of select="CusFmyPhNo" />
			</xsl:if>
			<xsl:if test="CusFmyPhNo = ''">
				<xsl:value-of select="CusOffPhNo" />
			</xsl:if>
		</Phone>
		<!-- 电子邮件-->
		<Email>
			<xsl:value-of select="CusEmail" />
		</Email>
	</xsl:template>
	<!-- 以下为字符转换模块 -->
	<!-- 性别 -->
	<xsl:template name="tran_sex">
		<xsl:param name="sex" />
		<xsl:choose>
			<!-- 男 -->
			<xsl:when test="$sex='M'">0</xsl:when>
			<!-- 女 -->
			<xsl:when test="$sex='F'">1</xsl:when>
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<!-- 身份证 -->
			<xsl:when test="$idtype='1'">0</xsl:when>
			<!-- 户口本 -->
			<xsl:when test="$idtype='2'">5</xsl:when>
			<!-- 军官证 -->
			<xsl:when test="$idtype='3'">2</xsl:when>
			<!-- 护照 -->
			<xsl:when test="$idtype='7'">1</xsl:when>
			<!-- 港澳台通行证 -->
			<xsl:when test="$idtype='8'">6</xsl:when>
			<!-- 临时身份证 -->
			<xsl:when test="$idtype='A'">9</xsl:when>
			<!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 投保人与被保人关系 -->
	<xsl:template name="tran_relation_to_app">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation=1">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relation=2">03</xsl:when><!-- 父母 -->
			<xsl:when test="$relation=3">01</xsl:when><!-- 子女 -->
			<xsl:when test="$relation=4">04</xsl:when><!-- 亲属 -->
			<xsl:when test="$relation=5">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relation=6">04</xsl:when><!-- 其他 -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 收益人与被保人关系 -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation=1">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relation=2">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relation=3">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relation=4">04</xsl:when><!-- 亲属 -->
			<xsl:when test="$relation=5">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relation=6">04</xsl:when><!-- 其他 -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payintv">0</xsl:param>
		<xsl:if test="$payintv = '0'">12</xsl:if><!-- 年缴 -->
		<xsl:if test="$payintv = '1'">6</xsl:if><!-- 半年交 -->
		<xsl:if test="$payintv = '2'">3</xsl:if><!-- 季交-->
		<xsl:if test="$payintv = '3'">1</xsl:if><!-- 月交 -->
		<xsl:if test="$payintv = '4'">0</xsl:if><!-- 趸交 -->
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="insuyearflag" />
		<xsl:choose>
			<xsl:when test="$insuyearflag=5">D</xsl:when><!-- 按日 -->
			<xsl:when test="$insuyearflag=4">M</xsl:when><!-- 按月 -->
			<xsl:when test="$insuyearflag=2">Y</xsl:when><!-- 按年 -->
			<xsl:when test="$insuyearflag=1">A</xsl:when><!-- 终身 -->
			<xsl:when test="$insuyearflag=3">A</xsl:when><!-- 保至某年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:choose>
		    <xsl:when test="$payendyearflag=1">Y</xsl:when><!-- 趸交 -->
			<xsl:when test="$payendyearflag=2">Y</xsl:when><!-- 按年限缴 -->
			<xsl:when test="$payendyearflag=3">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test="$payendyearflag=4">A</xsl:when><!-- 终身缴费 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 红利领取方式 -->
	<xsl:template name="tran_BonusGetMode">
		<xsl:param name="bonusgetmode" />
		<xsl:choose>
			<xsl:when test="$bonusgetmode=0">2</xsl:when><!-- 直接给付  -->
			<xsl:when test="$bonusgetmode=1">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test="$bonusgetmode=2">1</xsl:when><!-- 累计生息 -->
			<xsl:when test="$bonusgetmode=3">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='LNABZX01'">L12079</xsl:when>
			<!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskcode='LNABZX02'">50015</xsl:when>
			<!-- 50002(50015)-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048(L12081) - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002(50015)-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048(L12081) - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$contPlancode='LNABZX02'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
