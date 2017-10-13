<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/REQUEST">
<TranData>    
	<Head>
	    <!-- 交易日期 -->
	    <TranDate><xsl:value-of select="BUSI/TRSDATE"/></TranDate>
	    <!-- 交易时间 -->
        <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
        <!-- 柜员代码 -->
        <TellerNo><xsl:value-of select="DIST/TELLER"/></TellerNo>
        <!-- 交易流水号 -->
        <TranNo><xsl:value-of select="BUSI/TRANS"/></TranNo>
        <!-- 地区码+网点代码 -->
        <NodeNo>
             <xsl:value-of select="DIST/ZONE"/><xsl:value-of select="DIST/DEPT"/>
        </NodeNo>
        <xsl:copy-of select="Head/*"/>
        <!-- 交易单位 -->
        <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
    </Head>
	
	<Body>
		<ProposalPrtNo><xsl:value-of select="BUSI/CONTENT/MAIN/APPNO" /></ProposalPrtNo> <!-- 投保单(印刷)号 -->
		<ContPrtNo></ContPrtNo> <!-- 保单合同印刷号 -->
		<PolApplyDate><xsl:value-of select="BUSI/CONTENT/MAIN/APPDATE" /></PolApplyDate> <!-- 投保日期 -->		
		<!--出单网点名称-->
		<AgentComName><xsl:value-of select="DIST/BankBranchName"/></AgentComName>
		<!--银行销售人员工号-->
		<SellerNo><xsl:value-of select="DIST/FINANCIALID"/></SellerNo>
		<TellerName><xsl:value-of select="DIST/FINANCIALNAME"/></TellerName>		
		<AccName><xsl:value-of select="BUSI/CONTENT/TBR/NAME" /></AccName> <!-- 账户姓名 -->
		<AccNo><xsl:value-of select="BUSI/CONTENT/MAIN/PAYACC" /></AccNo> <!-- 银行账户 -->
		<!-- 保单递送方式 -->
		<GetPolMode>
		    <xsl:call-template name="tran_getPolMode">
			   <xsl:with-param name="getPolMode">
				  <xsl:value-of select="BUSI/CONTENT/MAIN/DELIVER"/>
			   </xsl:with-param>
		    </xsl:call-template>
		</GetPolMode> 
		<JobNotice><xsl:value-of select="BUSI/CONTENT/INFORM1/Occupation" /></JobNotice>   <!-- 职业告知(N/Y) -->
		<HealthNotice><xsl:value-of select="BUSI/CONTENT/HEALTH/NOTICE" /></HealthNotice> <!-- 健康告知(N/Y)  -->	
		<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="BUSI/CONTENT/INFORM1/JuvDieAssured*0.01"/></xsl:variable>
		<!-- 未成年被保险人是否在其他保险公司投保身故保险 Y是N否 -->
		<PolicyIndicator>
			<xsl:choose>
			    <xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
			    <xsl:otherwise>N</xsl:otherwise>
		    </xsl:choose>
		</PolicyIndicator>
		<!-- 累计投保身故保额 这个金额字段比较特殊，单位是百元 -->
		<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
        <!-- 产品组合 -->
        <ContPlan>
        	<!-- 产品组合编码 -->
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="BUSI/CONTENT/PTS/PT/ID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:value-of select="BUSI/CONTENT/PTS/PT/UNIT" />
			</ContPlanMult>
        </ContPlan>
        
		<!-- 投保人 -->
		<xsl:apply-templates select="BUSI/CONTENT/TBR" />
		
		<!-- 被保人 -->
		<xsl:apply-templates select="BUSI/CONTENT/BBR" />		
		
		<!-- 受益人 -->
		<xsl:for-each select="BUSI/CONTENT/SYR">
			<xsl:choose>
				<xsl:when test="NAME!=''">
					<Bnf>
						<Type>1</Type>	<!-- 默认为“1-身故受益人” -->
					    <Grade><xsl:value-of select="ORDER" /></Grade> <!-- 受益顺序 -->
					    <Name><xsl:value-of select="NAME" /></Name> <!-- 姓名 -->
					    <Sex>
					       <xsl:call-template name="tran_sex">
			                  <xsl:with-param name="sex">
				                 <xsl:value-of select="SEX"/>
			                  </xsl:with-param>
		                   </xsl:call-template>
					    </Sex> <!-- 性别 -->
					    <Birthday><xsl:value-of select="BIRTH" /></Birthday> <!-- 出生日期(yyyyMMdd) -->
					    <!-- 证件类型 -->
					    <IDType>
					        <xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="IDTYPE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </IDType> 
					    <IDNo><xsl:value-of select="IDNO" /></IDNo> <!-- 证件号码 -->
					    <!-- 与被保人关系 -->
					    <RelaToInsured>
					        <xsl:call-template name="tran_relation">
								<xsl:with-param name="relation">
									<xsl:value-of select="BBR_RELA"/>
								</xsl:with-param>
							</xsl:call-template>
					    </RelaToInsured> 
					    <Lot><xsl:value-of select="RATIO" /></Lot> <!-- 受益比例(整数，百分比) -->
					</Bnf>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- 险种信息 -->
		<xsl:apply-templates select="BUSI/CONTENT/PTS/PT" />			
	</Body>
</TranData>
</xsl:template>

