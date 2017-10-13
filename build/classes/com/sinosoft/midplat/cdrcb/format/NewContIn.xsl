<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/INSUREQ">
<TranData>    
	<xsl:apply-templates select="MAIN" />
	
	<Body>
		<ProposalPrtNo><xsl:value-of select="MAIN/APPLNO" /></ProposalPrtNo> <!-- 投保单(印刷)号 -->
		<ContPrtNo></ContPrtNo> <!-- 保单合同印刷号 -->
		<PolApplyDate><xsl:value-of select="MAIN/TB_DATE" /></PolApplyDate> <!-- 投保日期 -->
		
		<!--出单网点名称-->
		<AgentComName><xsl:value-of select="MAIN/BRACH_NAME"/></AgentComName>
		<!--银行销售人员工号-->
		<SellerNo><xsl:value-of select="MAIN/TELLER_NO"/></SellerNo>
				
		<AccName><xsl:value-of select="MAIN/PAYACC_NAME" /></AccName> <!-- 账户姓名 -->
		<AccNo><xsl:value-of select="MAIN/PAYACC" /></AccNo> <!-- 银行账户 -->
		<GetPolMode></GetPolMode> <!-- 保单递送方式 -->
		<JobNotice></JobNotice>   <!-- 职业告知(N/Y) -->
		<HealthNotice><xsl:value-of select="MAIN/HEALTH_NOTICE_FLAG" /></HealthNotice> <!-- 健康告知(N/Y)  -->	
		<PolicyIndicator></PolicyIndicator><!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount><!--累计投保身故保额-->
        
        <!-- 产品组合 -->
        <ContPlan>
        	<!-- 产品组合编码 -->
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="PRODUCTS/PRODUCT/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:value-of select="PRODUCTS/PRODUCT/AMT_UNIT" />
			</ContPlanMult>
        </ContPlan>
        
        
		<!-- 投保人 -->
		<xsl:apply-templates select="TBR" />
		
		<!-- 被保人 -->
		<xsl:apply-templates select="BBR" />		
		
		<!-- 受益人 -->
		<xsl:for-each select="SYRS/SYR">
			<xsl:choose>
				<xsl:when test="SYR_NAME!=''">
					<Bnf>
						<Type>1</Type>	<!-- 默认为“1-身故受益人” -->
					    <Grade><xsl:value-of select="SYR_ORDER" /></Grade> <!-- 受益顺序 -->
					    <Name><xsl:value-of select="SYR_NAME" /></Name> <!-- 姓名 -->
					    <Sex><xsl:value-of select="SYR_SEX" /></Sex> <!-- 性别 -->
					    <Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday> <!-- 出生日期(yyyyMMdd) -->
					    <IDType>
					        <xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="SYR_CERT_TYPE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </IDType> <!-- 证件类型 -->
					    <IDNo><xsl:value-of select="SYR_CERT_NO" /></IDNo> <!-- 证件号码 -->
					    <RelaToInsured>
					        <xsl:call-template name="tran_relation">
								<xsl:with-param name="relation">
									<xsl:value-of select="SYR_BBR_RELATE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </RelaToInsured> <!-- 与被保人关系 -->
					    <Lot><xsl:value-of select="SYR_BNFT_PROFIT" /></Lot> <!-- 受益比例(整数，百分比) -->
					</Bnf>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- 险种信息 -->
		<xsl:apply-templates select="PRODUCTS/PRODUCT" />			
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="MAIN">
<Head>
	<TranDate><xsl:value-of select="TRANSRDATE"/></TranDate>
    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
    <TellerNo><xsl:value-of select="TELLER_NO"/></TellerNo>
    <TranNo><xsl:value-of select="TRANSRNO"/></TranNo>
    <NodeNo><xsl:value-of select="BRACH_NO"/></NodeNo>
    <xsl:copy-of select="../Head/*"/>
    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<!-- 投保人 -->
<xsl:template name="Appnt" match="TBR">
<Appnt>
	<Name><xsl:value-of select="TBR_NAME" /></Name> <!-- 姓名 -->
	<Sex><!-- 性别 -->
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="TBR_SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday><!-- 出生日期(yyyyMMdd) -->
	<IDType><!-- 证件类型 -->
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype">
				<xsl:value-of select="TBR_CERT_TYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="TBR_CERT_NO" /></IDNo><!-- 证件号码 -->
	<IDTypeStartDate></IDTypeStartDate > <!-- 证件有效起期 -->
    <IDTypeEndDate></IDTypeEndDate > <!-- 证件有效止期 -->
	<JobCode>
	    <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="../MAIN/WORK_NOTICE_FLAG"/>
			</xsl:with-param>
		</xsl:call-template></JobCode> <!-- 职业代码 -->
		
	<!-- 投保人年收入，银行单位元，保险公司单位分 -->
	<Salary>
		<xsl:choose>
			<xsl:when test="TBR_AVR_SALARY=''">
				<xsl:value-of select="TBR_AVR_SALARY" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVR_SALARY)"/>
			</xsl:otherwise>
		</xsl:choose>
	</Salary>
	
	<!-- 客户类型 -->
	<LiveZone>
		<xsl:apply-templates select="TBR_AVR_TYPE" />
	</LiveZone>
	
    <Nationality>CHN</Nationality> <!-- 国籍 -->
    <Stature></Stature> <!-- 身高(cm) -->
    <Weight></Weight> <!-- 体重(kg) -->
    <MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
    <Address><xsl:value-of select="TBR_ADDR" /></Address> <!-- 地址 -->
    <ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode> <!-- 邮编 -->
    <Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile> <!-- 移动电话 -->
    <Phone><xsl:value-of select="TBR_TEL" /></Phone> <!-- 固定电话 -->
    <Email></Email> <!-- 电子邮件-->
    <RelaToInsured>
    	<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation">
				<xsl:value-of select="TBR_BBR_RELATE"/>
			</xsl:with-param>
		</xsl:call-template>
    </RelaToInsured> <!-- 与被保人关系 -->
