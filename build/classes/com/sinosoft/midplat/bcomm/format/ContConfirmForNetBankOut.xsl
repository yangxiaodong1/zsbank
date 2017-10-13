<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />

			<xsl:apply-templates select="TranData/Body" />
		</RMBP>
	</xsl:template>

	<xsl:template name="body" match="Body">
	
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
	
		<!-- 主险 -->
		<xsl:variable name="mainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<K_TrList>
			<!--总保费 非空-->
			<KR_TotalAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActSumPrem,15,$leftPadFlag)" />
			</KR_TotalAmt>
			<!--总保费大写		Char(60)		非空-->
			<PREMC>
				<xsl:value-of select="ActSumPremText" />
			</PREMC>
			<!--承保公司名称 可空-->
			<ManageCom>
				<xsl:value-of select="ComName" />
			</ManageCom>
			<!--承保公司地址		Char(60)		可空-->
			<ComLocation>
				<xsl:value-of select="ComLocation" />
			</ComLocation>
			<!--承保公司城市		Char(30)		可空-->
			<City />
			<!--承保公司电话		Char(20)		可空-->
			<Tel>
				<xsl:value-of select="ComPhone" />
			</Tel>
			<!--承保公司邮编		Char(6)		可空-->
			<Post>
				<xsl:value-of select="ComZipCode" />
			</Post>
			<!--营业单位代码		Char(20)		可空-->
			<AgentCode><xsl:value-of select="ComCode" /></AgentCode>
			<!--专管员姓名		Char(20)		可空-->
			<AgentName><xsl:value-of select="AgentName" /></AgentName>
			<!--主险险种代码		Char(10)		非空-->
			<KR_IdxType>
				<xsl:apply-templates select="$mainRisk/RiskCode" />
			</KR_IdxType>
			<!--主险险种名称		Char(40)		非空-->
			<KR_IdxName>
				<xsl:value-of select="$mainRisk/RiskName" />
			</KR_IdxName>
			<!--投保书号			Char(35)		非空-->
			<KR_Idx>
				<xsl:value-of select="ProposalPrtNo" />
			</KR_Idx>
			<!--保单号			Char(35)		非空-->
			<KR_Idx1>
				<xsl:value-of select="ContNo" />
			</KR_Idx1>
			<!--付费方式			Char(1)		非空 取银行值-->
			<KR_TrType></KR_TrType>
			<!--保险业务员代码	Char(10)		可空-->
			<KR_EntOper><xsl:value-of select="AgentCode" /></KR_EntOper>
			<!--签单日期			Char(8)		非空	格式：YYYYMMDD-->
			<KR_SignedDate>
				<xsl:value-of select="$mainRisk/SignDate" />
			</KR_SignedDate>
		</K_TrList>
		<K_BI>
			<xsl:apply-templates select="Appnt" />
			
			<xsl:apply-templates select="Insured" />

			<!-- 受益人 -->
			<xsl:for-each select="Bnf">
				<Benefit>
					<!--受益人受益顺序（或受益人分配方式）	Char(3)	非空-->
					<BeneDisMode>
						<xsl:value-of select="Grade" />
					</BeneDisMode>
					<!--受益人姓名		Char(60)		非空-->
					<Name>
						<xsl:value-of select="Name" />
					</Name>
					<!--受益人性别		Char(1)		可空	参见附录3.1-->
					<Sex>
						<xsl:value-of select="Sex" />
					</Sex>
					<!--受益人出生日期	Char(8)		可空	格式：YYYYMMDD-->
					<Birthday>
						<xsl:value-of select="Birthday" />
					</Birthday>
					<!--受益人证件类型	Char(3)		可空	-->
					<IdType>
						<xsl:apply-templates select="IDType" />
					</IdType>
					<!--受益人证件号码	Char(30)		可空-->
					<IdNo>
						<xsl:value-of select="IDNo" />
					</IdNo>
					<!--受益人与被保人关系	Char(3)	非空	-->
					<Rela>
						<xsl:call-template name="tran_relation">
							<xsl:with-param name="relation"
								select="RelaToInsured" />
							<xsl:with-param name="sex" select="sex" />
						</xsl:call-template>
					</Rela>
					<!--受益人类型		Char(1)		可空	参见附录3.18-->
					<BeneType>
						<xsl:apply-templates select="Type" />
					</BeneType>
					<!--受益人受益比例	Char(10)		非空-->
					<DisRate>
						<xsl:value-of select="Lot" />
					</DisRate>
					<!--受益人通讯地址	Char(60)		可空-->
					<Address />
				</Benefit>
			</xsl:for-each>

			<xsl:for-each select="Risk">
				<xsl:choose>
					<!-- 投保信息 -->
					<xsl:when test="RiskCode=MainRiskCode">
						<Info>
							<!--投保人与被保人关系	Char(3)		非空	-->
							<Rela>
								<xsl:call-template
									name="tran_relation">
									<xsl:with-param name="relation"
										select="//Appnt/RelaToInsured" />
									<xsl:with-param name="sex"
										select="//Appnt/sex" />
								</xsl:call-template>
							</Rela>
							<!--生效日期			Char(8)		可空	格式：YYYYMMDD-->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--终止日期			Char(8)		可空	格式：YYYYMMDD-->
							<InvaliDate>
								<xsl:value-of select="InsuEndDate" />
							</InvaliDate>
							<!--缴费方式			Char(3)		非空	-->
							<PremType>
								<xsl:apply-templates select="PayIntv" />
							</PremType>
							<!--缴费终止日期		Char(8)		可空	格式：YYYYMMDD-->
							<PayEndDate>
								<xsl:value-of select="PayEndDate" />
							</PayEndDate>
							<!--续保日期			Char(8)		可空	格式：YYYYMMDD-->
							<CPayDate />
							<!--（续期）缴费帐户	Char(30)		可空-->
							<OpenAct></OpenAct>
							<!--红利领取方式		Char(3)		可空	-->
							<DividMethod>
								<xsl:apply-templates select="BonusGetMode" />
							</DividMethod>
							<!--首期保费			Dec(15,0)	可空-->
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Prem>
							<!--保单递送方式		Char(1)		可空-->
							<Deliver></Deliver>
							<!--健康告知标志		Char(1)		可空	-->
							<Health></Health>
							<!--主险投保份数		Int(5)		非空-->
							<Unit>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(//ContPlan/ContPlanMult,5,$leftPadFlag)" />
							</Unit>
							<!--主险期缴保费		Dec(15,0)	主险期缴保费与主险保额之一为必输项-->
							<Premium>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Premium>
							<!--主险保额			Dec(15,0)	主险期缴保费与主险保额之一为必输项-->
							<BaseAmt>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Amnt,15,$leftPadFlag)" />
							</BaseAmt>
							<!--主险领取方式		Char(3)		可空	-->
							<PayOutMethod></PayOutMethod>
							<!--主险保险年期类型	Char(3)		非空	-->
							<CoverageType>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">1</xsl:when>
									<xsl:otherwise><xsl:apply-templates select="InsuYearFlag" /></xsl:otherwise>
								</xsl:choose>
							</CoverageType>
							<!--主险保险年期		Char(3)		非空-->
							<Coverage>
								<xsl:value-of select="InsuYear" />
							</Coverage>
							<!--主险缴费年期类型	Char(3)		非空	参见附录3.6-->
							<PremTermType>
								<xsl:choose>
									<xsl:when test="PayIntv=0">1</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="PayEndYearFlag" />
									</xsl:otherwise>
								</xsl:choose>
							</PremTermType>
							<!--主险缴费年期		Char(3)		非空-->
							<PremTerm>
								<xsl:choose>
									<xsl:when test="PayIntv=0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
								</xsl:choose>
							</PremTerm>
							<!--主险领取起始年龄	Char(3)		可空-->
							<GetFirAge />
							<!--主险领取终止年龄	Char(3)		可空-->
							<GetLstAge />
							<!--交至日期			Char(8)		可空	格式：YYYYMMDD -->
							<PayToDate>
								<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayToDate)" />
							</PayToDate>
							<!--起领日期			Char(8)		可空	格式：YYYYMMDD -->
							<GetStartDate>
								<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(GetStartDate)" />
							</GetStartDate>
							<!--首年度手续费		Dec(15,0)	可空-->
							<FirstCharge />
							<!--次年度手续费		Dec(15,0)	可空-->
							<SecondCharge />
							<!--首年退保比例		Dec(10,2)	可空-->
							<FirstRetPct />
							<!--次年退保比例		Dec(10,2)	可空-->
							<SecondRetPct />
							<!--费率				Dec(10,2)	可空-->
							<Rate />
							<!--初始费率			Dec(10,2)	可空-->
							<FirstRate />
							<!--保证利率			Dec(10,2)	可空-->
							<SureRate />
							<!--保单价值初始值	Dec(15,0)	可空-->
							<FirstValue />
							<!--主险现金价值单位描述	Char(20)	可空-->
							<CashDescription />
							<!--私有节点-->
							<Private>
								<!--是否为法定受益人	Char(1)		非空	0-否，1-是	如果是1-法定受益人，则受益人个数为0-->
								<xsl:variable name="bnfCount"
									select="count(//Bnf/Type)" />
								<BenefitKind>
									<xsl:choose>
										<xsl:when test="$bnfCount=0">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</BenefitKind>
								<!--受益人个数		Int(2)		非空-->
								<BenefitCount>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($bnfCount),2,$leftPadFlag)" />
								</BenefitCount>
								<!--缴费帐户户名		Char(60)		可空-->
								<ActName />
								<!--缴费方式描述		Char(10)		可空-->
								<PremType />
								<!--主险缴费标准		Dec(15,0)	可空-->
								<StdFee />
								<!--主险综合加费		Dec(15,0)	可空-->
								<ColFee />
								<!--主险职业加费		Dec(15,0)	可空-->
								<WorkFee />
								<!--管理部门			Char(20)		可空-->
								<ManageDM />
								<!--销售渠道			Char(2)		可空-->
								<SellChannel />
								<!--合同争议处理方式	Char(1)		可空	参见附录3.28-->
								<DEALTYPE />
								<!--仲裁委员会		Char(20)		可空-->
								<INTERCED />
								<!--职业告知标志		Char(1)		可空	参见附录3.23-->
								<WorkFlag />
								<!--主险领取年期类型	Char(3)		可空	参见附录3.7-->
								<PayM />
								<!--主险领取年期		Char(3)		可空	或主险领取年龄-->
								<PayD>
									<xsl:value-of select="GetYear" />
								</PayD>
								<!--领取日期标志		Char(1)		可空	参见附录3.29-->
								<ReceiveMark />
								<!--自动垫交标志		Char(1)		可空	参见附录3.16-->
								<AutoPayFlag />
								<!--减额交清标志		Char(1)		可空	参见附录3.17-->
								<SubFlag />
								<!--附加额外保费		Dec(15,0)	可空-->
								<ExcPremAmt />
								<!--附加额外保额		Dec(15,0)	可空-->
								<ExcBaseAmt />
								<!--可选部分身故保险金额		Dec(15,0)	可空-->
								<SelectAmt />
								<!--特别约定			Char(256)	可空-->
								<SpecialClause/>
								<!--投保告知			Char(256)	可空-->
								<Notice />
								<!--客户回访类型		Char(3)		可空	默认为1－电话回访-->
								<CusFolType />
								<!--申请一年期自动续保标志	Char(1)	可空	参见附录3.30-->
								<AutoRenewInd />
								<!--附加险个数		Int(2)		非空 -->
								<xsl:variable name="addCount"
									select="count(//Risk[RiskCode!=MainRiskCode])" />
								<AddCount>
									<xsl:value-of select="$addCount" />
								</AddCount>
								<!--投资日期			Char(3)		可空	参见附录3.20-->
								<InvestDateOn />
								<!--投资期间			Char(3)		可空	参见附录3.14-->
								<InvestType />
								<!--投连账户个数		Int(2)		非空-->
								<AccountCount>0</AccountCount>
								<!--投连险根节点-->
								<Invests></Invests>
							</Private>
							<!--主险现金价值节点-->
							<CashValues>
								<!--主险现金价值个数		Int(3)		非空-->
								<xsl:variable name="mainCashCount"
									select="count(CashValues/CashValue)" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($mainCashCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$mainCashCount > 0">
									<xsl:for-each
										select="CashValues/CashValue">
										<Cash>
											<!--生存年金			Dec(15,0)	可空-->
											<Live />
											<!--疾病身故保险金	Dec(15,0)	可空-->
											<IDAmt />
											<!--意外身故保险金	Dec(15,0)	可空-->
											<ADAmt />
											<!--年度末			Char(3)		可空-->
											<End />
											<!--年末现金价值		Dec(15,0)	可空-->
											<Ch>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Cash,15,$leftPadFlag)" />
											</Ch>
											<!--保单年度			Char(8)		可空-->
											<Year>
												<xsl:value-of
													select="EndYear" />
											</Year>
											<!--交清保额			Dec(15,0)	可空-->
											<PaidAmt />
											<!--现金价值表说明	Char(60)		可空-->
											<Descrip />
										</Cash>
									</xsl:for-each>
								</xsl:if>
							</CashValues>
							<!--主险红利保额保单年度末现金价值节点-->
							<BonusValues>
								<!--主险红利保额保单年度末现金价值个数		Int(3)		非空-->
								<xsl:variable name="mainBonusCount"
									select="count(BonusValues/BonusValue)" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($mainBonusCount),3,$leftPadFlag)" />
								</Count>
								<!--主险红利保额保单年度末现金价值循环节点	循环节点个数为“主险红利保额保单年度末现金价值个数”，主险红利保额保单年度末现金价值个数等于0，不包含主险红利保额保单年度末现金价值循环节点-->
								<xsl:if test="$mainBonusCount > 0">
									<xsl:for-each
										select="BonusValues/BonusValue">
										<Bonus>
											<!--年度末			Char(3)		可空-->
											<End>
												<xsl:value-of
													select="EndYear" />
											</End>
											<!--年末现金价值		Dec(15,0)	可空-->
											<Cash>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(EndYearCash ,15,$leftPadFlag)" />
											</Cash>
										</Bonus>
									</xsl:for-each>
								</xsl:if>
							</BonusValues>
						</Info>
					</xsl:when>
					<xsl:otherwise>
						<!-- 附加险信息 -->
						<Add>
							<!--附加险代码		Char(10)		非空-->
							<ProductId>
								<xsl:apply-templates select="RiskCode" />
							</ProductId>
							<!--附加险投保份数	Int(5)		非空-->
							<Unit>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Mult,5,$leftPadFlag)" />
							</Unit>
							<!--附加险保费		Dec(15,0)	附加险保费与附加险保额之一为必输项-->
							<Premium>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Premium>
							<!--附加险保额		Dec(15,0)	附加险保费与附加险保额之一为必输项-->
							<BaseAmt>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Amnt,15,$leftPadFlag)" />
							</BaseAmt>
							<!--附加险缴费方式	Char(3)		非空	参见附录3.8-->
							<PremType>
								<xsl:apply-templates select="PayIntv" />
							</PremType>
							<!--附加险缴费年期类型	Char(3)	非空	参见附录3.6-->
							<PremTermType>
								<xsl:choose>
									<xsl:when test="PayIntv=0">1</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="PayEndYearFlag" />
									</xsl:otherwise>
								</xsl:choose>
							</PremTermType>
							<!--附加险缴费年期	Char(3)		非空-->
							<PremTerm>
								<xsl:choose>
									<xsl:when test="PayIntv=0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
								</xsl:choose>
							</PremTerm>
							<!--附加险保险年期类型	Char(3)	非空	参见附录3.5-->
							<CoverageType>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">1</xsl:when>
									<xsl:otherwise><xsl:apply-templates select="InsuYearFlag" /></xsl:otherwise>
								</xsl:choose>
							</CoverageType>
							<!--附加险保险年期	Char(3)		非空-->
							<Coverage>
								<xsl:value-of select="InsuYear" />
							</Coverage>
							<!--附加险领取年期类型	Char(1)	非空	参见附录3.7-->
							<PayOutType>
								<xsl:apply-templates
									select="GetYearFlag" />
							</PayOutType>
							<!--附加险领取年期	Char(3)		非空-->
							<PayOut>
								<xsl:value-of select="GetYear" />
							</PayOut>
							<!--附加险领取方式	Char(3)		可空	参见附录3.10-->
							<PayOutMethod></PayOutMethod>
							<!--附加险红利领取方式	Char(3)	可空	参见附录3.9-->
							<DividMethod>
								<xsl:apply-templates select="BonusGetModes"/>
							</DividMethod>
							<!--附加险初始费率	Dec(10,2)	可空-->
							<FirstRate />
							<!--附加险保证利率	Dec(10,2)	可空-->
							<SureRate />
							<!--附加险保单价值初始值	Dec(15,0)	可空-->
							<FirstValue />
							<!--附加险险种类型	Char(1)		可空-->
							<RiskType />
							<!--附加险险种名称	Char(40)		可空-->
							<PlanName>
								<xsl:value-of select="RiskName" />
							</PlanName>
							<!--附加险起领日期	Char(8)		可空	格式：YYYYMMDD -->
							<GetStartDate>
								<xsl:value-of select="GetStartDate" />
							</GetStartDate>
							<!--附加险生效日期	Char(8)		可空	格式：YYYYMMDD -->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--附加险首年度手续费		Dec(15,0)	可空-->
							<FirstCharge></FirstCharge>
							<!--附加险次年度手续费		Dec(15,0)	可空-->
							<SecondCharge />

							<!--附加险私有节点-->
							<Private>
								<!--附加险缴费标准	Dec(15,0)	可空-->
								<StdFee></StdFee>
								<!--附加险综合加费	Dec(15,0)	可空-->
								<ColFee></ColFee>
								<!--附加险职业加费	Dec(15,0)	可空-->
								<WorkFee></WorkFee>
								<!--附加险自动垫交标志	Char(1)	可空	参见附录3.16-->
								<AutoPayFlag></AutoPayFlag>
								<!--附加险特别约定	Char(256)	可空-->
								<SpecialClause/>
								<!--附加被保险人		Char(1)		可空-->
								<AppendIns />
							</Private>
							<!--附加险现金价值节点-->
							<CashValues>
								<xsl:variable name="addCashCount"
									select="count(CashValues/CashValue[Cash != ''])" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($addCashCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$addCashCount > 0">
									<xsl:for-each
										select="CashValues/CashValue">
										<Cash>
											<!--生存年金			Dec(15,0)	可空-->
											<Live />
											<!--疾病身故保险金	Dec(15,0)	可空-->
											<IDAmt />
											<!--意外身故保险金	Dec(15,0)	可空-->
											<ADAmt />
											<!--年度末			Char(3)		可空-->
											<End />
											<!--年末现金价值		Dec(15,0)	可空-->
											<Ch>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Cash,15,$leftPadFlag)" />
											</Ch>
											<!--保单年度			Char(8)		可空-->
											<Year>
												<xsl:value-of
													select="EndYear" />
											</Year>
											<!--交清保额			Dec(15,0)	可空-->
											<PaidAmt />
											<!--现金价值表说明	Char(60)		可空-->
											<Descrip />
										</Cash>
									</xsl:for-each>
								</xsl:if>
							</CashValues>
							<!--附加险红利保额保单年度末现金价值节点-->
							<BonusValues>
								<xsl:variable name="addBonusCount"
									select="count(BonusValues/BonusValue[EndYearCash != ''])" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($addBonusCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$addBonusCount > 0">
									<xsl:for-each
										select="BonusValues/BonusValue">
										<Bonus>
											<!--年度末			Char(3)		可空-->
											<End>
												<xsl:value-of
													select="EndYear" />
											</End>
											<!--年末现金价值		Dec(15,0)	可空-->
											<Cash>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(EndYearCash ,15,$leftPadFlag)" />
											</Cash>
										</Bonus>
									</xsl:for-each>
								</xsl:if>
							</BonusValues>
						</Add>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<Prt>
				<!--打印1		Char(200)	可空-->
				<Line1 />
				<!--打印2		Char(200)	可空-->
				<Line2 />
				<!--打印3		Char(200)	可空-->
				<Line3 />
				<!--打印4		Char(200)	可空-->
				<Line4 />
				<!--打印5		Char(200)	可空-->
				<Line5 />
				<!--打印6		Char(200)	可空-->
				<Line6 />
				<!--打印7		Char(200)	可空-->
				<Line7 />
				<!--打印8		Char(200)	可空-->
				<Line8 />
				<!--打印9		Char(200)	可空-->
				<Line9 />
				<!--打印10		Char(200)	可空-->
				<Line10 />
				<!--打印11		Char(200)	可空-->
				<Line11 />
				<!--打印12		Char(200)	可空-->
				<Line12 />
				<!--打印13		Char(200)	可空-->
				<Line13 />
				<!--打印14		Char(200)	可空-->
				<Line14 />
				<!--打印15		Char(200)	可空-->
				<Line15 />
				<!--打印16		Char(200)	可空-->
				<Line16 />
				<!--打印17		Char(200)	可空-->
				<Line17 />
				<!--打印18		Char(200)	可空-->
				<Line18 />
				<!--打印19		Char(200)	可空-->
				<Line19 />
				<!--打印20		Char(200)	可空-->
				<Line20 />
			</Prt>
		</K_BI>
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="App" match="Appnt">
		<App>
			<!--投保人姓名		Char(60)		非空-->
			<AppName>
				<xsl:value-of select="Name" />
			</AppName>
			<!--投保人性别		Char(1)		非空	参见附录3.1-->
			<AppSex>
				<xsl:value-of select="Sex" />
			</AppSex>
			<!--投保人出生日期	Char(8)		非空	格式：YYYYMMDD-->
			<AppBirthday>
				<xsl:value-of select="Birthday" />
			</AppBirthday>
			<!--投保人证件类型	Char(3)		非空	-->
			<AppIdType>
				<xsl:apply-templates select="IDType" />
			</AppIdType>
			<!--投保人证件号码	Char(30)		非空-->
			<AppIdNo>
				<xsl:value-of select="IDNo" />
			</AppIdNo>
			<!--投保人通讯地址	Char(60)		非空-->
			<AppOfficAddr>
				<xsl:value-of select="Address" />
			</AppOfficAddr>
			<!--投保人邮政编码	Char(6)		非空-->
			<AppOfficPost>
				<xsl:value-of select="ZipCode" />
			</AppOfficPost>
			<!--投保人固定电话	Char(20)		固定电话与手机号码之一为必输项-->
			<AppOfficPhone>
				<xsl:value-of select="Phone" />
			</AppOfficPhone>
			<!--投保人手机号码	Char(20)		固定电话与手机号码之一为必输项-->
			<AppMobile>
				<xsl:value-of select="Mobile" />
			</AppMobile>
			<!--投保人电子邮箱	Char(60)		可空-->
			<AppEmail>
				<xsl:value-of select="Email" />
			</AppEmail>
			<!--投保人职业类型代码	Char(20)	可空	-->
			<AppWork>
				<xsl:apply-templates select="JobCode" />
			</AppWork>
			<!--投保人国籍		Char(10)		可空	-->
			<AppCountry>
				<xsl:apply-templates select="Nationality" />
			</AppCountry>
			<!--投保人工作单位	Char(30)		可空-->
			<AppCompany />
			<!--投保人传真		Char(20)		可空-->
			<AppCall />
			<!--投保人平均年收入	Char(20)		可空	以万元为单位-->
			<AppYearSalary />
			<!--投保人身高		Char(10)		可空	以厘米为单位-->
			<AppHeight>
				<xsl:value-of select="Stature" />
			</AppHeight>
			<!--投保人体重		Char(10)		可空	以千克为单位-->
			<AppWeight></AppWeight>
			<!--投保人证件有效日期	Char(8)	可空	格式：YYYYMMDD -->
			<AppIdExpDate />
			<!--投保人婚姻状况	Char(1)		可空	-->
			<AppMarStat>
				<xsl:apply-templates select="MaritalStatus" />
			</AppMarStat>
		</App>
	</xsl:template>

	<!-- 被保人 -->
	<xsl:template name="Ins" match="Insured">
		<Ins>
			<!--被保人姓名		Char(60)		非空-->
			<InsName>
				<xsl:value-of select="Name" />
			</InsName>
			<!--被保人性别		Char(1)		非空	-->
			<InsSex>
				<xsl:value-of select="Sex" />
			</InsSex>
			<!--被保人出生日期	Char(8)		非空	格式：YYYYMMDD-->
			<InsBirthday>
				<xsl:value-of select="Birthday" />
			</InsBirthday>
			<!--被保人证件类型	Char(3)		非空	-->
			<InsIdType>
				<xsl:apply-templates select="IDType" />
			</InsIdType>
			<!--被保人证件号码	Char(30)		非空-->
			<InsIdNo>
				<xsl:value-of select="IDNo" />
			</InsIdNo>
			<!--被保人通讯地址	Char(60)		非空-->
			<InsOfficAddr>
				<xsl:value-of select="Address" />
			</InsOfficAddr>
			<!--被保人邮政编码	Char(6)		非空-->
			<InsOfficPost>
				<xsl:value-of select="ZipCode" />
			</InsOfficPost>
			<!--被保人固定电话	Char(20)		固定电话与手机号码之一为必输项-->
			<InsOfficPhone>
				<xsl:value-of select="Phone" />
			</InsOfficPhone>
			<!--被保人手机号码	Char(20)		固定电话与手机号码之一为必输项-->
			<InsMobile>
				<xsl:value-of select="Mobile" />
			</InsMobile>
			<!--被保人电子邮箱	Char(60)		可空-->
			<InsEmail>
				<xsl:value-of select="Email" />
			</InsEmail>
			<!--被保人职业类型代码	Char(20)	可空	-->
			<InsWork>
				<xsl:apply-templates select="JobCode" />
			</InsWork>
			<!--被保人是否危险职业	Char(1)	可空	-->
			<WorkFlag />
			<!--被保人国籍		Char(10)		可空	-->
			<InsCountry>
				<xsl:apply-templates select="Nationality" />
			</InsCountry>
			<!--被保人工作单位	Char(30)		可空-->
			<InsCompany />
			<!--被保人传真		Char(20)		可空-->
			<InsCall />
			<!--被保人平均年收入	Char(20)		可空	以万元为单位-->
			<InsYearSalary />
			<!--被保人身高		Char(10)		可空	以厘米为单位-->
			<InsHeight>
				<xsl:value-of select="Stature" />
			</InsHeight>
			<!--被保人体重		Char(10)		可空	以千克为单位-->
			<InsWeight></InsWeight>
			<!--被保人证件有效日期	Char(8)	可空	格式：YYYYMMDD -->
			<InsIdExpDate />
			<!--被保人婚姻状况	Char(1)		可空	-->
			<InsMarStat>
				<xsl:apply-templates select="MaritalStatus" />
			</InsMarStat>
		</Ins>
	</xsl:template>


	<!-- ******************** 以下为枚举类型 ******************** -->
	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">15</xsl:when><!-- 居民身份证 -->
			<xsl:when test=".=9">16</xsl:when><!-- 临时身份证 -->
			<xsl:when test=".=2">17</xsl:when><!-- 军人身份证件 -->
			<xsl:when test=".=1">20</xsl:when><!-- 护照  -->
			<xsl:when test=".=8">21</xsl:when><!-- 其他  -->
			<xsl:when test=".=5">23</xsl:when><!-- 户口簿  -->
			<xsl:otherwise>21</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 职业代码 -->
	<xsl:template name="tran_Job" match="JobCode">
		<xsl:choose>
			<xsl:when test=".=3010101">1</xsl:when><!-- 单位文职内勤 -->
			<xsl:when test=".=3010102">2</xsl:when><!-- 外勤商旅餐饮 -->
			<xsl:when test=".=6230608">3</xsl:when><!-- 农牧钢塑装潢 -->
			<xsl:when test=".=5030206">4</xsl:when><!-- 渔港采砂水泥 -->
			<xsl:when test=".=6230902">5</xsl:when><!-- 电力建筑机械 -->
			<xsl:when test=".=6230618">6</xsl:when><!-- 高空海上航空 -->
			<xsl:when test=".=2021305">7</xsl:when><!-- 海渔航运出国 -->
			<xsl:when test=".=6051302">8</xsl:when><!-- 潜水爆破赛车 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  国籍类型-->
	<xsl:template name="tran_nationtype" match="Nationality">
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

	<!-- 婚姻状况 -->
	<xsl:template name="tran_marStat" match="MaritalStatus">
		<xsl:choose>
			<xsl:when test=".=N">5</xsl:when><!-- 未婚 -->
			<xsl:when test=".=Y">1</xsl:when><!-- 已婚 -->
			<!--<xsl:when test=".=2">6</xsl:when> 丧偶 -->
			<!--<xsl:when test=".=6">2</xsl:when> 离婚 -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 与被保人关系 -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$relation=00">1</xsl:when><!-- 本人 -->
			<xsl:when test="$relation=01"><!-- 父母 -->
				<xsl:choose>
					<xsl:when test="$sex=0">2</xsl:when>
					<xsl:otherwise>3</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=02"><!-- 配偶 -->
				<xsl:choose>
					<xsl:when test="$sex=0">7</xsl:when>
					<xsl:otherwise>6</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=03"><!-- 儿女 -->
				<xsl:choose>
					<xsl:when test="$sex=0">4</xsl:when>
					<xsl:otherwise>5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=04">45</xsl:when><!-- 其他 -->
			<xsl:otherwise>45</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 受益人类型 -->
	<xsl:template name="tran_BeneType" match="Type">
		<xsl:choose>
			<xsl:when test=".=1">1</xsl:when><!-- 死亡受益人 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费方式 -->
	<xsl:template name="tran_PayIntv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=12">5</xsl:when><!-- 年缴 -->
			<xsl:when test=".=1">2</xsl:when><!-- 月缴 -->
			<xsl:when test=".=6">4</xsl:when><!-- 半年缴 -->
			<xsl:when test=".=3">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".=0">1</xsl:when><!-- 趸缴 -->
			<xsl:when test=".=-1">7</xsl:when><!-- 不定期 -->
			<xsl:otherwise>9</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期标志 -->
	<xsl:template name="tran_InsuYearFlag" match="InsuYearFlag ">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when>
			<xsl:when test=".='M'">4</xsl:when>
			<xsl:when test=".='Y'">2</xsl:when>
			<xsl:when test=".='A'">3</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期类型 -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'"></xsl:when> <!-- 天 -->
			<xsl:when test=".='M'"></xsl:when> <!-- 月 -->
			<xsl:when test=".='Y'">2</xsl:when> <!-- 年 -->
			<xsl:when test=".='A'">3</xsl:when> <!-- 缴至某确定年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 红利领取方式 -->
	<xsl:template name="tran_BonusGetMode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- 累积生息 -->
			<xsl:when test=".=4">4</xsl:when><!-- 领取现金 -->
			<xsl:when test=".=3">1</xsl:when><!-- 抵缴保费 -->
			<xsl:when test=".=5">3</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取年期类型 -->
	<xsl:template name="tran_GetYearFlag" match="GetYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'"></xsl:when>
			<xsl:when test=".='D'"></xsl:when>
			<xsl:when test=".='M'">2</xsl:when>
			<xsl:when test=".='Y'">5</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>