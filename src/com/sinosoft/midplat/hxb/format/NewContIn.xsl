<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	
	<xsl:template match="/INSU">
	<xsl:variable name="MainRisk" select="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
		<TranData>
			<!-- 请求报文头 -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- 请求报文体 -->
			<Body>
				<!-- 投保单(印刷)号 -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLYNO" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
				<!-- 投保日期 -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TB_DATE" />
				</PolApplyDate>
				<!-- 账户姓名 -->
				<AccName>
					<xsl:value-of select="MAIN/PAYNAME" />
				</AccName>
				<!-- 银行账户 -->
				<AccNo>
					<xsl:value-of select="MAIN/PAYACC" />
				</AccNo>
				<!-- 保单递送方式 -->
				<GetPolMode>
					<xsl:apply-templates select="MAIN/SENDMETHOD" />
				</GetPolMode>
				<!-- 职业告知(N/Y) -->
				<JobNotice />
				<!-- 健康告知(N/Y)  -->
				<HealthNotice>
					<xsl:apply-templates select="MAIN/HEALTHTAG" />
				</HealthNotice>
				
				<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
				<PolicyIndicator />
				<!--累计投保身故保额 这个金额字段比较特殊，单位是百元-->
				<InsuredTotalFaceAmount />
				
				<!-- 销售员工号 -->
				<SellerNo><xsl:value-of select="MAIN/REMARK1" /></SellerNo>
				<!-- 销售员工姓名 -->
				<TellerName />
				<!-- 银行销售人员资格证 -->
				<TellerCertiCode />
				<!-- 网点名称 -->
				<AgentComName />
				
				<!-- 产品组合 -->
				<ContPlan>
					<!-- 产品组合编码 -->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode">
								<xsl:value-of select="$MainRisk/PRODUCTID" />
							</xsl:with-param>
						</xsl:call-template>
					</ContPlanCode>
					<!-- 产品组合份数 -->
					<ContPlanMult>
						<xsl:value-of select="$MainRisk/AMT_UNIT" />
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
	
	<!-- 报文头内容转换 -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<TranDate>
				<xsl:value-of select="BANK_DATE" />
			</TranDate>
			<!-- 交易时间 （hhmmss）-->
			<TranTime>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/>
			</TranTime>
			<!-- 柜员-->
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
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
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
	
	<!-- 投保人信息 -->
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
			<!-- 证件有效起期 -->
			<IDTypeStartDate>
				<xsl:value-of select="TBR_IDEFFSTARTDATE" />
			</IDTypeStartDate>
			<!-- 证件有效止期 -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_IDEFFENDDATE" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="TBR_OCCUTYPE" />
				</xsl:call-template>
			</JobCode>
			<!-- 年收入 -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_REMARK1)" />
			</Salary>
			<!-- 家庭年收入 -->
			<FamilySalary />
			<!-- 客户类型 -->
			<LiveZone />
			<!--风险测评结果是否适合投保，保监会3号文增加该字段。Y是N否-->
			<RiskAssess />
			<!-- 国籍 -->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="TBR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="TBR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- 身高(cm) -->
			<Stature />
			<!-- 体重(kg) -->
			<Weight />
			<!-- 婚否(N/Y) -->
			<MaritalStatus />
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
	
	<!-- 被保人信息 -->
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
			
			<!-- 证件有效起期 -->
			<IDTypeStartDate>
				<xsl:value-of select="BBR_IDEFFSTARTDATE" />
			</IDTypeStartDate>
			<!-- 证件有效止期 -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_IDEFFENDDATE" />
			</IDTypeEndDate>
			
			<!-- 职业代码 -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="BBR_OCCUTYPE" />
				</xsl:call-template>
			</JobCode>
			<!-- 身高(cm)-->
			<Stature />
			<!-- 国籍-->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="BBR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="BBR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- 体重(kg) -->
			<Weight />
			<!-- 婚否(N/Y) -->
			<MaritalStatus />
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
			<!-- 国籍-->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="SYR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="SYR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- 受益比例(整数，百分比) -->
			<Lot>
				<xsl:value-of select="SYR_PCT" />
			</Lot>
		</Bnf>
	</xsl:template>
	
	<!-- 产品信息 -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<!-- 险种代码 -->
			<RiskCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
			</RiskCode>
			<!-- 主险险种代码 -->
			<MainRiskCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="MAINPRODUCTID" />
				</xsl:call-template>
			</MainRiskCode>
			
			<!-- 保额(分) -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMNT)" />
			</Amnt>
			<!-- 保险费(分) -->
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" />
			</Prem>
			<!-- 投保份数 -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult>
			<!-- 缴费频次 -->
			<PayIntv>
				<xsl:apply-templates select="../../MAIN/PAYMETHOD" />
			</PayIntv>
			<!-- 缴费形式:A=银保通银行转帐 -->
			<PayMode>A</PayMode>
			
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
				<xsl:when test="CHARGE_PERIOD = '5'">
					<!-- 趸交 -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:when test="CHARGE_PERIOD = '8'">
					<!-- 终身缴费 -->
					<PayEndYearFlag>A</PayEndYearFlag>
					<PayEndYear>106</PayEndYear>
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
			<FullBonusGetMode />
			<!-- 领取年龄年期标志 -->
			<GetYearFlag />
			<!-- 领取年龄 -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear>
			<!-- 领取方式 -->
			<GetIntv>
				<xsl:apply-templates select="REVMETHOD" />
			</GetIntv>
			<!-- 领取银行编码 -->
			<GetBankCode />
			<!-- 领取银行账户 -->
			<GetBankAccNo />
			<!-- 领取银行户名 -->
			<GetAccName />
			<!-- 自动垫交标志 -->
			<AutoPayFlag>
				<xsl:apply-templates select="ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>
	
	<!-- 保单递送类型,核心：1=邮寄，2=银行柜面领取；银行：1=部门发送，2=邮寄，3=上门递送，4=银行柜台 -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'"></xsl:when>
			<xsl:when test=".='2'">1</xsl:when>
			<xsl:when test=".='3'"></xsl:when>
			<xsl:when test=".='4'">2</xsl:when>
			<xsl:otherwise></xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 健康告知，核心：N=无，Y=有；银行：0=无，1=有 -->
	<xsl:template match="HEALTHTAG">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when>
			<xsl:when test=".='1'">Y</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- 性别，核心：0=男性，1=女性；银行：1 男，2 女，3 不确定 -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 男性 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 女性 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型 -->
	<!-- 银行证件类型：51居民身份证或临时身份证,52外国公民护照,53户口簿,54其他类个人身份有效证件,55港澳居民往来内地通行证,56军人或武警身份证件,57士兵证,58军官证,59文职干部证,60军官退休证,61文职干部退休证,62武警身份证件,63武警士兵证,64警官证,65武警文职干部证,66武警军官退休证,67武警文职干部退休证,98其他,99分行客户虚拟证件 -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='51'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='52'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='56'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='57'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='58'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='60'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='62'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='63'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='64'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='65'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='66'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='67'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='53'">5</xsl:when><!-- 户口簿 -->
			<xsl:when test=".='98'">8</xsl:when><!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 职业代码 -->
	<xsl:template name="tran_jobcode">
		<xsl:param name="jobcode" />
		<xsl:choose>
			<xsl:when test="$jobcode='A'">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test="$jobcode='B'">2050101</xsl:when>	<!-- 卫生专业技术人员 -->
			<xsl:when test="$jobcode='C'">2070109</xsl:when>	<!-- 金融业务人员 -->
			<xsl:when test="$jobcode='D'">2080103</xsl:when>	<!-- 法律专业人员 -->
			<xsl:when test="$jobcode='E'">2090104</xsl:when>	<!-- 教学人员 -->
			<xsl:when test="$jobcode='F'">2100106</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
			<xsl:when test="$jobcode='G'">2130101</xsl:when>	<!-- 宗教职业者 -->
			<xsl:when test="$jobcode='H'">3030101</xsl:when>	<!-- 邮政和电信业务人员 -->
			<xsl:when test="$jobcode='I'">4010101</xsl:when>	<!-- 商业、服务业人员 -->
			<xsl:when test="$jobcode='J'">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
			<xsl:when test="$jobcode='K'">6240105</xsl:when>	<!-- 运输人员 -->
			<xsl:when test="$jobcode='L'">2020103</xsl:when>	<!-- 地址勘探人员 -->
			<xsl:when test="$jobcode='M'">2020906</xsl:when>	<!-- 工程施工人员 -->
			<xsl:when test="$jobcode='N'">6050611</xsl:when>	<!-- 加工制造、检验及计量人员 -->
			<xsl:when test="$jobcode='O'">7010103</xsl:when>	<!-- 军人 -->
			<xsl:when test="$jobcode='P'">8010101</xsl:when>	<!-- 无业 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 国籍代码 -->
	<xsl:template name="tran_nativeplace">
		<xsl:param name="nativeplace" />
		<xsl:param name="iDType" />
		<xsl:choose>
			<xsl:when test="$nativeplace='' and $iDType='51'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='53'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='56'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='57'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='58'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='59'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='60'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='61'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='62'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='63'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='64'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='65'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='66'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='' and $iDType='67'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='51'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='53'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='56'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='57'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='58'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='59'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='60'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='61'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='62'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='63'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='64'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='65'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='66'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0999' and $iDType='67'">CHN</xsl:when><!-- 中国 -->
			<xsl:when test="$nativeplace='0156'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='0344'">CHN</xsl:when>	<!-- 中国香港 -->
			<xsl:when test="$nativeplace='0158'">CHN</xsl:when>	<!-- 中国台湾 -->
			<xsl:when test="$nativeplace='0446'">CHN</xsl:when>	<!-- 中国澳门 -->
			<xsl:when test="$nativeplace='0392'">JP</xsl:when>	<!-- 日本 -->
			<xsl:when test="$nativeplace='0840'">US</xsl:when>	<!-- 美国 -->
			<xsl:when test="$nativeplace='0643'">RU</xsl:when>	<!-- 俄罗斯 -->
			<xsl:when test="$nativeplace='0826'">GB</xsl:when>	<!-- 英国 -->
			<xsl:when test="$nativeplace='0250'">FR</xsl:when>	<!-- 法国 -->
			<xsl:when test="$nativeplace='0276'">DE</xsl:when>	<!-- 德国 -->
			<xsl:when test="$nativeplace='0410'">KR</xsl:when>	<!-- 韩国 -->
			<xsl:when test="$nativeplace='0702'">SG</xsl:when>	<!-- 新加坡 -->
			<xsl:when test="$nativeplace='0360'">ID</xsl:when>	<!-- 印度尼西亚 -->
			<xsl:when test="$nativeplace='0356'">IN</xsl:when>	<!-- 印度 -->
			<xsl:when test="$nativeplace='0380'">IT</xsl:when>	<!-- 意大利 -->
			<xsl:when test="$nativeplace='0458'">MY</xsl:when>	<!-- 马来西亚 -->
			<xsl:when test="$nativeplace='0764'">TH</xsl:when>	<!-- 泰国 -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 投保人、被保人关系；受益人、被保人关系 -->
	<!-- 核心：00 本人,01 父母,02 配偶,03 子女,04 其他,05 雇佣,06 抚养,07 扶养,08 赡养 -->	
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='1'">00</xsl:when><!-- 本人 -->
			<xsl:when test=".='2'">02</xsl:when><!-- 丈夫 -->
			<xsl:when test=".='3'">02</xsl:when><!-- 妻子 -->
			<xsl:when test=".='4'">01</xsl:when><!-- 父亲 -->
			<xsl:when test=".='5'">01</xsl:when><!-- 母亲 -->
			
			<xsl:when test=".='6'">03</xsl:when><!-- 儿子 -->
			<xsl:when test=".='7'">03</xsl:when><!-- 女儿 -->
			<xsl:when test=".='8'">04</xsl:when><!-- 祖父 -->
			<xsl:when test=".='9'">04</xsl:when><!-- 祖母 -->
			<xsl:when test=".='10'">04</xsl:when><!-- 孙子 -->
			<xsl:when test=".='11'">04</xsl:when><!-- 孙女 -->
			<xsl:when test=".='12'">04</xsl:when><!-- 外祖父 -->
			<xsl:when test=".='13'">04</xsl:when><!-- 外祖母 -->
			<xsl:when test=".='14'">04</xsl:when><!-- 外孙 -->
			<xsl:when test=".='15'">04</xsl:when><!-- 外孙女 -->
			<xsl:when test=".='16'">04</xsl:when><!-- 哥哥 -->
			<xsl:when test=".='17'">04</xsl:when><!-- 姐姐 -->
			<xsl:when test=".='18'">04</xsl:when><!-- 弟弟 -->
			<xsl:when test=".='19'">04</xsl:when><!-- 妹妹 -->
			<xsl:when test=".='20'">04</xsl:when><!-- 公公 -->
			<xsl:when test=".='21'">04</xsl:when><!-- 婆婆 -->
			<xsl:when test=".='22'">04</xsl:when><!-- 儿媳 -->
			<xsl:when test=".='23'">04</xsl:when><!-- 岳父 -->
			<xsl:when test=".='24'">04</xsl:when><!-- 岳母 -->
			<xsl:when test=".='25'">04</xsl:when><!-- 女婿 -->
			<xsl:when test=".='26'">04</xsl:when><!-- 其它亲属 -->
			<xsl:when test=".='27'">04</xsl:when><!-- 同事 -->
			<xsl:when test=".='28'">04</xsl:when><!-- 朋友 -->
			<xsl:when test=".='29'">05</xsl:when><!-- 雇主 -->
			<xsl:when test=".='30'">04</xsl:when><!-- 其它 -->
			<xsl:otherwise>04</xsl:otherwise><!-- 其它 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , 122048-安邦长寿添利终身寿险（万能型）-->
			<!-- 50015-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , L12081-安邦长寿添利终身寿险（万能型）-->
			<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<!-- 50012-安邦长寿安享5号保险计划 主险：L12070 - 安邦长寿安享5号年金保险，附加险：L12071 - 安邦附加长寿添利5号两全保险（万能型） -->
			<xsl:when test="$contPlanCode='50012'">50012</xsl:when>
			<!-- 50011-安邦长寿安享3号保险计划 主险：L12068 - 安邦长寿安享3号年金保险，附加险：L12069 - 安邦附加长寿添利3号两全保险（万能型） -->
			<xsl:when test="$contPlanCode='50011'">50011</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- 险种代码 -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test="$riskcode='122012'">L12079</xsl:when>	<!--安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- xsl:when test="$riskcode='122010'">L12078</xsl:when> -->	<!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
			<!-- add 20150807 增加安享3号和安享5号产品  begin -->
			<xsl:when test="$riskcode='50011'">50011</xsl:when>	    <!--安邦长寿安享3号保险计划 -->
			<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!--安邦长寿安享5号保险计划 -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<!-- add 20150807 增加安享3号和安享5号产品  end -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			<xsl:when test="$riskcode='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<!-- 银行：1 年交，2 半年交，3 季交，4 月交，5 趸交，6 不定期交，7 交至某确定年龄，8 终生缴费 -->
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
	
	<!-- 保险年期类型 -->
	<!-- 银行：0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- 终身 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 保至某年龄 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月 -->
			<xsl:when test=".='5'">D</xsl:when><!-- 按日 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<!-- 银行：1 年缴，2 半年缴，3 季缴，4 月缴，5 趸缴， 6 不定期缴， 7 缴至某确定年龄， 8 终生缴费 -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月限缴 -->
			<xsl:when test=".='5'">Y</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='7'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='8'">A</xsl:when><!-- 终生缴费 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- 红利领取方式 -->
	<!-- 银行：0 现金给付 ，1抵交保费 ， 2累计生息， 3 增额交清 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- 直接给付  -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 累计生息 -->
			<xsl:when test=".='3'">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取方式 -->
	<!-- 银行：1月领 ，  2年领 ，  3趸领（一次性领取），4、季领 5、半年领 -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='2'">12</xsl:when><!--年领 -->
			<xsl:when test=".='3'">0</xsl:when><!-- 趸领 -->
			<xsl:when test=".='4'">3</xsl:when><!-- 趸领 -->
			<xsl:when test=".='5'">6</xsl:when><!-- 趸领 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 垫交标志 银行：1垫交，0非垫缴 -->
	<xsl:template match="ALFLAG">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 否 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 是 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