</Appnt>
</xsl:template>

<!-- 被保人 -->
<xsl:template name="Insured" match="BBR">
<Insured>
	<Name><xsl:value-of select="BBR_NAME" /></Name> <!-- 姓名 -->
    <Sex><!-- 性别 -->
        <xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="BBR_SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
    <Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday> <!-- 出生日期(yyyyMMdd) -->
    <IDType> <xsl:call-template name="tran_idtype">
		    <xsl:with-param name="idtype">
				<xsl:value-of select="BBR_CERT_TYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType> <!-- 证件类型 -->
    <IDNo><xsl:value-of select="BBR_CERT_NO" /></IDNo> <!-- 证件号码 -->
    <IDTypeStartDate></IDTypeStartDate > <!-- 证件有效起期 -->
    <IDTypeEndDate></IDTypeEndDate > <!-- 证件有效止期 -->
    <JobCode>        
        <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="../MAIN/WORK_NOTICE_FLAG"/>
			</xsl:with-param>
		</xsl:call-template></JobCode> <!-- 职业代码 -->
    <Stature></Stature> <!-- 身高(cm)-->	
    <Nationality>CHN</Nationality> <!-- 国籍-->
    <Weight></Weight> <!-- 体重(kg) -->
    <MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
    <Address><xsl:value-of select="BBR_ADDR" /></Address> <!-- 地址 -->
    <ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode> <!-- 邮编 -->
    <Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile> <!-- 移动电话 -->
    <Phone><xsl:value-of select="BBR_TEL" /></Phone> <!-- 固定电话 -->
    <Email></Email> <!-- 电子邮件-->
</Insured>
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
			<xsl:with-param name="riskcode" select="../PRODUCT[MAINSUBFLG='0']/PRODUCTID" />
		</xsl:call-template>
	</MainRiskCode><!-- 主险险种代码 -->
	<RiskType><xsl:value-of select="PRODUCT_TYPE"/></RiskType><!-- 险种类型 -->
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMT)"/></Amnt><!-- 保额(分) -->
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIU_AMT)"/></Prem><!-- 保险费(分) -->
	<Mult><xsl:value-of select="AMT_UNIT"/></Mult><!-- 投保份数 -->
	<PayIntv><!-- 缴费频次 -->
		<xsl:call-template name="tran_PayIntv">
			<xsl:with-param name="payintv">
				<xsl:value-of select="../../MAIN/PAYMETHOD"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayIntv>
	<PayMode>
		<xsl:call-template name="tran_PayMode">
			<xsl:with-param name="paymode">
				<xsl:value-of select="../../MAIN/PAY_METHOD"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayMode><!-- 缴费形式 -->
	<InsuYearFlag><!-- 保险年期年龄标志 -->
		<xsl:call-template name="tran_InsuYearFlag">
			<xsl:with-param name="insuyearflag">
				<xsl:value-of
					select="COVERAGE_PERIOD" />
			</xsl:with-param>
		</xsl:call-template>
	</InsuYearFlag>
	<InsuYear><!-- 保终身 -->
		<xsl:if test="COVERAGE_PERIOD=5">106</xsl:if>
		<xsl:if test="COVERAGE_PERIOD!=5"><xsl:value-of select="COVERAGE_YEAR" /></xsl:if>
	</InsuYear>	
	<xsl:if test="../../MAIN/PAYMETHOD = 5"><!-- 趸交 -->
		<PayEndYearFlag>Y</PayEndYearFlag>
		<PayEndYear>1000</PayEndYear>
	</xsl:if>
	<xsl:if test="../../MAIN/PAYMETHOD != 5">
		<PayEndYearFlag>
		<xsl:call-template name="tran_PayEndYearFlag">
			<xsl:with-param name="payendyearflag">
				<xsl:value-of
					select="CHARGE_PERIOD" />
			</xsl:with-param>
		</xsl:call-template>
	    </PayEndYearFlag><!-- 缴费年期年龄标志 -->
		<PayEndYear><xsl:value-of select="CHARGE_YEAR"/></PayEndYear><!-- 缴费年期年龄 -->
	</xsl:if>

	<BonusGetMode>
		<xsl:call-template name="tran_BonusGetMode">
			<xsl:with-param name="bonusgetmode" select="DVDMETHOD" />
		</xsl:call-template>
	</BonusGetMode><!-- 红利领取方式 -->
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
  	<xsl:when test="$sex = 1">0</xsl:when>
  	<xsl:when test="$sex = 2">1</xsl:when>
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 证件类型 -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype=0">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test="$idtype=1">1</xsl:when>	<!-- 护照 -->
	<xsl:when test="$idtype=2">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test="$idtype=3">2</xsl:when>	<!-- 士兵证 -->
	<xsl:when test="$idtype=4">8</xsl:when>	<!-- 回乡证 -->
	<xsl:when test="$idtype=5">8</xsl:when>	<!-- 临时身份证 -->
	<xsl:when test="$idtype=6">5</xsl:when>	<!-- 户口薄 -->
	<xsl:when test="$idtype=7">2</xsl:when>	<!-- 警官证 -->
	<xsl:when test="$idtype=8">4</xsl:when>	<!-- 出生证 -->
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
	<xsl:if test="$payintv = '1'">12</xsl:if> <!-- 年缴 -->
	<xsl:if test="$payintv = '2'">6</xsl:if>  <!-- 半年交 -->
	<xsl:if test="$payintv = '3'">3</xsl:if>  <!-- 季交-->
	<xsl:if test="$payintv = '4'">1</xsl:if>  <!-- 月交 -->
	<xsl:if test="$payintv = '5'">0</xsl:if>  <!-- 趸交 -->