<!-- 投保人 -->
<xsl:template name="Appnt" match="TBR">
<Appnt>
	<Name><xsl:value-of select="NAME" /></Name> <!-- 姓名 -->
	<Sex><!-- 性别 -->
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="BIRTH" /></Birthday><!-- 出生日期(yyyyMMdd) -->
	<IDType><!-- 证件类型 -->
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype">
				<xsl:value-of select="IDTYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="IDNO" /></IDNo><!-- 证件号码 -->
	<IDTypeStartDate><xsl:value-of select="IDVALIDATE2" /></IDTypeStartDate > <!-- 证件有效起期 -->
    <IDTypeEndDate><xsl:value-of select="IDVALIDATE" /></IDTypeEndDate > <!-- 证件有效止期 需要确认永久有效银行如何传值？-->
	<!-- 职业代码 ？-->
	<JobCode>
	    <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="Occupation"/>
			</xsl:with-param>
		</xsl:call-template>
	</JobCode>
	<!-- 投保人年收入，银行单位分，保险公司单位分 -->
	<Salary>
	    <xsl:value-of select="IncomeYear" />
	</Salary>
	<!-- 客户类型 -->
	<LiveZone>
		<xsl:apply-templates select="Resident" />
	</LiveZone>
	<!-- 国籍 -->
    <Nationality>
        <xsl:apply-templates select="COUNTRY_CODE" />
    </Nationality> 
    <Stature></Stature> <!-- 身高(cm) -->
    <Weight></Weight> <!-- 体重(kg) -->
    <!-- 婚否(N/Y) -->
    <MaritalStatus></MaritalStatus>
    <Address><xsl:value-of select="ADDR" /></Address> <!-- 地址 -->
    <ZipCode><xsl:value-of select="ZIP" /></ZipCode> <!-- 邮编 -->
    <Mobile><xsl:value-of select="MP" /></Mobile> <!-- 移动电话 -->
    <Phone><xsl:value-of select="TEL" /></Phone> <!-- 固定电话 -->
    <Email><xsl:value-of select="EMAIL" /></Email> <!-- 电子邮件-->
    <RelaToInsured>
    	<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation">
				<xsl:value-of select="BBR_RELA"/>
			</xsl:with-param>
		</xsl:call-template>
    </RelaToInsured> <!-- 与被保人关系 -->
</Appnt>
</xsl:template>

<!-- 被保人 -->
<xsl:template name="Insured" match="BBR">
<Insured>
	<Name><xsl:value-of select="NAME" /></Name> <!-- 姓名 -->
    <Sex><!-- 性别 -->
        <xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
    <Birthday><xsl:value-of select="BIRTH" /></Birthday> <!-- 出生日期(yyyyMMdd) -->
    <IDType> <xsl:call-template name="tran_idtype">
		    <xsl:with-param name="idtype">
				<xsl:value-of select="IDTYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType> <!-- 证件类型 -->
    <IDNo><xsl:value-of select="IDNO" /></IDNo> <!-- 证件号码 -->
    <IDTypeStartDate><xsl:value-of select="IDVALIDATE2" /></IDTypeStartDate > <!-- 证件有效起期 -->
    <IDTypeEndDate><xsl:value-of select="IDVALIDATE" /></IDTypeEndDate > <!-- 证件有效止期 -->
    <!-- 职业代码 -->
    <JobCode>        
        <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="Occupation"/>
			</xsl:with-param>
		</xsl:call-template>
    </JobCode>
    <Stature></Stature> <!-- 身高(cm)-->
    <!-- 国籍-->
    <Nationality>
        <xsl:apply-templates select="COUNTRY_CODE" />
    </Nationality> 
    <Weight></Weight> <!-- 体重(kg) -->
    <MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
    <Address><xsl:value-of select="ADDR" /></Address> <!-- 地址 -->
    <ZipCode><xsl:value-of select="ZIP" /></ZipCode> <!-- 邮编 -->
    <Mobile><xsl:value-of select="MP" /></Mobile> <!-- 移动电话 -->
    <Phone><xsl:value-of select="TEL" /></Phone> <!-- 固定电话 -->
    <Email><xsl:value-of select="EMAIL" /></Email> <!-- 电子邮件-->
</Insured>
</xsl:template>

<!-- 险种信息  -->
<xsl:template name="Risk" match="PT">
<Risk>
    <!-- 险种代码 -->
	<RiskCode>
	    <xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="ID" />
		</xsl:call-template>
	</RiskCode>
	<MainRiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="ID" />
		</xsl:call-template>
	</MainRiskCode><!-- 主险险种代码 -->
	<RiskType></RiskType><!-- 险种类型 -->
	<Amnt><xsl:value-of select="AMNT"/></Amnt><!-- 保额(分) -->
	<Prem><xsl:value-of select="PREMIUM"/></Prem><!-- 保险费(分) -->
	<Mult><xsl:value-of select="UNIT"/></Mult><!-- 投保份数 -->
	<!-- 缴费频次 -->
	<PayIntv>
		<xsl:call-template name="tran_PayIntv">
			<xsl:with-param name="payintv">
				<xsl:value-of select="CRG_T"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayIntv>
	<!-- 缴费形式 -->
	<PayMode></PayMode>
	<!-- 保险年期年龄标志 -->
	<InsuYearFlag>
		<xsl:call-template name="tran_InsuYearFlag">
			<xsl:with-param name="insuyearflag">
				<xsl:value-of select="COVER_T" />
			</xsl:with-param>
		</xsl:call-template>
	</InsuYearFlag>
	<InsuYear><!-- 保终身 -->
		<xsl:if test="COVER_T=1">106</xsl:if>
		<xsl:if test="COVER_T!=1"><xsl:value-of select="COVER_Y" /></xsl:if>
	</InsuYear>	
	<xsl:if test="CRG_T = 1"><!-- 趸交 -->
		<PayEndYearFlag>Y</PayEndYearFlag>
		<PayEndYear>1000</PayEndYear>
	</xsl:if>
	<!-- 缴费年期年龄标志 -->
	<xsl:if test="CRG_T != 1">
		<PayEndYearFlag>
		   <xsl:call-template name="tran_PayEndYearFlag">
			  <xsl:with-param name="payendyearflag">
				<xsl:value-of select="CRG_T" />
			</xsl:with-param>
		</xsl:call-template>
	    </PayEndYearFlag>
	    <!-- 缴费年期年龄 -->
		<PayEndYear><xsl:value-of select="CRG_Y"/></PayEndYear>
	</xsl:if>

	<BonusGetMode></BonusGetMode><!-- 红利领取方式 -->
    <FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->	
	<GetYearFlag></GetYearFlag><!-- 领取年龄年期标志 -->
	<GetYear></GetYear><!-- 领取年龄 -->
	<GetIntv></GetIntv><!-- 领取方式 -->
	<GetBankCode></GetBankCode><!-- 领取银行编码 -->
	<GetBankAccNo></GetBankAccNo><!-- 领取银行账户 -->
	<GetAccName></GetAccName><!-- 领取银行户名 -->
	<AutoPayFlag></AutoPayFlag> <!-- 自动垫交标志 -->
