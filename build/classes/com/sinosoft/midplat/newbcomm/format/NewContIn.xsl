<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="BusDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BrchId" /><xsl:value-of select="SubBrchId" />
			</NodeNo>
			<SourceType>
				<xsl:apply-templates select="ChanNo" />
			</SourceType>	
			<BankCode><xsl:value-of select="../TranCom/@outcode"/></BankCode>		
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Body">
	
		 <xsl:variable name="MainRisk" select="PrdList/PrdItem[IsMain=1]" />
		
		 <ProposalPrtNo><xsl:value-of select="PolItem/AppPrintNo" /></ProposalPrtNo>
		 <ContPrtNo></ContPrtNo>
		 <PolApplyDate><xsl:value-of select="../Head/Sender/TrDate" /></PolApplyDate>
		 <AccName></AccName>
		 <AccNo></AccNo>
		 <!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
		 <GetPolMode><xsl:apply-templates select="PolItem/Deliver" /></GetPolMode>
		 <!-- 保单递送类型1、纸制保单2、电子保单 -->
		 <PolicyDeliveryMethod>1</PolicyDeliveryMethod>
		 <!-- 职业告知 -->
		 <JobNotice><xsl:apply-templates select="PolItem/IsWorkTell" /></JobNotice>
		 <!-- 健康告知 -->
		 <HealthNotice><xsl:apply-templates select="PolItem/IsHealthTell" /></HealthNotice>
		 <PolicyIndicator></PolicyIndicator>
		 <InsuredTotalFaceAmount></InsuredTotalFaceAmount> 
		 <!-- 产品组合 -->
		 <ContPlan>
			<!-- 产品组合编码 -->
			<ContPlanCode><xsl:apply-templates select="$MainRisk/PrdId"  mode="contplan"/></ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult><xsl:value-of select="$MainRisk/Units" /></ContPlanMult>
		 </ContPlan>
		 <!--出单网点名称-->
		 <AgentComName></AgentComName>
		 <AgentComCertiCode>
		    <xsl:value-of select="PolItem/SubBrchCertNo" />
		 </AgentComCertiCode>
		 <!--银行销售人员工号及银行销售人员名称：
		 		首先判断银行推荐人员（IntrNo、IntrName）是否有值，如果有则取该值，如果银行推荐人员没有值，则取银行销售人员的值（SellNo、SellName）-->
		 <xsl:choose>
			<xsl:when test="PolItem/IntrNo!=''">
				<TellerName><xsl:value-of select="PolItem/IntrName" /></TellerName>
		 		<SellerNo><xsl:value-of select="PolItem/IntrNo" /></SellerNo>
			</xsl:when>
			<xsl:otherwise>
				<TellerName><xsl:value-of select="PolItem/SellName" /></TellerName>
		 		<SellerNo><xsl:value-of select="PolItem/SellNo" /></SellerNo>
			</xsl:otherwise>
		</xsl:choose>		 
		 <TellerCertiCode>
		  	<xsl:value-of select="PolItem/SellCertNo" />
		 </TellerCertiCode>
		 <TellerEmail></TellerEmail>	  
		  
		<!-- 投保人 -->
		<Appnt>
			<xsl:apply-templates select="AppItem" />
		</Appnt>
		<!-- 被保人 -->
		<Insured>
			<xsl:apply-templates select="InsList/InsItem" />
		</Insured>
		<!-- 受益人 -->
		<!-- BenListIsLegal=1为法定受益人 -->
		<xsl:if test="InsList/InsItem/BenTypeList/BenTypeItem[IsLegal=0]/BenItem!=''">
			<xsl:apply-templates select="InsList/InsItem/BenTypeList/BenTypeItem[IsLegal=0]/BenItem" /> 
		</xsl:if>
		
		<!-- 险种信息 -->
		<xsl:for-each select="PrdList/PrdItem">
			<Risk>
				<!-- 险种代码 -->
				<RiskCode><xsl:apply-templates select="PrdId"  mode="risk"/></RiskCode>
				<!-- 主险险种代码 -->
				<xsl:choose>
					<xsl:when test="IsMain='1'">
						<MainRiskCode><xsl:apply-templates select="PrdId"  mode="risk"/></MainRiskCode>
					</xsl:when>
					<xsl:otherwise>
						<MainRiskCode><xsl:apply-templates select="../PrdItem[IsMain='1']/PrdId"  mode="risk"/></MainRiskCode>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 保额 -->
				<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CovAmt)" /></Amnt>
				<!-- 保费  -->
				<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PremAmt)" /></Prem>
				<!-- 投保份数 -->
				<Mult><xsl:value-of select="Units" /></Mult>
				<PayMode></PayMode> <!-- 缴费形式 -->
				<PayIntv><xsl:apply-templates select="PremType" /></PayIntv> <!-- 缴费频次 --> 
				<xsl:choose>
					<!-- 保终身 -->
					<xsl:when test="CovTermType='01'">
						<InsuYearFlag>A</InsuYearFlag>
						<InsuYear>106</InsuYear>
					</xsl:when>
					<xsl:otherwise>
						<!--  保险年期/年龄标志  -->
						<InsuYearFlag><xsl:apply-templates select="CovTermType" /></InsuYearFlag>
						<!--  保险年期  -->
						<InsuYear><xsl:value-of select="CovTerm" /></InsuYear>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<!-- 趸交 -->
					<xsl:when test="PremTermType='01'">
						<PayEndYearFlag>Y</PayEndYearFlag>
						<PayEndYear>1000</PayEndYear>
					</xsl:when>
					<!-- 终身 -->
					<xsl:when test="PremTermType='04'">
						<PayEndYearFlag>A</PayEndYearFlag>
						<PayEndYear>106</PayEndYear>
					</xsl:when>
					<xsl:otherwise><!-- 其他 -->
						<!--  交费年期/年龄类型  -->
						<PayEndYearFlag>
							<xsl:apply-templates select="PremTermType" />
						</PayEndYearFlag>
						<!--  交费年期/年龄  -->
						<PayEndYear>
							<xsl:value-of select="PremTerm" />
						</PayEndYear>
					</xsl:otherwise>
				</xsl:choose>
				<BonusGetMode></BonusGetMode> <!-- 红利领取方式 -->
				<FullBonusGetMode></FullBonusGetMode> <!-- 满期领取金领取方式 -->
			    <GetYearFlag></GetYearFlag> <!-- 领取年龄年期标志 -->
			    <GetYear></GetYear> <!-- 领取年龄 -->		
			    <GetIntv></GetIntv> <!-- 领取方式 -->				
			    <GetBankCode></GetBankCode> <!-- 领取银行编码 -->
			    <GetBankAccNo></GetBankAccNo> <!-- 领取银行账户 -->
				<GetAccName></GetAccName> <!-- 领取银行户名 -->
				<AutoPayFlag>0</AutoPayFlag> <!-- 自动垫交标志 -->			
              </Risk>
		</xsl:for-each>		
	</xsl:template>
	
	
	<!-- 固定电话项 -->
	<xsl:template name="PhoneItem" match="PhoneItem" >
		<xsl:choose>
			<xsl:when test="Extension=''">
				<xsl:value-of select="Section" /><xsl:value-of select="Phone" /><xsl:value-of select="Extension" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="Section" /><xsl:value-of select="Phone" /><xsl:value-of select="Extension" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<!-- 投保人 -->
	<xsl:template name="AppItem" match="AppItem">
		<!-- 投保人姓名 -->
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- 性别 -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- 出生日期[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		<!-- 证件类型[参考5.5] -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		<!-- 证件号码 -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- 证件有效起期 -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- 证件有效止期 -->
		<JobCode><xsl:apply-templates select="CusItem/Work" /></JobCode> <!-- 职业代码（待映射） -->
		<!-- 投保人年收入 单位分，银行万元 -->
		<Salary>
			<xsl:choose>
				<xsl:when test="YearIncome=''">
					<xsl:value-of select="YearIncome" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(YearIncome)*1000000"/>
				</xsl:otherwise>
			</xsl:choose>
		</Salary>
		<!-- 投保人家庭收入 单位分，银行万元 -->
		<FamilySalary>
			<xsl:choose>
				<xsl:when test="HomeYearIncome=''">
					<xsl:value-of select="HomeYearIncome" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(HomeYearIncome)*1000000"/>
				</xsl:otherwise>
			</xsl:choose>
		</FamilySalary>
		<!-- 居住地区 城镇1/农村2 -->
		<LiveZone>
			<xsl:apply-templates select="DenizenOrigin" />
		</LiveZone>  
		<RiskAssess><xsl:apply-templates select="IsRiskEval" /></RiskAssess><!--风险测评结果是否适合投保，保监会3号文增加该字段。Y是N否-->
		<!-- 国籍 -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<Stature><xsl:value-of select="Stature" /></Stature><!-- 身高(cm)，银行：身高：厘米 -->
    	<Weight><xsl:value-of select="Weight" /></Weight> <!-- 体重(kg) 银行：体重：千克 -->
		<MaritalStatus><xsl:apply-templates select="CusItem/MarStat" /></MaritalStatus> <!-- 婚否(N/Y) -->
		<Company><xsl:value-of select="CusItem/Company" /></Company> <!-- 工作单位--><!--保监会3号文邮储增加该字段-->
		<Province></Province> <!-- 省别 --><!--保监会3号文邮储增加该字段-->
		<City></City> <!-- 市县 --><!--保监会3号文邮储增加该字段-->
    	<Address><xsl:value-of select="CusItem/AddrItem/Province" /><xsl:value-of select="CusItem/AddrItem/City" /><xsl:value-of select="CusItem/AddrItem/County" /><xsl:value-of select="CusItem/AddrItem/AddrDetail" /></Address> <!-- 地址 -->		
		<!-- 邮编 -->
		<ZipCode>
			<xsl:value-of select="CusItem/AddrItem/Post" />
		</ZipCode>
		<!-- 移动电话 -->
		<Mobile>
			<xsl:value-of select="CusItem/MobileItem/Mobile" />
		</Mobile>
		<!-- 固定电话 -->
		<Phone>
			<xsl:apply-templates select="CusItem/PhoneItem" />
		</Phone>
		<!-- email -->
		<Email>
			<xsl:value-of select="CusItem/EmailItem/Email" />
		</Email>
		<!-- 与被保人关系：银行表示投保人是被保人的** --> 
		<RelaToInsured>
			<xsl:call-template name="tran_relaCode_ins">
				<xsl:with-param name="relaCode" select="../InsList/InsItem/AppRela" />
			</xsl:call-template>
		</RelaToInsured>
	</xsl:template>
	
	<!-- 被保人 -->
	<xsl:template name="Ins" match="InsItem">
				
		<!-- 被保人姓名 -->
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- 性别 -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- 出生日期[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		<!-- 证件类型 -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		<!-- 证件号码 -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- 证件有效起期 -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- 证件有效止期 -->
		<JobCode><xsl:apply-templates select="CusItem/Work" /></JobCode> <!-- 职业代码（待映射） -->
		<Stature><xsl:value-of select="Stature" /></Stature><!-- 身高(cm)，银行：身高：厘米 -->
   		<Weight><xsl:value-of select="Weight" /></Weight> <!-- 体重(kg) 银行：体重：千克 -->
		<!-- 国籍 -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<MaritalStatus><xsl:apply-templates select="CusItem/MarStat" /></MaritalStatus> <!-- 婚否(N/Y) -->
		<Company><xsl:value-of select="CusItem/Company" /></Company> <!-- 工作单位--><!--保监会3号文邮储增加该字段-->
		<Province></Province> <!-- 省别 --><!--保监会3号文邮储增加该字段-->
		<City></City> <!-- 市县 --><!--保监会3号文邮储增加该字段-->
    	<Address><xsl:value-of select="CusItem/AddrItem/Province" /><xsl:value-of select="CusItem/AddrItem/City" /><xsl:value-of select="CusItem/AddrItem/County" /><xsl:value-of select="CusItem/AddrItem/AddrDetail" /></Address> <!-- 地址 -->		
		<!-- 邮编 -->
		<ZipCode>
			<xsl:value-of select="CusItem/AddrItem/Post" />
		</ZipCode>
		<!-- 移动电话 -->
		<Mobile>
			<xsl:value-of select="CusItem/MobileItem/Mobile" />
		</Mobile>
		<!-- 固定电话 -->
		<Phone>
			<xsl:apply-templates select="CusItem/PhoneItem" />
		</Phone>
		<!-- email -->
		<Email>
			<xsl:value-of select="CusItem/EmailItem/Email" />
		</Email>	
	</xsl:template>

	<!-- 受益人 -->
	<xsl:template name="BenItem" match="BenItem">
		<Bnf>
		<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
		<Grade><xsl:value-of select="BenOrder" /></Grade> <!-- 受益顺序 -->		
		<!-- 受益人姓名 -->	
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- 性别[参考5.4] -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- 出生日期[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		 <!-- 证件类型[参考5.5] -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		 <!-- 证件号码 -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>			
		<!-- 与被保险人关系[参考5.7],银行：表示受益人是被保人的** -->
		<RelaToInsured>
			<xsl:call-template name="tran_relaCode_ins">
				<xsl:with-param name="relaCode" select="InsRela" />
			</xsl:call-template>
		</RelaToInsured>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- 证件有效起期 -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- 证件有效止期 -->
		<!-- 国籍 -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<!-- 受益比例,银行是：百分比的分子 -->
		<Lot><xsl:value-of select="BenRate" /></Lot>					
		</Bnf>
	</xsl:template>
	<!-- 渠道 -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- 柜面 -->
			<xsl:when test=".=21">1</xsl:when>	<!-- 个人网银 -->
			<xsl:when test=".=51">17</xsl:when>	<!-- 手机银行 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template match="PrdId"  mode="risk">
		<xsl:choose>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 东风五号  -->
			<!--<xsl:when test=".='50012'">50012</xsl:when> --><!--安邦长寿安享5号保险计划-->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<!--<xsl:when test=".='50001'">50001</xsl:when>--><!-- 安邦长寿稳赢1号两全保险  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template  match="PrdId" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='50012'">50012</xsl:when><!--安邦长寿安享5号保险计划-->
			<!-- <xsl:when test=".='50001'">50001</xsl:when>--><!-- 安邦长寿稳赢1号两全保险  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保单递送方式 -->
	<xsl:template name="Deliver" match="Deliver">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>	<!-- 邮寄 -->
			<xsl:when test=".=02"></xsl:when>	<!-- 电子发送 -->
			<xsl:when test=".=03">2</xsl:when>	<!-- 柜面领取 -->
		</xsl:choose>
	</xsl:template>
	<!-- 健康告知 -->
	<xsl:template name="IsHealthTell" match="IsHealthTell">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- 否 -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- 是 -->
		</xsl:choose>
	</xsl:template>
	<!-- 职业告知 -->
	<xsl:template name="IsWorkTell" match="IsWorkTell">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- 否 -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- 是 -->
		</xsl:choose>
	</xsl:template>
	<!-- 性别 -->
	<xsl:template name="Sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when>	<!-- 男 -->
			<xsl:when test=".=02">1</xsl:when>	<!-- 女 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template name="IdType" match="IdType">
		<xsl:choose>
			<xsl:when test=".='0101'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0102'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0200'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0300'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test=".='0301'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='0400'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test=".='0601'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0604'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0700'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0701'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0800'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='1000'">1</xsl:when> <!-- 护照 -->
			<xsl:when test=".='1202'">1</xsl:when> <!-- 护照 -->
			<xsl:when test=".='1100'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1110'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1111'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1112'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1113'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1114'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1120'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1121'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test=".='1122'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test=".='1123'">7</xsl:when> <!-- 台湾居民来往大陆通行证 -->
			<xsl:when test=".='1300'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='9999'">8</xsl:when> <!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 居民来源 城镇1/农村2 -->
	<xsl:template name="DenizenOrigin" match="DenizenOrigin">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>	<!-- 城镇 -->
			<xsl:when test=".=02">2</xsl:when>	<!-- 农村 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 是否已风险评估 -->
	<xsl:template name="IsRiskEval" match="IsRiskEval">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- 否 -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- 是 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 国籍 -->
	<xsl:template name="Country" match="Country">
		<xsl:choose>
			<xsl:when test=".='ABW'">AW</xsl:when> <!-- 阿鲁巴       -->
			<xsl:when test=".='AFG'">AF</xsl:when> <!-- 阿富汗       -->
			<xsl:when test=".='AGO'">AO</xsl:when> <!-- 安哥拉       -->
			<xsl:when test=".='AIA'">AI</xsl:when> <!-- 安圭拉       -->
			<xsl:when test=".='ALB'">AL</xsl:when> <!-- 阿尔巴尼亚   -->
			<xsl:when test=".='AND'">AD</xsl:when> <!-- 安道尔       -->
			<xsl:when test=".='ANT'">AN</xsl:when> <!-- 荷属安第刑斯 -->
			<xsl:when test=".='ARE'">AE</xsl:when> <!-- 阿联酋       -->
			<xsl:when test=".='ARG'">AR</xsl:when> <!-- 阿根廷       -->
			<xsl:when test=".='ARM'">AM</xsl:when> <!-- 阿美尼亚     -->
			<xsl:when test=".='ASM'">AS</xsl:when> <!-- 东萨摩亚     -->
			<xsl:when test=".='ATA'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='ATG'">AG</xsl:when> <!-- 安提瓜和巴布 -->
			<xsl:when test=".='AUS'">AU</xsl:when> <!-- 澳大利亚     -->
			<xsl:when test=".='AUT'">AT</xsl:when> <!-- 奥地利       -->
			<xsl:when test=".='AZE'">AZ</xsl:when> <!-- 阿塞拜疆     -->
			<xsl:when test=".='BDI'">BI</xsl:when> <!-- 布隆迪       -->
			<xsl:when test=".='BEL'">BE</xsl:when> <!-- 比利时       -->
			<xsl:when test=".='BEN'">BJ</xsl:when> <!-- 贝宁         -->
			<xsl:when test=".='BFA'">BF</xsl:when> <!-- 布基纳法索   -->
			<xsl:when test=".='BGD'">BD</xsl:when> <!-- 孟加拉       -->
			<xsl:when test=".='BGR'">BG</xsl:when> <!-- 保加利亚     -->
			<xsl:when test=".='BHR'">BH</xsl:when> <!-- 巴林         -->
			<xsl:when test=".='BHS'">BS</xsl:when> <!-- 巴哈马       -->
			<xsl:when test=".='BIH'">BA</xsl:when> <!-- 波斯尼亚－黑 -->
			<xsl:when test=".='BLR'">BY</xsl:when> <!-- 白俄罗斯     -->
			<xsl:when test=".='BLZ'">BZ</xsl:when> <!-- 伯利兹       -->
			<xsl:when test=".='BMU'">BM</xsl:when> <!-- 百慕大       -->
			<xsl:when test=".='BOL'">BO</xsl:when> <!-- 玻利维亚     -->
			<xsl:when test=".='BRA'">BR</xsl:when> <!-- 巴西         -->
			<xsl:when test=".='BRB'">BB</xsl:when> <!-- 巴巴多期     -->
			<xsl:when test=".='BRN'">BN</xsl:when> <!-- 文莱         -->
			<xsl:when test=".='BTN'">BT</xsl:when> <!-- 布丹         -->
			<xsl:when test=".='BVT'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='BWA'">BW</xsl:when> <!-- 博茨瓦纳     -->
			<xsl:when test=".='CAF'">CF</xsl:when> <!-- 中非共和国   -->
			<xsl:when test=".='CAN'">CA</xsl:when> <!-- 加拿大       -->
			<xsl:when test=".='CCK'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='CHE'">CH</xsl:when> <!-- 瑞士         -->
			<xsl:when test=".='CHL'">CL</xsl:when> <!-- 智利         -->
			<xsl:when test=".='CHN'">CHN</xsl:when> <!--  中国        -->
			<xsl:when test=".='CIV'">CI</xsl:when> <!-- 科特迪亚     -->
			<xsl:when test=".='CMR'">CM</xsl:when> <!-- 喀麦隆       -->
			<xsl:when test=".='COD'">CG</xsl:when> <!-- 刚果（金）   -->
			<xsl:when test=".='COG'">ZR</xsl:when> <!-- 刚果（布）   -->
			<xsl:when test=".='COK'">CK</xsl:when> <!-- 库克群岛     -->
			<xsl:when test=".='COL'">CO</xsl:when> <!-- 哥伦比亚     -->
			<xsl:when test=".='COM'">KM</xsl:when> <!-- 科摩罗群岛   -->
			<xsl:when test=".='CPV'">CV</xsl:when> <!-- 佛得角群岛   -->
			<xsl:when test=".='CRI'">CR</xsl:when> <!-- 哥斯达黎加   -->
			<xsl:when test=".='CUB'">CU</xsl:when> <!-- 古巴         -->
			<xsl:when test=".='CXR'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='CYM'">KY</xsl:when> <!-- 开曼群岛     -->
			<xsl:when test=".='CYP'">CY</xsl:when> <!-- 塞浦路斯     -->
			<xsl:when test=".='CZE'">CZ</xsl:when> <!-- 捷克共和国   -->
			<xsl:when test=".='DEU'">DE</xsl:when> <!-- 德国         -->
			<xsl:when test=".='DJI'">DJ</xsl:when> <!-- 吉布提       -->
			<xsl:when test=".='DMA'">DM</xsl:when> <!-- 多米尼加联邦 -->
			<xsl:when test=".='DNK'">DK</xsl:when> <!-- 丹麦         -->
			<xsl:when test=".='DOM'">DO</xsl:when> <!-- 多米尼加共和 -->
			<xsl:when test=".='DZA'">DZ</xsl:when> <!-- 阿尔及尼亚   -->
			<xsl:when test=".='ECU'">EC</xsl:when> <!-- 厄瓜多尔     -->
			<xsl:when test=".='EGY'">EG</xsl:when> <!-- 埃及         -->
			<xsl:when test=".='ERI'">ER</xsl:when> <!-- 厄立特里亚   -->
			<xsl:when test=".='ESH'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='ESP'">ES</xsl:when> <!-- 西班牙       -->
			<xsl:when test=".='EST'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='ETH'">ET</xsl:when> <!-- 埃塞俄比亚   -->
			<xsl:when test=".='FIN'">FI</xsl:when> <!-- 芬兰         -->
			<xsl:when test=".='FJI'">FJ</xsl:when> <!-- 斐济         -->
			<xsl:when test=".='FLK'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='FRA'">FR</xsl:when> <!-- 法国         -->
			<xsl:when test=".='FSM'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='GAB'">GA</xsl:when> <!-- 加蓬         -->
			<xsl:when test=".='GBR'">GB</xsl:when> <!-- 英国         -->
			<xsl:when test=".='GEO'">GE</xsl:when> <!-- 格鲁吉亚     -->
			<xsl:when test=".='GHA'">GH</xsl:when> <!-- 加纳         -->
			<xsl:when test=".='GIB'">GI</xsl:when> <!-- 直布罗陀     -->
			<xsl:when test=".='GIN'">GN</xsl:when> <!-- 几内亚       -->
			<xsl:when test=".='GLP'">GP</xsl:when> <!-- 瓜德罗普     -->
			<xsl:when test=".='GMB'">GM</xsl:when> <!-- 冈比亚       -->
			<xsl:when test=".='GNB'">GW</xsl:when> <!-- 几内亚比绍   -->
			<xsl:when test=".='GNQ'">GQ</xsl:when> <!-- 赤道几内亚   -->
			<xsl:when test=".='GRC'">GR</xsl:when> <!-- 希腊         -->
			<xsl:when test=".='GRD'">GD</xsl:when> <!-- 格林纳达     -->
			<xsl:when test=".='GRL'">GL</xsl:when> <!-- 格林兰岛     -->
			<xsl:when test=".='GTM'">GT</xsl:when> <!-- 危地马拉     -->
			<xsl:when test=".='GUF'">GF</xsl:when> <!-- 法属圭亚那   -->
			<xsl:when test=".='GUM'">GU</xsl:when> <!-- 关岛         -->
			<xsl:when test=".='GUY'">GY</xsl:when> <!-- 圭亚那       -->
			<xsl:when test=".='HKG'">CHN</xsl:when> <!--  中国        -->
			<xsl:when test=".='HMD'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='HND'">HN</xsl:when> <!-- 洪都拉斯     -->
			<xsl:when test=".='HRV'">HR</xsl:when> <!-- 克罗地亚     -->
			<xsl:when test=".='HTI'">HT</xsl:when> <!-- 海地         -->
			<xsl:when test=".='HUN'">HU</xsl:when> <!-- 匈牙利       -->
			<xsl:when test=".='IDN'">ID</xsl:when> <!-- 印度尼西亚   -->
			<xsl:when test=".='IND'">IN</xsl:when> <!-- 印度         -->
			<xsl:when test=".='IOT'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='IRL'">IE</xsl:when> <!-- 爱尔兰       -->
			<xsl:when test=".='IRN'">IR</xsl:when> <!-- 伊朗         -->
			<xsl:when test=".='IRQ'">IQ</xsl:when> <!-- 伊拉克       -->
			<xsl:when test=".='ISL'">IS</xsl:when> <!-- 冰岛         -->
			<xsl:when test=".='ISR'">IL</xsl:when> <!-- 以色列       -->
			<xsl:when test=".='ITA'">IT</xsl:when> <!-- 意大利       -->
			<xsl:when test=".='JAM'">JM</xsl:when> <!-- 牙买加       -->
			<xsl:when test=".='JOR'">JO</xsl:when> <!-- 约旦         -->
			<xsl:when test=".='JPN'">JP</xsl:when> <!-- 日本         -->
			<xsl:when test=".='KAZ'">KZ</xsl:when> <!-- 哈萨克斯坦   -->
			<xsl:when test=".='KEN'">KE</xsl:when> <!-- 肯尼亚       -->
			<xsl:when test=".='KGZ'">KG</xsl:when> <!-- 吉尔吉思     -->
			<xsl:when test=".='KHM'">KH</xsl:when> <!-- 柬埔寨       -->
			<xsl:when test=".='KIR'">KT</xsl:when> <!-- 基利巴斯     -->
			<xsl:when test=".='KNA'">SX</xsl:when> <!-- 圣基茨和尼维 -->
			<xsl:when test=".='KOR'">KR</xsl:when> <!-- 韩国         -->
			<xsl:when test=".='KWT'">KW</xsl:when> <!-- 科威特       -->
			<xsl:when test=".='LAO'">LA</xsl:when> <!-- 老挝         -->
			<xsl:when test=".='LBN'">LB</xsl:when> <!-- 黎巴嫩       -->
			<xsl:when test=".='LBR'">LR</xsl:when> <!-- 利比里亚     -->
			<xsl:when test=".='LBY'">LY</xsl:when> <!-- 利比亚       -->
			<xsl:when test=".='LCA'">SQ</xsl:when> <!-- 圣卢西亚     -->
			<xsl:when test=".='LIE'">LI</xsl:when> <!-- 列支敦士登   -->
			<xsl:when test=".='LKA'">LK</xsl:when> <!-- 斯里兰卡     -->
			<xsl:when test=".='LSO'">LS</xsl:when> <!-- 莱索托       -->
			<xsl:when test=".='LTU'">LT</xsl:when> <!-- 立陶宛       -->
			<xsl:when test=".='LUX'">LU</xsl:when> <!-- 卢森堡       -->
			<xsl:when test=".='LVA'">LV</xsl:when> <!-- 拉脱维亚     -->
			<xsl:when test=".='MAC'">CHN</xsl:when> <!--  中国        -->
			<xsl:when test=".='MAR'">MA</xsl:when> <!-- 摩洛哥       -->
			<xsl:when test=".='MCO'">MC</xsl:when> <!-- 摩纳哥       -->
			<xsl:when test=".='MDA'">MD</xsl:when> <!-- 摩尔多瓦     -->
			<xsl:when test=".='MDG'">MG</xsl:when> <!-- 马达加斯加   -->
			<xsl:when test=".='MDV'">MV</xsl:when> <!-- 马尔代夫     -->
			<xsl:when test=".='MEX'">MX</xsl:when> <!-- 墨西哥       -->
			<xsl:when test=".='MHL'">MH</xsl:when> <!-- 马召尔群岛   -->
			<xsl:when test=".='MKD'">MK</xsl:when> <!-- 马其顿       -->
			<xsl:when test=".='MLI'">ML</xsl:when> <!-- 马里         -->
			<xsl:when test=".='MLT'">MT</xsl:when> <!-- 马耳他       -->
			<xsl:when test=".='MMR'">MM</xsl:when> <!-- 缅甸         -->
			<xsl:when test=".='MNG'">MN</xsl:when> <!-- 蒙古         -->
			<xsl:when test=".='MNP'">MP</xsl:when> <!-- 北马里亚纳群 -->
			<xsl:when test=".='MOZ'">MZ</xsl:when> <!-- 莫桑比克     -->
			<xsl:when test=".='MRT'">MR</xsl:when> <!-- 毛里塔尼亚   -->
			<xsl:when test=".='MSR'">MS</xsl:when> <!-- 蒙特塞拉特   -->
			<xsl:when test=".='MTQ'">MQ</xsl:when> <!-- 马提尼克     -->
			<xsl:when test=".='MUS'">MU</xsl:when> <!-- 毛里求斯     -->
			<xsl:when test=".='MWI'">MW</xsl:when> <!-- 马拉维       -->
			<xsl:when test=".='MYS'">MY</xsl:when> <!-- 马来西亚     -->
			<xsl:when test=".='MYT'">YT</xsl:when> <!-- 马约特岛     -->
			<xsl:when test=".='NAM'">NA</xsl:when> <!-- 纳米比亚     -->
			<xsl:when test=".='NCL'">NC</xsl:when> <!-- 新客里多尼亚 -->
			<xsl:when test=".='NER'">NE</xsl:when> <!-- 尼日尔       -->
			<xsl:when test=".='NFK'">NF</xsl:when> <!-- 诺福克群岛   -->
			<xsl:when test=".='NGA'">NG</xsl:when> <!-- 尼日利亚     -->
			<xsl:when test=".='NIC'">NI</xsl:when> <!-- 尼加拉瓜     -->
			<xsl:when test=".='NIU'">NU</xsl:when> <!-- 纽埃岛       -->
			<xsl:when test=".='NLD'">NL</xsl:when> <!-- 荷兰         -->
			<xsl:when test=".='NOR'">NO</xsl:when> <!-- 挪威         -->
			<xsl:when test=".='NPL'">NP</xsl:when> <!-- 尼泊尔       -->
			<xsl:when test=".='NRU'">NR</xsl:when> <!-- 瑙鲁         -->
			<xsl:when test=".='NZL'">NZ</xsl:when> <!-- 新西兰       -->
			<xsl:when test=".='OWN'">OM</xsl:when> <!-- 阿曼         -->
			<xsl:when test=".='PAK'">PK</xsl:when> <!-- 巴基斯坦     -->
			<xsl:when test=".='PAN'">PA</xsl:when> <!-- 巴拿马       -->
			<xsl:when test=".='PCN'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='PER'">PE</xsl:when> <!-- 秘鲁         -->
			<xsl:when test=".='PHL'">PH</xsl:when> <!-- 菲律宾       -->
			<xsl:when test=".='PLW'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='POL'">PL</xsl:when> <!-- 波兰         -->
			<xsl:when test=".='PRI'">PR</xsl:when> <!-- 波多黎各     -->
			<xsl:when test=".='PRK'">KP</xsl:when> <!-- 朝鲜         -->
			<xsl:when test=".='PRT'">PT</xsl:when> <!-- 葡萄牙       -->
			<xsl:when test=".='PRY'">PY</xsl:when> <!-- 巴拉圭       -->
			<xsl:when test=".='PSE'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='PYF'">PF</xsl:when> <!-- 法属波利尼西 -->
			<xsl:when test=".='QAT'">QA</xsl:when> <!-- 卡塔尔       -->
			<xsl:when test=".='REU'">RE</xsl:when> <!-- 留尼汪岛     -->
			<xsl:when test=".='ROM'">RO</xsl:when> <!-- 罗马尼亚     -->
			<xsl:when test=".='RUS'">RU</xsl:when> <!-- 俄罗斯       -->
			<xsl:when test=".='RWA'">RW</xsl:when> <!-- 卢旺达       -->
			<xsl:when test=".='SAU'">SA</xsl:when> <!-- 沙特阿拉伯   -->
			<xsl:when test=".='SCG'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='SDN'">SD</xsl:when> <!-- 苏丹         -->
			<xsl:when test=".='SEN'">SN</xsl:when> <!-- 塞内加尔     -->
			<xsl:when test=".='SGP'">SG</xsl:when> <!-- 新加坡       -->
			<xsl:when test=".='SGS'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='SHN'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='SJM'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='SLB'">SB</xsl:when> <!-- 所罗门群岛   -->
			<xsl:when test=".='SLE'">SL</xsl:when> <!-- 塞拉里昂     -->
			<xsl:when test=".='SLV'">SV</xsl:when> <!-- 萨尔瓦多     -->
			<xsl:when test=".='SMR'">SM</xsl:when> <!-- 圣马力诺     -->
			<xsl:when test=".='SOM'">SO</xsl:when> <!-- 索马里       -->
			<xsl:when test=".='SPM'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='STP'">ST</xsl:when> <!-- 圣多美和普林 -->
			<xsl:when test=".='SUR'">SR</xsl:when> <!-- 苏里南       -->
			<xsl:when test=".='SVK'">SK</xsl:when> <!-- 斯洛伐克     -->
			<xsl:when test=".='SVN'">SI</xsl:when> <!-- 斯洛文尼亚   -->
			<xsl:when test=".='SWE'">SE</xsl:when> <!-- 瑞典         -->
			<xsl:when test=".='SWZ'">SZ</xsl:when> <!-- 斯威士兰     -->
			<xsl:when test=".='SYC'">SC</xsl:when> <!-- 塞舌尔       -->
			<xsl:when test=".='SYR'">SY</xsl:when> <!-- 叙利亚       -->
			<xsl:when test=".='TCA'">TC</xsl:when> <!-- 特克斯和凯科 -->
			<xsl:when test=".='TCD'">TD</xsl:when> <!-- 乍得         -->
			<xsl:when test=".='TGO'">TG</xsl:when> <!-- 多哥         -->
			<xsl:when test=".='THA'">TH</xsl:when> <!-- 泰国         -->
			<xsl:when test=".='TJK'">TJ</xsl:when> <!-- 塔吉克斯坦   -->
			<xsl:when test=".='TKL'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='TKM'">TM</xsl:when> <!-- 土库曼斯坦   -->
			<xsl:when test=".='TMP'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='TON'">TO</xsl:when> <!-- 汤加         -->
			<xsl:when test=".='TTO'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='TUN'">TN</xsl:when> <!-- 突尼斯       -->
			<xsl:when test=".='TUR'">TR</xsl:when> <!-- 土耳其       -->
			<xsl:when test=".='TUV'">TV</xsl:when> <!-- 图瓦卢       -->
			<xsl:when test=".='TWN'">CHN</xsl:when> <!--  中国        -->
			<xsl:when test=".='TZA'">TZ</xsl:when> <!-- 坦桑尼亚     -->
			<xsl:when test=".='UGA'">UG</xsl:when> <!-- 乌干达       -->
			<xsl:when test=".='UKR'">UA</xsl:when> <!-- 乌克兰       -->
			<xsl:when test=".='UMI'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='URY'">UY</xsl:when> <!-- 乌拉圭       -->
			<xsl:when test=".='USA'">US</xsl:when> <!-- 美国         -->
			<xsl:when test=".='UZB'">UZ</xsl:when> <!-- 乌兹别克斯坦 -->
			<xsl:when test=".='VAT'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='VCT'">VC</xsl:when> <!-- 圣文斯特     -->
			<xsl:when test=".='VEN'">VE</xsl:when> <!-- 委内瑞拉     -->
			<xsl:when test=".='VGB'">VG</xsl:when> <!-- 英属维尔京群 -->
			<xsl:when test=".='VIR'">VI</xsl:when> <!-- 美属维尔京群 -->
			<xsl:when test=".='VNM'">VN</xsl:when> <!-- 越南         -->
			<xsl:when test=".='VUT'">VU</xsl:when> <!-- 瓦努阿图     -->
			<xsl:when test=".='WLF'">OTH</xsl:when> <!--  其他        -->
			<xsl:when test=".='WSM'">WS</xsl:when> <!-- 萨摩亚       -->
			<xsl:when test=".='YEM'">YE</xsl:when> <!-- 也门         -->
			<xsl:when test=".='YUG'">YU</xsl:when> <!-- 南斯拉夫     -->
			<xsl:when test=".='ZAF'">ZA</xsl:when> <!-- 南非         -->
			<xsl:when test=".='ZMB'">ZM</xsl:when> <!-- 赞比亚       -->
			<xsl:when test=".='ZWE'">ZW</xsl:when> <!-- 津巴布韦     -->
		</xsl:choose>
	</xsl:template>
	<!-- 婚姻状况 -->
	<xsl:template name="MarStat" match="MarStat">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- 否 -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- 是 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 与被保险人关系 -->
	<xsl:template name="tran_relaCode_ins">
		<xsl:param name="relaCode" />
		<xsl:choose>
			<xsl:when test="$relaCode='01'">00</xsl:when> <!-- 本人 -->
			<xsl:when test="$relaCode='02'">01</xsl:when> <!-- 父母 -->
			<xsl:when test="$relaCode='03'">01</xsl:when> <!-- 父母 -->
			<xsl:when test="$relaCode='04'">03</xsl:when> <!-- 子女 -->
			<xsl:when test="$relaCode='05'">03</xsl:when> <!-- 子女 -->
			<xsl:when test="$relaCode='06'">02</xsl:when> <!-- 配偶 -->
			<xsl:when test="$relaCode='07'">02</xsl:when> <!-- 配偶 -->
			<xsl:when test="$relaCode='08'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='09'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='10'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='11'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='12'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='13'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='14'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='15'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='16'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='17'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='18'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='19'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='20'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='21'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='22'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='23'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='24'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='25'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='26'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='27'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='28'">05</xsl:when> <!-- 雇佣 -->
			<xsl:when test="$relaCode='29'">05</xsl:when> <!-- 雇佣 -->
			<xsl:when test="$relaCode='30'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='31'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='32'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='33'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='34'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='35'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='36'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='37'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='38'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='39'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='40'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='41'">06</xsl:when> <!-- 抚养 -->
			<xsl:when test="$relaCode='42'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='43'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='44'">04</xsl:when> <!-- 其他 -->
			<xsl:when test="$relaCode='45'">04</xsl:when> <!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费方式（银行）—缴费频次（我司） -->
	<xsl:template name="PremType" match="PremType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when>	<!-- 趸缴    -->
			<xsl:when test=".=02">1</xsl:when>	<!-- 月缴    -->
			<xsl:when test=".=03">3</xsl:when>	<!-- 季缴    -->
			<xsl:when test=".=04">6</xsl:when>	<!-- 半年缴  -->
			<xsl:when test=".=05">12</xsl:when>	<!-- 年缴 -->
			<xsl:when test=".=06">-1</xsl:when>	<!-- 不定期交 -->
			<xsl:when test=".=07"></xsl:when>	  <!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 保险年期/年龄标志 -->
	<xsl:template name="CovTermType" match="CovTermType">
		<xsl:choose>
			<xsl:when test=".=01">A</xsl:when>	<!-- 保终身        -->
			<xsl:when test=".=02">Y</xsl:when>	<!-- 按年          -->
			<xsl:when test=".=03">A</xsl:when>	<!-- 到某确定年龄  -->
			<xsl:when test=".=04"></xsl:when>	  <!-- 按季保  -->
			<xsl:when test=".=05">M</xsl:when>	<!-- 按月 -->
			<xsl:when test=".=06">D</xsl:when>	<!-- 按日 -->
			<xsl:when test=".=99"></xsl:when>	  <!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 缴费年期 -->
	<xsl:template name="PremTermType" match="PremTermType">
		<xsl:choose>
			<xsl:when test=".=01">Y</xsl:when>	<!-- 趸缴           -->
			<xsl:when test=".=02">Y</xsl:when>	<!-- 按年           -->
			<xsl:when test=".=03">A</xsl:when>	<!-- 到某确定年龄   -->
			<xsl:when test=".=04">A</xsl:when>	<!-- 终身      -->        
			<xsl:when test=".=05"></xsl:when>	<!-- 不定期缴 -->
			<xsl:when test=".=06">M</xsl:when>	<!-- 按月 -->
			<xsl:when test=".=07"></xsl:when>	  <!-- 季缴 -->
			<xsl:when test=".=99"></xsl:when>	  <!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 职业代码 -->
	<xsl:template name="Work" match="Work">
		<xsl:choose>
			<xsl:when test=".='000'">4030111</xsl:when>	<!-- 国家公务员及企事业单位负责人                                            -->
			<xsl:when test=".='001'">4030111</xsl:when>	<!-- 国家公务员                                                              -->
			<xsl:when test=".='002'">4030111</xsl:when>	<!-- 事业单位负责人                                                          -->
			<xsl:when test=".='003'">4030111</xsl:when>	<!-- 企业负责人                                                              -->
			<xsl:when test=".='100'">2050101</xsl:when>	<!-- 专业技术人员                                                            -->
			<xsl:when test=".='101'">2050101</xsl:when>	<!-- 科学研究人员                                                            -->
			<xsl:when test=".='102'">2050101</xsl:when>	<!-- 工程技术人员                                                            -->
			<xsl:when test=".='103'">2050101</xsl:when>	<!-- 农业技术人员                                                            -->
			<xsl:when test=".='104'">2050101</xsl:when>	<!-- 飞机和船舶技术人员                                                      -->
			<xsl:when test=".='105'">2050101</xsl:when>	<!-- 卫生专业技术人员                                                        -->
			<xsl:when test=".='106'">2070109</xsl:when>	<!-- 经济业务人员                                                            -->
			<xsl:when test=".='107'">2070109</xsl:when>	<!-- 金融业务人员                                                            -->
			<xsl:when test=".='108'">2080103</xsl:when>	<!-- 法律专业人员                                                            -->
			<xsl:when test=".='109'">2090104</xsl:when>	<!-- 教学人员                                                                -->
			<xsl:when test=".='110'">2100106</xsl:when>	<!-- 文学艺术工作人员                                                        -->
			<xsl:when test=".='111'">2100106</xsl:when>	<!-- 体育工作人员                                                            -->
			<xsl:when test=".='112'">2100106</xsl:when>	<!-- 新闻出版、文化工作人员                                                  -->
			<xsl:when test=".='113'">2130101</xsl:when>	<!-- 宗教职业者                                                              -->
			<xsl:when test=".='114'">2050101</xsl:when>	<!-- 其他专业技术人员                                                        -->
			<xsl:when test=".='200'">4010101</xsl:when>	<!-- 办事人员和有关人员                                                      -->
			<xsl:when test=".='201'">4010101</xsl:when>	<!-- 行政办公人员                                                            -->
			<xsl:when test=".='202'">2020906</xsl:when>	<!-- 安全保卫和消防人员                                                      -->
			<xsl:when test=".='203'">3030101</xsl:when>	<!-- 邮政和电信业务人员                                                      -->
			<xsl:when test=".='204'">4010101</xsl:when>	<!-- 其他办事人员和有关人员                                                  -->
			<xsl:when test=".='300'">4010101</xsl:when>	<!-- 商业、服务业人员                                                        -->
			<xsl:when test=".='301'">4010101</xsl:when>	<!-- 购销人员                                                                -->
			<xsl:when test=".='302'">4010101</xsl:when>	<!-- 仓储人员                                                                -->
			<xsl:when test=".='303'">4010101</xsl:when>	<!-- 餐饮服务人员                                                            -->
			<xsl:when test=".='304'">4010101</xsl:when>	<!-- 饭店、旅游及健身娱乐场所服务人员                                        -->
			<xsl:when test=".='305'">4010101</xsl:when>	<!-- 运输服务人员                                                            -->
			<xsl:when test=".='306'">4010101</xsl:when>	<!-- 医疗卫生辅助服务人员                                                    -->
			<xsl:when test=".='307'">4010101</xsl:when>	<!-- 社会服务和居民生活服务人员                                              -->
			<xsl:when test=".='308'">4010101</xsl:when>	<!-- 其他商业、服务业人员                                                    -->
			<xsl:when test=".='400'">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员                                          -->
			<xsl:when test=".='401'">5010107</xsl:when>	<!-- 种植业生产人员                                                          -->
			<xsl:when test=".='402'">5010107</xsl:when>	<!-- 林业生产及野生动植物保护人员                                            -->
			<xsl:when test=".='403'">5010107</xsl:when>	<!-- 畜牧业生产人员                                                          -->
			<xsl:when test=".='404'">5010107</xsl:when>	<!-- 渔业生产人员                                                            -->
			<xsl:when test=".='405'">5010107</xsl:when>	<!-- 水利设施管理养护人员                                                    -->
			<xsl:when test=".='406'">5010107</xsl:when>	<!-- 其他农、林、牧、渔、水利业生产人员                                      -->
			<xsl:when test=".='500'">6240105</xsl:when>	<!-- 生产、运输设备操作人员及有关人员                                        -->
			<xsl:when test=".='501'">2020103</xsl:when>	<!-- 勘探及矿物开采人员                                                      -->
			<xsl:when test=".='502'">6050611</xsl:when>	<!-- 金属冶炼、轧制人员                                                      -->
			<xsl:when test=".='503'">6050611</xsl:when>	<!-- 化工产品生产人员                                                        -->
			<xsl:when test=".='504'">6050611</xsl:when>	<!-- 机械制造加工人员                                                        -->
			<xsl:when test=".='505'">6050611</xsl:when>	<!-- 机电产品装配人员                                                        -->
			<xsl:when test=".='506'">6050611</xsl:when>	<!-- 机械设备修理人员                                                        -->
			<xsl:when test=".='507'">6050611</xsl:when>	<!-- 电力设备安装、运行、检修及供电人员                                      -->
			<xsl:when test=".='508'">6050611</xsl:when>	<!-- 电子元器件与设备制造、装配、调试及维修人员                              -->
			<xsl:when test=".='509'">6050611</xsl:when>	<!-- 橡胶和塑料制品生产人员                                                  -->
			<xsl:when test=".='510'">6050611</xsl:when>	<!-- 纺织、针织、印染人员                                                    -->
			<xsl:when test=".='511'">6050611</xsl:when>	<!-- 裁剪、缝纫和皮革、毛皮制品加工制作人员                                  -->
			<xsl:when test=".='512'">6050611</xsl:when>	<!-- 粮油、食品、饮料生产加工及饲料生产加工人员                              -->
			<xsl:when test=".='513'">6050611</xsl:when>	<!-- 烟草及其制品加工人员                                                    -->
			<xsl:when test=".='514'">6050611</xsl:when>	<!-- 药品生产人员                                                            -->
			<xsl:when test=".='515'">6050611</xsl:when>	<!-- 木材加工、人造板生产、木制品制作及制浆、造纸和纸制品生产加工人员        -->
			<xsl:when test=".='516'">6050611</xsl:when>	<!-- 建筑材料生产、加工人员                                                  -->
			<xsl:when test=".='517'">6050611</xsl:when>	<!-- 玻璃、陶瓷、搪瓷及其制品生产加工人员                                    -->
			<xsl:when test=".='518'">6050611</xsl:when>	<!-- 广播影视制品制作、播放及文物保护作业人员                                -->
			<xsl:when test=".='519'">6050611</xsl:when>	<!-- 印刷人员                                                                -->
			<xsl:when test=".='520'">6050611</xsl:when>	<!-- 工艺、美术品制作人员                                                    -->
			<xsl:when test=".='521'">6050611</xsl:when>	<!-- 文化教育、体育用品制作人员                                              -->
			<xsl:when test=".='522'">2020906</xsl:when>	<!-- 工程施工人员                                                            -->
			<xsl:when test=".='523'">6240105</xsl:when>	<!-- 运输设备操作人员及有关人员                                              -->
			<xsl:when test=".='524'">6050611</xsl:when>	<!-- 环境监测与废物处理人员                                                  -->
			<xsl:when test=".='525'">6050611</xsl:when>	<!-- 检验、计量人员                                                          -->
			<xsl:when test=".='526'">6240105</xsl:when>	<!-- 其他生产、运输设备操作人员及有关人员                                    -->
			<xsl:when test=".='600'">7010103</xsl:when>	<!-- 军人                                                                    -->
			<xsl:when test=".='700'">4030111</xsl:when>	<!-- 私营业主                                                                -->
			<xsl:when test=".='801'">2090114</xsl:when>	<!-- 学生                                                                    -->
			<xsl:when test=".='802'">8010104</xsl:when>	<!-- 家庭主妇                                                                -->
			<xsl:when test=".='803'">8010101</xsl:when>	<!-- 无业人员                                                                -->
			<xsl:when test=".='804'">8010102</xsl:when>	<!-- 退休人员                                                                -->
			<xsl:when test=".='805'">2070109</xsl:when>	<!-- 自由职业                                                                -->
			<xsl:when test=".='999'"></xsl:when>	<!-- 其他           -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
