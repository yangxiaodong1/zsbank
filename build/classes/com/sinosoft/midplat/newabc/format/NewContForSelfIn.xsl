<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />

			<!-- 报文体 -->
			<xsl:apply-templates select="App/Req" />

		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template match="Header">
		<!--基本信息-->
		<Head>
			<typeEdit>225</typeEdit>
			<!-- 银行交易日期 -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- 交易时间 农行不传交易时间 取系统当前时间 -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- 柜员代码 -->
			<TellerNo>
			    <xsl:if test="Tlid =''">sys</xsl:if>
			    <xsl:if test="Tlid !=''"><xsl:value-of select="Tlid" /></xsl:if>
			</TellerNo>
			<!-- 银行交易流水号 -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- 地区码+网点码 -->
			<NodeNo>
				<xsl:value-of select="ProvCode" />
				<xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>
				<xsl:apply-templates select="EntrustWay" />
			</SourceType>
			<!-- YBT组织的节点信息 -->
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!--报文体信息-->
	<xsl:template match="App/Req">
		<Body>
			<!-- 投保基本信息 -->
			<xsl:apply-templates select="Base" />
			<!-- 试算申请顺序号 -->
			<OldLogNo>
				<xsl:value-of select="AppNo" />
			</OldLogNo>
			<!-- 保单递送方式 -->
			<GetPolMode></GetPolMode>
			<!-- 职业告知(N/Y) -->
			<JobNotice>
				<xsl:apply-templates select="Insu/IsRiskJob" />
			</JobNotice>
			<!-- 健康告知(N/Y)  -->
			<HealthNotice>
				<xsl:apply-templates select="Insu/HealthNotice" />
			</HealthNotice>
			<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
			<PolicyIndicator></PolicyIndicator>
			<!--累计投保身故保额-->
			<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
			<!-- 产品组合 -->
			<ContPlan>
				<!-- 产品组合编码 -->
				<ContPlanCode>
					<xsl:apply-templates select="Risks/RiskCode" mode="contplan"/>
				</ContPlanCode>
			</ContPlan>
			<!-- 保单递送类型1、纸制保单2、电子保单 -->
			<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
			
			<!-- 投保人 -->
			<xsl:apply-templates select="Appl" />
			<!-- 被保人 -->
			<xsl:apply-templates select="Insu" />
			<!-- 受益人 -->
			<xsl:apply-templates select="Bnfs" />
			<!-- 险种信息 -->
			<xsl:apply-templates select="Risks" />
		</Body>
	</xsl:template>

	<!--投保基本信息-->
	<xsl:template match="Base">
        <!-- 投保单(印刷)号 -->
		<ProposalPrtNo>
		    <xsl:value-of select ="PolicyApplySerial"/>
		</ProposalPrtNo> 
		<!-- 保单合同印刷号 -->
        <ContPrtNo>
            <xsl:value-of select="VchNo"/>
        </ContPrtNo> 
        <!-- 投保日期 -->
        <PolApplyDate>
            <xsl:value-of select ="ApplyDate"/>
        </PolApplyDate> 
        <!-- 账户姓名 -->
        <AccName>
        </AccName> 
        <!-- 银行账户 -->
        <AccNo>
        </AccNo>
		<!--出单网点资格证-->
    	<AgentComCertiCode>
    		<xsl:value-of select="BranchCertNo" />
    	</AgentComCertiCode>
    	<!--出单网点名称-->
    	<AgentComName>
    		<xsl:value-of select="BranchName" />
    	</AgentComName>
    	<!--出单柜员姓名-->
    	<TellerName>
    		<xsl:value-of select="Saler" />
    	</TellerName>
    	<!--柜员资格证-->
    	<TellerCertiCode>
    		<xsl:value-of select="SalerCertNo" />
    	</TellerCertiCode>		
	</xsl:template>
	
	<!--投保人信息-->
	<xsl:template match="Appl">
		<Appnt>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- 证件有效起期 -->
			<IDTypeStartDate></IDTypeStartDate>
			<!-- 证件有效止期yyyyMMdd -->
			<IDTypeEndDate>
				<xsl:value-of select="InvalidDate" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode><xsl:apply-templates select="JobType" /></JobCode>
			<!-- 投保人年收入 -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AnnualIncome)" />
			</Salary>
			<!-- 投保人家庭年收入-->
			<FamilySalary></FamilySalary>
			<!-- 投保人所属区域-->
			<LiveZone>
				<xsl:apply-templates select="CustSource" />
			</LiveZone>
			<!-- 国籍 -->
			<!-- 因农行网银银行端不传国家过来，导致业务出单受限，所以调整为依据证件类型进行国家映射，参见jira：PBKINSR-1065 寿险农行网银系统证件类型转换国籍规则变更 -->
			<Nationality>
				<xsl:call-template name="tran_IDType2Country">
		          <xsl:with-param name="iDType" select="IDKind" />
	      		</xsl:call-template>
			</Nationality>
			<!-- 身高(cm) -->
			<Stature></Stature>
			<!-- 体重(g) -->
			<Weight></Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- 电子邮件-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:apply-templates select="RelaToInsured" />
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!--被保人信息-->
	<xsl:template match="Insu">
		<Insured>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- 证件有效起期 -->
			<IDTypeStartDate></IDTypeStartDate>
			<!-- 证件有效止期 -->
			<IDTypeEndDate>
				<xsl:value-of select="ValidDate" />
			</IDTypeEndDate>
			<!-- 职业代码 -->
			<JobCode><xsl:apply-templates select="JobType" /></JobCode>
			<!-- 身高(cm)-->
			<Stature><xsl:value-of select="Tall" /></Stature>
			<!-- 国籍 -->
			<!-- 因农行网银银行端不传国家过来，导致业务出单受限，所以调整为依据证件类型进行国家映射，参见jira：PBKINSR-1065 寿险农行网银系统证件类型转换国籍规则变更 -->
			<Nationality>
				<!--
				<xsl:apply-templates select="Country" />
				-->
				<xsl:call-template name="tran_IDType2Country">
					<xsl:with-param name="iDType" select="IDKind" />
				</xsl:call-template>
			</Nationality>
			<!-- 体重(kg) -->
			<Weight><xsl:value-of select="Weight" /></Weight>
			<!-- 婚否(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- 联系地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 手机号 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- 电话号 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- 电子邮箱 -->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
		</Insured>
	</xsl:template>

	<!--受益人-->
	<xsl:template match="Bnfs">
		<Count>
			<xsl:value-of select="Count" />
		</Count>
		<xsl:for-each select="Bnf">
			<!-- 受益人 -->
			<Bnf>
				<!-- 受益人类型 1-死亡受益人 -->
				<Type>1</Type>
				<!-- 受益人顺位 -->
				<Grade>
					<xsl:value-of select="Sequence" />
				</Grade>
				<!-- 受益比例 -->
				<Lot>
					<xsl:value-of select="Prop" />
				</Lot>
				<!-- 受益人姓名 -->
				<Name>
					<xsl:value-of select="Name" />
				</Name>
				<!-- 受益人性别 -->
				<Sex>
					<xsl:value-of select="Sex" />
				</Sex>
				<!-- 受益人生日 -->
				<Birthday>
					<xsl:value-of select="Birthday" />
				</Birthday>
				<!-- 受益人证件类型 -->
				<IDType>
					<xsl:apply-templates select="IDKind" />
				</IDType>
				<!-- 受益人证件编号 -->
				<IDNo>
					<xsl:value-of select="IDCode" />
				</IDNo>
				<!-- 受益人与被保险人关系 -->
				<RelaToInsured>
					<xsl:apply-templates select="RelaToInsured" />
				</RelaToInsured>
			</Bnf>
		</xsl:for-each>
	</xsl:template>

	<!--险种信息-->
	<xsl:template match="Risks">
		<!-- 险种 -->
		<Risk>
			<!-- 险种号 -->
			<RiskCode>
				<xsl:apply-templates select="RiskCode"  mode="risk"/>
			</RiskCode>
			<!-- 主险号 -->
			<MainRiskCode>
				<xsl:apply-templates select="RiskCode"  mode="risk"/>
			</MainRiskCode>
			<!-- 保额（农行元） -->
			<!-- 农行网银产品是按照保费销售的、保额值应为0，但是银行保额传值过来导致核心试算失败，所以此处赞不取银行保额值，将来如果上线按保额销售的产，这块调整将会存在风险，必须对所有产品进行测试。 -->
			<Amnt></Amnt>
			<!-- 保费（农行元） -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" />
			</Prem>
			<!-- 份数 -->
			<Mult>
				<xsl:value-of select="Share" />
			</Mult>
			<!-- 缴费频率 -->
			<PayIntv>
				<xsl:apply-templates select="PayType" />
			</PayIntv>
			<PayMode></PayMode>
			
			<xsl:choose>
				<!-- 保终身 -->
				<xsl:when
					test="InsuDueType='6'">
					<InsuYearFlag>A</InsuYearFlag>
					<InsuYear>106</InsuYear>
				</xsl:when>
				<xsl:otherwise>
					<!--  保险年期/年龄标志  -->
					<InsuYearFlag>
						<xsl:apply-templates
							select="InsuDueType" />
					</InsuYearFlag>
					<!--  保险年期  -->
					<InsuYear>
						<xsl:value-of select="InsuDueDate" />
					</InsuYear>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<!-- 趸交 -->
				<xsl:when test="PayType = '1'">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise><!-- 其他 -->
					<!--  交费年期/年龄类型  -->
					<PayEndYearFlag>
						<xsl:apply-templates
							select="PayDueType" />
					</PayEndYearFlag>
					<!--  交费年期/年龄  -->
					<PayEndYear>
						<xsl:value-of
							select="PayDueDate" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 领取年龄年期标志 -->
			<GetYearFlag>
				<xsl:apply-templates select="FullBonusGetMode" />
			</GetYearFlag>
			<!-- 领取年龄 -->
			<GetYear>
				<xsl:value-of select="GetYear" />
			</GetYear>
			<!-- 领取频率 -->
			<GetIntv>
				<xsl:apply-templates select="GetYearFlag" />
			</GetIntv>
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag>
			<!-- 处理农行红利领取方式 -->
			<BonusGetMode>
				<xsl:apply-templates select="BonusGetMode" />
			</BonusGetMode>
			<!-- 满期领取方式 -->
			<FullBonusGetMode></FullBonusGetMode>
		</Risk>
	</xsl:template>

	<!-- 保险年期年龄类型 -->
	<xsl:template match="InsuDueType">
		<xsl:choose>
			<xsl:when test=".='1'">D</xsl:when><!-- 日 -->
			<xsl:when test=".='2'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='4'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='5'">A</xsl:when><!-- 年龄 -->
			<xsl:when test=".='6'">A</xsl:when><!-- 终身 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- 缴费年期年龄类型 -->
	<xsl:template  match="PayDueType">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- 年龄 -->
			<xsl:when test=".='2'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='3'">D</xsl:when><!-- 日 -->
			<xsl:when test=".='4'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='5'">A</xsl:when><!-- 年 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取年期年龄类型 -->
	<xsl:template  match="GetYearFlag">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 趸领 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 季领 -->
			<xsl:when test=".='3'">6</xsl:when><!-- 半年领 -->
			<xsl:when test=".='4'">12</xsl:when><!-- 年领 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<!--领取年龄年期标志 -->
	<xsl:template  match="FullBonusGetMode">
		<xsl:choose>
			<xsl:when test=".='0'">Y</xsl:when><!-- 按年 -->
			<xsl:when test=".='1'">A</xsl:when><!-- 按年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- 缴费方式（频次） -->
	<xsl:template match="PayType">
		<xsl:choose>
		    <xsl:when test=".='0'">-1</xsl:when><!--  不定期 -->
			<xsl:when test=".='1'">0</xsl:when><!-- 趸交 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 月交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交 -->
			<xsl:when test=".='4'">6</xsl:when><!-- 半年交 -->
			<xsl:when test=".='5'">12</xsl:when><!-- 年交 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- 证件类型 -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='110001'">0</xsl:when><!--居民身份证                -->
			<xsl:when test=".='110002'">0</xsl:when><!--重号居民身份证            -->
			<xsl:when test=".='110003'">0</xsl:when><!--临时居民身份证            -->
			<xsl:when test=".='110004'">0</xsl:when><!--重号临时居民身份证        -->
			<xsl:when test=".='110005'">5</xsl:when><!--户口簿                    -->
			<xsl:when test=".='110006'">5</xsl:when><!--重号户口簿                -->			
			<xsl:when test=".='110023'">1</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test=".='110024'">1</xsl:when><!--重号中华人民共和国护照    -->
			<xsl:when test=".='110025'">1</xsl:when><!--外国护照                  -->
			<xsl:when test=".='110026'">1</xsl:when><!--重号外国护照              -->
			<xsl:when test=".='110027'">2</xsl:when><!--军官证                    -->
			<xsl:when test=".='110028'">2</xsl:when><!--重号军官证                -->
			<xsl:when test=".='110029'">2</xsl:when><!--文职干部证                -->
			<xsl:when test=".='110030'">2</xsl:when><!--重号文职干部证            -->
            <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
    <!-- 职业 -->
	<xsl:template match="JobType">
		<xsl:choose>
			<xsl:when test=".='01'">9210103</xsl:when><!--从事农业，牧业，钢铁业，塑胶业，装璜业，修理业，家俱制造业，出租车服务业的人员                -->
			<xsl:when test=".='02'">9210101</xsl:when><!--机关团体，事业单位的工作人员以及所有文职人员            -->
			<xsl:when test=".='03'">9210101</xsl:when><!--机关团体，事业单位的工作人员以及所有文职人员            -->
			<xsl:when test=".='04'">9210101</xsl:when><!--机关团体，事业单位的工作人员以及所有文职人员        -->
			<xsl:when test=".='05'">9210105</xsl:when><!--                    -->
			<xsl:when test=".='06'">9210102</xsl:when><!--                -->			
			<xsl:when test=".='07'">9210107</xsl:when><!--        -->			
		</xsl:choose>
	</xsl:template>
    
	<!-- 关系 -->
	<xsl:template match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='01'">00</xsl:when><!-- 本人 -->
			<xsl:when test=".='02'">02</xsl:when><!-- 配偶 -->
			<xsl:when test=".='03'">02</xsl:when><!-- 配偶 -->
			<xsl:when test=".='04'">01</xsl:when><!-- 父母 -->
			<xsl:when test=".='05'">01</xsl:when><!-- 父母 -->
			<xsl:when test=".='06'">03</xsl:when><!-- 儿女 -->
			<xsl:when test=".='07'">03</xsl:when><!-- 儿女 -->
			<xsl:otherwise>04</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 国籍转换 -->
	
	<xsl:template match="Country">
		<xsl:choose>
			<xsl:when test=".='156'">CHN</xsl:when><!-- 中國 -->
			<xsl:when test=".='344'">CHN</xsl:when><!-- 中國香港 -->
			<xsl:when test=".='158'">CHN</xsl:when><!-- 中國臺灣 -->
			<xsl:when test=".='446'">CHN</xsl:when><!-- 中國澳门 -->
			<xsl:when test=".='392'">JP</xsl:when><!-- 日本 -->
			<xsl:when test=".='840'">US</xsl:when><!-- 美国 -->
			<xsl:when test=".='643'">RU</xsl:when><!-- 俄罗斯 -->
			<xsl:when test=".='826'">GB</xsl:when><!-- 英国 -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 国籍转换 -->
	<!-- 因农行网银银行端不传国家过来，导致业务出单受限，所以调整为依据证件类型进行国家映射，参见jira：PBKINSR-1065 寿险农行网银系统证件类型转换国籍规则变更 -->
	<xsl:template name="tran_IDType2Country">
		<xsl:param name="iDType" />
		<xsl:choose>
			<xsl:when test="$iDType='110001'">CHN</xsl:when>
			<xsl:when test="$iDType='110002'">CHN</xsl:when>
			<xsl:when test="$iDType='110003'">CHN</xsl:when>
			<xsl:when test="$iDType='110004'">CHN</xsl:when>
			<xsl:when test="$iDType='110005'">CHN</xsl:when>
			<xsl:when test="$iDType='110006'">CHN</xsl:when>
			<xsl:when test="$iDType='110023'">CHN</xsl:when>
			<xsl:when test="$iDType='110024'">CHN</xsl:when>
			<xsl:when test="$iDType='110025'">OTH</xsl:when>
			<xsl:when test="$iDType='110026'">OTH</xsl:when>
			<xsl:when test="$iDType='110027'">CHN</xsl:when>
			<xsl:when test="$iDType='110028'">CHN</xsl:when>
			<xsl:when test="$iDType='110029'">CHN</xsl:when>
			<xsl:when test="$iDType='110030'">CHN</xsl:when>
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--健康情况 -->
	<xsl:template match="HealthNotice">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when><!-- 否 -->
			<xsl:when test=".='1'">Y</xsl:when><!-- 是 -->
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--职业告知 -->
	<xsl:template match="IsRiskJob">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when><!-- 否 -->
			<xsl:when test=".='1'">Y</xsl:when><!-- 是 -->
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--客户来源 -->
	<xsl:template match="CustSource">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 农村 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<!-- 盛世3号产品代码变更start -->
			<!-- <xsl:when test=".='L12078'">L12078</xsl:when> --><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型） -->
			<xsl:when test=".='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险组合计划 -->
			<!-- guning -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型） -->
			<!-- guning -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template  match="RiskCode"  mode="contplan">
		<xsl:choose>
            <xsl:when test=".='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险组合计划-->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<!-- 红利领取方式-->
	<xsl:template match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='2'">1</xsl:when><!-- 累积生息 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".=''"></xsl:when><!-- 默认 -->
			<xsl:otherwise>9</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<!-- 银行保单销售渠道: 0=柜面，1=网银-->
	<xsl:template match="EntrustWay">
		<xsl:choose>
			<xsl:when test=".='11'">0</xsl:when><!--银保通柜面 -->
			<xsl:when test=".='01'">1</xsl:when><!--网银 -->
			<xsl:when test=".='04'">8</xsl:when><!-- 自助终端 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>