</Risk>
</xsl:template>



<!-- 重要字段代码转换（请仔细核对） -->
<!-- 性别 -->
<xsl:template name="tran_sex">
  <xsl:param name="sex">0</xsl:param>
  <xsl:choose>
  	<xsl:when test="$sex = 1">0</xsl:when><!-- 男 -->
  	<xsl:when test="$sex = 2">1</xsl:when><!-- 女 -->
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 证件类型 -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype=1">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test="$idtype=2">1</xsl:when>	<!-- 护照 -->
	<xsl:when test="$idtype=3">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test="$idtype=4">2</xsl:when>	<!-- 武警证-军官证 -->
	<xsl:when test="$idtype=5">6</xsl:when>	<!-- 港澳居民来往内地通行证 -->
	<xsl:when test="$idtype=6">5</xsl:when>	<!-- 户口簿 -->
	<xsl:when test="$idtype=7">8</xsl:when>	<!-- 其它 -->
	<xsl:when test="$idtype=8">2</xsl:when>	<!-- 警官证-军官证 -->
	<xsl:when test="$idtype=9">8</xsl:when>	<!-- 执行公务证-其它 -->	
	<xsl:when test="$idtype=A">8</xsl:when>	<!-- 士兵证-其它 -->
	<xsl:when test="$idtype=B">7</xsl:when>	<!-- 台湾居民来往大陆通行证 -->
	<xsl:when test="$idtype=C">0</xsl:when>	<!-- 临时身份证-身份证 -->
	<xsl:when test="$idtype=D">8</xsl:when>	<!-- 外国人居留证-其它 -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 投保人与被保人关系 -->
<xsl:template name="tran_relation">
<xsl:param name="relation" />
<xsl:choose>
	<xsl:when test="$relation=1">02</xsl:when>	<!-- 配偶 -->
	<xsl:when test="$relation=2">01</xsl:when>	<!-- 父母 -->
	<xsl:when test="$relation=3">03</xsl:when>	<!-- 子女 -->
	<xsl:when test="$relation=4">04</xsl:when>	<!-- 亲属 -->	
	<xsl:when test="$relation=5">00</xsl:when>	<!-- 本人 -->
	<xsl:when test="$relation=6">04</xsl:when>	<!-- 其他 -->
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费频次 -->
<xsl:template name="tran_PayIntv">
<xsl:param name="payintv">0</xsl:param>
	<xsl:if test="$payintv = '2'">12</xsl:if> <!-- 年缴 -->
	<xsl:if test="$payintv = '3'">6</xsl:if>  <!-- 半年交 -->
	<xsl:if test="$payintv = '1'">0</xsl:if>  <!-- 趸交 -->
	<xsl:if test="$payintv = '4'">3</xsl:if>  <!-- 季交 -->
	<xsl:if test="$payintv = '5'">1</xsl:if>  <!-- 月交 -->
	<xsl:if test="$payintv = '8'">-1</xsl:if>  <!-- 不定期交 -->
</xsl:template>
	
<!-- 保险年龄年期标志 -->
<xsl:template name="tran_InsuYearFlag">
<xsl:param name="insuyearflag" />
<xsl:choose>
	<xsl:when test="$insuyearflag=5">D</xsl:when>	<!-- 按日 -->
	<xsl:when test="$insuyearflag=4">M</xsl:when>	<!-- 按月 -->
	<xsl:when test="$insuyearflag=2">Y</xsl:when>	<!-- 按年 -->
	<xsl:when test="$insuyearflag=1">A</xsl:when>   <!-- 终身 -->
	<xsl:when test="$insuyearflag=3">A</xsl:when>   <!-- 到某确定年龄 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费年期年龄标志 -->