</xsl:template>

<!-- 缴费形式 -->
<xsl:template name="tran_PayMode">
<xsl:param name="paymode">0</xsl:param>
	<xsl:if test="$paymode = '1'">7</xsl:if> <!-- 银行转帐  -->
</xsl:template>
	
<!-- 保险年龄年期标志 -->
<xsl:template name="tran_InsuYearFlag">
<xsl:param name="insuyearflag" />
<xsl:choose>
	<xsl:when test="$insuyearflag=0">D</xsl:when>	<!-- 按日 -->
	<xsl:when test="$insuyearflag=1">M</xsl:when>	<!-- 按月 -->
	<xsl:when test="$insuyearflag=2">Y</xsl:when>	<!-- 按年 -->
	<xsl:when test="$insuyearflag=5">A</xsl:when>   <!-- 终身 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费年期年龄标志 -->
<xsl:template name="tran_PayEndYearFlag">
<xsl:param name="payendyearflag" />
<xsl:choose>
	<xsl:when test="$payendyearflag=0">D</xsl:when>	<!-- 按日 -->
	<xsl:when test="$payendyearflag=1">M</xsl:when>	<!-- 按月 -->
	<xsl:when test="$payendyearflag=2">Y</xsl:when>	<!-- 按年 -->
	<xsl:when test="$payendyearflag=5">A</xsl:when> <!-- 终身 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<!-- 即使银行和我司险种代码相同也要转换，为了限制某个银行只能卖的险种 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122006">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122008">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=50002">50015</xsl:when>	<!-- 安邦长寿稳赢1号两全保险组合 -->
	<!-- add by 20151109 PBKINSR-725:成都农商行上线盛2、盛3  begin-->
	<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12078'">L12078</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 
	<!-- 增加安邦东风5号两全保险（万能型） -->
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
	<!-- add by 20151109 PBKINSR-725:成都农商行上线盛2、盛3  begin-->
	<!-- add by duanjz 2015-6-17 增加安享5号组合产品    begin -->
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
	<!-- add by duanjz 2015-6-17 增加安享5号组合产品    end -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 产品组合代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- 50002(50015): 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
		<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
		<!-- add by duanjz 2015-6-17 增加安享5号组合产品    begin -->
		<!-- 50012 安邦长寿安享5号保险计划：主险：L12070（安邦长寿安享5号年金保险）、附加险L12071（安邦附加长寿添利5号两全保险（万能型）） -->
	    <xsl:when test="$contPlanCode='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
	    <!-- add by duanjz 2015-6-17 增加安享5号组合产品    end -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
    <xsl:when test="$jobcode=0">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
	<xsl:when test="$jobcode=1">3010102</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
	<xsl:when test="$jobcode=2">1020203</xsl:when>	<!-- 企业职能部门经理或主管 -->
	<xsl:when test="$jobcode=3">5010101</xsl:when>	<!-- 农夫-->
	<xsl:when test="$jobcode=4">2090114</xsl:when>	<!-- 学生 -->
	<xsl:when test="$jobcode=5">8010101</xsl:when>	<!-- 无业 -->	
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
		<xsl:when test=".='1'">1</xsl:when><!--	城镇 -->
		<xsl:when test=".='2'">2</xsl:when><!--	农村 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
