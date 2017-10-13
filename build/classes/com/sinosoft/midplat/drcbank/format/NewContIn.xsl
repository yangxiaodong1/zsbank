<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="TranData">
        <TranData>
            <xsl:apply-templates select="Head" />
            <Body>
                <xsl:apply-templates select="Body" />
            </Body>
        </TranData>
    </xsl:template>

    <!-- 报文头信息 -->
    <xsl:template name="Head" match="Head">
        <Head>
            <!-- 交易日期[yyyyMMdd] -->
            <TranDate>
                <xsl:value-of select="TranDate" />
            </TranDate>
            <!-- 交易时间[hhmmss] -->
            <TranTime>
                <xsl:value-of select="TranTime" />
            </TranTime>
            <!-- 柜员代码 -->
            <TellerNo>
                <xsl:value-of select="TellerNo" />
            </TellerNo>
            <!-- 交易流水号 -->
            <TranNo>
                <xsl:value-of select="TranNo" />
            </TranNo>
            <!-- 银行网点 哈行没有地区码 -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" /><xsl:value-of select="NodeNo" />
            </NodeNo>
            <xsl:copy-of select="FuncFlag" />
            <xsl:copy-of select="ClientIp" />
            <xsl:copy-of select="TranCom" />
            <BankCode>
                <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>

    <!-- 报文体信息 -->
    <xsl:template name="Body" match="Body">
        <xsl:variable name="MainRisk"
            select="Risk[RiskCode=MainRiskCode]" />
        <!-- 投保单(印刷)号 -->
        <ProposalPrtNo>
            <xsl:value-of select="ProposalPrtNo" />
        </ProposalPrtNo>
        <!-- 保单合同印刷号 -->
        <ContPrtNo>
            <xsl:value-of select="ContPrtNo" />
        </ContPrtNo>
        <!-- 投保日期[yyyyMMdd] -->
        <PolApplyDate>
            <xsl:value-of select="PolApplyDate" />
        </PolApplyDate>
        <!-- 账户姓名 -->
        <AccName>
            <xsl:value-of select="AccName" />
        </AccName>
        <!-- 银行账户 -->
        <AccNo>
            <xsl:value-of select="AccNo" />
        </AccNo>
        <!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
        <GetPolMode>
        	<xsl:value-of select="GetPolMode" />
        </GetPolMode>
        <!-- 职业告知(N/Y) -->
        <JobNotice>
            <xsl:value-of select="JobNotice" />
        </JobNotice>
        <!-- 健康告知(N/Y)  -->
        <HealthNotice>
            <xsl:value-of select="HealthNotice" />
        </HealthNotice>

        <!-- 产品组合 -->
        <ContPlan>
            <!-- 产品组合编码 -->
            <ContPlanCode>
                <xsl:call-template name="tran_ContPlanCode">
                    <xsl:with-param name="contPlanCode">
                        <xsl:value-of select="$MainRisk/RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </ContPlanCode>
            <!-- 产品组合份数 -->
            <ContPlanMult>
                <xsl:value-of select="$MainRisk/Mult" />
            </ContPlanMult>
        </ContPlan>
        <!--未成年被保险人是否在其他保险公司投保身故保险 Y是/N否-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!--累计投保身故保额(核心单位百元)-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount>
        <!--银行销售人员工号，保监会3号文增加该字段-->
        <SellerNo>
        	<xsl:value-of select="../Head/TellerNo" />
        </SellerNo>
        <!--出单网点名称-->
        <AgentComName>
            <xsl:value-of select="AgentComName" />
        </AgentComName>
        <!-- 网点许可证-->
        <AgentComCertiCode>
            <xsl:value-of select="AgentComCertiCode" />
        </AgentComCertiCode>
        <!--银行销售人员名称-->
        <TellerName>
            <xsl:value-of select="TellerName" />
        </TellerName>
        <!-- 销售人员资格证-->
        <TellerCertiCode>
            <xsl:value-of select="TellerCertiCode" />
        </TellerCertiCode>
        <!-- 销售人员电子邮箱-->
        <TellerEmail>
            <xsl:value-of select="TellerEmail" />
        </TellerEmail>
        <!-- 投保人 -->
        <Appnt>
            <xsl:apply-templates select="Appnt" />
        </Appnt>
        <!-- 被保人 -->
        <Insured>
            <xsl:apply-templates select="Insured" />
        </Insured>
        <!-- 受益人 -->
        <xsl:apply-templates select="Bnf" />

        <!-- 险种信息 -->
        <xsl:apply-templates select="Risk" />
    </xsl:template>
    
    <!-- 投保人信息 -->
    <xsl:template name="Appnt" match="Appnt">
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
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- 身高(cm)-->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- 体重(g)  -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- 投保人年收入(分) -->
		<xsl:choose>
			<xsl:when test="Salary=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="Salary" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 投保人家庭年收入(分) -->
		<xsl:choose>
			<xsl:when test="FamilySalary=''">
				<FamilySalary />
			</xsl:when>
			<xsl:otherwise>
				<FamilySalary>
					<xsl:value-of
						select="FamilySalary" />
				</FamilySalary>
			</xsl:otherwise>
		</xsl:choose>
        <!-- 1.城镇，2.农村 -->
        <LiveZone>
            <xsl:apply-templates select="LiveZone" />
        </LiveZone>
        <!-- 是否已进行风险评估问卷调查 -->
        <RiskAssess>
            <xsl:apply-templates select="EvalRisk" />
        </RiskAssess>
        <!-- 婚姻状况（银行无法增加录入项信息，非必填） -->
        <MaritalStatus>
            <xsl:value-of select="MaritalStatus" />
        </MaritalStatus>
        <!-- 地址 -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
        <!-- 投保人与被保人关系 -->
        <RelaToInsured>
            <xsl:value-of select="RelaToInsured" />
        </RelaToInsured>
    </xsl:template>


    <!-- 被保险人信息 -->
    <xsl:template name="Insured" match="Insured">
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
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- 身高（cm） -->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- 体重（kg） -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- 婚否 -->
        <MaritalStatus>
            <xsl:value-of select="MaritalStatus" />
        </MaritalStatus>
        <!-- 地址 -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
    </xsl:template>

    <!-- 受益人信息 -->
    <xsl:template match="Bnf">
        <Bnf>
            <Type>1</Type>
            <!-- 受益顺序 (整数，从1开始) -->
            <Grade>
                <xsl:value-of select="Grade" />
            </Grade>
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
                <xsl:value-of select="IDType" />
            </IDType>
            <!-- 证件号码 -->
            <IDNo>
                <xsl:value-of select="IDNo" />
            </IDNo>
            <!-- 证件有效起期（yyyymmdd） -->
            <IDTypeStartDate>
                <xsl:value-of select="IDTypeStartDate" />
            </IDTypeStartDate>
            <!-- 证件有效止期（yyyymmdd） -->
            <IDTypeEndDate>
                <xsl:value-of select="IDTypeEndDate" />
            </IDTypeEndDate>
            <!-- 受益人与被保险人关系 -->
            <RelaToInsured>
                <xsl:value-of select="RelaToInsured" />
            </RelaToInsured>
            <!-- 收益比例（整数） -->
            <Lot>
                <xsl:value-of select="Lot" />
            </Lot>
        </Bnf>
    </xsl:template>

    <!-- 险种信息 -->
    <xsl:template match="Risk">
        <Risk>
            <!-- 险种代码 -->
            <RiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">
                        <xsl:value-of select="RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </RiskCode>
            <!-- 主险险种代码 -->
            <MainRiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">
                        <xsl:value-of select="MainRiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </MainRiskCode>
            <!-- 保额(单位为分) ，暂时为空-->
            <Amnt>
                <xsl:value-of select="Amnt" />
            </Amnt>
            <!-- 保险费(单位为分)，按保费卖 -->
            <Prem>
                <xsl:value-of select="Prem" />
            </Prem>
            <!-- 投保份数，暂时为空- -->
            <Mult>
                <xsl:value-of select="Mult" />
            </Mult>
            <!-- 缴费形式 -->
            <PayMode></PayMode>
            <!-- 缴费频次 -->
            <PayIntv>
                <xsl:value-of select="PayIntv" />
            </PayIntv>
            <!-- 保险年期年龄标志 -->
            <InsuYearFlag>
                <xsl:value-of select="InsuYearFlag" />
            </InsuYearFlag>
            <!-- 保险年期年龄 保终身写死106-->
            <InsuYear>
                <xsl:value-of select="InsuYear" />
            </InsuYear>
            <!-- 缴费年期年龄标志 -->
            <PayEndYearFlag>
                <xsl:value-of select="PayEndYearFlag" />
            </PayEndYearFlag>
            <!-- 缴费年期年龄 趸交写死1000-->
            <PayEndYear>
                <xsl:value-of select="PayEndYear" />
            </PayEndYear>
            <!-- 红利领取方式 -->
            <BonusGetMode>
                <xsl:value-of select="BonusGetMode" />
            </BonusGetMode>
            <FullBonusGetMode></FullBonusGetMode>
        </Risk>
    </xsl:template>

    <!-- 产品组合代码 -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>
            <!-- 50002套餐-->
            <!-- PBKINSR-704 东莞农商行50002升级 -->
            <xsl:when test="$contPlanCode='50002'">50015</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>
        
        <xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
        <!-- <xsl:when test="$riskCode='L12089'">L12089</xsl:when>  --> <!-- 安邦盛世1号终身寿险（万能型） B款-->
        
        	<!-- PBKINSR-704 东莞农商行50002升级 -->
            <xsl:when test="$riskCode='50002'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->
        	<!-- -PBKINSR-780 东莞农商行黄金鼎5号产品升级 -->
            <xsl:when test="$riskCode='122009'">122009</xsl:when><!-- 黄金鼎5号产品 -->
            <!-- -PBKINSR-779 东莞农商行黄金鼎6号产品升级 -->
            <xsl:when test="$riskCode='122036'">122036</xsl:when><!-- 黄金鼎6号产品 -->
            <!-- PBKINSR-1298 zx add  -->
            <xsl:when test="$riskCode='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型） -->
            <xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
            <xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型） -->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- 是否已进行风险评估问卷调查 -->
	<xsl:template match="EvalRisk">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when>
			<xsl:when test=".='0'">N</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- 居民来源 1城镇,0农村 -->
	<xsl:template match="LiveZone">
		<xsl:choose>
			<xsl:when test=".='0'">2</xsl:when><!-- 农村 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 城镇 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
