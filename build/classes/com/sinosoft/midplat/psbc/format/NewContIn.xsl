<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>
			<xsl:apply-templates select="MAIN" />

			<Body>
				<!-- 投保单(印刷)号 -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo></ContPrtNo>
				<!-- 投保日期 -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TB_DATE" />
				</PolApplyDate>
				
				<!--出单网点名称-->
				<AgentComName><xsl:value-of select="MAIN/BRNM"/></AgentComName>
				<!--银行销售人员工号-->
				<SellerNo><xsl:value-of select="MAIN/SALE_ID"/></SellerNo>
				
				<!-- 账户姓名 -->
				<AccName>
					<xsl:value-of select="TBR/TBR_NAME" />
				</AccName>
				<!-- 银行账户 -->
				<AccNo>
					<xsl:value-of select="MAIN/PAYACC" />
				</AccNo>
				<!-- 保单递送方式 -->
				<GetPolMode>
					<xsl:call-template name="tran_sendmethod">
						<xsl:with-param name="sendmethod">
							<xsl:value-of select="MAIN/SENDMETHOD" />
						</xsl:with-param>
					</xsl:call-template>
				</GetPolMode>
				<!-- 职业告知(N/Y) -->
				<JobNotice></JobNotice>
				<!-- 健康告知(N/Y)  -->
				<HealthNotice>
					<xsl:call-template name="tran_healthnotice">
						<xsl:with-param name="healthnotice">
							<xsl:value-of select="HEALTH_NOTICE/NOTICE_ITEM" />
						</xsl:with-param>
					</xsl:call-template>
				</HealthNotice>
				<!-- 产品组合 -->
				<ContPlan>
					<!-- 产品组合编码 -->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode">
								<xsl:value-of select="//PRODUCT[MAINSUBFLG='1']/PRODUCTID" />
							</xsl:with-param>
						</xsl:call-template>
					</ContPlanCode>
					<!-- 产品组合份数 -->
					<ContPlanMult>
						<xsl:value-of select="//PRODUCT[MAINSUBFLG='1']/AMT_UNIT" />
					</ContPlanMult>
				</ContPlan>
				<!-- 投保人 -->
				<xsl:apply-templates select="TBR" />

				<!-- 被保人 -->
				<xsl:apply-templates select="BBR" />

				<!-- 受益人 -->
				<xsl:choose>
					<xsl:when test="SYRS/SYR/SYR_NAME!=''">
						<xsl:apply-templates select="SYRS/SYR" />
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

				<!-- 险种信息 -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="MAIN">
		<Head>
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="Appnt" match="TBR">
		<Appnt>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="TBR_NAME" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex">
						<xsl:value-of select="TBR_SEX" />
					</xsl:with-param>
				</xsl:call-template>
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="TBR_BIRTH" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="TBR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- 证件有效期 -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_EFF_DATE" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="TBR_WORKTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</JobCode>
			
			
			<!-- 投保人年收入，银行单位为分 -->
			<Salary><xsl:value-of select="TBR_INCOME"/></Salary>
			
			<!-- 投保人家庭年收入，银行单位为分 -->
			<FamilySalary><xsl:value-of select="TBR_HM" /></FamilySalary>
			<!-- 1.城镇，2.农村 -->
			<LiveZone><xsl:value-of select="TBR_TP"/></LiveZone>
			
			<!-- 国籍 FIXME 需要映射-->
			<Nationality><xsl:value-of select="TBR_CNTY_CODE"/></Nationality>
			<!-- 身高(cm) -->
			<Stature><xsl:value-of select="TBR_HEIGHT"/></Stature>
			<!-- 体重(kg) -->
			<Weight><xsl:value-of select="TBR_WEIGHT"/></Weight>
			<!-- 投保人工作单位 -->
			<Company><xsl:value-of select="TBR_UNIT"/></Company>
			<!-- 投保人省别 FIXME 需要映射-->
			<Province><xsl:value-of select="TBR_PROV"/></Province>
			<!-- 投保人所属市县 -->
			<City></City>
			
			
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="TBR_CITY"/><xsl:value-of select="TBR_ADDR" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="TBR_POSTCODE" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="TBR_MOBILE" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="TBR_TEL" />
			</Phone>
			<!-- 电子邮件-->
			<Email>
				<xsl:value-of select="TBR_EMAIL" />
			</Email>
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="TBR_BBR_RELA" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- 被保人 -->
	<xsl:template name="Insured" match="BBR">
		<Insured>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="BBR_NAME" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex">
						<xsl:value-of select="BBR_SEX" />
					</xsl:with-param>
				</xsl:call-template>
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="BBR_BIRTH" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="BBR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="BBR_IDNO" />
			</IDNo>
			<!-- 证件有效期 -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_EFF_DATE" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="BBR_WORKTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</JobCode>
			
			
			<!-- 国籍 FIXME 需要映射-->
			<Nationality><xsl:value-of select="BBR_CNTY_CODE"/></Nationality>
			<!-- 身高(cm) -->
			<Stature><xsl:value-of select="BBR_HEIGHT"/></Stature>
			<!-- 体重(kg) -->
			<Weight><xsl:value-of select="BBR_WEIGHT"/></Weight>
			<!-- 被保人工作单位 -->
			<Company><xsl:value-of select="BBR_UNIT"/></Company>
			<!-- 被保人省别 FIXME 需要映射-->
			<Province><xsl:value-of select="BBR_PROV"/></Province>
			<!-- 被保人所属市县 -->
			<City></City>
			
			
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="BBR_CITY"/><xsl:value-of select="BBR_ADDR" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="BBR_POSTCODE" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="BBR_MOBILE" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="BBR_TEL" />
			</Phone>
			<!-- 电子邮件-->
			<Email>
				<xsl:value-of select="BBR_EMAIL" />
			</Email>
		</Insured>
	</xsl:template>

	<!-- 受益人 -->
	<xsl:template name="Bnf" match="SYRS/SYR">
		<Bnf>
			<!-- 默认为“1-身故受益人” -->
			<Type>1</Type>
			<!-- 受益顺序 -->
			<Grade>
				<xsl:value-of select="SYR_ORDER" />
			</Grade>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="SYR_NAME" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="SYR_SEX" />
			</Sex>
			
			<!-- 国籍 FIXME 需要映射-->
			<Nationality><xsl:value-of select="SYR_CNTY_CODE"/></Nationality>
			
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="SYR_BIRTH" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="SYR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="SYR_IDNO" />
			</IDNo>
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="SYR_BBR_RELA" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
			<!-- 受益比例(整数，百分比) -->
			<Lot>
				<xsl:value-of select="BNFT_PROFIT_PCENT" />
			</Lot>
		</Bnf>
	</xsl:template>

	<!-- 险种信息  -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
			</RiskCode><!-- 险种代码 -->
			<MainRiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="../PRODUCT[MAINSUBFLG='1']/PRODUCTID" />
				</xsl:call-template>
			</MainRiskCode><!-- 主险险种代码 -->
			<Amnt>
				<xsl:value-of select="AMT" />
			</Amnt><!-- 保额(分) -->
			<Prem>
				<xsl:value-of select="PREMIUM" />
			</Prem><!-- 保险费(分) -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult><!-- 投保份数 -->
			<PayIntv><!-- 缴费频次 -->
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="payintv">
						<xsl:value-of select="PAYMETHOD" />
					</xsl:with-param>
				</xsl:call-template>
			</PayIntv>
			<PayMode></PayMode><!-- 缴费形式, 无论传什么给核心，核心都默认存A=银行转账 -->
			<InsuYearFlag><!-- 保险年期年龄标志 -->
				<xsl:call-template name="tran_InsuYearFlag">
					<xsl:with-param name="insuyearflag">
						<xsl:value-of select="COVERAGE_PERIOD" />
					</xsl:with-param>
				</xsl:call-template>
			</InsuYearFlag>
			<!-- 保险年期年龄 -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD=1">106</xsl:if><!-- 保终身 -->
				<xsl:if test="COVERAGE_PERIOD!=1">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<xsl:if test="PAYMETHOD = 5"><!-- 趸交 -->
				<PayEndYearFlag>Y</PayEndYearFlag>
				<PayEndYear>1000</PayEndYear>
			</xsl:if>
			<xsl:if test="PAYMETHOD != 5">
				<PayEndYearFlag>
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="payendyearflag">
							<xsl:value-of select="CHARGE_PERIOD" />
						</xsl:with-param>
					</xsl:call-template>
				</PayEndYearFlag><!-- 缴费年期年龄标志 -->
				<PayEndYear>
					<xsl:value-of select="CHARGE_YEAR" />
				</PayEndYear><!-- 缴费年期年龄 -->
			</xsl:if>

			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="bonusgetmode"
						select="DVDMETHOD" />
				</xsl:call-template>
			</BonusGetMode><!-- 红利领取方式 -->
			<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->
			<GetYearFlag></GetYearFlag><!-- 领取年龄年期标志 -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear><!-- 领取年龄 -->
			<GetIntv/><!-- 领取方式 -->
			<GetBankCode></GetBankCode><!-- 领取银行编码 -->
			<GetBankAccNo></GetBankAccNo><!-- 领取银行账户 -->
			<GetAccName></GetAccName><!-- 领取银行户名 -->
			<AutoPayFlag>
				<xsl:value-of select="ALFLAG" />
			</AutoPayFlag><!-- 自动垫交标志 -->
		</Risk>
	</xsl:template>



	<!-- 重要字段代码转换（请仔细核对） -->
	<!-- 性别 -->
	<xsl:template name="tran_sex">
		<xsl:param name="sex">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$sex = 1">0</xsl:when><!-- 男性 -->
			<xsl:when test="$sex = 2">1</xsl:when><!-- 女性 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<xsl:when test="$idtype=1">0</xsl:when><!-- 身份证 -->
			<xsl:when test="$idtype=2">2</xsl:when><!-- 军官证 -->
			<xsl:when test="$idtype=3">1</xsl:when><!-- 护照 -->
			<xsl:when test="$idtype=4">4</xsl:when><!-- 出生证 -->
			<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 投保人与被保人关系 -->
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
		<xsl:if test="$payintv = '1'">12</xsl:if><!-- 年缴 -->
		<xsl:if test="$payintv = '2'">6</xsl:if><!-- 半年交 -->
		<xsl:if test="$payintv = '3'">3</xsl:if><!-- 季交-->
		<xsl:if test="$payintv = '4'">1</xsl:if><!-- 月交 -->
		<xsl:if test="$payintv = '5'">0</xsl:if><!-- 趸交 -->
	</xsl:template>

	<!-- 缴费形式 --><!-- 需要再次确认  -->
	<xsl:template name="tran_PayMode">
		<xsl:param name="paymode">0</xsl:param>
		<xsl:if test="$paymode = '1'">7</xsl:if><!-- 银行转帐  -->
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
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 --><!-- 需要再次确认  -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:choose>
			<xsl:when test="$payendyearflag=2">Y</xsl:when><!-- 按年限缴 -->
			<xsl:when test="$payendyearflag=3">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test="$payendyearflag=4">A</xsl:when><!-- 终身缴费 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<!-- 即使银行和我司险种代码相同也要转换，为了限制某个银行只能卖的险种 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12074'">L12074</xsl:when>
			<!-- 安邦盛世9号两全保险（分红型）-->
			<xsl:when test="$riskcode=122006">122006</xsl:when>
			<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
			<xsl:when test="$riskcode=122009">122009</xsl:when>
			<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test="$riskcode=122012">L12079</xsl:when>
			<!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskcode=122010">L12100</xsl:when>
			<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test="$riskcode=50003">50016</xsl:when>
			<!-- 50003(50016)-安邦长寿利丰保险计划  -->
			<xsl:when test="$riskcode='L12084'">L12084</xsl:when>
			<!-- 安邦汇赢2号年金保险A款  -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>
			<!-- 安邦东风5号两全保险（万能型）  -->
			<!-- <xsl:when test="$riskcode='L12094'">L12094</xsl:when>-->
			<!-- 安邦汇赢3号年金保险A款  -->
			<!-- <xsl:when test="$riskcode='L12088'">L12088</xsl:when>-->
			<!-- 安邦东风9号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50003(50016)-安邦长寿利丰保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , 122048(L12081)-安邦长寿添利终身寿险（万能型）-->
			<xsl:when test="$contPlanCode='50003'">50016</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 红利领取方式 -->
	<xsl:template name="tran_BonusGetMode">
		<xsl:param name="bonusgetmode" />
		<xsl:choose>
			<xsl:when test="$bonusgetmode=0">2</xsl:when><!-- 直接给付  -->
			<xsl:when test="$bonusgetmode=1">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test="$bonusgetmode=2">1</xsl:when><!-- 累计生息 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 领取方式 -->
	<xsl:template name="tran_GetIntv">
		<xsl:param name="getintv" />
		<xsl:choose>
			<xsl:when test="$getintv=1">1</xsl:when><!-- 月领 -->
			<xsl:when test="$getintv=2">2</xsl:when><!-- 年领 -->
			<xsl:when test="$getintv=3">3</xsl:when><!-- 趸领  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- 保单提送方式 -->
	<xsl:template name="tran_sendmethod">
		<xsl:param name="sendmethod">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$sendmethod = 1">2</xsl:when>
			<xsl:when test="$sendmethod = 2">0</xsl:when>
			<xsl:when test="$sendmethod = 3">3</xsl:when>
			<xsl:when test="$sendmethod = 4">1</xsl:when><!-- 银行领取 -->
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>

	<!-- 婚姻状态 -->
	<xsl:template name="tran_marriage">
		<xsl:param name="marriage">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$marriage = 0">0</xsl:when><!-- 未婚 -->
			<xsl:when test="$marriage = 1">1</xsl:when><!-- 已婚 -->
			<xsl:when test="$marriage = 2">6</xsl:when><!-- 离婚 -->
			<xsl:when test="$marriage = 3">2</xsl:when><!-- 丧偶 -->
			<xsl:when test="$marriage = 4">7</xsl:when><!-- 同居 -->
			<xsl:when test="$marriage = 5">8</xsl:when><!-- 分居 -->
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>
	
	<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
	<xsl:when test="$jobcode= 4030111">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
	<xsl:when test="$jobcode= 2050101">2050101</xsl:when>	<!-- 卫生专业技术人员 -->
	<xsl:when test="$jobcode= 2070109">2070109</xsl:when>	<!-- 金融业务人员 -->
	<xsl:when test="$jobcode= 2080103">2080103</xsl:when>	<!-- 法律专业人员 -->
	<xsl:when test="$jobcode= 2090104">2090104</xsl:when>	<!-- 教学人员 -->
	<xsl:when test="$jobcode= 2100106">2100106</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
	<xsl:when test="$jobcode= 2130101">2130101</xsl:when>	<!-- 宗教职业者 -->
	<xsl:when test="$jobcode= 3030101">3030101</xsl:when>	<!-- 邮政和电信业务人员 -->
	<xsl:when test="$jobcode= 4010101">4010101</xsl:when>	<!-- 商业、服务业人员 -->
	<xsl:when test="$jobcode= 5010107">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
	<xsl:when test="$jobcode= 6240105">6240105</xsl:when>	<!-- 运输人员 -->
	<xsl:when test="$jobcode= 2020103">2020103</xsl:when>	<!-- 地址勘探人员 -->
	<xsl:when test="$jobcode= 2020906">2020906</xsl:when>	<!-- 工程施工人员 -->
	<xsl:when test="$jobcode= 6050611">6050611</xsl:when>	<!-- 加工制造、检验及计量人员 -->
	<xsl:when test="$jobcode= 7010103">7010103</xsl:when>	<!-- 军人 -->
	<xsl:when test="$jobcode= 8010101">8010101</xsl:when>	<!-- 无业 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 健康告知 -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice='Y'">N</xsl:when><!-- 邮储Y表示健康的 -->
	<xsl:otherwise>Y</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