<xsl:template name="tran_PayEndYearFlag">
<xsl:param name="payendyearflag" />
<xsl:choose>
	<xsl:when test="$payendyearflag=1">Y</xsl:when>	<!-- 趸缴 -->
	<xsl:when test="$payendyearflag=2">Y</xsl:when>	<!-- 按年 -->
	<xsl:when test="$payendyearflag=5">M</xsl:when>	<!-- 按月 -->
	<xsl:when test="$payendyearflag=6">A</xsl:when> <!-- 到某确定年龄 -->
	<xsl:when test="$payendyearflag=7">A</xsl:when> <!-- 终身 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<!-- 即使银行和我司险种代码相同也要转换，为了限制某个银行只能卖的险种 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122009">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode=53000001">50015</xsl:when>	<!-- 安邦长寿稳赢1号两全保险组合 -->	
	<!-- guning -->
	<xsl:when test="$riskcode=53000002">L12074</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 产品组合代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- 50002(50015): 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
		<xsl:when test="$contPlanCode='53000001'">50015</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 职业代码 ？-->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
   <xsl:when test="$jobcode='B001001'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='B001002'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='B001003'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='B001004'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='B001005'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='C001001'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001002'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001003'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001004'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001005'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001006'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001007'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001008'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001009'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001010'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001011'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001012'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001013'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001014'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001015'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001016'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001017'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001018'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='C001019'">9210102</xsl:when>  <!-- 从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
  <xsl:when test="$jobcode='D001001'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001002'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001003'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001004'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001005'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001006'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001007'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001008'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001009'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001010'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001011'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D001012'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='D002001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002005'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002006'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002007'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002008'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002009'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002010'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002012'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D002013'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D003001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D003002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D003003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='D003004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001005'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001006'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001007'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001008'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='F001009'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->  
  <xsl:when test="$jobcode='G001001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001005'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001006'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001007'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001008'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001009'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001010'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001012'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001013'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001014'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001015'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001016'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001017'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001018'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001019'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001020'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001021'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001022'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001023'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001024'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001025'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001026'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001027'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001028'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001029'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001030'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001031'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001032'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001033'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001034'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='G001035'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业 -->
  <xsl:when test="$jobcode='H001001'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001002'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001003'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001004'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001005'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001006'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001007'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001008'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001009'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001010'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001011'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001012'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001013'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001014'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001015'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001016'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001017'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001018'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001019'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001020'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001021'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001022'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001023'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001024'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001025'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001026'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001027'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001028'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001029'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001030'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001031'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001032'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001033'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001034'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001035'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001036'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001037'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001038'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001039'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001040'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001041'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
  <xsl:when test="$jobcode='H001042'">9210107</xsl:when>  <!-- 从事海上渔业,航运,危险运动的人员,出国人员 -->
                           
  <xsl:when test="$jobcode='H002001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002005'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002006'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002007'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002008'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002009'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002010'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002012'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002013'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002014'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002015'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002016'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='H002017'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->

  <xsl:when test="$jobcode='J001001'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J001002'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J001003'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J001004'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  
  <xsl:when test="$jobcode='J003001'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003002'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003003'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003004'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003005'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003006'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003007'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003008'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J003009'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员 -->
  <xsl:when test="$jobcode='J004001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004002'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004003'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004004'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004005'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004006'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004007'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004008'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004009'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004010'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004012'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004013'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004014'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004015'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004016'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004017'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004018'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004019'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004020'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004021'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004022'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004023'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004024'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004025'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004026'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004027'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004028'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004029'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004030'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004031'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004032'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004033'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004034'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004035'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004036'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J004037'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='J005001'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J005002'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J005003'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J005004'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J005005'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J005006'">9210101</xsl:when>  <!-- 机关团体,事业单位的工作人员以及所有文职人员 -->
  <xsl:when test="$jobcode='J006001'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006002'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006003'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006004'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006005'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006006'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006007'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006008'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006009'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006010'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006011'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006012'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006013'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006014'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006015'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006016'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006017'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006018'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006019'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006020'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006021'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006022'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006023'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006024'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006025'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006026'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006027'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006028'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='J006029'">9210108</xsl:when>  <!-- 坑道内作业,潜水人员,爆破人员,炸药业,镇暴警察及特种兵,战地记者,特技演员,动物园驯兽师,电力高压电工程设施人员,赛车运动员及教练,跳伞运动员及教练 -->
  <xsl:when test="$jobcode='K001001'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='K001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='K001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001017'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001018'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001019'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001020'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001021'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='K001022'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001023'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001024'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001025'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001026'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001027'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001028'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001029'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001030'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001031'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='K001032'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001033'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001034'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001035'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001036'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001037'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002001'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002002'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002003'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002004'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002005'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002006'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002007'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002008'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002009'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002010'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002011'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002012'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002013'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002014'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002015'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002016'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002017'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002018'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002019'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002020'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002021'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002022'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002023'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002024'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002025'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002026'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001011'">9210105</xsl:when>  <!-- 从事造林业,陆上油矿开采业,建筑业,铁路铺设,造修船业家电制造业,电信及电力业,铁工厂,机械厂,以及危险程度稍高的职业-->
  <xsl:when test="$jobcode='L001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='L002001'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员-->
  <xsl:when test="$jobcode='L002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002004'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002005'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002006'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002007'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002011'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员-->
  <xsl:when test="$jobcode='L002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002014'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002015'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002016'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002017'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002018'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002019'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002020'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002021'">9210103</xsl:when>  <!-- 从事农业,牧业,钢铁业,塑胶业,装璜业,修理业,家俱制造业,出租车服务业的人员-->
  <xsl:when test="$jobcode='L002022'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002023'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002024'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002025'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002026'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001004'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001005'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002005'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002006'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002016'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002007'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002015'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002011'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002001'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002004'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002014'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001012'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q002001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Q002002'">9210101</xsl:when>
  <xsl:when test="$jobcode='S001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001012'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002001'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002011'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='S003001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003009'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003010'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003011'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003012'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003013'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003014'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005009'">9210104</xsl:when>
  <xsl:when test="$jobcode='T001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001011'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001017'">9210105</xsl:when>
  <xsl:when test="$jobcode='T002001'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002002'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002003'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002008'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002009'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002010'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002011'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002012'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002013'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002014'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002015'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002016'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002017'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002018'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002019'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002020'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002021'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002022'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002023'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002024'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002025'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002026'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002027'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002028'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002029'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002030'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002031'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002032'">9210104</xsl:when>
  <xsl:when test="$jobcode='W001003'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001004'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001005'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001006'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001007'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001008'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001009'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001010'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001011'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001012'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001001'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001002'">9210101</xsl:when>
  <xsl:when test="$jobcode='W002001'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002002'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002003'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002004'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002005'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002006'">9210106</xsl:when>
  <xsl:when test="$jobcode='X001001'">9210101</xsl:when>
  <xsl:when test="$jobcode='X001002'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001003'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001004'">9210108</xsl:when>
  <xsl:when test="$jobcode='X001005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001006'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001008'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001010'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001012'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001014'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001019'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001021'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001023'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002025'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002026'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002027'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002028'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002029'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002030'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002031'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002032'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002033'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002034'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002035'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002036'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002037'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002038'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002039'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002040'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002019'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002021'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002023'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004007'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004008'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004009'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004010'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004011'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004012'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004013'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004014'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004015'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004016'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004017'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004018'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y005001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y005002'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005003'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005004'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005005'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005006'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005007'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005008'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005009'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005010'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005011'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005012'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y006001'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006003'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006005'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y006006'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y006007'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006009'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006011'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006013'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006015'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006017'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006019'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006021'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006023'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006025'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006026'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006027'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006028'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006029'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006030'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006031'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006032'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006033'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006034'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006035'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006036'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006037'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006038'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006039'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006040'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006041'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006042'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006046'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006047'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006048'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006049'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006050'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006051'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006052'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006053'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006054'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006055'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006056'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006057'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006058'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006059'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006060'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006061'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006062'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006063'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006064'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006065'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006066'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006067'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006068'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006069'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006070'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001003'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001005'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001007'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001009'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002002'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002003'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002004'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002005'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002006'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z003001'">9210108</xsl:when>
  <xsl:when test="$jobcode='Z004001'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004002'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004003'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004004'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004006'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004008'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004009'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004010'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004011'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004012'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004013'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004014'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004015'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004016'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004017'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004018'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004019'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004020'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004021'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004022'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004023'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004024'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004025'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004026'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004027'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004028'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004029'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004030'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004033'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004034'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004035'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004036'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004037'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004038'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004039'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004040'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004041'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004042'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004043'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004044'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004045'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004046'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004047'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004048'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004049'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004050'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004051'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004052'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004053'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004054'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004031'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004032'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004055'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004065'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004056'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004066'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004057'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004067'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004058'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004068'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004059'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004069'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004060'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004070'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004061'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004062'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004063'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004064'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005001'">9210102</xsl:when>
  <xsl:when test="$jobcode='Z005002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Z005003'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005004'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005005'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005006'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005007'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005008'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005009'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005010'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005011'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005010'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005011'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005012'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005013'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005014'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005015'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005016'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005017'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z006001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006004'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006005'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008004'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008005'">9210101</xsl:when>  
                           	
	<!--  <xsl:when test="$jobcode=5">8010101</xsl:when>	无业 -->	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取方式 -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="bonusgetmode" />
