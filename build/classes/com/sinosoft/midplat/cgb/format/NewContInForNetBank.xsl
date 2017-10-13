<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>

			<!-- 报文头 -->
			<xsl:apply-templates select="MAIN" />

			<!-- 报文体 -->
			<Body>
				<!-- 此处用来银保通暂存银行投保单流水号 -->
				<OldLogNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</OldLogNo>
				<!-- 投保单(印刷)号 -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo></ContPrtNo>
				<!-- 投保日期 -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</PolApplyDate>
				<!-- 账户姓名 -->
				<AccName>
					<xsl:value-of select="ACCOUNT_INFO/PAY_IN_ACC_NAME" />
				</AccName>
				<!-- 银行账户 -->
				<AccNo>
					<xsl:value-of select="ACCOUNT_INFO/PAY_IN_ACC" />
				</AccNo>
				<!-- 保单递送方式 -->
				<GetPolMode />
				<!-- 保单递送类型1、纸制保单2、电子保单 -->
				<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
				<!-- 职业告知(N/Y) -->
				<JobNotice>
					<xsl:value-of
						select="OCCUPATION_NOTICE/NOTICE_ITEM" />
				</JobNotice>
				<!-- 健康告知(N/Y)  -->
				<HealthNotice>
					<xsl:value-of select="HEALTH_NOTICE/NOTICE_ITEM" />
				</HealthNotice>

				<!-- 销售员工号 -->
				<SellerNo>
					<xsl:value-of select="MAIN/MANAGERNO" />
				</SellerNo>
				<!-- 销售员工姓名 -->
				<TellerName>
					<xsl:value-of select="MAIN/MANAGERNAME" />
				</TellerName>
				<!-- 网点名称 -->
				<AgentComName>
					<xsl:value-of select="MAIN/BRANCHNAME" />
				</AgentComName>

				<!-- 产品组合 -->
				<ContPlan>
					<!-- 产品组合编码 -->
					<ContPlanCode>
						<xsl:apply-templates
							select="PRODUCTS/PRODUCT[MAINSUBFLAG='0']/PRODUCTID" mode="plan" />
					</ContPlanCode>
					<!-- 产品组合份数 -->
					<ContPlanMult>
						<xsl:value-of
							select="PRODUCTS/PRODUCT[MAINSUBFLAG='0']/AMT_UNIT" />
					</ContPlanMult>
				</ContPlan>
				<!-- 投保人 -->
				<xsl:apply-templates select="TBR" />

				<!-- 被保人 -->
				<xsl:apply-templates select="BBR" />

				<!-- 受益人 -->
				<xsl:apply-templates select="SYRS/SYR" />

				<!-- 险种信息 -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头 -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- 交易时间 （hhmmss）-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- 柜员-->
			<TellerNo>sys</TellerNo>
			<!-- 流水号-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- 地区码+网点码-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- 银行编号（核心定义）-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>1</SourceType><!-- 0=银保通柜面、1=网银、8=自助终端 -->
			<xsl:copy-of select="../Head/*" />
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
				<xsl:apply-templates select="TBR_SEX" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="TBR_BIRTH" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="TBR_IDTYPE" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<IDTypeStartDate>
				<xsl:value-of select="TBR_IDEFFSTARTDATE" />
			</IDTypeStartDate><!-- 证件有效起期 -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_IDEFFENDDATE" />
			</IDTypeEndDate><!-- 证件有效止期 -->
			<!-- 职业代码 -->
			<JobCode>
				<xsl:value-of select="TBR_WORKCODE" />
			</JobCode>
			<!-- 年收入 -->
			<Salary>
				<xsl:value-of select="TBR_AVR_SALARY" />
			</Salary>
			<!-- 家庭年收入 -->
			<FamilySalary></FamilySalary>
			<!-- 客户类型 -->
			<LiveZone>
				<xsl:apply-templates select="TBR_RESIDENTSOURCE" />
			</LiveZone>
			<!-- 国籍 -->
			<Nationality>
				<xsl:value-of select="TBR_NATIVEPLACE" />
			</Nationality>
			<!-- 身高(cm) -->
			<Stature></Stature>
			<!-- 体重(kg) -->
			<Weight></Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="TBR_ADDR" />
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
				<xsl:apply-templates select="TBR_BBR_RELA" />
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
				<xsl:apply-templates select="BBR_SEX" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="BBR_BIRTH" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="BBR_IDTYPE" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="BBR_IDNO" />
			</IDNo>
			<IDTypeStartDate>
				<xsl:value-of select="BBR_IDEFFSTARTDATE" />
			</IDTypeStartDate><!-- 证件有效起期 -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_IDEFFENDDATE" />
			</IDTypeEndDate><!-- 证件有效止期 -->
			<!-- 职业代码 -->
			<JobCode>
				<xsl:value-of select="BBR_WORKCODE" />
			</JobCode>
			<!-- 身高(cm)-->
			<Stature></Stature>
			<!-- 国籍-->
			<Nationality>
				<xsl:value-of select="BBR_NATIVEPLACE" />
			</Nationality>
			<!-- 体重(kg) -->
			<Weight></Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="BBR_ADDR" />
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
		<xsl:if test="SYR_NAME != ''">
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
					<xsl:apply-templates select="SYR_SEX" />
				</Sex>
				<!-- 出生日期(yyyyMMdd) -->
				<Birthday>
					<xsl:value-of select="SYR_BIRTH" />
				</Birthday>
				<!-- 证件类型 -->
				<IDType>
					<xsl:apply-templates select="SYR_IDTYPE" />
				</IDType>
				<!-- 证件号码 -->
				<IDNo>
					<xsl:value-of select="SYR_IDNO" />
				</IDNo>
				<!-- 与被保人关系 -->
				<RelaToInsured>
					<xsl:apply-templates select="SYR_BBR_RELA" />
				</RelaToInsured>
				<!-- 受益比例(整数，百分比) -->
				<Lot>
					<xsl:value-of select="BNFT_PROFIT_PCENT" />
				</Lot>
			</Bnf>
		</xsl:if>
	</xsl:template>

	<!-- 险种信息  -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<!-- 险种代码 -->
			<RiskCode>
				<xsl:apply-templates select="PRODUCTID" mode="risk" />
			</RiskCode>
			<!-- 主险险种代码 -->
			<MainRiskCode>
				<xsl:apply-templates
					select="../PRODUCT[MAINSUBFLAG='0']/PRODUCTID" mode="risk" />
			</MainRiskCode>
			<!-- 保额(分) -->
			<Amnt>
				<xsl:value-of select="AMOUNT" />
			</Amnt>
			<!-- 保险费(分) -->
			<Prem>
				<xsl:value-of select="PREMIUM" />
			</Prem>
			<!-- 投保份数 -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult>
			<!-- 缴费频次 -->
			<PayIntv>
				<xsl:apply-templates select="//PAYMETHOD" />
			</PayIntv>
			<!-- 缴费形式 -->
			<PayMode></PayMode>
			<!-- 保险年期年龄标志 -->
			<InsuYearFlag>
				<xsl:apply-templates select="COVERAGE_PERIOD" />
			</InsuYearFlag>
			<!-- 保险年期年龄 -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD='1'">106</xsl:if><!-- 保终身 -->
				<xsl:if test="COVERAGE_PERIOD!='1'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<!-- 缴费年期年龄标志 -->
			<xsl:choose>
				<xsl:when
					test="CHARGE_PERIOD = '1' or CHARGE_PERIOD = '4'">
					<!-- 趸交或交终身 -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<PayEndYearFlag>
						<xsl:apply-templates select="CHARGE_PERIOD" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="CHARGE_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>

			<!-- 红利领取方式 -->
			<BonusGetMode>
				<xsl:apply-templates select="DVDMETHOD" />
			</BonusGetMode>
			<!-- 满期领取金领取方式 -->
			<FullBonusGetMode></FullBonusGetMode>
			<!-- 领取年龄年期标志 -->
			<GetYearFlag></GetYearFlag>
			<!-- 领取年龄 -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear>
			<!-- 领取方式 -->
			<GetIntv>
				<xsl:apply-templates select="REVMETHOD" />
			</GetIntv>
			<!-- 领取银行编码 -->
			<GetBankCode></GetBankCode>
			<!-- 领取银行账户 -->
			<GetBankAccNo>
				<xsl:value-of select="//ACCOUNT_INFO/PAY_OUT_ACC" />
			</GetBankAccNo>
			<!-- 领取银行户名 -->
			<GetAccName>
				<xsl:value-of select="//ACCOUNT_INFO/PAY_OUT_ACC_NAME" />
			</GetAccName>
			<!-- 自动垫交标志 -->
			<AutoPayFlag>
				<xsl:apply-templates select="ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>

	<!-- 性别 -->
	<!-- 广发：1 男，2 女，3 不确定 -->
	<!-- 核心：0 男，1 女 -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 男性 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 女性 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<!-- 广发：1 身份证，2 军人证，3 护照，4 出生证，5 其它 -->
	<!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='3'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='4'">4</xsl:when><!-- 出生证 -->
			<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 投保人/受益人与被保人关系 -->
	<!-- 广发：1 配偶，2 父母，3 子女，4 亲属，5 本人，6 其它 当为身故受益人时，5特指法定受益人 -->
	<!-- 核心：00 本人,01 父母,02 配偶,03 子女,04 其他,05 雇佣,06 抚养,07 扶养,08 赡养 -->
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- 配偶 -->
			<xsl:when test=".='2'">01</xsl:when><!-- 父母 -->
			<xsl:when test=".='3'">03</xsl:when><!-- 子女 -->
			<xsl:when test=".='4'">04</xsl:when><!-- 亲属 -->
			<xsl:when test=".='5'">00</xsl:when><!-- 本人 -->
			<xsl:when test=".='6'">04</xsl:when><!-- 其他 -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<!-- 广发：1 年交，2 半年交，3 季交，4 月交，5 趸交 -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='2'">6</xsl:when><!-- 半年交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交-->
			<xsl:when test=".='4'">1</xsl:when><!-- 月交 -->
			<xsl:when test=".='5'">0</xsl:when><!-- 趸交 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 领取方式 -->
	<!-- 广发：1 月领，2 年领，3 趸领 -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='2'">12</xsl:when><!--年领 -->
			<xsl:when test=".='3'">0</xsl:when><!-- 趸领 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<!-- 广发：0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='5'">D</xsl:when><!-- 按日 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年 -->
			<xsl:when test=".='1'">A</xsl:when><!-- 终身 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 保至某年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<!-- 广发：0 无关，1 趸交，2 按年限交，3 交至某确定年龄，4 终生交费，5 不定期交 -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when> --><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='50002'">50015</xsl:when><!-- 安邦长寿稳赢保险计划  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<xsl:when test=".='L12079'">L12098</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号B款终身寿险（万能型）-->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型 -->
			<xsl:when test=".='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template match="PRODUCTID" mode="plan">
		<xsl:choose>
			<xsl:when test=".='50002'">50015</xsl:when><!-- 安邦长寿稳赢保险计划  -->
			<xsl:when test=".=''"></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 红利领取方式 -->
	<!-- 广发：0 现金给付 ，1抵交保费 ， 2累计生息 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- 直接给付  -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 累计生息 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 垫交标志 -->
	<xsl:template match="ALFLAG">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 否 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 是 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 职业代码 -->
	<xsl:template match="TBR_WORKCODE|BBR_WORKCODE">
		<xsl:choose>
			<xsl:when test=".= '100001'">4030111</xsl:when><!-- 国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test=".= '100002'">2050101</xsl:when><!-- 卫生专业技术人员 -->
			<xsl:when test=".= '100003'">2070109</xsl:when><!-- 金融业务人员 -->
			<xsl:when test=".= '100004'">2080103</xsl:when><!-- 法律专业人员 -->
			<xsl:when test=".= '100005'">2090104</xsl:when><!-- 教学人员 -->
			<xsl:when test=".= '100006'">2100106</xsl:when><!-- 新闻出版及文学艺术工作人员 -->
			<xsl:when test=".= '100007'">2130101</xsl:when><!-- 宗教职业者 -->
			<xsl:when test=".= '100008'">3030101</xsl:when><!-- 邮政和电信业务人员 -->
			<xsl:when test=".= '100009'">4010101</xsl:when><!-- 商业、服务业人员 -->
			<xsl:when test=".= '100010'">5010107</xsl:when><!-- 农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".= '100011'">6240105</xsl:when><!-- 运输人员 -->
			<xsl:when test=".= '100012'">2020103</xsl:when><!-- 地址勘探人员 -->
			<xsl:when test=".= '100013'">2020906</xsl:when><!-- 工程施工人员 -->
			<xsl:when test=".= '100014'">6050611</xsl:when><!-- 加工制造、检验及计量人员 -->
			<xsl:when test=".= '100015'">7010103</xsl:when><!-- 军人 -->
			<xsl:when test=".= '100016'">8010101</xsl:when><!-- 无业 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 居民类型：银行方0=城镇，1=农村；核心1=城镇，2=农村 -->
	<xsl:template match="TBR_RESIDENTSOURCE">
		<xsl:choose>
			<xsl:when test=".= '0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".= '1'">2</xsl:when><!-- 农村 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
