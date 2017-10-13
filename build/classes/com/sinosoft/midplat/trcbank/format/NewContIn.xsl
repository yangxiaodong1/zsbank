<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TXLife">
		<TranData>
			<xsl:apply-templates select="Head" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<TranDate><xsl:value-of select="MsgSendDate" /></TranDate>
			<TranTime><xsl:value-of select="MsgSendTime" /></TranTime>
			<TellerNo><xsl:value-of select="OperTellerNo" /></TellerNo>
			<TranNo><xsl:value-of select="TransSerialCode" /></TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
		<ProposalPrtNo><xsl:value-of select="PolicyInfo/PolHNo" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="PolicyInfo/PolPrintCode" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="PolicyInfo/InsureDate" /></PolApplyDate>
		<AccName><xsl:value-of select="PolicyInfo/AccName" /></AccName>
		<AccNo><xsl:value-of select="PolicyInfo/AccNo" /></AccNo>
		<GetPolMode><xsl:apply-templates select="PolicyInfo/SendPolType" /></GetPolMode><!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
		<JobNotice><xsl:value-of select="PolicyInfo/DangerInf" /></JobNotice><!-- 职业告知(N/Y) -->
		<HealthNotice><xsl:value-of select="PolicyInfo/HealthInf" /></HealthNotice><!-- 健康告知(N/Y)  -->
		<!--未成年被保险人是否在其他保险公司投保身故保险 Y是/N否-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredList/InsuredInFo/DeadInfo > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!--累计投保身故保额(核心单位百元)-->
        <xsl:choose>
			<xsl:when test="InsuredList/InsuredInFo/DeadInfo='0.00' or InsuredList/InsuredInFo/DeadInfo=''">
				<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount><xsl:value-of select="InsuredList/InsuredInFo/DeadInfo*0.01" /></InsuredTotalFaceAmount>
			</xsl:otherwise>
		</xsl:choose>
		<PolicyDeliveryMethod>1</PolicyDeliveryMethod><!-- 保单递送类型1、纸制保单2、电子保单 -->
		<SellerNo>
        	<xsl:value-of select="PolicyInfo/ClerkCode" /><!-- 销售人员工号 -->
        </SellerNo>
		<AgentComName><xsl:value-of select="BranchName" /></AgentComName><!--出单网点名称-->
		<AgentComCertiCode></AgentComCertiCode><!-- 网点许可证-->
		<TellerName><xsl:value-of select="PolicyInfo/ClerkName" /></TellerName><!--银行销售人员名称-->
		<TellerCertiCode><xsl:value-of select="PolicyInfo/ClerkCard" /></TellerCertiCode><!-- 销售人员资格证-->
		<xsl:variable name="MainRisk"   select="PlanCodeInfo/PClist/PCCategory/PCInfo[PCIsMajor='Y']" />
		<!-- 产品组合 -->
        <ContPlan>
            <!-- 产品组合编码 -->
            <ContPlanCode>
                <xsl:call-template name="tran_ContPlanCode">
                    <xsl:with-param name="contPlanCode">
                        <xsl:value-of select="$MainRisk/PCCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </ContPlanCode>
            <!-- 产品组合份数 -->
            <ContPlanMult>
                <xsl:value-of select="$MainRisk/PCNumber" />
            </ContPlanMult>
        </ContPlan>
        <!-- 投保人 -->
        <Appnt>
        	<xsl:apply-templates select="PolicyHolder/CustomsGeneralInfo" />
        	<!-- 1.城镇，2.农村 -->
			<LiveZone>
				<xsl:value-of select="PolicyHolder/CustomsGeneralInfo/Residence" />
			</LiveZone>
			<!-- 投保人年收入(银行元) -->
			<xsl:choose>
				<xsl:when test="PolicyHolder/CustomsGeneralInfo/CusAnnualIncome=''">
					<Salary />
				</xsl:when>
				<xsl:otherwise>
					<Salary>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PolicyHolder/CustomsGeneralInfo/CusAnnualIncome)" />
					</Salary>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="PolicyHolder/CustomsGeneralInfo/HomeYearIncome=''">
					<FamilySalary />
				</xsl:when>
				<xsl:otherwise>
					<FamilySalary>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PolicyHolder/CustomsGeneralInfo/HomeYearIncome)" />
					</FamilySalary>
				</xsl:otherwise>
			</xsl:choose>
			<RiskAssess></RiskAssess>
        	<RelaToInsured>
				<xsl:apply-templates select="InsuredList/InsuredInFo/IsdToPolH" />
			</RelaToInsured>
        </Appnt>
        <!-- 被保险人 -->
        <Insured>
        	<xsl:apply-templates select="InsuredList/InsuredInFo/CustomsGeneralInfo" />
        </Insured>
        <!-- 受益人 -->
        <xsl:apply-templates select="BeneficiaryList[BCount!='00']/BeneficiaryInfo" />
        <Risk>
        	<xsl:apply-templates select="PlanCodeInfo/PClist/PCCategory/PCInfo[PCIsMajor='Y']" />
        </Risk>
    </xsl:template>
    <!-- 投保人AND被保险人 -->
	<xsl:template name="Customs" match="CustomsGeneralInfo">
		<Name>
			<xsl:value-of select="CusName" />
		</Name>
		<Sex>
			<xsl:apply-templates select="CusGender" />
		</Sex>
		<Birthday>
			<xsl:value-of select="CusBirthDay" />
		</Birthday>
		<IDType>
			<xsl:apply-templates select="CusCerType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="CusCerNo" />
		</IDNo>
		<IDTypeStartDate>
			<xsl:value-of select="CusCerStartDate" />
		</IDTypeStartDate>
		<IDTypeEndDate>
			<xsl:value-of select="CusCerEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="CusJobCode" />
		</JobCode>
		<Nationality>
			<xsl:apply-templates select="CusCty" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Weight" />
		</Weight>
		<MaritalStatus>
			<xsl:apply-templates select="CusMarriage" />
		</MaritalStatus>
		<Address>
			<xsl:value-of select="CusPostAddr" />
		</Address>
		<ZipCode>
			<xsl:value-of select="CusPostCode" />
		</ZipCode>
		<Mobile>
			<xsl:value-of select="CusCPhNo" /><!-- 移动电话 -->
		</Mobile>
		<!-- 家庭电话”和“办公电话”如果只传送一个，银保通将该值作为固定电话传给核心系统；如果两个同时传送，则将“家庭电话”作为固定电话传给核心系统； -->
		<Phone><!-- 固定电话 -->
			<xsl:choose>
				<xsl:when test="CusFmyPhNo=''">
					<xsl:value-of select="CusOffPhNo" /><!-- 办公电话 -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CusFmyPhNo" /><!-- 家庭电话 -->
				</xsl:otherwise>
			</xsl:choose>
		</Phone>
		<Email>
			<xsl:value-of select="CusEmail" />
		</Email>
	</xsl:template>
	<!-- 受益人信息 -->
    <xsl:template match="BeneficiaryInfo">
        <Bnf>
        	<!-- 银保通判断受益人类型只允许为“1身故受益人” -->
            <Type><xsl:value-of select="BFType" /></Type>
            <!-- 受益顺序 (整数，从1开始) -->
            <Grade>
                <xsl:value-of select="BFSequence" />
            </Grade>
            
            <xsl:apply-templates select="CustomsGeneralInfo" />
            
            <!-- 受益人与被保险人关系 -->
            <RelaToInsured>
                <xsl:apply-templates select="BFToIsd" />
            </RelaToInsured>
            
            <!-- 收益比例（整数） -->
            <Lot>
                <xsl:value-of select="BFLot" />
            </Lot>
        </Bnf>
    </xsl:template>
	<xsl:template match="PCInfo">
		<RiskCode><xsl:apply-templates select="PCCode" /></RiskCode>
   		<MainRiskCode><xsl:apply-templates select="PCCode" /></MainRiskCode>
   		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" /></Amnt>
   		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" /></Prem>
   		<Mult><xsl:value-of select="format-number(PCNumber,'#')" /></Mult>
   		<PayMode></PayMode><!-- 缴费形式 -->
   		<PayIntv><xsl:apply-templates select="PayPeriodType" /></PayIntv><!-- 缴费年限类型+++缴费频次 -->
   		<InsuYearFlag><xsl:apply-templates select="CovPeriodType" /></InsuYearFlag>
   		<!-- 保险年期 -->
   		<xsl:choose>
			<xsl:when test="CovPeriodType='1'"><!-- 保终身 -->
				<InsuYear>106</InsuYear>
			</xsl:when>
			<xsl:otherwise>
				<InsuYear><xsl:value-of select="InsuYear" /></InsuYear>
			</xsl:otherwise>
		</xsl:choose>
   		<PayEndYearFlag><xsl:apply-templates select="PayTermType" /></PayEndYearFlag><!-- 缴费年期/年龄类型 -->
   		<xsl:choose>
			<xsl:when test="PayTermType='1'"><!-- 1 趸交 -->
				<PayEndYear>1000</PayEndYear>
			</xsl:when>
			<xsl:otherwise>
				<PayEndYear><xsl:value-of select="PayYear" /></PayEndYear>
			</xsl:otherwise>
		</xsl:choose>   		
   		<BonusGetMode><xsl:apply-templates select="BonusPayMode" /></BonusGetMode><!-- 红利领取方式 -->
   		<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->
   		<GetYearFlag></GetYearFlag><!-- 领取年龄年期标志 -->
   		<GetYear><xsl:value-of select="FullBonusPeriod" /></GetYear><!-- 领取年龄 -->
   		<GetIntv><xsl:apply-templates select="FullBonusGetMode" /></GetIntv> <!-- 领取方式 -->
   		<GetBankCode><xsl:value-of select="../../../GetBankInfo/GetBankCode" /></GetBankCode> <!-- 领取银行编码 -->
   		<GetBankAccNo><xsl:value-of select="../../../GetBankInfo/GetBankAccNo" /></GetBankAccNo><!-- 领取银行账户 -->
   		<GetAccName><xsl:value-of select="../../../GetBankInfo/GetAccName" /></GetAccName><!-- 领取银行户名 -->
   		<AutoPayFlag></AutoPayFlag> <!-- 自动垫交标志 -->
	</xsl:template>
	
	
	<!-- SendPolType 保单递送方式:1=邮寄，2=银行柜面领取 -->
	<xsl:template match="SendPolType">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 保险公司部门发送 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 邮寄 -->
			<xsl:when test=".='3'">1</xsl:when><!-- 上门递送 -->
			<xsl:when test=".='4'">2</xsl:when><!-- 银行柜台 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusGender 性别：M/F/N -->
	<xsl:template match="CusGender">
		<xsl:choose>
			<xsl:when test=".='M'">0</xsl:when><!-- 男 -->
			<xsl:when test=".='F'">1</xsl:when><!-- 女 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- CusCerType 证件类型 -->
	<xsl:template match="CusCerType">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 身份证+++ 居民身份证 -->
			<xsl:when test=".='2'">5</xsl:when><!-- 户口本+++ 户口簿 -->
			<xsl:when test=".='3'">2</xsl:when><!-- 军官证+++ 军官证 -->
			<xsl:when test=".='4'">8</xsl:when><!-- 警官证+++ 其他 -->
			<xsl:when test=".='5'">8</xsl:when><!-- 士兵证+++ 其他 -->
			<xsl:when test=".='6'">8</xsl:when><!-- 文职干部证+++ 其他 -->
			<xsl:when test=".='7'">1</xsl:when><!-- 护照+++ 护照 -->
			<xsl:when test=".='8'">6</xsl:when><!-- 港澳台通行证+++ 港澳居民来往内地通行证 -->
			<xsl:when test=".='9'">8</xsl:when><!-- 其他+++ 其他 -->
			<xsl:when test=".='A'">9</xsl:when><!-- 临时身份证+++异常身份证 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusMarriage 婚姻状态 -->
	<xsl:template match="CusMarriage">
		<xsl:choose>
			<xsl:when test=".='1'">N</xsl:when><!-- 未婚+++否 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 已婚 +++是 -->
			<xsl:when test=".='3'">N</xsl:when><!-- 离异+++子女 -->
			<xsl:when test=".='4'">N</xsl:when><!-- 丧偶+++其他 -->
			<xsl:when test=".='5'">N</xsl:when><!-- 不明+++ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- IsdToPolH 关系：天津农：被保险人与投保人关系；核心：投保人与被保人关系 -->
	<xsl:template match="IsdToPolH">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- 配偶+++配偶 -->
			<xsl:when test=".='2'">03</xsl:when><!-- 父母+++子女 -->
			<xsl:when test=".='3'">01</xsl:when><!-- 子女+++父母 -->
			<xsl:when test=".='4'">04</xsl:when><!-- 亲属+++其他 -->
			<xsl:when test=".='5'">00</xsl:when><!-- 本人+++本人 -->
			<xsl:when test=".='6'">04</xsl:when><!-- 其它+++其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- BFToIsd 关系：天津农：受益人与被保险人关系；核心：受益人与被保险人关系 -->
	<xsl:template match="BFToIsd">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- 配偶+++配偶 -->
			<xsl:when test=".='2'">01</xsl:when><!-- 父母+++父母 -->
			<xsl:when test=".='3'">03</xsl:when><!-- 子女+++子女 -->
			<xsl:when test=".='4'">04</xsl:when><!-- 亲属+++其他 -->
			<xsl:when test=".='5'">00</xsl:when><!-- 本人+++本人 -->
			<xsl:when test=".='6'">04</xsl:when><!-- 其它+++其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>            
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="PCCode">
		<xsl:choose>
			<xsl:when test=".='50015'">50015</xsl:when>  <!-- 安邦长寿稳赢保险计划 -->	
			
			<xsl:when test=".='L12088'">L12088</xsl:when>  <!-- 安邦东风9号两全保险（万能型） -->	
					
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PayPeriodType缴费年限类型 -->
	<xsl:template match="PayPeriodType">
		<xsl:choose>
			<xsl:when test=".='0'">12</xsl:when><!-- 年交+++年交 -->
			<xsl:when test=".='1'">6</xsl:when><!-- 半年交+++半年交 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 季交+++季交 -->
			<xsl:when test=".='3'">1</xsl:when><!-- 月交+++月交 -->
			<xsl:when test=".='4'">0</xsl:when><!-- 趸交+++趸交 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CovPeriodType保险年期类型 -->
	<xsl:template match="CovPeriodType">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- 保终身+++保终身 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年限保+++按年 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 保至某确定年龄+++到某确定年龄 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月保+++按月 -->
			<xsl:when test=".='5'">D</xsl:when><!-- 按天保+++按日 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PayTermType缴费年期类型 -->
	<xsl:template match="PayTermType">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- 趸交+++趸交 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年限交+++按年 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 交至某确定年龄+++到某确定年龄 -->
			<xsl:when test=".='4'">A</xsl:when><!-- 终生交费+++终身 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- BonusPayMode红利领取方式 -->
	<xsl:template match="BonusPayMode">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- 现金给付+++现金领取 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费+++抵交保费 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 累计生息+++累计生息 -->
			<xsl:when test=".='3'">5</xsl:when><!-- 增额红利+++增额缴清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- FullBonusGetMode满期领取金领取方式 -->
	<xsl:template match="FullBonusGetMode">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 月领+++月领 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 季领+++季领 -->
			<xsl:when test=".='3'">6</xsl:when><!-- 半年领+++半年领 -->
			<xsl:when test=".='4'">12</xsl:when><!-- 年领+++年领 -->
			<xsl:when test=".='5'">0</xsl:when><!-- 趸领+++趸领 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- CusCty 国籍 -->
	<xsl:template match="CusCty">
		<xsl:choose>
			<xsl:when test=".='CHN'">CHN</xsl:when><!-- 中国+++中国 -->
			<xsl:when test=".='AFG'">AF</xsl:when><!-- 阿富汗+++阿富汗 -->
			<xsl:when test=".='ALB'">AL</xsl:when><!-- 阿尔巴尼亚+++阿尔巴尼亚 -->
			<xsl:when test=".='DZA'">OTH</xsl:when><!-- 阿尔及利亚+++其他 -->
			<xsl:when test=".='ASM'">OTH</xsl:when><!-- 美属萨摩亚群岛+++其他 -->
			<xsl:when test=".='AND'">AD</xsl:when><!-- 安道尔+++安道尔 -->
			<xsl:when test=".='AGO'">AO</xsl:when><!-- 安哥拉+++安哥拉 -->
			<xsl:when test=".='AIA'">AI</xsl:when><!-- ANGUILLA+++安圭拉 -->
			<xsl:when test=".='ATA'">OTH</xsl:when><!-- 南极洲+++其他 -->
			<xsl:when test=".='ATG'">AG</xsl:when><!-- 安提瓜和巴布达+++安提瓜和巴布达 -->
			<xsl:when test=".='ARG'">AR</xsl:when><!-- 阿根廷+++阿根廷 -->
			<xsl:when test=".='ARM'">OTH</xsl:when><!-- 亚美尼亚+++其他 -->
			<xsl:when test=".='ABW'">AW</xsl:when><!-- 阿鲁巴+++阿鲁巴 -->
			<xsl:when test=".='AUS'">AU</xsl:when><!-- 澳大利亚+++澳大利亚 -->
			<xsl:when test=".='AUT'">AT</xsl:when><!-- 奥地利+++奥地利 -->
			<xsl:when test=".='AZE'">AZ</xsl:when><!-- 阿塞拜疆+++阿塞拜疆 -->
			<xsl:when test=".='BHS'">BS</xsl:when><!-- 巴哈马+++巴哈马 -->
			<xsl:when test=".='BHR'">BH</xsl:when><!-- 巴林+++巴林 -->
			<xsl:when test=".='BGD'">BD</xsl:when><!-- 孟加拉+++孟加拉 -->
			<xsl:when test=".='BRB'">OTH</xsl:when><!-- 巴巴多斯+++其他 -->
			<xsl:when test=".='BLR'">BY</xsl:when><!-- 白俄罗斯+++白俄罗斯 -->
			<xsl:when test=".='BEL'">BE</xsl:when><!-- 比利时+++比利时 -->
			<xsl:when test=".='BLZ'">BZ</xsl:when><!-- 伯利兹+++伯利兹 -->
			<xsl:when test=".='BEN'">BJ</xsl:when><!-- 贝宁+++贝宁 -->
			<xsl:when test=".='BMU'">BM</xsl:when><!-- 百慕达群岛+++百慕大 -->
			<xsl:when test=".='BTN'">OTH</xsl:when><!-- 不丹+++其他 -->
			<xsl:when test=".='BOL'">BO</xsl:when><!-- 玻利维亚+++玻利维亚 -->
			<xsl:when test=".='BIH'">OTH</xsl:when><!-- 波黑+++其他 -->
			<xsl:when test=".='BWA'">BW</xsl:when><!-- 博茨瓦纳+++博茨瓦纳 -->
			<xsl:when test=".='BVT'">OTH</xsl:when><!-- BOUVET ISLAND+++其他 -->
			<xsl:when test=".='BRA'">BR</xsl:when><!-- 巴西+++巴西 -->
			<xsl:when test=".='IOT'">OTH</xsl:when><!-- BRITISH INDIAN OCEAN TERRITORY+++其他 -->
			<xsl:when test=".='BRN'">BN</xsl:when><!-- 文莱+++文莱 -->
			<xsl:when test=".='BGR'">BG</xsl:when><!-- 保加利亚+++保加利亚 -->
			<xsl:when test=".='BFA'">BF</xsl:when><!-- BURKINA FASO+++布基纳法索 -->
			<xsl:when test=".='BDI'">BI</xsl:when><!-- 布隆迪+++布隆迪 -->
			<xsl:when test=".='KHM'">OTH</xsl:when><!-- 高棉+++其他 -->
			<xsl:when test=".='CMR'">CM</xsl:when><!-- 咯麦隆+++喀麦隆 -->
			<xsl:when test=".='CAN'">CA</xsl:when><!-- 加拿大+++加拿大 -->
			<xsl:when test=".='CPV'">CV</xsl:when><!-- 佛得角+++佛得角群岛 -->
			<xsl:when test=".='CYM'">KY</xsl:when><!-- CAYMAN ISLANDS+++开曼群岛 -->
			<xsl:when test=".='CAF'">CF</xsl:when><!-- CENTRAL AFRICAN REPUBLIC+++中非共和国 -->
			<xsl:when test=".='TCD'">TD</xsl:when><!-- 乍得+++乍得 -->
			<xsl:when test=".='CHL'">CL</xsl:when><!-- 智利+++智利 -->
			<xsl:when test=".='CXR'">OTH</xsl:when><!-- CHRISTMAS ISLAND+++其他 -->
			<xsl:when test=".='CCK'">OTH</xsl:when><!-- COCOS (KEELING) ISLANDS+++其他 -->
			<xsl:when test=".='COL'">CO</xsl:when><!-- 哥伦比亚+++哥伦比亚 -->
			<xsl:when test=".='COM'">KM</xsl:when><!-- COMOROS+++科摩罗群岛 -->
			<xsl:when test=".='COG'">ZR</xsl:when><!-- 刚果+++刚果（布） -->
			<xsl:when test=".='COD'">CG</xsl:when><!-- CONGO, THE DEMOCRATIC REPUBLIC OF THE+++刚果（金） -->
			<xsl:when test=".='COK'">CK</xsl:when><!-- 库克群岛+++库克群岛 -->
			<xsl:when test=".='CRI'">CR</xsl:when><!-- 哥斯达黎加+++哥斯达黎加 -->
			<xsl:when test=".='CIV'">OTH</xsl:when><!-- COTE D'IVOIRE+++其他 -->
			<xsl:when test=".='HRV'">HR</xsl:when><!-- 克罗地亚+++克罗地亚 -->
			<xsl:when test=".='CUB'">CU</xsl:when><!-- 古巴+++古巴 -->
			<xsl:when test=".='CYP'">CY</xsl:when><!-- 塞浦路斯+++塞浦路斯 -->
			<xsl:when test=".='CZE'">CZ</xsl:when><!-- 捷克+++捷克共和国 -->
			<xsl:when test=".='DNK'">DK</xsl:when><!-- 丹麦+++丹麦 -->
			<xsl:when test=".='DJI'">DJ</xsl:when><!-- DJIBOUTI+++吉布提 -->
			<xsl:when test=".='DMA'">DM</xsl:when><!-- 多米尼加+++多米尼加联邦 -->
			<xsl:when test=".='DOM'">DO</xsl:when><!-- DOMINICAN REPUBLIC+++多米尼加共和国 -->
			<xsl:when test=".='TMP'">OTH</xsl:when><!-- 东帝汶+++其他 -->
			<xsl:when test=".='ECU'">EC</xsl:when><!-- 厄瓜多尔+++厄瓜多尔 -->
			<xsl:when test=".='EGY'">EG</xsl:when><!-- 埃及+++埃及 -->
			<xsl:when test=".='SLV'">SV</xsl:when><!-- 萨尔瓦多+++萨尔瓦多 -->
			<xsl:when test=".='GNQ'">GQ</xsl:when><!-- 赤道几内亚+++赤道几内亚 -->
			<xsl:when test=".='ERI'">ER</xsl:when><!-- ERITREA+++厄立特里亚 -->
			<xsl:when test=".='EST'">EE</xsl:when><!-- 爱沙尼亚+++爱沙尼亚 -->
			<xsl:when test=".='ETH'">ET</xsl:when><!-- 埃塞俄比亚+++埃塞俄比亚 -->
			<xsl:when test=".='FLK'">OTH</xsl:when><!-- FALKLAND ISLANDS (MALVINAS)+++其他 -->
			<xsl:when test=".='FRO'">FO</xsl:when><!-- FAROE ISLANDS+++法罗群岛 -->
			<xsl:when test=".='FJI'">FJ</xsl:when><!-- 斐济+++斐济 -->
			<xsl:when test=".='FIN'">FI</xsl:when><!-- 芬兰+++芬兰 -->
			<xsl:when test=".='FRA'">FR</xsl:when><!-- 法国+++法国 -->
			<xsl:when test=".='FXX'">OTH</xsl:when><!-- FRANCE, METROPOLITAN+++其他 -->
			<xsl:when test=".='GUF'">OTH</xsl:when><!-- 法属几内亚+++其他 -->
			<xsl:when test=".='PYF'">PF</xsl:when><!-- 法属波利尼西亚+++法属波利尼西亚 -->
			<xsl:when test=".='ATF'">OTH</xsl:when><!-- FRENCH SOUTHERN TERRITORIES+++其他 -->
			<xsl:when test=".='GAB'">GA</xsl:when><!-- 加蓬+++加蓬 -->
			<xsl:when test=".='GMB'">GM</xsl:when><!-- 冈比亚+++冈比亚 -->
			<xsl:when test=".='GEO'">GE</xsl:when><!-- 格鲁吉亚+++格鲁吉亚 -->
			<xsl:when test=".='DEU'">DE</xsl:when><!-- 德国+++德国 -->
			<xsl:when test=".='GHA'">GH</xsl:when><!-- 迦纳+++加纳 -->
			<xsl:when test=".='GIB'">GI</xsl:when><!-- 直布罗陀+++直布罗陀 -->
			<xsl:when test=".='GRC'">GR</xsl:when><!-- 希腊+++希腊 -->
			<xsl:when test=".='GRL'">OTH</xsl:when><!-- 格陵兰+++其他 -->
			<xsl:when test=".='GRD'">GD</xsl:when><!-- 格林那达+++格林纳达 -->
			<xsl:when test=".='GLP'">GP</xsl:when><!-- GUADELOUPE+++瓜德罗普 -->
			<xsl:when test=".='GUM'">GU</xsl:when><!-- 关岛+++关岛 -->
			<xsl:when test=".='GTM'">OTH</xsl:when><!-- 瓜地马拉+++其他 -->
			<xsl:when test=".='GIN'">GN</xsl:when><!-- 几内亚+++几内亚 -->
			<xsl:when test=".='GNB'">OTH</xsl:when><!-- 几内亚比索共和国+++其他 -->
			<xsl:when test=".='GUY'">OTH</xsl:when><!-- 盖亚那+++其他 -->
			<xsl:when test=".='HTI'">HT</xsl:when><!-- 海地+++海地 -->
			<xsl:when test=".='HMD'">OTH</xsl:when><!-- HEARD AND MC DONALD ISLANDS+++其他 -->
			<xsl:when test=".='VAT'">OTH</xsl:when><!-- HOLY SEE (VATICAN CITY STATE)+++其他 -->
			<xsl:when test=".='HND'">HN</xsl:when><!-- 洪都拉斯+++洪都拉斯 -->
			<xsl:when test=".='HKG'">CHN</xsl:when><!-- 香港+++中国 -->
			<xsl:when test=".='HUN'">HU</xsl:when><!-- 匈牙利+++匈牙利 -->
			<xsl:when test=".='ISL'">IS</xsl:when><!-- 冰岛+++冰岛 -->
			<xsl:when test=".='IND'">IN</xsl:when><!-- 印度+++印度 -->
			<xsl:when test=".='IDN'">ID</xsl:when><!-- 印尼+++印度尼西亚 -->
			<xsl:when test=".='IRN'">IR</xsl:when><!-- 伊朗+++伊朗 -->
			<xsl:when test=".='IRQ'">IQ</xsl:when><!-- 伊拉克共和国+++伊拉克 -->
			<xsl:when test=".='IRL'">IE</xsl:when><!-- 爱尔兰+++爱尔兰 -->
			<xsl:when test=".='ISR'">IL</xsl:when><!-- 以色列+++以色列 -->
			<xsl:when test=".='ITA'">IT</xsl:when><!-- 意大利+++意大利 -->
			<xsl:when test=".='JAM'">JM</xsl:when><!-- 牙买加+++牙买加 -->
			<xsl:when test=".='JPN'">JP</xsl:when><!-- 日本+++日本 -->
			<xsl:when test=".='JOR'">JO</xsl:when><!-- 约旦+++约旦 -->
			<xsl:when test=".='KAZ'">KZ</xsl:when><!-- 哈萨克斯坦+++哈萨克斯坦 -->
			<xsl:when test=".='KEN'">KE</xsl:when><!-- 肯尼亚+++肯尼亚 -->
			<xsl:when test=".='KIR'">OTH</xsl:when><!-- KIRIBATI+++其他 -->
			<xsl:when test=".='PRK'">KP</xsl:when><!-- 朝鲜人民共和国+++朝鲜 -->
			<xsl:when test=".='KOR'">KR</xsl:when><!-- 韩国+++韩国 -->
			<xsl:when test=".='KWT'">KW</xsl:when><!-- 科威特+++科威特 -->
			<xsl:when test=".='KGZ'">KG</xsl:when><!-- KYRGYZSTAN+++吉尔吉思 -->
			<xsl:when test=".='LAO'">LA</xsl:when><!-- 老挝+++老挝 -->
			<xsl:when test=".='LVA'">LV</xsl:when><!-- 拉脱维亚+++拉脱维亚 -->
			<xsl:when test=".='LBN'">LB</xsl:when><!-- 黎巴嫩+++黎巴嫩 -->
			<xsl:when test=".='LSO'">LB</xsl:when><!-- 赖索托+++黎巴嫩 -->
			<xsl:when test=".='LBR'">OTH</xsl:when><!-- 利比利亚+++其他 -->
			<xsl:when test=".='LBY'">OTH</xsl:when><!-- LIBYAN ARAB JAMAHIRIYA+++其他 -->
			<xsl:when test=".='LIE'">LI</xsl:when><!-- LIECHTENSTEIN+++列支敦士登 -->
			<xsl:when test=".='LTU'">LT</xsl:when><!-- LITHUANIA+++立陶宛 -->
			<xsl:when test=".='LUX'">LU</xsl:when><!-- 卢森堡+++卢森堡 -->
			<xsl:when test=".='MAC'">CHN</xsl:when><!-- 澳门+++中国 -->
			<xsl:when test=".='MKD'">MK</xsl:when><!-- MACEDONIA+++马其顿 -->
			<xsl:when test=".='MDG'">MG</xsl:when><!-- 马达加斯加+++马达加斯加 -->
			<xsl:when test=".='MWI'">OTH</xsl:when><!-- 马拉威+++其他 -->
			<xsl:when test=".='MYS'">MY</xsl:when><!-- 马来西亚+++马来西亚 -->
			<xsl:when test=".='MDV'">MV</xsl:when><!-- 马尔代夫+++马尔代夫 -->
			<xsl:when test=".='MLI'">ML</xsl:when><!-- 马利+++马里 -->
			<xsl:when test=".='MLT'">MT</xsl:when><!-- 马尔他+++马耳他 -->
			<xsl:when test=".='MHL'">MH</xsl:when><!-- 马绍尔群岛+++马召尔群岛 -->
			<xsl:when test=".='MTQ'">MQ</xsl:when><!-- MARTINIQUE+++马提尼克 -->
			<xsl:when test=".='MRT'">MR</xsl:when><!-- 毛利塔尼亚+++毛里塔尼亚 -->
			<xsl:when test=".='MUS'">MU</xsl:when><!-- 毛里求斯+++毛里求斯 -->
			<xsl:when test=".='MYT'">YT</xsl:when><!-- MAYOTTE+++马约特岛 -->
			<xsl:when test=".='MEX'">MX</xsl:when><!-- 墨西哥+++墨西哥 -->
			<xsl:when test=".='FSM'">OTH</xsl:when><!-- 密克罗尼西亚+++其他 -->
			<xsl:when test=".='MDA'">MD</xsl:when><!-- 摩尔多瓦+++摩尔多瓦 -->
			<xsl:when test=".='MCO'">MC</xsl:when><!-- 摩纳哥+++摩纳哥 -->
			<xsl:when test=".='MNG'">MN</xsl:when><!-- 蒙古+++蒙古 -->
			<xsl:when test=".='MSR'">MS</xsl:when><!-- MONTSERRAT+++蒙特塞拉特 -->
			<xsl:when test=".='MAR'">MA</xsl:when><!-- 摩洛哥+++摩洛哥 -->
			<xsl:when test=".='MOZ'">MZ</xsl:when><!-- 莫桑比克+++莫桑比克 -->
			<xsl:when test=".='MMR'">MM</xsl:when><!-- 缅甸+++缅甸 -->
			<xsl:when test=".='NAM'">NA</xsl:when><!-- 那米比亚+++纳米比亚 -->
			<xsl:when test=".='NRU'">NR</xsl:when><!-- 瑙鲁+++瑙鲁 -->
			<xsl:when test=".='NPL'">NP</xsl:when><!-- 尼泊尔+++尼泊尔 -->
			<xsl:when test=".='NLD'">NL</xsl:when><!-- 荷兰+++荷兰 -->
			<xsl:when test=".='ANT'">OTH</xsl:when><!-- NETHERLANDS ANTILLES+++其他 -->
			<xsl:when test=".='NCL'">OTH</xsl:when><!-- 新加里多尼亚+++其他 -->
			<xsl:when test=".='NZL'">NZ</xsl:when><!-- 新西兰+++新西兰 -->
			<xsl:when test=".='NIC'">NI</xsl:when><!-- 尼加拉瓜+++尼加拉瓜 -->
			<xsl:when test=".='NER'">NE</xsl:when><!-- 尼日尔+++尼日尔 -->
			<xsl:when test=".='NGA'">NG</xsl:when><!-- 尼日利亚+++尼日利亚 -->
			<xsl:when test=".='NIU'">NU</xsl:when><!-- NIUE+++纽埃岛 -->
			<xsl:when test=".='NFK'">NF</xsl:when><!-- NORFOLK ISLAND+++诺福克群岛 -->
			<xsl:when test=".='MNP'">MP</xsl:when><!-- NORTHERN MARIANA ISLANDS+++北马里亚纳群岛 -->
			<xsl:when test=".='NOR'">NO</xsl:when><!-- 挪威+++挪威 -->
			<xsl:when test=".='OMN'">OM</xsl:when><!-- 阿曼+++阿曼 -->
			<xsl:when test=".='PAK'">PK</xsl:when><!-- 巴基斯坦+++巴基斯坦 -->
			<xsl:when test=".='PLW'">PW</xsl:when><!-- 帕劳+++帕劳 -->
			<xsl:when test=".='PAN'">PA</xsl:when><!-- 巴拿马+++巴拿马 -->
			<xsl:when test=".='PNG'">PG</xsl:when><!-- 巴布亚新几内亚+++巴布亚新几内亚 -->
			<xsl:when test=".='PRY'">PY</xsl:when><!-- 巴拉圭+++巴拉圭 -->
			<xsl:when test=".='PER'">PE</xsl:when><!-- 秘鲁+++秘鲁 -->
			<xsl:when test=".='PHL'">PH</xsl:when><!-- 菲律宾共和国+++菲律宾 -->
			<xsl:when test=".='PCN'">OTH</xsl:when><!-- PITCAIRN+++其他 -->
			<xsl:when test=".='POL'">PL</xsl:when><!-- 波兰+++波兰 -->
			<xsl:when test=".='PRT'">PT</xsl:when><!-- 葡萄牙+++葡萄牙 -->
			<xsl:when test=".='PRI'">PR</xsl:when><!-- 波多黎各+++波多黎各 -->
			<xsl:when test=".='QAT'">QA</xsl:when><!-- QATAR+++卡塔尔 -->
			<xsl:when test=".='REU'">RE</xsl:when><!-- REUNION+++留尼汪岛 -->
			<xsl:when test=".='ROM'">RO</xsl:when><!-- 罗马尼亚+++罗马尼亚 -->
			<xsl:when test=".='RUS'">RU</xsl:when><!-- 俄罗斯+++俄罗斯 -->
			<xsl:when test=".='RWA'">RW</xsl:when><!-- 卢旺达+++卢旺达 -->
			<xsl:when test=".='KNA'">OTH</xsl:when><!-- SAINT KITTS AND NEVIS+++其他 -->
			<xsl:when test=".='LCA'">SQ</xsl:when><!-- SAINT LUCIA+++圣卢西亚 -->
			<xsl:when test=".='VCT'">OTH</xsl:when><!-- SAINT VINCENT AND THE GRENADINES+++其他 -->
			<xsl:when test=".='WSM'">WS</xsl:when><!-- 萨摩亚+++萨摩亚 -->
			<xsl:when test=".='SMR'">SM</xsl:when><!-- 圣马力诺+++圣马力诺 -->
			<xsl:when test=".='STP'">ST</xsl:when><!-- SAO TOME AND PRINCIPE+++圣多美和普林西比 -->
			<xsl:when test=".='SAU'">SA</xsl:when><!-- 沙特阿拉伯+++沙特阿拉伯 -->
			<xsl:when test=".='SEN'">SN</xsl:when><!-- SENEGAL+++塞内加尔 -->
			<xsl:when test=".='SYC'">SC</xsl:when><!-- 塞舌尔+++塞舌尔 -->
			<xsl:when test=".='SLE'">SL</xsl:when><!-- 塞拉利昂+++塞拉里昂 -->
			<xsl:when test=".='SGP'">SG</xsl:when><!-- 新加坡+++新加坡 -->
			<xsl:when test=".='SVK'">SK</xsl:when><!-- 斯洛伐克+++斯洛伐克 -->
			<xsl:when test=".='SVN'">SI</xsl:when><!-- 斯洛文尼亚+++斯洛文尼亚 -->
			<xsl:when test=".='SLB'">SB</xsl:when><!-- 所罗门群岛+++所罗门群岛 -->
			<xsl:when test=".='SOM'">SO</xsl:when><!-- 索马里+++索马里 -->
			<xsl:when test=".='ZAF'">ZA</xsl:when><!-- 南非+++南非 -->
			<xsl:when test=".='SGS'">OTH</xsl:when><!-- SOUTH GEORGIA AND+++其他 -->
			<xsl:when test=".='ESP'">ES</xsl:when><!-- 西班牙+++西班牙 -->
			<xsl:when test=".='LKA'">LK</xsl:when><!-- 斯里兰卡+++斯里兰卡 -->
			<xsl:when test=".='SHN'">OTH</xsl:when><!-- ST. HELENA+++其他 -->
			<xsl:when test=".='SPM'">OTH</xsl:when><!-- ST. PIERRE AND MIQUELON+++其他 -->
			<xsl:when test=".='SDN'">SD</xsl:when><!-- 苏丹+++苏丹 -->
			<xsl:when test=".='SUR'">SR</xsl:when><!-- SURINAME+++苏里南 -->
			<xsl:when test=".='SJM'">OTH</xsl:when><!-- SVALBARD AND JAN MAYEN ISLANDS+++其他 -->
			<xsl:when test=".='SWZ'">OTH</xsl:when><!-- 史瓦济兰+++其他 -->
			<xsl:when test=".='SWE'">SE</xsl:when><!-- 瑞典+++瑞典 -->
			<xsl:when test=".='CHE'">CH</xsl:when><!-- 瑞士+++瑞士 -->
			<xsl:when test=".='SYR'">SY</xsl:when><!-- SYRIAN ARAB REPUBLIC+++叙利亚 -->
			<xsl:when test=".='TWN'">CHN</xsl:when><!-- 台湾+++中国 -->
			<xsl:when test=".='TJK'">TJ</xsl:when><!-- 塔吉克斯坦+++塔吉克斯坦 -->
			<xsl:when test=".='TZA'">TZ</xsl:when><!-- 坦桑尼亚+++坦桑尼亚 -->
			<xsl:when test=".='THA'">TH</xsl:when><!-- 泰国+++泰国 -->
			<xsl:when test=".='TGO'">TG</xsl:when><!-- TOGO+++多哥 -->
			<xsl:when test=".='TKL'">OTH</xsl:when><!-- TOKELAU+++其他 -->
			<xsl:when test=".='TON'">TO</xsl:when><!-- TONGA+++汤加 -->
			<xsl:when test=".='TTO'">TT</xsl:when><!-- TRINIDAD AND TOBAGO+++特里尼达和多巴哥 -->
			<xsl:when test=".='TUN'">TN</xsl:when><!-- 突尼斯+++突尼斯 -->
			<xsl:when test=".='TUR'">TR</xsl:when><!-- 土耳其+++土耳其 -->
			<xsl:when test=".='TKM'">TM</xsl:when><!-- 土库曼斯坦+++土库曼斯坦 -->
			<xsl:when test=".='TCA'">OTH</xsl:when><!-- TURKS AND CAICOS ISLANDS+++其他 -->
			<xsl:when test=".='TUV'">TV</xsl:when><!-- TUVALU+++图瓦卢 -->
			<xsl:when test=".='UGA'">UG</xsl:when><!-- 乌干达+++乌干达 -->
			<xsl:when test=".='UKR'">UA</xsl:when><!-- 乌克兰+++乌克兰 -->
			<xsl:when test=".='ARE'">AE</xsl:when><!-- 阿联酋+++阿联酋 -->
			<xsl:when test=".='GBR'">GB</xsl:when><!-- 英国+++英国 -->
			<xsl:when test=".='USA'">US</xsl:when><!-- 美国+++美国 -->
			<xsl:when test=".='UMI'">OTH</xsl:when><!-- UNITED STATES MINOR OUTLYING ISLANDS+++其他 -->
			<xsl:when test=".='URY'">UY</xsl:when><!-- 乌拉圭+++乌拉圭 -->
			<xsl:when test=".='UZB'">UZ</xsl:when><!-- 乌兹别克斯坦+++乌兹别克斯坦 -->
			<xsl:when test=".='VUT'">VU</xsl:when><!-- VANUATU+++瓦努阿图 -->
			<xsl:when test=".='VEN'">VE</xsl:when><!-- 委内瑞拉+++委内瑞拉 -->
			<xsl:when test=".='VNM'">VN</xsl:when><!-- 越南+++越南 -->
			<xsl:when test=".='VGB'">VG</xsl:when><!-- VIRGIN ISLANDS (BRITISH)+++英属维尔京群岛 -->
			<xsl:when test=".='WLF'">OTH</xsl:when><!-- WALLIS AND FUTUNA ISLANDS+++其他 -->
			<xsl:when test=".='ESH'">OTH</xsl:when><!-- 西撒哈拉+++其他 -->
			<xsl:when test=".='YEM'">YE</xsl:when><!-- 也门+++也门 -->
			<xsl:when test=".='YUG'">YU</xsl:when><!-- 南斯拉夫+++南斯拉夫 -->
			<xsl:when test=".='ZMB'">ZM</xsl:when><!-- 赞比亚+++赞比亚 -->
			<xsl:when test=".='ZWE'">ZW</xsl:when><!-- 津巴布韦+++津巴布韦 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusJobCode 职业代码 -->
	<xsl:template match="CusJobCode">
		<xsl:choose>
			<xsl:when test=".='000101'">4030111</xsl:when><!-- 公务员、职员（内勤）+++国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test=".='000102'">6050611</xsl:when><!-- 维修工、司机（外勤）+++加工制造、检验及计量人员 -->
			<xsl:when test=".='000103'">6050611</xsl:when><!-- 其他工作人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='010101'">5010107</xsl:when><!-- 种植业者+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010102'">5010107</xsl:when><!-- 养殖业者+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010103'">5010107</xsl:when><!-- 果农 +++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010104'">5010107</xsl:when><!-- 苗圃工 +++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010105'">5010107</xsl:when><!-- 农业管理人员(不亲自作业)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010106'">5010107</xsl:when><!-- 农业技师 +++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010107'">5010107</xsl:when><!-- 农业工人 +++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010108'">5010107</xsl:when><!-- 农业机械操作或维修人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010109'">5010107</xsl:when><!-- 农业实验人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010110'">5010107</xsl:when><!-- 农副特产品加工人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010111'">5010107</xsl:when><!-- 热带作物生产人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010112'">5010107</xsl:when><!-- 长短工+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010113'">5010107</xsl:when><!-- 农具商+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010201'">5010107</xsl:when><!-- 畜牧管理人员(不亲自作业)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010202'">5010107</xsl:when><!-- 圈牧人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010203'">5010107</xsl:when><!-- 放牧人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010204'">5010107</xsl:when><!-- 兽医+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010205'">5010107</xsl:when><!-- 动物疫病防治人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010206'">5010107</xsl:when><!-- 实验动物饲养人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010207'">5010107</xsl:when><!-- 草业生产人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010208'">5010107</xsl:when><!-- 家禽、家畜等饲养人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010209'">5010107</xsl:when><!-- 其他畜牧业生产人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010210'">5010107</xsl:when><!-- 畜牧管理人员（亲自作业）+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010211'">5010107</xsl:when><!-- 昆虫（蜜蜂）饲养人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='010212'">5010107</xsl:when><!-- 宠物健康护理员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020101'">5010107</xsl:when><!-- 渔场管理人员(不亲自作业)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020102'">5010107</xsl:when><!-- 渔场管理人员(亲自作业) +++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020103'">5010107</xsl:when><!-- 养殖工人(内陆)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020104'">5010107</xsl:when><!-- 养殖工人(沿海)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020105'">5010107</xsl:when><!-- 捕鱼人(内陆)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020107'">5010107</xsl:when><!-- 水产实验人员(室内)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020108'">5010107</xsl:when><!-- 捕鱼人(沿海)+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020109'">5010107</xsl:when><!-- 水产品加工人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020110'">5010107</xsl:when><!-- 水族馆经营者+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020201'">5010107</xsl:when><!-- 海洋渔船船员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020202'">5010107</xsl:when><!-- 近海渔业、船长等管理人员、工程师、大副、二副、三副、甲板手、捕鱼人、厨师、雷达操作员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='020203'">5010107</xsl:when><!-- 远洋渔业、船长等管理人员、工程师、大副、二副、三副、甲板手、捕鱼人、厨师、雷达操作员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030101'">5010107</xsl:when><!-- 山林管理员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030102'">5010107</xsl:when><!-- 山地造林工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030103'">5010107</xsl:when><!-- 森林防火员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030104'">5010107</xsl:when><!-- 平地育苗人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030105'">5010107</xsl:when><!-- 实验室育苗栽培人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030201'">5010107</xsl:when><!-- 生产行政管理员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030201'">5010107</xsl:when><!-- 生产行政管理员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030202'">5010107</xsl:when><!-- 伐木工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030203'">5010107</xsl:when><!-- 运材车辆司机及押运人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030204'">5010107</xsl:when><!-- 起重机操作工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030205'">5010107</xsl:when><!-- 装运工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030206'">5010107</xsl:when><!-- 领班+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030207'">5010107</xsl:when><!-- 木材工厂现场工作人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030301'">5010107</xsl:when><!-- 一般工作人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030302'">5010107</xsl:when><!-- 技术人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030303'">5010107</xsl:when><!-- 锯木工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030304'">5010107</xsl:when><!-- 防腐剂工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030305'">5010107</xsl:when><!-- 木材储藏槽工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030306'">5010107</xsl:when><!-- 木材搬运工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030307'">5010107</xsl:when><!-- 吊车操作人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030308'">5010107</xsl:when><!-- 领班+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030309'">5010107</xsl:when><!-- 合板制造工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030310'">5010107</xsl:when><!-- 分级员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030311'">5010107</xsl:when><!-- 检查员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030312'">5010107</xsl:when><!-- 标记员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030313'">5010107</xsl:when><!-- 磅秤员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030401'">5010107</xsl:when><!-- 护林员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030402'">5010107</xsl:when><!-- 森林病虫害防治员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030403'">5010107</xsl:when><!-- 其他森林资源管护人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030501'">5010107</xsl:when><!-- 野生动物保护人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030502'">5010107</xsl:when><!-- 野生植物保护人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030503'">5010107</xsl:when><!-- 自然保护区巡护监测员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='030504'">5010107</xsl:when><!-- 标本员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='040101'">2020103</xsl:when><!-- 生产管理人员(不到现场)+++地址勘探人员 -->
			<xsl:when test=".='040102'">2020103</xsl:when><!-- 矿业工程师、技师、领班+++地址勘探人员 -->
			<xsl:when test=".='040103'">2020103</xsl:when><!-- 采石、采矿作业人员+++地址勘探人员 -->
			<xsl:when test=".='040104'">2020103</xsl:when><!-- 油矿、钻勘作业人员+++地址勘探人员 -->
			<xsl:when test=".='040105'">2020103</xsl:when><!-- 其他作业人员+++地址勘探人员 -->
			<xsl:when test=".='040106'">2020103</xsl:when><!-- 其他工作人员+++地址勘探人员 -->
			<xsl:when test=".='040107'">2020103</xsl:when><!-- 工矿安全人员+++地址勘探人员 -->
			<xsl:when test=".='040108'">2020103</xsl:when><!-- 其他矿物处理人员+++地址勘探人员 -->
			<xsl:when test=".='040109'">2020103</xsl:when><!-- 生产管理人员(现场监督)+++地址勘探人员 -->
			<xsl:when test=".='040201'">2020103</xsl:when><!-- 生产技术管理人+++地址勘探人员 -->
			<xsl:when test=".='040202'">2020103</xsl:when><!-- 采掘工+++地址勘探人员 -->
			<xsl:when test=".='040203'">2020103</xsl:when><!-- 其他作业人员:地方国有煤矿、采石、采矿+++地址勘探人员 -->
			<xsl:when test=".='040204'">2020103</xsl:when><!-- 生产技术管理人员+++地址勘探人员 -->
			<xsl:when test=".='040205'">2020103</xsl:when><!-- 采掘工+++地址勘探人员 -->
			<xsl:when test=".='040206'">2020103</xsl:when><!-- 其他作业人员:城镇集体企业煤矿、采石、采矿+++地址勘探人员 -->
			<xsl:when test=".='040207'">2020103</xsl:when><!-- 生产技术管理人员+++地址勘探人员 -->
			<xsl:when test=".='040208'">2020103</xsl:when><!-- 采掘工+++地址勘探人员 -->
			<xsl:when test=".='040209'">2020103</xsl:when><!-- 其他作业人员:乡镇煤矿、采石、采矿+++地址勘探人员 -->
			<xsl:when test=".='040210'">2020103</xsl:when><!-- 个人私营煤矿+++地址勘探人员 -->
			<xsl:when test=".='040301'">2020103</xsl:when><!-- 所有作业人员+++地址勘探人员 -->
			<xsl:when test=".='040401'">2020103</xsl:when><!-- 行政人员+++地址勘探人员 -->
			<xsl:when test=".='040402'">2020103</xsl:when><!-- 工程师+++地址勘探人员 -->
			<xsl:when test=".='040403'">2020103</xsl:when><!-- 技术员+++地址勘探人员 -->
			<xsl:when test=".='040404'">2020103</xsl:when><!-- 油气井清洁保养修护工+++地址勘探人员 -->
			<xsl:when test=".='040405'">2020103</xsl:when><!-- 钻勘设备装修保养工+++地址勘探人员 -->
			<xsl:when test=".='040406'">2020103</xsl:when><!-- 钻油井工人+++地址勘探人员 -->
			<xsl:when test=".='040407'">2020103</xsl:when><!-- 石油、天然气开采人员+++地址勘探人员 -->
			<xsl:when test=".='040408'">2020103</xsl:when><!-- 其他勘探及矿物开采人员+++地址勘探人员 -->
			<xsl:when test=".='040501'">2020103</xsl:when><!-- 行政人员+++地址勘探人员 -->
			<xsl:when test=".='040502'">2020103</xsl:when><!-- 工程师+++地址勘探人员 -->
			<xsl:when test=".='040503'">2020103</xsl:when><!-- 技术员+++地址勘探人员 -->
			<xsl:when test=".='040504'">2020103</xsl:when><!-- 油气井清洁保养修护工+++地址勘探人员 -->
			<xsl:when test=".='040505'">2020103</xsl:when><!-- 钻勘设备装修保养工+++地址勘探人员 -->
			<xsl:when test=".='040506'">2020103</xsl:when><!-- 钻油井工人+++地址勘探人员 -->
			<xsl:when test=".='040507'">2020103</xsl:when><!-- 石油、天然气开采人员+++地址勘探人员 -->
			<xsl:when test=".='040508'">2020103</xsl:when><!-- 其他勘探及矿物开采人员+++地址勘探人员 -->
			<xsl:when test=".='050101'">6240105</xsl:when><!-- 一般工作人员(不参与驾驶者)+++运输人员 -->
			<xsl:when test=".='050103'">6240105</xsl:when><!-- 出租车司机+++运输人员 -->
			<xsl:when test=".='050104'">6240105</xsl:when><!-- 短途客货运输车司机及随车人员+++运输人员 -->
			<xsl:when test=".='050105'">6240105</xsl:when><!-- 人力三轮车驾驶员+++运输人员 -->
			<xsl:when test=".='050106'">6240105</xsl:when><!-- 拖拉机、农用四轮车驾驶人员+++运输人员 -->
			<xsl:when test=".='050107'">6240105</xsl:when><!-- 机动三轮车驾驶员+++运输人员 -->
			<xsl:when test=".='050108'">6240105</xsl:when><!-- 长途客货运输车司机及随车人员+++运输人员 -->
			<xsl:when test=".='050109'">6240105</xsl:when><!-- 装卸工人+++运输人员 -->
			<xsl:when test=".='050110'">6240105</xsl:when><!-- 砂石车司机及随车人员+++运输人员 -->
			<xsl:when test=".='050111'">6240105</xsl:when><!-- 工程卡车人员+++运输人员 -->
			<xsl:when test=".='050112'">6240105</xsl:when><!-- 液化、汽化油罐车人员+++运输人员 -->
			<xsl:when test=".='050113'">6240105</xsl:when><!-- 缆车操作员+++运输人员 -->
			<xsl:when test=".='050114'">6240105</xsl:when><!-- 拖吊车驾驶及工作人员+++运输人员 -->
			<xsl:when test=".='050115'">6240105</xsl:when><!-- 救护车驾驶员+++运输人员 -->
			<xsl:when test=".='050116'">6240105</xsl:when><!-- 营运摩托车驾驶人员+++运输人员 -->
			<xsl:when test=".='050117'">6240105</xsl:when><!-- 垃圾车驾驶员+++运输人员 -->
			<xsl:when test=".='050201'">6240105</xsl:when><!-- 一般工作人员+++运输人员 -->
			<xsl:when test=".='050202'">6240105</xsl:when><!-- 车站清洁工人+++运输人员 -->
			<xsl:when test=".='050203'">6240105</xsl:when><!-- 随车人员(技术人员除外)+++运输人员 -->
			<xsl:when test=".='050204'">6240105</xsl:when><!-- 驾驶员+++运输人员 -->
			<xsl:when test=".='050205'">6240105</xsl:when><!-- 燃料填充员+++运输人员 -->
			<xsl:when test=".='050206'">6240105</xsl:when><!-- 机、电工+++运输人员 -->
			<xsl:when test=".='050207'">6240105</xsl:when><!-- 修理厂一般工作人员+++运输人员 -->
			<xsl:when test=".='050208'">6240105</xsl:when><!-- 修理厂技工+++运输人员 -->
			<xsl:when test=".='050209'">6240105</xsl:when><!-- 修路工+++运输人员 -->
			<xsl:when test=".='050210'">6240105</xsl:when><!-- 铁路维护工+++运输人员 -->
			<xsl:when test=".='050211'">6240105</xsl:when><!-- 道口看守人员+++运输人员 -->
			<xsl:when test=".='050212'">6240105</xsl:when><!-- 装卸搬运工人+++运输人员 -->
			<xsl:when test=".='050213'">6240105</xsl:when><!-- 月台工作人员+++运输人员 -->
			<xsl:when test=".='050214'">6240105</xsl:when><!-- 修理厂工程师+++运输人员 -->
			<xsl:when test=".='050215'">6240105</xsl:when><!-- 货运领班+++运输人员 -->
			<xsl:when test=".='050301'">6240105</xsl:when><!-- 船长+++运输人员 -->
			<xsl:when test=".='050302'">6240105</xsl:when><!-- 轮机长+++运输人员 -->
			<xsl:when test=".='050303'">6240105</xsl:when><!-- 大副+++运输人员 -->
			<xsl:when test=".='050304'">6240105</xsl:when><!-- 二副+++运输人员 -->
			<xsl:when test=".='050305'">6240105</xsl:when><!-- 三副+++运输人员 -->
			<xsl:when test=".='050306'">6240105</xsl:when><!-- 大管轮+++运输人员 -->
			<xsl:when test=".='050307'">6240105</xsl:when><!-- 二管轮+++运输人员 -->
			<xsl:when test=".='050308'">6240105</xsl:when><!-- 三管轮+++运输人员 -->
			<xsl:when test=".='050309'">6240105</xsl:when><!-- 报务员+++运输人员 -->
			<xsl:when test=".='050310'">6240105</xsl:when><!-- 事务长+++运输人员 -->
			<xsl:when test=".='050311'">6240105</xsl:when><!-- 医务人员+++运输人员 -->
			<xsl:when test=".='050312'">6240105</xsl:when><!-- 水手长+++运输人员 -->
			<xsl:when test=".='050313'">6240105</xsl:when><!-- 水手+++运输人员 -->
			<xsl:when test=".='050314'">6240105</xsl:when><!-- 铁匠、木匠、泵匠+++运输人员 -->
			<xsl:when test=".='050315'">6240105</xsl:when><!-- 电机师+++运输人员 -->
			<xsl:when test=".='050316'">6240105</xsl:when><!-- 厨师+++运输人员 -->
			<xsl:when test=".='050317'">6240105</xsl:when><!-- 服务员+++运输人员 -->
			<xsl:when test=".='050318'">6240105</xsl:when><!-- 实习生+++运输人员 -->
			<xsl:when test=".='050319'">6240105</xsl:when><!-- 游览船驾驶及工作人员+++运输人员 -->
			<xsl:when test=".='050320'">6240105</xsl:when><!-- 小汽艇驾驶及工作人员+++运输人员 -->
			<xsl:when test=".='050321'">6240105</xsl:when><!-- 码头工人及领班+++运输人员 -->
			<xsl:when test=".='050322'">6240105</xsl:when><!-- 起重机械操作员+++运输人员 -->
			<xsl:when test=".='050323'">6240105</xsl:when><!-- 仓库管理人+++运输人员 -->
			<xsl:when test=".='050324'">6240105</xsl:when><!-- 领航员+++运输人员 -->
			<xsl:when test=".='050325'">6240105</xsl:when><!-- 引水人+++运输人员 -->
			<xsl:when test=".='050326'">6240105</xsl:when><!-- 关务人员+++运输人员 -->
			<xsl:when test=".='050327'">6240105</xsl:when><!-- 稽查人员+++运输人员 -->
			<xsl:when test=".='050328'">6240105</xsl:when><!-- 缉私人员+++运输人员 -->
			<xsl:when test=".='050329'">6240105</xsl:when><!-- 拖船驾驶员及工作人员+++运输人员 -->
			<xsl:when test=".='050330'">6240105</xsl:when><!-- 渡轮驾驶员及工作人员+++运输人员 -->
			<xsl:when test=".='050331'">6240105</xsl:when><!-- 救难船员+++运输人员 -->
			<xsl:when test=".='050401'">6240105</xsl:when><!-- 一般工作人员+++运输人员 -->
			<xsl:when test=".='050402'">6240105</xsl:when><!-- 缉私人员+++运输人员 -->
			<xsl:when test=".='050403'">6240105</xsl:when><!-- 清洁工人+++运输人员 -->
			<xsl:when test=".='050404'">6240105</xsl:when><!-- 机场内交通司机+++运输人员 -->
			<xsl:when test=".='050405'">6240105</xsl:when><!-- 行李货物搬运工+++运输人员 -->
			<xsl:when test=".='050406'">6240105</xsl:when><!-- 加添燃料员+++运输人员 -->
			<xsl:when test=".='050407'">6240105</xsl:when><!-- 航空清洁工(内)、飞机洗刷人员(外)+++运输人员 -->
			<xsl:when test=".='050408'">6240105</xsl:when><!-- 跑道维护工+++运输人员 -->
			<xsl:when test=".='050409'">6240105</xsl:when><!-- 机械员+++运输人员 -->
			<xsl:when test=".='050410'">6240105</xsl:when><!-- 飞机修护人员+++运输人员 -->
			<xsl:when test=".='050411'">6240105</xsl:when><!-- 一般工作人员+++运输人员 -->
			<xsl:when test=".='050412'">6240105</xsl:when><!-- 理货员+++运输人员 -->
			<xsl:when test=".='050415'">6240105</xsl:when><!-- 直升机飞行员+++运输人员 -->
			<xsl:when test=".='050416'">6240105</xsl:when><!-- 一般工作人员+++运输人员 -->
			<xsl:when test=".='050417'">6240105</xsl:when><!-- 票务人员+++运输人员 -->
			<xsl:when test=".='050418'">6240105</xsl:when><!-- 机场柜台人员+++运输人员 -->
			<xsl:when test=".='050419'">6240105</xsl:when><!-- 清仓员+++运输人员 -->
			<xsl:when test=".='050420'">6240105</xsl:when><!-- 外务人员+++运输人员 -->
			<xsl:when test=".='050421'">6240105</xsl:when><!-- 报关人员+++运输人员 -->
			<xsl:when test=".='050422'">6240105</xsl:when><!-- 国际航线飞行人员及服务人员+++运输人员 -->
			<xsl:when test=".='050423'">6240105</xsl:when><!-- 国内航线飞行人员及服务人员+++运输人员 -->
			<xsl:when test=".='050424'">6240105</xsl:when><!-- 飞行训练学员+++运输人员 -->
			<xsl:when test=".='060101'">4010101</xsl:when><!-- 一般内勤人员+++商业、服务业人员 -->
			<xsl:when test=".='060102'">4010101</xsl:when><!-- 外务员+++商业、服务业人员 -->
			<xsl:when test=".='060103'">4010101</xsl:when><!-- 导游+++商业、服务业人员 -->
			<xsl:when test=".='060104'">4010101</xsl:when><!-- 司机+++商业、服务业人员 -->
			<xsl:when test=".='060201'">4010101</xsl:when><!-- 一般工作人员+++商业、服务业人员 -->
			<xsl:when test=".='060202'">4010101</xsl:when><!-- 服务人员+++商业、服务业人员 -->
			<xsl:when test=".='060203'">4010101</xsl:when><!-- 外务员+++商业、服务业人员 -->
			<xsl:when test=".='060204'">4010101</xsl:when><!-- 技工+++商业、服务业人员 -->
			<xsl:when test=".='060301'">4010101</xsl:when><!-- 一般工作人员+++商业、服务业人员 -->
			<xsl:when test=".='060302'">4010101</xsl:when><!-- 采买+++商业、服务业人员 -->
			<xsl:when test=".='060303'">4010101</xsl:when><!-- 厨师+++商业、服务业人员 -->
			<xsl:when test=".='060304'">4010101</xsl:when><!-- 服务员+++商业、服务业人员 -->
			<xsl:when test=".='060305'">4010101</xsl:when><!-- 收账员+++商业、服务业人员 -->
			<xsl:when test=".='060306'">4010101</xsl:when><!-- 屠宰工人+++商业、服务业人员 -->
			<xsl:when test=".='070101'">2020906</xsl:when><!-- 一般工作人员+++工程施工人员 -->
			<xsl:when test=".='070102'">2020906</xsl:when><!-- 建筑设计人员+++工程施工人员 -->
			<xsl:when test=".='070103'">2020906</xsl:when><!-- 现场技术检查员+++工程施工人员 -->
			<xsl:when test=".='070104'">2020906</xsl:when><!-- 领班+++工程施工人员 -->
			<xsl:when test=".='070105'">2020906</xsl:when><!-- 模板工+++工程施工人员 -->
			<xsl:when test=".='070106'">2020906</xsl:when><!-- 木匠(室内)、泥水匠（室内）+++工程施工人员 -->
			<xsl:when test=".='070107'">2020906</xsl:when><!-- 泥水匠（室外及高处）+++工程施工人员 -->
			<xsl:when test=".='070108'">2020906</xsl:when><!-- 建筑工程车辆机械操作员+++工程施工人员 -->
			<xsl:when test=".='070109'">2020906</xsl:when><!-- 建筑工程车辆驾驶员+++工程施工人员 -->
			<xsl:when test=".='070110'">2020906</xsl:when><!-- 油漆工(室内)+++工程施工人员 -->
			<xsl:when test=".='070111'">2020906</xsl:when><!-- 水电工(室内)+++工程施工人员 -->
			<xsl:when test=".='070112'">2020906</xsl:when><!-- 钢骨结构工人+++工程施工人员 -->
			<xsl:when test=".='070113'">2020906</xsl:when><!-- 钢架架设工人+++工程施工人员 -->
			<xsl:when test=".='070114'">2020906</xsl:when><!-- 焊工(室内)+++工程施工人员 -->
			<xsl:when test=".='070115'">2020906</xsl:when><!-- 焊工(室外及高处)+++工程施工人员 -->
			<xsl:when test=".='070116'">2020906</xsl:when><!-- 楼宇拆除工人(无需用炸药)+++工程施工人员 -->
			<xsl:when test=".='070117'">2020906</xsl:when><!-- 楼宇拆除工人(需用炸药)+++工程施工人员 -->
			<xsl:when test=".='070118'">2020906</xsl:when><!-- 安装玻璃幕墙工人、扎铁工人+++工程施工人员 -->
			<xsl:when test=".='070119'">2020906</xsl:when><!-- 散工+++工程施工人员 -->
			<xsl:when test=".='070120'">2020906</xsl:when><!-- 推土机操作员+++工程施工人员 -->
			<xsl:when test=".='070121'">2020906</xsl:when><!-- 负责人(不亲自作业不在现场)+++工程施工人员 -->
			<xsl:when test=".='070122'">2020906</xsl:when><!-- 负责人 (不亲自作业偶到现场)+++工程施工人员 -->
			<xsl:when test=".='070123'">2020906</xsl:when><!-- 负责人(亲自作业视具体性质)+++工程施工人员 -->
			<xsl:when test=".='070124'">2020906</xsl:when><!-- 外勤人员+++工程施工人员 -->
			<xsl:when test=".='070125'">2020906</xsl:when><!-- 测量人员+++工程施工人员 -->
			<xsl:when test=".='070126'">2020906</xsl:when><!-- 工程人员+++工程施工人员 -->
			<xsl:when test=".='070127'">2020906</xsl:when><!-- 工地服务人员+++工程施工人员 -->
			<xsl:when test=".='070128'">2020906</xsl:when><!-- 木匠(室外及高处)+++工程施工人员 -->
			<xsl:when test=".='070129'">2020906</xsl:when><!-- 混凝土混合机操作员+++工程施工人员 -->
			<xsl:when test=".='070130'">2020906</xsl:when><!-- 磨石工人+++工程施工人员 -->
			<xsl:when test=".='070131'">2020906</xsl:when><!-- 洗石工人+++工程施工人员 -->
			<xsl:when test=".='070132'">2020906</xsl:when><!-- 安装工人(室外及高处)+++工程施工人员 -->
			<xsl:when test=".='070133'">2020906</xsl:when><!-- 装修人员+++工程施工人员 -->
			<xsl:when test=".='070134'">2020906</xsl:when><!-- 排水、防水工程人员+++工程施工人员 -->
			<xsl:when test=".='070135'">2020906</xsl:when><!-- 油漆工(室外及高处)+++工程施工人员 -->
			<xsl:when test=".='070136'">2020906</xsl:when><!-- 水电工(地下)+++工程施工人员 -->
			<xsl:when test=".='070138'">2020906</xsl:when><!-- 建筑物外墙、玻璃幕墙维护人员+++工程施工人员 -->
			<xsl:when test=".='070139'">2020906</xsl:when><!-- 电工、管道工人、防火系统安装人员+++工程施工人员 -->
			<xsl:when test=".='070140'">2020906</xsl:when><!-- 警报器安装人员+++工程施工人员 -->
			<xsl:when test=".='070142'">2020906</xsl:when><!-- 物业管理行政、办公室工作人员+++工程施工人员 -->
			<xsl:when test=".='070143'">2020906</xsl:when><!-- 保安+++工程施工人员 -->
			<xsl:when test=".='070144'">2020906</xsl:when><!-- 工程师+++工程施工人员 -->
			<xsl:when test=".='070201'">2020906</xsl:when><!-- 现场技术检查员+++工程施工人员 -->
			<xsl:when test=".='070202'">2020906</xsl:when><!-- 工程机械操作员+++工程施工人员 -->
			<xsl:when test=".='070203'">2020906</xsl:when><!-- 工程车辆驾驶员+++工程施工人员 -->
			<xsl:when test=".='070204'">2020906</xsl:when><!-- 铺设工人(平地)+++工程施工人员 -->
			<xsl:when test=".='070205'">2020906</xsl:when><!-- 维护工人+++工程施工人员 -->
			<xsl:when test=".='070206'">2020906</xsl:when><!-- 电线架设及维护工人+++工程施工人员 -->
			<xsl:when test=".='070207'">2020906</xsl:when><!-- 管道铺设及维护工人+++工程施工人员 -->
			<xsl:when test=".='070208'">2020906</xsl:when><!-- 铺设工人(山地)+++工程施工人员 -->
			<xsl:when test=".='070209'">2020906</xsl:when><!-- 工程师+++工程施工人员 -->
			<xsl:when test=".='070301'">2020906</xsl:when><!-- 安装工人+++工程施工人员 -->
			<xsl:when test=".='070302'">2020906</xsl:when><!-- 修理及维护工人+++工程施工人员 -->
			<xsl:when test=".='070303'">2020906</xsl:when><!-- 操作员(不包括矿场使用者)+++工程施工人员 -->
			<xsl:when test=".='070401'">2020906</xsl:when><!-- 设计人员+++工程施工人员 -->
			<xsl:when test=".='070402'">2020906</xsl:when><!-- 室内装璜人员+++工程施工人员 -->
			<xsl:when test=".='070403'">2020906</xsl:when><!-- 室外装璜人员(高处作业)+++工程施工人员 -->
			<xsl:when test=".='070404'">2020906</xsl:when><!-- 地毯装设人员+++工程施工人员 -->
			<xsl:when test=".='070405'">2020906</xsl:when><!-- 监工+++工程施工人员 -->
			<xsl:when test=".='070406'">2020906</xsl:when><!-- 工程师+++工程施工人员 -->
			<xsl:when test=".='070407'">2020906</xsl:when><!-- 领班、监工+++工程施工人员 -->
			<xsl:when test=".='070408'">2020906</xsl:when><!-- 工人+++工程施工人员 -->
			<xsl:when test=".='070409'">2020906</xsl:when><!-- 室外装潢人员（非高处作业）+++工程施工人员 -->
			<xsl:when test=".='070410'">2020906</xsl:when><!-- 承包商+++工程施工人员 -->
			<xsl:when test=".='070411'">2020906</xsl:when><!-- 金属门窗制作、安装工人+++工程施工人员 -->
			<xsl:when test=".='070501'">2020906</xsl:when><!-- 地质探测员(山区、海上)+++工程施工人员 -->
			<xsl:when test=".='070502'">2020906</xsl:when><!-- 工地看守员+++工程施工人员 -->
			<xsl:when test=".='070503'">2020906</xsl:when><!-- 海湾港口工程人员+++工程施工人员 -->
			<xsl:when test=".='070504'">2020906</xsl:when><!-- 水坝工程人员+++工程施工人员 -->
			<xsl:when test=".='070505'">2020906</xsl:when><!-- 桥梁工程人员+++工程施工人员 -->
			<xsl:when test=".='070506'">2020906</xsl:when><!-- 隧道工作人员+++工程施工人员 -->
			<xsl:when test=".='070507'">2020906</xsl:when><!-- 潜水工作人员+++工程施工人员 -->
			<xsl:when test=".='070508'">2020906</xsl:when><!-- 爆破工作人员+++工程施工人员 -->
			<xsl:when test=".='070509'">2020906</xsl:when><!-- 地质探测员(平地)+++工程施工人员 -->
			<xsl:when test=".='070510'">2020906</xsl:when><!-- 挖泥船工人、挖沙工人+++工程施工人员 -->
			<xsl:when test=".='070511'">2020906</xsl:when><!-- 寺庙彩绘人员+++工程施工人员 -->
			<xsl:when test=".='070512'">2020906</xsl:when><!-- 挖井工程人员+++工程施工人员 -->
			<xsl:when test=".='080101'">2020906</xsl:when><!-- 生产行政管理人员+++工程施工人员 -->
			<xsl:when test=".='080102'">2020906</xsl:when><!-- 技术人员+++工程施工人员 -->
			<xsl:when test=".='080103'">2020906</xsl:when><!-- 炼钢工人+++工程施工人员 -->
			<xsl:when test=".='080104'">2020906</xsl:when><!-- 其他工人+++工程施工人员 -->
			<xsl:when test=".='080201'">2020906</xsl:when><!-- 生产行政管理人员+++工程施工人员 -->
			<xsl:when test=".='080202'">2020906</xsl:when><!-- 技术人员+++工程施工人员 -->
			<xsl:when test=".='080203'">2020906</xsl:when><!-- 扳金工+++工程施工人员 -->
			<xsl:when test=".='080204'">2020906</xsl:when><!-- 装配工+++工程施工人员 -->
			<xsl:when test=".='080205'">2020906</xsl:when><!-- *焊接工（室内）+++工程施工人员 -->
			<xsl:when test=".='080206'">2020906</xsl:when><!-- 车床工+++工程施工人员 -->
			<xsl:when test=".='080207'">2020906</xsl:when><!-- 铸造工+++工程施工人员 -->
			<xsl:when test=".='080208'">2020906</xsl:when><!-- 水电工+++工程施工人员 -->
			<xsl:when test=".='080209'">2020906</xsl:when><!-- 锅炉工+++工程施工人员 -->
			<xsl:when test=".='080210'">2020906</xsl:when><!-- 电镀工+++工程施工人员 -->
			<xsl:when test=".='080211'">2020906</xsl:when><!-- 铣、剪、冲床工+++工程施工人员 -->
			<xsl:when test=".='080219'">2020906</xsl:when><!-- 焊接工（室外及高处）+++工程施工人员 -->
			<xsl:when test=".='080212'">2020906</xsl:when><!-- 化工产品生产通用工艺工人+++工程施工人员 -->
			<xsl:when test=".='080213'">2020906</xsl:when><!-- 石油炼制生产人员+++工程施工人员 -->
			<xsl:when test=".='080214'">2020906</xsl:when><!-- 煤化工生产人员+++工程施工人员 -->
			<xsl:when test=".='080215'">2020906</xsl:when><!-- 化学肥料生产人员+++工程施工人员 -->
			<xsl:when test=".='080216'">2020906</xsl:when><!-- 火药、炸药制造人员+++工程施工人员 -->
			<xsl:when test=".='080217'">2020906</xsl:when><!-- 日用化学品生产人员+++工程施工人员 -->
			<xsl:when test=".='080218'">2020906</xsl:when><!-- 其他化工产品生产人员+++工程施工人员 -->
			<xsl:when test=".='080301'">4010101</xsl:when><!-- 生产行政管理人员+++商业、服务业人员 -->
			<xsl:when test=".='080302'">4010101</xsl:when><!-- 技术人员、工程师+++商业、服务业人员 -->
			<xsl:when test=".='080303'">6050611</xsl:when><!-- 装配修理工+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080304'">6050611</xsl:when><!-- 制造工+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080305'">6050611</xsl:when><!-- 包装工+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080401'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080402'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080403'">6050611</xsl:when><!-- 空气调节器装修人员(高处)+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080404'">6050611</xsl:when><!-- 有关高压电工作人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080405'">6050611</xsl:when><!-- 冷冻修理工、室内空调装修员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080501'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080502'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080503'">6050611</xsl:when><!-- 工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080504'">6050611</xsl:when><!-- 塑胶射出成型工人(自动)+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080505'">6050611</xsl:when><!-- 塑胶射出成型个人(其他)+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080506'">6050611</xsl:when><!-- 工程师+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080601'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080602'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080603'">6050611</xsl:when><!-- 熟练工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080604'">2020103</xsl:when><!-- 采掘工+++地址勘探人员 -->
			<xsl:when test=".='080605'">2020103</xsl:when><!-- 爆破工+++地址勘探人员 -->
			<xsl:when test=".='080606'">2020103</xsl:when><!-- 非熟练工人+++地址勘探人员 -->
			<xsl:when test=".='080607'">2020103</xsl:when><!-- 石棉瓦工人、作业者+++地址勘探人员 -->
			<xsl:when test=".='080608'">6050611</xsl:when><!-- 陶瓷、木炭、砖块制作工+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080701'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080702'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080703'">6050611</xsl:when><!-- 一般工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080704'">2020103</xsl:when><!-- 硫酸、盐酸、硝酸制造工+++地址勘探人员 -->
			<xsl:when test=".='080705'">2020103</xsl:when><!-- 电池制造工人+++地址勘探人员 -->
			<xsl:when test=".='080706'">2020103</xsl:when><!-- 液化气体制造工人+++地址勘探人员 -->
			<xsl:when test=".='080801'">2020103</xsl:when><!-- 火药爆竹制造及处理人员+++地址勘探人员 -->
			<xsl:when test=".='080802'">2020103</xsl:when><!-- 火工品制造人员+++地址勘探人员 -->
			<xsl:when test=".='080803'">2020103</xsl:when><!-- 雷管制造工+++地址勘探人员 -->
			<xsl:when test=".='080804'">2020103</xsl:when><!-- 爆破器材制造、实验工+++地址勘探人员 -->
			<xsl:when test=".='080901'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080902'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080903'">6050611</xsl:when><!-- 装造工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080904'">6050611</xsl:when><!-- 修理保养工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080905'">6050611</xsl:when><!-- 喷漆工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='080906'">6050611</xsl:when><!-- 试车人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081001'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081002'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081003'">6050611</xsl:when><!-- 织造工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081004'">6050611</xsl:when><!-- 染整工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081005'">6050611</xsl:when><!-- 切棉、压边、锯工、椅垫工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081006'">6050611</xsl:when><!-- 吹气、毛占、填料、机械操作+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081007'">6050611</xsl:when><!-- 暴身于尘埃和有毒化合物工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081101'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081102'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081103'">6050611</xsl:when><!-- 造纸厂工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081104'">6050611</xsl:when><!-- 纸浆厂工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081105'">6050611</xsl:when><!-- 纸箱制造工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081201'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081202'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081203'">6050611</xsl:when><!-- 木制家俱装造修理工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081204'">6050611</xsl:when><!-- 金属家俱装造修理工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081301'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081302'">6050611</xsl:when><!-- 竹木制手工艺品加工工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081303'">6050611</xsl:when><!-- 金属手工艺品加工工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081304'">6050611</xsl:when><!-- 布类纸品工艺品加工工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081305'">6050611</xsl:when><!-- 矿石手工艺品加工人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081306'">6050611</xsl:when><!-- 其他手工艺品加工人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081307'">6050611</xsl:when><!-- 陶瓷制作加工人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081308'">6050611</xsl:when><!-- 玻璃制作加工人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081401'">6050611</xsl:when><!-- 生产行政管理人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081402'">6050611</xsl:when><!-- 技术人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081403'">6050611</xsl:when><!-- 工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081404'">6050611</xsl:when><!-- 从事有毒有害的作业人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081405'">6050611</xsl:when><!-- 肥皂、洗洁精制造人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081406'">6050611</xsl:when><!-- 烟草业制作人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081501'">6050611</xsl:when><!-- 技师+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081502'">6050611</xsl:when><!-- 工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081601'">6050611</xsl:when><!-- 冰块制造工+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081602'">6050611</xsl:when><!-- 技师+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081603'">6050611</xsl:when><!-- 碾米厂操作人员+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081604'">6050611</xsl:when><!-- 其他制造工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081605'">6050611</xsl:when><!-- 装罐工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='081606'">6050611</xsl:when><!-- 制造工人+++加工制造、检验及计量人员 -->
			<xsl:when test=".='090101'">2100106</xsl:when><!-- 一般工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090102'">2100106</xsl:when><!-- 外勤记者+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090103'">2100106</xsl:when><!-- 摄影记者+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090104'">2100106</xsl:when><!-- 印刷厂工人+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090105'">2100106</xsl:when><!-- 送报员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090106'">2100106</xsl:when><!-- 战地记者+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090201'">2100106</xsl:when><!-- 一般工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090202'">2100106</xsl:when><!-- 编辑人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090203'">2100106</xsl:when><!-- 摄影记者+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090204'">2100106</xsl:when><!-- 送货员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090301'">2100106</xsl:when><!-- 一般工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090302'">2100106</xsl:when><!-- 外勤业务人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090303'">2100106</xsl:when><!-- 广告影片之拍摄录制人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090304'">2100106</xsl:when><!-- 广告招牌架设、安装人员(室外)+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090305'">2100106</xsl:when><!-- 广告招牌制作者(室内)+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090306'">2100106</xsl:when><!-- 玻璃匠及图样设计人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='090307'">2100106</xsl:when><!-- 安装光管及外勤维修人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='100101'">2050101</xsl:when><!-- 一般医务行政人员+++卫生专业技术人员 -->
			<xsl:when test=".='100102'">2050101</xsl:when><!-- 一般医师及护士+++卫生专业技术人员 -->
			<xsl:when test=".='100103'">2050101</xsl:when><!-- 精神病科医师、看护及护士+++卫生专业技术人员 -->
			<xsl:when test=".='100104'">2050101</xsl:when><!-- 病理检查员+++卫生专业技术人员 -->
			<xsl:when test=".='100105'">2050101</xsl:when><!-- 放射线技术人员+++卫生专业技术人员 -->
			<xsl:when test=".='100106'">2050101</xsl:when><!-- 放射线修护人员+++卫生专业技术人员 -->
			<xsl:when test=".='100107'">2050101</xsl:when><!-- 医院炊事员+++卫生专业技术人员 -->
			<xsl:when test=".='100108'">2050101</xsl:when><!-- 杂工+++卫生专业技术人员 -->
			<xsl:when test=".='100109'">2050101</xsl:when><!-- 清洁工+++卫生专业技术人员 -->
			<xsl:when test=".='100110'">2050101</xsl:when><!-- 监狱、看守所医生+++卫生专业技术人员 -->
			<xsl:when test=".='100111'">2050101</xsl:when><!-- 助产士+++卫生专业技术人员 -->
			<xsl:when test=".='100112'">2050101</xsl:when><!-- 跌打损伤治疗人员+++卫生专业技术人员 -->
			<xsl:when test=".='100201'">2050101</xsl:when><!-- 一般医务行政人员+++卫生专业技术人员 -->
			<xsl:when test=".='100202'">2050101</xsl:when><!-- 一般医师及护士+++卫生专业技术人员 -->
			<xsl:when test=".='100203'">2050101</xsl:when><!-- 分析员+++卫生专业技术人员 -->
			<xsl:when test=".='100204'">2050101</xsl:when><!-- 消毒员+++卫生专业技术人员 -->
			<xsl:when test=".='110101'">2100106</xsl:when><!-- 行政人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110102'">2100106</xsl:when><!-- 制片人+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110103'">2100106</xsl:when><!-- 编剧+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110104'">2100106</xsl:when><!-- 一般演员(含导演)+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110105'">2100106</xsl:when><!-- 舞蹈演艺人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110106'">2100106</xsl:when><!-- 巡回演出文艺团体人员(杂技除外)+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110107'">2100106</xsl:when><!-- 一般杂技演员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110108'">2100106</xsl:when><!-- 高难度动作杂技演员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110109'">2100106</xsl:when><!-- 武打演员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110110'">2100106</xsl:when><!-- 特技演员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110111'">2100106</xsl:when><!-- 其他从业人员(绘画、演奏、作曲等)+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110112'">2100106</xsl:when><!-- 驯兽师、空中飞人、走钢丝+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110113'">2100106</xsl:when><!-- 饲养员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110114'">2100106</xsl:when><!-- 化妆师+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110115'">2100106</xsl:when><!-- 场记+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110116'">2100106</xsl:when><!-- 摄影工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110117'">2100106</xsl:when><!-- 灯光及音响效果工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110118'">2100106</xsl:when><!-- 冲洗片工作人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110119'">2100106</xsl:when><!-- 电视记者+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110120'">2100106</xsl:when><!-- 机械工、电工+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110121'">2100106</xsl:when><!-- 布景搭设人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110122'">2100106</xsl:when><!-- 电影院售票员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110123'">2100106</xsl:when><!-- 电影院放映人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110124'">2100106</xsl:when><!-- 电影院服务人员+++新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='110201'">4010101</xsl:when><!-- 教练+++商业、服务业人员 -->
			<xsl:when test=".='110202'">4010101</xsl:when><!-- 球场保养工人+++商业、服务业人员 -->
			<xsl:when test=".='110203'">4010101</xsl:when><!-- 维护工人+++商业、服务业人员 -->
			<xsl:when test=".='110204'">4010101</xsl:when><!-- 球场服务员+++商业、服务业人员 -->
			<xsl:when test=".='110301'">4010101</xsl:when><!-- 球馆服务+++商业、服务业人员 -->
			<xsl:when test=".='110302'">4010101</xsl:when><!-- 机械修护员+++商业、服务业人员 -->
			<xsl:when test=".='110303'">4010101</xsl:when><!-- 清洁工人+++商业、服务业人员 -->
			<xsl:when test=".='110304'">4010101</xsl:when><!-- 教练+++商业、服务业人员 -->
			<xsl:when test=".='110305'">4010101</xsl:when><!-- 球员+++商业、服务业人员 -->
			<xsl:when test=".='110401'">4010101</xsl:when><!-- 负责人+++商业、服务业人员 -->
			<xsl:when test=".='110402'">4010101</xsl:when><!-- 记分员+++商业、服务业人员 -->
			<xsl:when test=".='110501'">4010101</xsl:when><!-- 管理人员+++商业、服务业人员 -->
			<xsl:when test=".='110502'">4010101</xsl:when><!-- 服务员+++商业、服务业人员 -->
			<xsl:when test=".='110503'">4010101</xsl:when><!-- 游泳池救生员+++商业、服务业人员 -->
			<xsl:when test=".='110504'">4010101</xsl:when><!-- 海水浴场救生员+++商业、服务业人员 -->
			<xsl:when test=".='110601'">4010101</xsl:when><!-- 管理人员+++商业、服务业人员 -->
			<xsl:when test=".='110602'">4010101</xsl:when><!-- 售票员+++商业、服务业人员 -->
			<xsl:when test=".='110603'">4010101</xsl:when><!-- 电动玩具操作员+++商业、服务业人员 -->
			<xsl:when test=".='110604'">4010101</xsl:when><!-- 一般清洁工+++商业、服务业人员 -->
			<xsl:when test=".='110605'">4010101</xsl:when><!-- 兽栏清洁工+++商业、服务业人员 -->
			<xsl:when test=".='110606'">4010101</xsl:when><!-- 水电机械工+++商业、服务业人员 -->
			<xsl:when test=".='110607'">4010101</xsl:when><!-- 动物园驯兽师+++商业、服务业人员 -->
			<xsl:when test=".='110608'">4010101</xsl:when><!-- 饲养人员+++商业、服务业人员 -->
			<xsl:when test=".='110701'">4010101</xsl:when><!-- 咖啡厅工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110702'">4010101</xsl:when><!-- 茶室工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110703'">4010101</xsl:when><!-- 酒家工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110704'">4010101</xsl:when><!-- 歌厅工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110705'">4010101</xsl:when><!-- 舞厅工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110706'">4010101</xsl:when><!-- 夜总会工作人员+++商业、服务业人员 -->
			<xsl:when test=".='110707'">4010101</xsl:when><!-- 酒吧、网吧工作人员+++商业、服务业人员 -->
			<xsl:when test=".='120101'">2090104</xsl:when><!-- 教师+++教学人员 -->
			<xsl:when test=".='120102'">2090104</xsl:when><!-- 学生+++教学人员 -->
			<xsl:when test=".='120103'">2090104</xsl:when><!-- 校工+++教学人员 -->
			<xsl:when test=".='120104'">2090104</xsl:when><!-- 体育老师+++教学人员 -->
			<xsl:when test=".='120105'">2090104</xsl:when><!-- 军训教官+++教学人员 -->
			<xsl:when test=".='120106'">2090104</xsl:when><!-- 各项运动教练+++教学人员 -->
			<xsl:when test=".='120107'">2090104</xsl:when><!-- 汽车驾驶训练教练+++教学人员 -->
			<xsl:when test=".='120201'">2090104</xsl:when><!-- 维修工+++教学人员 -->
			<xsl:when test=".='120202'">2090104</xsl:when><!-- 一般工作人员+++教学人员 -->
			<xsl:when test=".='120203'">2090104</xsl:when><!-- 售货员+++教学人员 -->
			<xsl:when test=".='120204'">2090104</xsl:when><!-- 外勤人员+++教学人员 -->
			<xsl:when test=".='120205'">2090104</xsl:when><!-- 博物馆工作人员+++教学人员 -->
			<xsl:when test=".='120206'">2090104</xsl:when><!-- 图书馆工作人员+++教学人员 -->
			<xsl:when test=".='130101'">2090104</xsl:when><!-- 寺庙及教堂管理人员+++教学人员 -->
			<xsl:when test=".='130102'">2090104</xsl:when><!-- 宗教团体工作人员+++教学人员 -->
			<xsl:when test=".='130103'">2090104</xsl:when><!-- 僧尼、道士及传教人员+++教学人员 -->
			<xsl:when test=".='140101'">3030101</xsl:when><!-- 内勤人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140102'">3030101</xsl:when><!-- 骑摩托车邮递人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140103'">3030101</xsl:when><!-- 邮递人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140104'">3030101</xsl:when><!-- 包裹搬运工+++邮政和电信业务人员 -->
			<xsl:when test=".='140201'">3030101</xsl:when><!-- 内勤人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140202'">3030101</xsl:when><!-- 抄表员、收费员+++邮政和电信业务人员 -->
			<xsl:when test=".='140203'">3030101</xsl:when><!-- 电信电力装置维护修理工+++邮政和电信业务人员 -->
			<xsl:when test=".='140204'">3030101</xsl:when><!-- 电信电力工程设施之架设人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140205'">3030101</xsl:when><!-- 电信高压电工程设施人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140206'">3030101</xsl:when><!-- 核能发电厂工作人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140207'">3030101</xsl:when><!-- 电台天线维护人员+++邮政和电信业务人员 -->
			<xsl:when test=".='140301'">5010107</xsl:when><!-- 一般工作人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140302'">5010107</xsl:when><!-- 抄表员、 收费员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140303'">5010107</xsl:when><!-- 水坝、水库管理人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140304'">5010107</xsl:when><!-- 水利工程设施人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140305'">5010107</xsl:when><!-- 自来水管装修人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140306'">5010107</xsl:when><!-- 水土保持作业人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140307'">5010107</xsl:when><!-- 水文勘测作业人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140308'">5010107</xsl:when><!-- 水质分析员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140309'">5010107</xsl:when><!-- 其他水利设施管护人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140310'">5010107</xsl:when><!-- 其他水利能源开发人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140401'">5010107</xsl:when><!-- 一般工作人员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140402'">5010107</xsl:when><!-- 收费员、抄表员、检察员+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140403'">5010107</xsl:when><!-- 管线装修工+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140404'">5010107</xsl:when><!-- 煤气器具制造工+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140405'">5010107</xsl:when><!-- 操作工+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140406'">5010107</xsl:when><!-- 煤气分装工+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='140407'">5010107</xsl:when><!-- 液化气罐随车司机及工人+++农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='150101'">4010101</xsl:when><!-- 一般工作人员+++商业、服务业人员 -->
			<xsl:when test=".='150102'">4010101</xsl:when><!-- 售货员+++商业、服务业人员 -->
			<xsl:when test=".='150103'">4010101</xsl:when><!-- 仓库保管员+++商业、服务业人员 -->
			<xsl:when test=".='150104'">4010101</xsl:when><!-- 燃料仓库保管员+++商业、服务业人员 -->
			<xsl:when test=".='150105'">4010101</xsl:when><!-- 搬运工+++商业、服务业人员 -->
			<xsl:when test=".='150106'">4010101</xsl:when><!-- 司机+++商业、服务业人员 -->
			<xsl:when test=".='150201'">4010101</xsl:when><!-- 一般工作人员+++商业、服务业人员 -->
			<xsl:when test=".='150202'">4010101</xsl:when><!-- 售货员+++商业、服务业人员 -->
			<xsl:when test=".='150203'">4010101</xsl:when><!-- 珠宝工艺品售货员+++商业、服务业人员 -->
			<xsl:when test=".='150204'">4010101</xsl:when><!-- 保管员+++商业、服务业人员 -->
			<xsl:when test=".='150205'">4010101</xsl:when><!-- 采购、推销员+++商业、服务业人员 -->
			<xsl:when test=".='150206'">4010101</xsl:when><!-- 搬运+++商业、服务业人员 -->
			<xsl:when test=".='150207'">4010101</xsl:when><!-- 司机+++商业、服务业人员 -->
			<xsl:when test=".='150208'">4010101</xsl:when><!-- 厨具、陶瓷、古董、花卉商+++商业、服务业人员 -->
			<xsl:when test=".='150209'">4010101</xsl:when><!-- 银楼、当铺、杂货、食品商+++商业、服务业人员 -->
			<xsl:when test=".='150210'">4010101</xsl:when><!-- 家具、机车、眼镜、文具商+++商业、服务业人员 -->
			<xsl:when test=".='150211'">4010101</xsl:when><!-- 布匹、服饰、药品、工艺商+++商业、服务业人员 -->
			<xsl:when test=".='150212'">4010101</xsl:when><!-- 玻璃、石材、建材、钢材商+++商业、服务业人员 -->
			<xsl:when test=".='150213'">4010101</xsl:when><!-- 木材、五金、电器、器材商+++商业、服务业人员 -->
			<xsl:when test=".='150214'">4010101</xsl:when><!-- 肉鱼、医疗仪器、珠宝商+++商业、服务业人员 -->
			<xsl:when test=".='150215'">4010101</xsl:when><!-- 化学原料商+++商业、服务业人员 -->
			<xsl:when test=".='150216'">4010101</xsl:when><!-- 液化瓦斯零售商+++商业、服务业人员 -->
			<xsl:when test=".='150217'">4010101</xsl:when><!-- 瓦斯分装工+++商业、服务业人员 -->
			<xsl:when test=".='150218'">4010101</xsl:when><!-- 旧货收购人员+++商业、服务业人员 -->
			<xsl:when test=".='160101'">2070109</xsl:when><!-- 内勤人员+++金融业务人员 -->
			<xsl:when test=".='160102'">2070109</xsl:when><!-- 外勤人员+++金融业务人员 -->
			<xsl:when test=".='160103'">2070109</xsl:when><!-- 储蓄所工作人员+++金融业务人员 -->
			<xsl:when test=".='160104'">2070109</xsl:when><!-- 营业点工作人员+++金融业务人员 -->
			<xsl:when test=".='160105'">2070109</xsl:when><!-- 运钞押运人员(含司机)+++金融业务人员 -->
			<xsl:when test=".='170101'">2080103</xsl:when><!-- 律师+++法律专业人员 -->
			<xsl:when test=".='170102'">2080103</xsl:when><!-- 会计师+++法律专业人员 -->
			<xsl:when test=".='170103'">2080103</xsl:when><!-- 文书+++法律专业人员 -->
			<xsl:when test=".='170104'">2080103</xsl:when><!-- 经纪人+++法律专业人员 -->
			<xsl:when test=".='170201'">4010101</xsl:when><!-- 理发师+++商业、服务业人员 -->
			<xsl:when test=".='170202'">4010101</xsl:when><!-- 美容师、形象设计师+++商业、服务业人员 -->
			<xsl:when test=".='170203'">4010101</xsl:when><!-- 浴室(领有牌照的)+++商业、服务业人员 -->
			<xsl:when test=".='170204'">4010101</xsl:when><!-- 各业修理工+++商业、服务业人员 -->
			<xsl:when test=".='170205'">4010101</xsl:when><!-- 刻字工+++商业、服务业人员 -->
			<xsl:when test=".='170206'">4010101</xsl:when><!-- 洗衣店工人+++商业、服务业人员 -->
			<xsl:when test=".='170207'">4010101</xsl:when><!-- 大楼管理员、市场管理员+++商业、服务业人员 -->
			<xsl:when test=".='170208'">4010101</xsl:when><!-- 摄影师+++商业、服务业人员 -->
			<xsl:when test=".='170209'">4010101</xsl:when><!-- 服装加工工人+++商业、服务业人员 -->
			<xsl:when test=".='170210'">4010101</xsl:when><!-- 警卫人员(有巡逻押运任务者)+++商业、服务业人员 -->
			<xsl:when test=".='170211'">4010101</xsl:when><!-- 警卫人员(内勤)+++商业、服务业人员 -->
			<xsl:when test=".='170212'">4010101</xsl:when><!-- 保镖+++商业、服务业人员 -->
			<xsl:when test=".='170213'">4010101</xsl:when><!-- 邮递人员+++商业、服务业人员 -->
			<xsl:when test=".='170214'">4010101</xsl:when><!-- 公证行外务员+++商业、服务业人员 -->
			<xsl:when test=".='170215'">4010101</xsl:when><!-- 报关行外务员+++商业、服务业人员 -->
			<xsl:when test=".='170216'">4010101</xsl:when><!-- 冲印师+++商业、服务业人员 -->
			<xsl:when test=".='170217'">4010101</xsl:when><!-- 裁缝+++商业、服务业人员 -->
			<xsl:when test=".='170218'">4010101</xsl:when><!-- 一般管理及工作人员+++商业、服务业人员 -->
			<xsl:when test=".='170219'">4010101</xsl:when><!-- 服务员、护卫员、接待员+++商业、服务业人员 -->
			<xsl:when test=".='170220'">4010101</xsl:when><!-- 按摩人员+++商业、服务业人员 -->
			<xsl:when test=".='170301'">2020906</xsl:when><!-- 道路清洁工+++工程施工人员 -->
			<xsl:when test=".='170302'">2020906</xsl:when><!-- 下水道清洁工+++工程施工人员 -->
			<xsl:when test=".='170303'">2020906</xsl:when><!-- 高楼外部清洁工+++工程施工人员 -->
			<xsl:when test=".='170304'">2020906</xsl:when><!-- 存车及洗车工+++工程施工人员 -->
			<xsl:when test=".='170305'">2020906</xsl:when><!-- 装修工+++工程施工人员 -->
			<xsl:when test=".='170306'">2020906</xsl:when><!-- 殡葬工+++工程施工人员 -->
			<xsl:when test=".='170307'">2020906</xsl:when><!-- 烟囱清洁工+++工程施工人员 -->
			<xsl:when test=".='170308'">2020906</xsl:when><!-- 加油站工作人员+++工程施工人员 -->
			<xsl:when test=".='170401'">3030101</xsl:when><!-- 维护工程师+++邮政和电信业务人员 -->
			<xsl:when test=".='170402'">3030101</xsl:when><!-- 系统工程师+++邮政和电信业务人员 -->
			<xsl:when test=".='170403'">3030101</xsl:when><!-- 销售工程师+++邮政和电信业务人员 -->
			<xsl:when test=".='180101'">8010104</xsl:when><!-- 家庭主妇(无业)+++家庭主妇 -->
			<xsl:when test=".='180102'">4010101</xsl:when><!-- 佣人+++商业、服务业人员 -->
			<xsl:when test=".='180103'">4010101</xsl:when><!-- 家庭护理+++商业、服务业人员 -->
			<xsl:when test=".='190101'">7010103</xsl:when><!-- 警务行政及内勤人员+++军人 -->
			<xsl:when test=".='190102'">7010103</xsl:when><!-- 警察(有巡逻任务者)+++军人 -->
			<xsl:when test=".='190103'">7010103</xsl:when><!-- 监狱看守所管理人员+++军人 -->
			<xsl:when test=".='190104'">7010103</xsl:when><!-- 交通警察+++军人 -->
			<xsl:when test=".='190105'">7010103</xsl:when><!-- 刑警+++军人 -->
			<xsl:when test=".='190106'">7010103</xsl:when><!-- 消防队队员+++军人 -->
			<xsl:when test=".='190107'">7010103</xsl:when><!-- 保安人员+++军人 -->
			<xsl:when test=".='190108'">7010103</xsl:when><!-- 治安人员+++军人 -->
			<xsl:when test=".='190109'">7010103</xsl:when><!-- 主管、高级管理人员+++军人 -->
			<xsl:when test=".='190110'">7010103</xsl:when><!-- 办公室公务人员+++军人 -->
			<xsl:when test=".='190111'">7010103</xsl:when><!-- 炸药处理警察+++军人 -->
			<xsl:when test=".='190112'">7010103</xsl:when><!-- 治安警察+++军人 -->
			<xsl:when test=".='190113'">7010103</xsl:when><!-- 防暴警察+++军人 -->
			<xsl:when test=".='190114'">7010103</xsl:when><!-- 警校学生+++军人 -->
			<xsl:when test=".='200101'">2050101</xsl:when><!-- 教练人员、裁判人员+++卫生专业技术人员 -->
			<xsl:when test=".='200102'">2050101</xsl:when><!-- 足球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200103'">2050101</xsl:when><!-- 篮球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200104'">2050101</xsl:when><!-- 曲棍球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200105'">2050101</xsl:when><!-- 冰上曲棍球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200106'">2050101</xsl:when><!-- 其他球类运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200107'">2050101</xsl:when><!-- 桌球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200108'">2050101</xsl:when><!-- 羽毛球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200109'">2050101</xsl:when><!-- 网球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200110'">2050101</xsl:when><!-- 垒球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200111'">2050101</xsl:when><!-- 排球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200112'">2050101</xsl:when><!-- 棒球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200113'">2050101</xsl:when><!-- 手球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200114'">2050101</xsl:when><!-- 巧固球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200115'">2050101</xsl:when><!-- 橄榄球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200116'">2050101</xsl:when><!-- 高尔夫球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200117'">2050101</xsl:when><!-- 保龄球运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200201'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200202'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200301'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200302'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200401'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200402'">2050101</xsl:when><!-- 游泳运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200403'">2050101</xsl:when><!-- 跳水运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200501'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200502'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200503'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200504'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200505'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200506'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200507'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200508'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200601'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200602'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200701'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200702'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200801'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200802'">2050101</xsl:when><!-- 自行车运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200803'">2050101</xsl:when><!-- 汽车赛车手+++卫生专业技术人员 -->
			<xsl:when test=".='200804'">2050101</xsl:when><!-- 摩托车赛车手+++卫生专业技术人员 -->
			<xsl:when test=".='200901'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='200902'">2050101</xsl:when><!-- 帆船、划船运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200903'">2050101</xsl:when><!-- 赛艇、风浪板运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200904'">2050101</xsl:when><!-- 水上摩托艇运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200905'">2050101</xsl:when><!-- 冲浪运动员+++卫生专业技术人员 -->
			<xsl:when test=".='200906'">2050101</xsl:when><!-- 潜水运动员—0至50米+++卫生专业技术人员 -->
			<xsl:when test=".='200907'">2050101</xsl:when><!-- 潜水运动员—50以上+++卫生专业技术人员 -->
			<xsl:when test=".='200908'">2050101</xsl:when><!-- 潜水教练+++卫生专业技术人员 -->
			<xsl:when test=".='201001'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='201002'">2050101</xsl:when><!-- 滑冰运动员+++卫生专业技术人员 -->
			<xsl:when test=".='201003'">2050101</xsl:when><!-- 滑雪运动员+++卫生专业技术人员 -->
			<xsl:when test=".='201101'">2050101</xsl:when><!-- 教练员+++卫生专业技术人员 -->
			<xsl:when test=".='201102'">2050101</xsl:when><!-- 运动员+++卫生专业技术人员 -->
			<xsl:when test=".='201201'">2050101</xsl:when><!-- 教练+++卫生专业技术人员 -->
			<xsl:when test=".='201202'">2050101</xsl:when><!-- 马房工人、马夫、练马师+++卫生专业技术人员 -->
			<xsl:when test=".='201203'">2050101</xsl:when><!-- 骑师、见习骑师、参赛骑师+++卫生专业技术人员 -->
			<xsl:when test=".='201301'">2050101</xsl:when><!-- 特技表演人员+++卫生专业技术人员 -->
			<xsl:when test=".='201401'">2050101</xsl:when><!-- 教练+++卫生专业技术人员 -->
			<xsl:when test=".='201402'">2050101</xsl:when><!-- 驾驶人员+++卫生专业技术人员 -->
			<xsl:when test=".='201501'">2050101</xsl:when><!-- 教练+++卫生专业技术人员 -->
			<xsl:when test=".='201502'">2050101</xsl:when><!-- 跳伞人员+++卫生专业技术人员 -->
			<xsl:when test=".='201601'">2050101</xsl:when><!-- 登山运动员+++卫生专业技术人员 -->
			<xsl:when test=".='201602'">2050101</xsl:when><!-- 教练+++卫生专业技术人员 -->
			<xsl:when test=".='201701'">2050101</xsl:when><!-- 赛车人员+++卫生专业技术人员 -->
			<xsl:when test=".='201702'">2050101</xsl:when><!-- 教练+++卫生专业技术人员 -->
			<xsl:when test=".='210101'">2080103</xsl:when><!-- 公、检、法、工商、税务、卫生+++法律专业人员 -->
			<xsl:when test=".='210201'">4030111</xsl:when><!-- 厂长+++国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test=".='210202'">4030111</xsl:when><!-- 经理+++国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test=".='210302'">4010101</xsl:when><!-- 无固定职业人员+++商业、服务业人员 -->
			<xsl:when test=".='210401'">8010101</xsl:when><!-- 学龄前儿童+++无业 -->
			<xsl:when test=".='210402'">8010101</xsl:when><!-- 离退休人员(无兼职)+++无业 -->
			<xsl:when test=".='210403'">8010101</xsl:when><!-- 其他人员(无兼职)+++无业 -->
			<xsl:when test=".='210501'">7010103</xsl:when><!-- 一般军人、军校学生（非军事专业）+++军人 -->
			<xsl:when test=".='210502'">7010103</xsl:when><!-- 行政及内勤人员+++军人 -->
			<xsl:when test=".='210503'">7010103</xsl:when><!-- 后勤补给及通讯、地勤人员+++军人 -->
			<xsl:when test=".='210504'">7010103</xsl:when><!-- 军医院官兵+++军人 -->
			<xsl:when test=".='210505'">7010103</xsl:when><!-- 军事研究单位设计人员+++军人 -->
			<xsl:when test=".='210506'">7010103</xsl:when><!-- 军事单位武器弹药研究、制作人员+++军人 -->
			<xsl:when test=".='210507'">7010103</xsl:when><!-- 伞兵部队+++军人 -->
			<xsl:when test=".='210508'">7010103</xsl:when><!-- 航空试飞人员+++军人 -->
			<xsl:when test=".='210509'">7010103</xsl:when><!-- 一般地面部队人员+++军人 -->
			<xsl:when test=".='210510'">7010103</xsl:when><!-- 特种兵+++军人 -->
			<xsl:when test=".='210511'">7010103</xsl:when><!-- 空军、海军、潜艇军人+++军人 -->
			<xsl:when test=".='210512'">7010103</xsl:when><!-- 军校学生（军事专业）及新兵+++军人 -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