<xsl:choose>
	<xsl:when test="$bonusgetmode=1">1</xsl:when>	<!-- 累计生息 -->
	<xsl:when test="$bonusgetmode=2">3</xsl:when>	<!-- 抵交保费 -->
	<xsl:when test="$bonusgetmode=3">5</xsl:when>	<!-- 增额交清 -->
	<xsl:when test="$bonusgetmode=4">4</xsl:when>	<!-- 直接给付  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 居民来源 -->
<xsl:template match="TBR_AVR_TYPE">
	<xsl:choose>
		<xsl:when test=".='2'">1</xsl:when><!--	城镇 -->
		<xsl:when test=".='1'">2</xsl:when><!--	农村 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 保单递送方式 -->
<xsl:template name="tran_getPolMode">
<xsl:param name="getPolMode" />
<xsl:choose>
	<xsl:when test="$getPolMode=1">1</xsl:when>	<!-- 邮寄 -->
	<xsl:when test="$getPolMode=4">2</xsl:when>	<!-- 银行柜面领取 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 国家 -->
<xsl:template match="COUNTRY_CODE">
	<xsl:choose>
		<xsl:when test=".='ABW'">AW</xsl:when><!--	阿鲁巴 -->
		<xsl:when test=".='AFG'">AF</xsl:when><!--	阿富汗 -->
        <xsl:when test=".='AGO'">AO</xsl:when><!--  安哥拉        -->
        <xsl:when test=".='AIA'">AI</xsl:when><!--  安圭拉        -->
        <xsl:when test=".='ALB'">AL</xsl:when><!--  阿尔巴尼亚    -->
        <xsl:when test=".='AND'">AD</xsl:when><!--  安道尔        -->
        <xsl:when test=".='ANT'">AN</xsl:when><!--  荷属安第刑斯  -->
        <xsl:when test=".='ARE'">AE</xsl:when><!--  阿联酋        -->
        <xsl:when test=".='ARG'">AR</xsl:when><!--  阿根廷        -->
        <xsl:when test=".='ARM'">AM</xsl:when><!--  阿美尼亚      -->
        <xsl:when test=".='ASM'">AS</xsl:when><!--  东萨摩亚      -->
        <xsl:when test=".='ATA'">OTH</xsl:when><!-- 其他          -->
        <xsl:when test=".='ATG'">AG</xsl:when><!--  安提瓜和巴布达-->
        <xsl:when test=".='AUS'">AU</xsl:when><!--  澳大利亚   -->
        <xsl:when test=".='AUT'">AT</xsl:when><!--  奥地利     -->
        <xsl:when test=".='AZE'">AZ</xsl:when><!--  阿塞拜疆   -->
        <xsl:when test=".='BDI'">BI</xsl:when><!--  布隆迪     -->
        <xsl:when test=".='BEL'">BE</xsl:when><!--  比利时     -->
        <xsl:when test=".='BEN'">BJ</xsl:when><!--  贝宁       -->
        <xsl:when test=".='BFA'">BF</xsl:when><!--  布基纳法索 -->
        <xsl:when test=".='BGD'">BD</xsl:when><!--  孟加拉     -->
        <xsl:when test=".='BGR'">BG</xsl:when><!--  保加利亚   -->
        <xsl:when test=".='BHR'">BH</xsl:when><!--  巴林       -->
        <xsl:when test=".='BHS'">BS</xsl:when><!--  巴哈马     -->
        <xsl:when test=".='BIH'">BA</xsl:when><!--  波斯尼亚－黑塞哥维那  -->
        <xsl:when test=".='BLR'">BY</xsl:when><!--  白俄罗斯  -->
        <xsl:when test=".='BLZ'">BZ</xsl:when><!--  伯利兹    -->
        <xsl:when test=".='BMU'">BM</xsl:when><!--  百慕大    -->
        <xsl:when test=".='BOL'">BO</xsl:when><!--  玻利维亚  -->
        <xsl:when test=".='BRA'">BR</xsl:when><!--  巴西      -->
        <xsl:when test=".='BRB'">BB</xsl:when><!--  巴巴多期  -->
        <xsl:when test=".='BRN'">BN</xsl:when><!--  文莱      -->
        <xsl:when test=".='BTN'">BT</xsl:when><!--  布丹      -->
        <xsl:when test=".='BVT'">OTH</xsl:when><!--  其他     -->
        <xsl:when test=".='BWA'">BW</xsl:when><!--  博茨瓦纳  -->
        <xsl:when test=".='CAF'">CF</xsl:when><!--  中非共和国-->
        <xsl:when test=".='CAN'">CA</xsl:when><!--  加拿大    -->
        <xsl:when test=".='CCK'">OTH</xsl:when><!--  其他     -->
        <xsl:when test=".='CHE'">CH</xsl:when><!--  瑞士      -->
        <xsl:when test=".='CHL'">CL</xsl:when><!--  智利      -->
        <xsl:when test=".='CHN'">CHN</xsl:when><!--  中国     -->
        <xsl:when test=".='CIV'">CI</xsl:when><!--  科特迪亚  -->
        <xsl:when test=".='CMR'">CM</xsl:when><!--  喀麦隆        -->
        <xsl:when test=".='COD'">CG</xsl:when><!--  刚果（金）    -->
        <xsl:when test=".='COG'">ZR</xsl:when><!--  刚果（布）    -->
        <xsl:when test=".='COK'">CK</xsl:when><!--  库克群岛      -->
        <xsl:when test=".='COL'">CO</xsl:when><!--  哥伦比亚      -->
        <xsl:when test=".='COM'">KM</xsl:when><!--  科摩罗群岛    -->
        <xsl:when test=".='CPV'">CV</xsl:when><!--  佛得角群岛    -->
        <xsl:when test=".='CRI'">CR</xsl:when><!--  哥斯达黎加    -->
        <xsl:when test=".='CUB'">CU</xsl:when><!--  古巴          -->
        <xsl:when test=".='CSR'">OTH</xsl:when><!--  其他         -->
        <xsl:when test=".='CYM'">KY</xsl:when><!--  开曼群岛      -->
        <xsl:when test=".='CYP'">CY</xsl:when><!--  塞浦路斯      -->
        <xsl:when test=".='CZE'">CZ</xsl:when><!--  捷克共和国    -->
        <xsl:when test=".='DEU'">DE</xsl:when><!--  德国          -->
        <xsl:when test=".='DJI'">DJ</xsl:when><!--  吉布提        -->
        <xsl:when test=".='DMA'">DM</xsl:when><!--  多米尼加联邦  -->
        <xsl:when test=".='DNK'">DK</xsl:when><!--  丹麦          -->
        <xsl:when test=".='DOM'">DO</xsl:when><!--  多米尼加共和国-->
        <xsl:when test=".='DZA'">DZ</xsl:when><!--  阿尔及尼亚 -->
        <xsl:when test=".='ECU'">EC</xsl:when><!--  厄瓜多尔   -->
        <xsl:when test=".='EGY'">EG</xsl:when><!--  埃及       -->
        <xsl:when test=".='ERI'">ER</xsl:when><!--  厄立特里亚 -->
        <xsl:when test=".='ESH'">OTH</xsl:when><!--   其他     -->   
        <xsl:when test=".='ESP'">ES</xsl:when><!--   西班牙    -->
        <xsl:when test=".='EST'">EE</xsl:when><!--   爱沙尼亚  -->
        <xsl:when test=".='ETH'">ET</xsl:when><!--   埃塞俄比亚-->
        <xsl:when test=".='FIN'">FI</xsl:when><!--   芬兰      -->
        <xsl:when test=".='FJI'">FJ</xsl:when><!--   斐济      -->
        <xsl:when test=".='FLK'">OTH</xsl:when><!--   其他     -->
        <xsl:when test=".='FRA'">FR</xsl:when><!--   法国      -->
        <xsl:when test=".='FRO'">FO</xsl:when><!--  罗群岛     -->
        <xsl:when test=".='FSM'">OTH</xsl:when><!-- 渌?        -->
        <xsl:when test=".='GAB'">GA</xsl:when><!--   加蓬      -->
        <xsl:when test=".='GBR'">GB</xsl:when><!--   英国      -->
        <xsl:when test=".='GEO'">GE</xsl:when><!--   格鲁吉亚  -->
        <xsl:when test=".='GHA'">GH</xsl:when><!--   加纳      -->
        <xsl:when test=".='GIB'">GI</xsl:when><!--   直布罗陀  -->
        <xsl:when test=".='GIN'">GN</xsl:when><!--   几内亚    -->
        <xsl:when test=".='GLP'">GP</xsl:when><!--   瓜德罗普  -->
        <xsl:when test=".='GMB'">GM</xsl:when><!--   冈比亚    -->
        <xsl:when test=".='GNB'">GW</xsl:when><!--   几内亚比绍 -->
        <xsl:when test=".='GNQ'">GQ</xsl:when><!--   赤道几内亚 -->
        <xsl:when test=".='GRC'">GR</xsl:when><!--   希腊       -->
        <xsl:when test=".='GRD'">GD</xsl:when><!--   格林纳达   -->
        <xsl:when test=".='GRL'">GL</xsl:when><!--   格林兰岛   -->
        <xsl:when test=".='GTM'">GT</xsl:when><!--   危地马拉   -->
        <xsl:when test=".='GUF'">GF</xsl:when><!--   法属圭亚那 -->
        <xsl:when test=".='ATF'">OTH</xsl:when><!--   其他      -->
        <xsl:when test=".='GUM'">GU</xsl:when><!--   关岛       -->
        <xsl:when test=".='GUY'">GY</xsl:when><!--   圭亚那     -->
        <xsl:when test=".='HKG'">CHN</xsl:when><!--   中国      -->
        <xsl:when test=".='HMD'">OTH</xsl:when><!--   其他      -->
        <xsl:when test=".='HND'">HN</xsl:when><!--   洪都拉斯   -->
        <xsl:when test=".='HRV'">HR</xsl:when><!--   克罗地亚   -->
        <xsl:when test=".='HTI'">HT</xsl:when><!--   海地       -->
        <xsl:when test=".='HUN'">HU</xsl:when><!--   匈牙利     -->
        <xsl:when test=".='IDN'">ID</xsl:when><!--   印度尼西亚 -->
        <xsl:when test=".='IND'">IN</xsl:when><!--   印度       -->
        <xsl:when test=".='IOT'">OTH</xsl:when><!--   其他      -->
        <xsl:when test=".='IRL'">IE</xsl:when><!--   爱尔兰     -->
        <xsl:when test=".='IRN'">IR</xsl:when><!--   伊朗   -->
        <xsl:when test=".='IRQ'">IQ</xsl:when><!--   伊拉克 -->
        <xsl:when test=".='ISL'">IS</xsl:when><!--   冰岛   -->
        <xsl:when test=".='ISR'">IL</xsl:when><!--   以色列 -->
        <xsl:when test=".='ITA'">IT</xsl:when><!--   意大利 -->
        <xsl:when test=".='JAM'">JM</xsl:when><!--   牙买加 -->
        <xsl:when test=".='JOR'">JO</xsl:when><!--   约旦   -->
        <xsl:when test=".='JPN'">JP</xsl:when><!--   日本   -->
        <xsl:when test=".='KAZ'">KZ</xsl:when><!--   哈萨克斯坦-->
        <xsl:when test=".='KEN'">KE</xsl:when><!--   肯尼亚    -->
        <xsl:when test=".='KGZ'">KG</xsl:when><!--   吉尔吉思  -->
        <xsl:when test=".='KHM'">KH</xsl:when><!--   柬埔寨    -->
        <xsl:when test=".='KIR'">KT</xsl:when><!--   基利巴斯  -->
        <xsl:when test=".='KNA'">SX</xsl:when><!--   圣基茨和尼维斯岛-->
        <xsl:when test=".='KOR'">KR</xsl:when><!--   韩国      -->
        <xsl:when test=".='KWT'">KW</xsl:when><!--   科威特    -->
        <xsl:when test=".='LAO'">LA</xsl:when><!--   老挝      -->
        <xsl:when test=".='LBN'">LB</xsl:when><!--   黎巴嫩    -->
        <xsl:when test=".='LBR'">LR</xsl:when><!--   利比里亚  -->
        <xsl:when test=".='LBY'">LY</xsl:when><!--   利比亚    -->
        <xsl:when test=".='LCA'">SQ</xsl:when><!--   圣卢西亚  -->
        <xsl:when test=".='LIE'">LI</xsl:when><!--   列支敦士登-->
        <xsl:when test=".='LKA'">LK</xsl:when><!--   斯里兰卡  -->
        <xsl:when test=".='LSO'">LS</xsl:when><!--   莱索托    -->
        <xsl:when test=".='LTU'">LT</xsl:when><!--   立陶宛    -->
        <xsl:when test=".='LUX'">LU</xsl:when><!--   卢森堡    -->
        <xsl:when test=".='LVA'">LV</xsl:when><!--   拉脱维亚  -->
        <xsl:when test=".='MAC'">CHN</xsl:when><!--   中国     -->
        <xsl:when test=".='MAR'">MA</xsl:when><!--   摩洛哥    -->
        <xsl:when test=".='MCO'">MC</xsl:when><!--   摩纳哥    -->
        <xsl:when test=".='MDA'">MD</xsl:when><!--   摩尔多瓦  -->
        <xsl:when test=".='MDG'">MG</xsl:when><!--   马达加斯加-->
        <xsl:when test=".='MDV'">MV</xsl:when><!--   马尔代夫  -->
        <xsl:when test=".='MEX'">MX</xsl:when><!--   墨西哥    -->
        <xsl:when test=".='MHL'">MH</xsl:when><!--   马召尔群岛-->
        <xsl:when test=".='MKD'">MK</xsl:when><!--   马其顿    -->
        <xsl:when test=".='MLI'">ML</xsl:when><!--   马里      -->
        <xsl:when test=".='MLT'">MT</xsl:when><!--   马耳他    -->
        <xsl:when test=".='MMR'">MM</xsl:when><!--   缅甸      -->
        <xsl:when test=".='MNG'">MN</xsl:when><!--    蒙古     -->
        <xsl:when test=".='MNP'">MP</xsl:when><!--    北马里亚纳群岛-->
        <xsl:when test=".='MOZ'">MZ</xsl:when><!--    莫桑比克      -->
        <xsl:when test=".='MRT'">MR</xsl:when><!--    毛里塔尼亚    -->
        <xsl:when test=".='MSR'">MS</xsl:when><!--    蒙特塞拉特    -->
        <xsl:when test=".='MTQ'">MQ</xsl:when><!--    马提尼克      -->
        <xsl:when test=".='MUS'">MU</xsl:when><!--    毛里求斯      -->
        <xsl:when test=".='MWI'">MW</xsl:when><!--    马拉维        -->
        <xsl:when test=".='MYS'">MY</xsl:when><!--    马来西亚      -->
        <xsl:when test=".='MYT'">YT</xsl:when><!--    马约特岛      -->
        <xsl:when test=".='NAM'">NA</xsl:when><!--    纳米比亚      -->
        <xsl:when test=".='NCL'">NC</xsl:when><!--    新客里多尼亚-->
        <xsl:when test=".='NER'">NE</xsl:when><!--    尼日尔      -->
        <xsl:when test=".='NFK'">NF</xsl:when><!--    诺福克群岛  -->
        <xsl:when test=".='NGA'">NG</xsl:when><!--    尼日利亚    -->
        <xsl:when test=".='NIC'">NI</xsl:when><!--    尼加拉瓜    -->
        <xsl:when test=".='NIU'">NU</xsl:when><!--    纽埃岛      -->
        <xsl:when test=".='NLD'">NL</xsl:when><!--    荷兰        -->
        <xsl:when test=".='NOR'">NO</xsl:when><!--    挪威        -->
        <xsl:when test=".='NPL'">NP</xsl:when><!--    尼泊尔      -->
        <xsl:when test=".='NRU'">NR</xsl:when><!--    瑙鲁        -->
        <xsl:when test=".='NZL'">NZ</xsl:when><!--    新西兰      -->
        <xsl:when test=".='OMN'">OM</xsl:when><!--    阿曼        -->
        <xsl:when test=".='PAK'">PK</xsl:when><!--    巴基斯坦-->
        <xsl:when test=".='PAN'">PA</xsl:when><!--    巴拿马  -->
        <xsl:when test=".='PCN'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='PER'">PE</xsl:when><!--    秘鲁    -->
        <xsl:when test=".='PHL'">PH</xsl:when><!--    菲律宾  -->
        <xsl:when test=".='PLW'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='PNG'">PG</xsl:when><!--    巴布亚新几内亚-->
        <xsl:when test=".='POL'">PL</xsl:when><!--    波兰    -->
        <xsl:when test=".='PRI'">PR</xsl:when><!--    波多黎各-->
        <xsl:when test=".='PRK'">KP</xsl:when><!--    朝鲜    -->
        <xsl:when test=".='PRT'">PT</xsl:when><!--    葡萄牙  -->
        <xsl:when test=".='PRY'">PY</xsl:when><!--    巴拉圭  -->
        <xsl:when test=".='PSE'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='PYF'">PF</xsl:when><!--    法属波利尼西亚-->
        <xsl:when test=".='QAT'">QA</xsl:when><!--    卡塔尔    -->
        <xsl:when test=".='REU'">RE</xsl:when><!--    留尼汪岛  -->
        <xsl:when test=".='ROM'">RO</xsl:when><!--    罗马尼亚  -->
        <xsl:when test=".='RUS'">RU</xsl:when><!--    俄罗斯    -->
        <xsl:when test=".='RWA'">RW</xsl:when><!--    卢旺达    -->
        <xsl:when test=".='SAU'">SA</xsl:when><!--    沙特阿拉伯-->
        <xsl:when test=".='CSR'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='SCG'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='SDN'">SD</xsl:when><!--    苏丹    -->
        <xsl:when test=".='SEN'">SN</xsl:when><!--    塞内加尔-->
        <xsl:when test=".='SGP'">SG</xsl:when><!--    新加坡  -->
        <xsl:when test=".='SGS'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='SHN'">OTH</xsl:when><!--    其他   -->
        <xsl:when test=".='SJM'">OTH</xsl:when><!--  其他     -->
        <xsl:when test=".='SLB'">SB</xsl:when><!--  所罗门群岛-->
        <xsl:when test=".='SLE'">SL</xsl:when><!--  塞拉里昂  -->
        <xsl:when test=".='SLV'">SV</xsl:when><!--  萨尔瓦多  -->
        <xsl:when test=".='SMR'">SM</xsl:when><!--  圣马力诺  -->
        <xsl:when test=".='SOM'">SO</xsl:when><!--  索马里    -->
        <xsl:when test=".='SPM'">OTH</xsl:when><!--  其他     -->
        <xsl:when test=".='STP'">ST</xsl:when><!--  圣多美和普林西比-->
        <xsl:when test=".='SUR'">SR</xsl:when><!--  苏里南    -->
        <xsl:when test=".='SVK'">SK</xsl:when><!--  斯洛伐克  -->
        <xsl:when test=".='SVN'">SI</xsl:when><!--  斯洛文尼亚-->
        <xsl:when test=".='SWE'">SE</xsl:when><!--  瑞典      -->
        <xsl:when test=".='SWZ'">SZ</xsl:when><!--  斯威士兰  -->
        <xsl:when test=".='SYC'">SC</xsl:when><!--  塞舌尔    -->
        <xsl:when test=".='SYR'">SY</xsl:when><!--  叙利亚    -->
        <xsl:when test=".='TCA'">TC</xsl:when><!--  特克斯和凯科斯群岛    -->
        <xsl:when test=".='TCD'">TD</xsl:when><!--  乍得 -->
        <xsl:when test=".='TGO'">TG</xsl:when><!--  多哥 -->
        <xsl:when test=".='THA'">TH</xsl:when><!--  泰国 -->
        <xsl:when test=".='TJK'">TJ</xsl:when><!--  塔吉克斯坦 -->
        <xsl:when test=".='TKL'">OTH</xsl:when><!--  其他      -->
        <xsl:when test=".='TKM'">TM</xsl:when><!--  土库曼斯坦 -->
        <xsl:when test=".='TMP'">OTH</xsl:when><!--  其他      -->
        <xsl:when test=".='TON'">TO</xsl:when><!--  汤加       -->
        <xsl:when test=".='TTO'">OTH</xsl:when><!--  其他      -->
        <xsl:when test=".='TUN'">TN</xsl:when><!--  突尼斯     -->
        <xsl:when test=".='TUR'">TR</xsl:when><!--  土耳其     -->
        <xsl:when test=".='TUV'">TV</xsl:when><!--  图瓦卢     -->
        <xsl:when test=".='TWN'">CHN</xsl:when><!--  中国      -->
        <xsl:when test=".='TZA'">TZ</xsl:when><!--  坦桑尼亚   -->
        <xsl:when test=".='UGA'">UG</xsl:when><!--  乌干达 -->
        <xsl:when test=".='UKR'">UA</xsl:when><!--  乌克兰 -->
        <xsl:when test=".='UMI'">OTH</xsl:when><!--  其他  -->
        <xsl:when test=".='URY'">UY</xsl:when><!--  乌拉圭 -->
        <xsl:when test=".='USA'">US</xsl:when><!--  美国   -->
        <xsl:when test=".='UZB'">UZ</xsl:when><!--  乌兹别克斯坦 -->
        <xsl:when test=".='VAT'">OTH</xsl:when><!--  其他        -->
        <xsl:when test=".='VCT'">VC</xsl:when><!--  圣文斯特     -->
        <xsl:when test=".='VEN'">VE</xsl:when><!--  委内瑞拉     -->
        <xsl:when test=".='VGB'">VG</xsl:when><!--  英属维尔京群岛-->
        <xsl:when test=".='VIR'">VI</xsl:when><!--  美属维尔京群岛-->
        <xsl:when test=".='VNM'">VN</xsl:when><!--  越南     -->
        <xsl:when test=".='VUT'">VU</xsl:when><!--  瓦努阿图 -->
        <xsl:when test=".='WLF'">OTH</xsl:when><!--  其他    -->
        <xsl:when test=".='WSM'">WS</xsl:when><!--  萨摩亚-->
        <xsl:when test=".='YEM'">YE</xsl:when><!--  也门  -->
        <xsl:when test=".='ZAF'">ZA</xsl:when><!--  南非  -->
        <xsl:when test=".='ZAR'">OTH</xsl:when><!--  其他   -->
        <xsl:when test=".='ZMB'">ZM</xsl:when><!--  赞比亚  -->
        <xsl:when test=".='ZWE'">ZW</xsl:when><!--  津巴布韦-->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
