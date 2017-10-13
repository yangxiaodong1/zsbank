<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="InsuReq">
        <TranData>
            <xsl:apply-templates select="Main" />
            <Body>
                <!-- 投保单(印刷)号 -->
                <ProposalPrtNo><xsl:value-of select="Main/ApplyNo" /></ProposalPrtNo>
                <!-- 保单合同印刷号 -->
                <ContPrtNo></ContPrtNo>
                <!-- 投保日期[yyyyMMdd] -->
                <PolApplyDate>
                   <xsl:value-of select="Main/ApplyDate" />
                </PolApplyDate>
                <!-- 账户姓名 -->
                <AccName>
                   <xsl:value-of select="Risks/Appendix/PayAccName" />
                </AccName>
                <!-- 银行账户 -->
                <AccNo>
                    <xsl:value-of select="Risks/Appendix/PayAcc" />
                </AccNo>
                <!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
                <GetPolMode><xsl:value-of select="Risks/Appendix/SendMethod" /></GetPolMode>
                <!-- 职业告知(N/Y) -->
                <JobNotice>
                    <xsl:value-of select="Risks/Appendix/OccupationFlag" />
                </JobNotice>
                <!-- 健康告知(N/Y)  -->
                <HealthNotice>
                    <xsl:value-of select="Risks/Appendix/HealthFlag" />
                </HealthNotice>
                <AutoPayFlag></AutoPayFlag>
                <!-- 产品组合 -->
                <ContPlan>
                	<!-- 产品组合编码 -->
                	<ContPlanCode>
                		<xsl:call-template name="tran_ContPlanCode">
                			<xsl:with-param name="contPlanCode">
                				<xsl:value-of select="Risks/Risk/Code" />
                			</xsl:with-param>
                		</xsl:call-template>
                	</ContPlanCode>
                	<!-- 产品组合份数 -->
                	<ContPlanMult><xsl:value-of select="Risks/Risk/Unit" /></ContPlanMult>
                </ContPlan>
                <!--未成年被保险人是否在其他保险公司投保身故保险 Y是/N否-->
               <PolicyIndicator></PolicyIndicator>
              <!--累计投保身故保额(核心单位百元)-->
              <InsuredTotalFaceAmount></InsuredTotalFaceAmount>
              <!--出单网点名称-->
              <AgentComName>
                 <xsl:value-of select="Main/BrName" />
              </AgentComName>
              <!-- 网点许可证-->
              <AgentComCertiCode>
                 <xsl:value-of select="Main/BrCertID" />
              </AgentComCertiCode>
              <!--银行销售人员工号-->
              <SellerNo>
                 <xsl:value-of select="Main/SellTeller" />
              </SellerNo>
              <!--银行销售人员名称-->
              <TellerName>
                 <xsl:value-of select="Main/SellTellerName" />
              </TellerName>
              <!-- 销售人员资格证-->
              <TellerCertiCode>
                 <xsl:value-of select="Main/SellCertID" />
              </TellerCertiCode>
              <!-- 销售人员电子邮箱-->
              <TellerEmail></TellerEmail>
              <!-- 投保人 -->
              <Appnt>
                <xsl:apply-templates select="Appnt" />
              </Appnt>
              <!-- 被保人 -->
              <Insured>
                <xsl:apply-templates select="Insured" />
              </Insured>
              <!-- 受益人 -->
              <xsl:apply-templates select="Bnfs" />
              <!-- 险种信息 -->
              <xsl:apply-templates select="Risks" />
           </Body>
        </TranData>
    </xsl:template>

    <!-- 报文头信息 -->
    <xsl:template name="Head" match="Main">
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
                <xsl:value-of select="TransNo" />
            </TranNo>
            <!-- 地区码+网点码 -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" />
                <xsl:value-of select="BrNo" />
            </NodeNo>
            <xsl:copy-of select="../Head/*" />
            <BankCode>
                <xsl:value-of select="../Head/TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>
    
    <!-- 投保人信息 -->
    <xsl:template name="Appnt" match="Appnt">
        <!-- 姓名 -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- 性别 -->
        <Sex>
            <xsl:apply-templates select="Sex" />
        </Sex>
        <!-- 出生日期(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- 证件类型 -->
        <IDType>
            <xsl:apply-templates select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
        <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>    
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:call-template name="tran_Nationality">
				<xsl:with-param name="Nationality" select="Nationality" />
				<xsl:with-param name="IDType" select="IDType" />
		    </xsl:call-template>
            <!--<xsl:apply-templates select="Nationality" />-->
        </Nationality>
        <!-- 身高(cm)-->
        <Stature></Stature>
        <!-- 体重(g)  -->
        <Weight></Weight>
        <!-- 投保人年收入(分) -->
        <Salary>
            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Income)" />
        </Salary>
        <!-- 投保人家庭年收入(分) -->
        <FamilySalary>
            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(FamilyIncome)" />
        </FamilySalary>
        <!-- 1.城镇，2.农村 -->
        <LiveZone>
           <xsl:apply-templates select="ResiType" />
        </LiveZone>
        <!-- 是否已进行风险评估问卷调查 -->
        <RiskAssess>
           <xsl:choose>
    		  <xsl:when test="../Risks/Appendix/RiskAssess != ''">
    			<xsl:value-of select="../Risks/Appendix/RiskAssess" />
    		  </xsl:when>
    		  <xsl:otherwise>Y</xsl:otherwise>
    	   </xsl:choose>
        </RiskAssess>
        <!-- 婚姻状况（银行无法增加录入项信息，非必填） 银行是代码，需要确认核心代码进行映射？ -->
        <MaritalStatus>
            <xsl:value-of select="Marriage" />
        </MaritalStatus>
        <!-- 地址 是指通讯还是邮寄呢？-->
        <Address>
            <xsl:value-of select="HomeAddr" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="HomeZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="MobilePhone" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="HomePhone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
        <!-- 投保人与被保人关系 -->
        <RelaToInsured>
            <xsl:apply-templates select="RelaToInsured" />
        </RelaToInsured>
        <!-- 保费预算金额 -->
        <Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PremBudget)" /></Premiumbudget>
    </xsl:template>


    <!-- 被保险人信息 -->
    <xsl:template name="Insured" match="Insured">
        <!-- 姓名 -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- 性别 -->
        <Sex>
            <xsl:apply-templates select="Sex" />
        </Sex>
        <!-- 出生日期(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- 证件类型 -->
        <IDType>
            <xsl:apply-templates select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
        <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:call-template name="tran_Nationality">
				<xsl:with-param name="Nationality" select="Nationality" />
				<xsl:with-param name="IDType" select="IDType" />
		    </xsl:call-template>
            <!-- <xsl:apply-templates select="Nationality" /> -->
        </Nationality>
        <!-- 身高（cm） -->
        <Stature></Stature>
        <!-- 体重（kg） -->
        <Weight></Weight>
        <!-- 婚否 -->
        <MaritalStatus>
            <xsl:value-of select="Marriage" />
        </MaritalStatus>
        <!-- 地址 -->
        <Address>
            <xsl:value-of select="HomeAddr" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="HomeZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="MobilePhone" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="HomePhone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
    </xsl:template>

    <!-- 受益人信息 -->
    <xsl:template match="Bnfs">
       <xsl:for-each select="Bnf">
        <Bnf>
            <Type>1</Type>
            <!-- 受益顺序 (整数，从1开始) -->
            <Grade>
                <xsl:value-of select="Order" />
            </Grade>
            <!-- 姓名 -->
            <Name>
                <xsl:value-of select="Name" />
            </Name>
            <!-- 性别 -->
            <Sex>
                <xsl:apply-templates select="Sex" />
            </Sex>
            <!-- 出生日期(yyyyMMdd) -->
            <Birthday>
                <xsl:value-of select="Birthday" />
            </Birthday>
            <!-- 证件类型 -->
            <IDType>
                <xsl:apply-templates select="IDType" />
            </IDType>
            <!-- 证件号码 -->
            <IDNo>
                <xsl:value-of select="IDNo" />
            </IDNo>
            <!-- 证件有效起期（yyyymmdd） -->
            <IDTypeStartDate>
                <xsl:value-of select="IDStartDate" />
            </IDTypeStartDate>
            <!-- 证件有效止期（yyyymmdd）银行传值为99999999，需要确认核心终身有效默认值为什么？ -->
            <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
            <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>
            <!-- 受益人与被保险人关系 -->
            <RelaToInsured>
                <xsl:apply-templates select="RelationToInsured" />
            </RelaToInsured>
            <!-- 收益比例（整数） -->
            <Lot>
                <xsl:value-of select="Percent" />
            </Lot>
        </Bnf>
       </xsl:for-each>
    </xsl:template>

    <!-- 险种信息 -->
    <xsl:template match="Risks">
       <xsl:for-each select="Risk[MainSubFlag = '1']">
        <Risk>
            <!-- 险种代码 -->
            <RiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="Code">
                        <xsl:value-of select="Code" />
                    </xsl:with-param>
                </xsl:call-template>
            </RiskCode>
            <!-- 主险险种代码 -->
            <MainRiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="Code">
                        <xsl:value-of select="Code" />
                    </xsl:with-param>
                </xsl:call-template>
            </MainRiskCode>
            <!-- 保额(单位为分) ，暂时为空-->
            <Amnt>
                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsuAmount)" />
            </Amnt>
            <!-- 保险费(单位为分)，按保费卖 -->
            <Prem>
                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" />
            </Prem>
            <!-- 投保份数，暂时为空- -->
            <Mult>
                <xsl:value-of select="Unit" />
            </Mult>
            <!-- 缴费形式 -->
            <PayMode>A</PayMode>
            <!-- 缴费频次 -->
            <PayIntv>
                <xsl:apply-templates select="../Appendix/PayIntv" />
            </PayIntv>
            <!-- 保险年期年龄标志 -->
            <InsuYearFlag>
                <xsl:apply-templates select="InsuYearFlag" />
            </InsuYearFlag>
            <!-- 保险年期年龄 保终身写死106-->
            <InsuYear>
               <xsl:choose>
				  <xsl:when test="InsuYearFlag = '06'">106</xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="InsuYear" />
				  </xsl:otherwise>
			   </xsl:choose>
            </InsuYear>
            <!-- 缴费年期年龄标志 -->
            <PayEndYearFlag>
                <xsl:apply-templates select="PayEndYearFlag" />
            </PayEndYearFlag>
            <!-- 缴费年期年龄 趸交写死1000-->
            <PayEndYear>
               <xsl:choose>
				  <xsl:when test="PayEndYearFlag='01'">1000</xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="PayEndYear" />
				  </xsl:otherwise>
			   </xsl:choose>
            </PayEndYear>
            <!-- 红利领取方式 -->
            <BonusGetMode>
                <xsl:value-of select="../Appendix/BonusGetMode" />
            </BonusGetMode>
            <FullBonusGetMode></FullBonusGetMode>
            <!-- 领取年龄年期标志 -->
            <GetYearFlag></GetYearFlag> 
            <!-- 领取年龄 -->
            <GetYear></GetYear>
            <!-- 领取方式 -->
            <GetIntv></GetIntv>
            <!-- 领取银行编码 -->
            <GetBankCode></GetBankCode>
            <!-- 领取银行账户 -->
            <GetBankAccNo></GetBankAccNo>
            <!-- 领取银行户名 -->
            <GetAccName></GetAccName>
            <!-- 自动垫交标志 -->
            <AutoPayFlag></AutoPayFlag>
        </Risk>
        </xsl:for-each>
    </xsl:template>

    <!-- 缴费方式（频次） -->
	<xsl:template name="tran_payintv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='02'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='03'">6</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='04'">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".='05'">1</xsl:when><!-- 月缴 -->
			<xsl:when test=".='06'">-1</xsl:when><!-- 不定期缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=1">0</xsl:when><!-- 男 -->
			<xsl:when test=".=0">1</xsl:when><!-- 女 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when><!-- 居民身份证 -->
			<xsl:when test=".=02">0</xsl:when><!-- 临时身份证 -->
			<xsl:when test=".=03">1</xsl:when><!-- 护照 -->
			<xsl:when test=".=04">5</xsl:when><!-- 户口簿 -->
			<xsl:when test=".=05">2</xsl:when><!-- 军官身份证 -->
			<xsl:when test=".=06">2</xsl:when><!-- 武装警察身份证  -->
			<xsl:when test=".=08">8</xsl:when><!-- 外交人员身份证 -->
			<xsl:when test=".=09">8</xsl:when><!-- 外国人居留许可证-->
			<xsl:when test=".=10">8</xsl:when><!-- 边民出入境通行证簿 -->
			<xsl:when test=".=11">8</xsl:when><!-- 其他 -->
			<xsl:when test=".=47">6</xsl:when><!-- 港澳居民来往内地通行证（香港） -->
			<xsl:when test=".=48">6</xsl:when><!-- 港澳居民来往内地通行证（澳门） -->
			<xsl:when test=".=49">7</xsl:when><!-- 台湾居民来往大陆通行证 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 被保人关系人映射-->
	<xsl:template name="tran_Relation_Insured" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".=01">00</xsl:when><!-- 本人=本人 -->
			<xsl:when test=".=02">02</xsl:when><!-- 丈夫=配偶 -->
			<xsl:when test=".=03">02</xsl:when><!-- 妻子=配偶 -->
			<xsl:when test=".=04">01</xsl:when><!-- 父亲=父母 -->
			<xsl:when test=".=05">01</xsl:when><!-- 母亲=父母 -->
			<xsl:when test=".=06">03</xsl:when><!-- 儿子=儿女  -->
			<xsl:when test=".=07">03</xsl:when><!-- 女儿=儿女 -->
			<xsl:when test=".=08">04</xsl:when><!-- 祖父=其他-->
			<xsl:when test=".=09">04</xsl:when><!-- 祖母=其他-->
			<xsl:when test=".=10">04</xsl:when><!-- 孙子=其他-->
			<xsl:when test=".=11">04</xsl:when><!-- 孙女=其他-->
			<xsl:when test=".=12">04</xsl:when><!-- 外祖父=其他-->
			<xsl:when test=".=13">04</xsl:when><!-- 外祖母=其他-->
			<xsl:when test=".=14">04</xsl:when><!-- 外孙=其他-->
			<xsl:when test=".=15">04</xsl:when><!-- 外孙女=其他-->
			<xsl:when test=".=16">04</xsl:when><!-- 哥哥=其他-->
			<xsl:when test=".=17">04</xsl:when><!-- 姐姐=其他-->
			<xsl:when test=".=18">04</xsl:when><!-- 弟弟=其他-->
			<xsl:when test=".=19">04</xsl:when><!-- 妹妹=其他-->
			<xsl:when test=".=99">04</xsl:when><!-- 其他=其他-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 受益人关系人映射-->
	<xsl:template name="tran_Relation_Bef" match="RelationToInsured">
		<xsl:choose>
			<xsl:when test=".=01">00</xsl:when><!-- 本人=本人 -->
			<xsl:when test=".=02">02</xsl:when><!-- 丈夫=配偶 -->
			<xsl:when test=".=03">02</xsl:when><!-- 妻子=配偶 -->
			<xsl:when test=".=04">01</xsl:when><!-- 父亲=父母 -->
			<xsl:when test=".=05">01</xsl:when><!-- 母亲=父母 -->
			<xsl:when test=".=06">03</xsl:when><!-- 儿子=儿女  -->
			<xsl:when test=".=07">03</xsl:when><!-- 女儿=儿女 -->
			<xsl:when test=".=08">04</xsl:when><!-- 祖父=其他-->
			<xsl:when test=".=09">04</xsl:when><!-- 祖母=其他-->
			<xsl:when test=".=10">04</xsl:when><!-- 孙子=其他-->
			<xsl:when test=".=11">04</xsl:when><!-- 孙女=其他-->
			<xsl:when test=".=12">04</xsl:when><!-- 外祖父=其他-->
			<xsl:when test=".=13">04</xsl:when><!-- 外祖母=其他-->
			<xsl:when test=".=14">04</xsl:when><!-- 外孙=其他-->
			<xsl:when test=".=15">04</xsl:when><!-- 外孙女=其他-->
			<xsl:when test=".=16">04</xsl:when><!-- 哥哥=其他-->
			<xsl:when test=".=17">04</xsl:when><!-- 姐姐=其他-->
			<xsl:when test=".=18">04</xsl:when><!-- 弟弟=其他-->
			<xsl:when test=".=19">04</xsl:when><!-- 妹妹=其他-->
			<xsl:when test=".=99">04</xsl:when><!-- 其他=其他-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期年龄类型 -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
		    <xsl:when test=".='08'">A</xsl:when><!-- 终身 -->
			<xsl:when test=".='07'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='05'">M</xsl:when><!-- 月缴 -->
			<xsl:when test=".='06'">D</xsl:when><!-- 日缴 -->
			<xsl:when test=".='02'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='01'">Y</xsl:when><!-- 趸缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保险年期年龄类型 -->
	<xsl:template name="tran_insuyearflag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='05'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='03'">M</xsl:when><!-- 月保 -->
			<xsl:when test=".='04'">D</xsl:when><!-- 日保 -->
			<xsl:when test=".='01'">Y</xsl:when><!-- 年保 -->
			<xsl:when test=".='06'">A</xsl:when><!-- 保终身 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保单递送方式 -->
	<xsl:template name="tran_getPolMode" match="SendMethod">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- 银行领取 -->
			<xsl:when test=".=2">1</xsl:when><!-- 邮寄或专递 -->
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 国籍转换 -->
	<xsl:template name="tran_Nationality">
	    <xsl:param name="Nationality" />
	    <xsl:param name="IDType" />
		<xsl:choose>
		    <xsl:when test="$Nationality='' and $IDType='01'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='' and $IDType='02'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='' and $IDType='04'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='' and $IDType='05'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='' and $IDType='06'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='01'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='02'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='04'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='05'">CHN</xsl:when>	<!-- 中国 -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='06'">CHN</xsl:when>	<!-- 中国 -->
			<xsl:when test="$Nationality='AD'">AD</xsl:when><!--	安道尔   -->       
			<xsl:when test="$Nationality='AE'">AE</xsl:when><!--	阿联酋   -->       
			<xsl:when test="$Nationality='AF'">AF</xsl:when><!--	阿富汗   -->       
			<xsl:when test="$Nationality='AG'">AG</xsl:when><!--	安提瓜和巴布达-->  
			<xsl:when test="$Nationality='AI'">AI</xsl:when><!--	安圭拉      -->    
			<xsl:when test="$Nationality='AL'">AL</xsl:when><!--	阿尔巴尼亚  -->    
			<xsl:when test="$Nationality='AM'">AM</xsl:when><!--	阿美尼亚    -->    
			<xsl:when test="$Nationality='AN'">AN</xsl:when><!--	荷属安的列斯-->    
			<xsl:when test="$Nationality='AO'">AO</xsl:when><!--	安哥拉      -->    
			<xsl:when test="$Nationality='AQ'">OTH</xsl:when><!--其他        -->    
			<xsl:when test="$Nationality='AR'">AR</xsl:when><!--	阿根廷      -->    
			<xsl:when test="$Nationality='AS'">AS</xsl:when><!--	 东萨摩亚   -->    
			<xsl:when test="$Nationality='AT'">AT</xsl:when><!--	奥地利      -->    
			<xsl:when test="$Nationality='AU'">AU</xsl:when><!--	澳大利亚    -->    
			<xsl:when test="$Nationality='AW'">AW</xsl:when><!--	阿鲁巴（荷）-->    
			<xsl:when test="$Nationality='AX'">OTH</xsl:when><!--其他        -->    
			<xsl:when test="$Nationality='AZ'">AZ</xsl:when><!--	阿塞拜疆     -->   
			<xsl:when test="$Nationality='BA'">BA</xsl:when><!--	波斯尼亚－黑塞哥维-->
			<xsl:when test="$Nationality='BB'">BB</xsl:when><!--	巴巴多斯    -->    
			<xsl:when test="$Nationality='BD'">BD</xsl:when><!--	孟加拉国    -->    
			<xsl:when test="$Nationality='BE'">BE</xsl:when><!--	比利时      -->    
			<xsl:when test="$Nationality='BF'">BF</xsl:when><!--	布基纳法索  -->    
			<xsl:when test="$Nationality='BG'">BG</xsl:when><!--	保加利亚    -->    
			<xsl:when test="$Nationality='BH'">BH</xsl:when><!--	巴林        -->    
			<xsl:when test="$Nationality='BI'">BI</xsl:when><!-- 布隆迪      -->    
			<xsl:when test="$Nationality='BJ'">BJ</xsl:when><!-- 贝宁        -->    
			<xsl:when test="$Nationality='BM'">BM</xsl:when><!-- 百慕大      -->    
			<xsl:when test="$Nationality='BN'">BN</xsl:when><!--   文莱      -->    
			<xsl:when test="$Nationality='BO'">BO</xsl:when> <!--	玻利维亚  -->    
			<xsl:when test="$Nationality='BR'">BR</xsl:when> <!--	巴西      -->    
			<xsl:when test="$Nationality='BS'">BS</xsl:when> <!--	巴哈马     -->   
			<xsl:when test="$Nationality='BT'">BT</xsl:when> <!--	 布丹      -->   
			<xsl:when test="$Nationality='BV'">OTH</xsl:when><!--	其他       -->   
			<xsl:when test="$Nationality='BW'">BW</xsl:when> <!--	博茨瓦纳   -->   
			<xsl:when test="$Nationality='BY'">BY</xsl:when> <!--	白俄罗斯   -->   
			<xsl:when test="$Nationality='BZ'">BZ</xsl:when> <!--	伯利兹     -->   
			<xsl:when test="$Nationality='CA'">CA</xsl:when> <!-- 加拿大     -->    
			<xsl:when test="$Nationality='CC'">OTH</xsl:when><!-- 其他       -->    
			<xsl:when test="$Nationality='CD'">CG</xsl:when> <!-- 刚果（金） -->    
			<xsl:when test="$Nationality='CF'">CF</xsl:when> <!-- 中非       -->    
			<xsl:when test="$Nationality='CG'">ZR</xsl:when> <!--	刚果（布） -->   
			<xsl:when test="$Nationality='CH'">CH</xsl:when> <!--	瑞士      -->    
			<xsl:when test="$Nationality='CI'">CI</xsl:when> <!--	 科特迪亚 -->    
			<xsl:when test="$Nationality='CK'">CK</xsl:when> <!--	库克群岛  -->    
			<xsl:when test="$Nationality='CL'">CL</xsl:when> <!--	智利      -->    
			<xsl:when test="$Nationality='CM'">CM</xsl:when> <!--	喀麦隆    -->    
			<xsl:when test="$Nationality='CN'">CHN</xsl:when><!--	中国      -->    
			<xsl:when test="$Nationality='CO'">CO</xsl:when> <!--	哥伦比亚  -->    
			<xsl:when test="$Nationality='CR'">CR</xsl:when> <!-- 哥斯达黎加 -->    
			<xsl:when test="$Nationality='CU'">CU</xsl:when> <!-- 古巴       -->    
			<xsl:when test="$Nationality='CW'">OTH</xsl:when><!-- 其他       -->    
			<xsl:when test="$Nationality='CV'">CV</xsl:when> <!-- 佛得角     -->    
			<xsl:when test="$Nationality='CX'">OTH</xsl:when><!-- 其他      -->     
			<xsl:when test="$Nationality='CY'">CY</xsl:when> <!-- 塞浦路斯  -->     
			<xsl:when test="$Nationality='CZ'">CZ</xsl:when> <!-- 捷克     -->      
			<xsl:when test="$Nationality='DE'">DE</xsl:when> <!-- 德国     -->      
			<xsl:when test="$Nationality='DJ'">DJ</xsl:when> <!-- 吉布提   -->      
			<xsl:when test="$Nationality='DK'">DK</xsl:when> <!-- 丹麦     -->      
			<xsl:when test="$Nationality='DM'">DM</xsl:when> <!-- 多米尼克 -->      
			<xsl:when test="$Nationality='DO'">DO</xsl:when> <!-- 多米尼加 -->      
			<xsl:when test="$Nationality='DZ'">DZ</xsl:when> <!-- 阿尔及利亚 -->    
			<xsl:when test="$Nationality='EC'">EC</xsl:when> <!-- 厄瓜多尔   -->    
			<xsl:when test="$Nationality='EE'">EE</xsl:when> <!-- 爱沙尼亚   -->    
			<xsl:when test="$Nationality='EG'">EG</xsl:when> <!-- 埃及       -->    
			<xsl:when test="$Nationality='EH'">OTH</xsl:when><!-- 其他        -->   
			<xsl:when test="$Nationality='ER'">ER</xsl:when> <!-- 厄立特里亚  -->   
			<xsl:when test="$Nationality='ES'">ES</xsl:when> <!-- 西班牙    -->     
			<xsl:when test="$Nationality='ET'">ET</xsl:when> <!-- 埃塞俄比亚-->     
			<xsl:when test="$Nationality='FI'">FI</xsl:when> <!-- 芬兰      -->     
			<xsl:when test="$Nationality='FJ'">FJ</xsl:when> <!-- 斐济      -->     
			<xsl:when test="$Nationality='FK'">OTH</xsl:when><!-- 其他      -->     
			<xsl:when test="$Nationality='FM'">OTH</xsl:when><!-- 其他         -->  
			<xsl:when test="$Nationality='FO'">FO</xsl:when><!-- 法罗群岛（丹）-->  
			<xsl:when test="$Nationality='FR'">FR</xsl:when><!-- 法国  -->          
			<xsl:when test="$Nationality='GA'">GA</xsl:when><!-- 加蓬  -->          
			<xsl:when test="$Nationality='GB'">GB</xsl:when> <!-- 英国  -->         
			<xsl:when test="$Nationality='GD'">GD</xsl:when> <!--	格林纳达  -->    
			<xsl:when test="$Nationality='GE'">GE</xsl:when> <!--	格鲁吉亚   -->   
			<xsl:when test="$Nationality='GF'">GF</xsl:when> <!--	法属圭亚那  -->  
			<xsl:when test="$Nationality='GG'">OTH</xsl:when><!--	其他        -->  
			<xsl:when test="$Nationality='GH'">GH</xsl:when> <!--	加纳        -->  
			<xsl:when test="$Nationality='GI'">GI</xsl:when> <!--	直布罗陀    -->  
			<xsl:when test="$Nationality='GL'">GL</xsl:when> <!--	格陵兰      -->  
			<xsl:when test="$Nationality='GM'">GM</xsl:when> <!--	冈比亚      -->  
			<xsl:when test="$Nationality='GN'">GN</xsl:when> <!-- 几内亚     -->    
			<xsl:when test="$Nationality='GP'">GP</xsl:when> <!-- 瓜德罗普   -->    
			<xsl:when test="$Nationality='GQ'">GQ</xsl:when> <!-- 赤道几内亚 -->    
			<xsl:when test="$Nationality='GR'">GR</xsl:when> <!-- 希腊       -->    
			<xsl:when test="$Nationality='GS'">OTH</xsl:when> <!-- 其他       -->   
			<xsl:when test="$Nationality='GT'">GT</xsl:when> <!--	危地马拉   -->   
			<xsl:when test="$Nationality='GU'">GU</xsl:when> <!--	关岛（美） -->   
			<xsl:when test="$Nationality='GW'">GW</xsl:when> <!--	几内亚比绍 -->   
			<xsl:when test="$Nationality='GY'">GY</xsl:when> <!--	圭亚那     -->   
			<xsl:when test="$Nationality='HK'">CHN</xsl:when> <!--	:中国      -->   
			<xsl:when test="$Nationality='HM'">OTH</xsl:when> <!--	:其他     -->    
			<xsl:when test="$Nationality='HN'">HN</xsl:when> <!--	洪都拉斯  -->    
			<xsl:when test="$Nationality='HR'">HR</xsl:when> <!-- 克罗地亚   -->    
			<xsl:when test="$Nationality='HT'">HT</xsl:when> <!-- 海地       -->    
			<xsl:when test="$Nationality='HU'">HU</xsl:when> <!-- 匈牙利     -->    
			<xsl:when test="$Nationality='ID'">ID</xsl:when> <!-- 印度尼西亚 -->    
			<xsl:when test="$Nationality='IE'">IE</xsl:when> <!--	爱尔兰    -->    
			<xsl:when test="$Nationality='IL'">IL</xsl:when> <!--	以色列    -->    
			<xsl:when test="$Nationality='IM'">OTH</xsl:when> <!--	其他      -->    
			<xsl:when test="$Nationality='IN'">IN</xsl:when> <!--	印度      -->    
			<xsl:when test="$Nationality='IO'">OTH</xsl:when> <!--	其他      -->    
			<xsl:when test="$Nationality='IQ'">IQ</xsl:when> <!--	伊拉克    -->    
			<xsl:when test="$Nationality='IR'">IR</xsl:when> <!--	伊朗      -->    
			<xsl:when test="$Nationality='IS'">IS</xsl:when> <!--	冰岛      -->    
			<xsl:when test="$Nationality='IT'">IT</xsl:when> <!-- 意大利     -->    
			<xsl:when test="$Nationality='JE'">JE</xsl:when> <!-- 泽西岛     -->    
			<xsl:when test="$Nationality='JM'">JM</xsl:when> <!-- 牙买加     -->    
			<xsl:when test="$Nationality='JO'">JO</xsl:when> <!-- 约旦       -->    
			<xsl:when test="$Nationality='JP'">JP</xsl:when> <!-- 日本       -->    
			<xsl:when test="$Nationality='KE'">KE</xsl:when> <!--	肯尼亚    -->    
			<xsl:when test="$Nationality='KG'">KG</xsl:when> <!--	吉尔吉斯  -->    
			<xsl:when test="$Nationality='KH'">KH</xsl:when> <!--	柬埔寨    -->    
			<xsl:when test="$Nationality='KI'">KT</xsl:when> <!--	基利巴斯  -->    
			<xsl:when test="$Nationality='KM'">KM</xsl:when> <!--	科摩罗    -->    
			<xsl:when test="$Nationality='KN'">SX</xsl:when> <!--	圣基茨和尼维斯 -->
			<xsl:when test="$Nationality='KP'">KP</xsl:when> <!--  朝鲜      -->    
			<xsl:when test="$Nationality='KR'">KR</xsl:when> <!--  韩国      -->    
			<xsl:when test="$Nationality='KW'">KW</xsl:when> <!--  科威特    -->    
			<xsl:when test="$Nationality='KY'">KY</xsl:when> <!--  开曼群岛  -->    
			<xsl:when test="$Nationality='KZ'">KZ</xsl:when> <!--  哈萨克斯坦  -->  
			<xsl:when test="$Nationality='LA'">LA</xsl:when> <!--  老挝       -->   
			<xsl:when test="$Nationality='LB'">LB</xsl:when> <!--  黎巴嫩     -->   
			<xsl:when test="$Nationality='LC'">SQ</xsl:when> <!--  圣卢西亚   -->   
			<xsl:when test="$Nationality='LI'">LI</xsl:when> <!--  列支敦士登 -->   
			<xsl:when test="$Nationality='LK'">LK</xsl:when> <!--  斯里兰卡   -->   
			<xsl:when test="$Nationality='LR'">LR</xsl:when> <!--  利比里亚   -->   
			<xsl:when test="$Nationality='LS'">LS</xsl:when> <!--  莱索托     -->   
			<xsl:when test="$Nationality='LT'">LT</xsl:when> <!--  立陶宛     -->   
			<xsl:when test="$Nationality='LU'">LU</xsl:when> <!--  卢森堡     -->   
			<xsl:when test="$Nationality='LV'">LV</xsl:when> <!--  拉脱维亚   -->   
			<xsl:when test="$Nationality='LY'">LY</xsl:when> <!--  利比亚     -->   
			<xsl:when test="$Nationality='MA'">MA</xsl:when> <!--  摩洛哥     -->   
			<xsl:when test="$Nationality='MC'">MC</xsl:when> <!--  摩纳哥     -->   
			<xsl:when test="$Nationality='MD'">MD</xsl:when> <!--  摩尔多瓦   -->   
			<xsl:when test="$Nationality='ME'">OTH</xsl:when> <!--  其他      -->   
			<xsl:when test="$Nationality='MG'">MG</xsl:when> <!--  马达加斯加 -->   
			<xsl:when test="$Nationality='MH'">MH</xsl:when> <!--  马绍尔群岛-->    
			<xsl:when test="$Nationality='MK'">MK</xsl:when> <!--   马其顿   -->    
			<xsl:when test="$Nationality='ML'">ML</xsl:when> <!--  马里      -->    
			<xsl:when test="$Nationality='MM'">MM</xsl:when> <!--  缅甸      -->    
			<xsl:when test="$Nationality='MN'">MN</xsl:when> <!--  蒙古      -->    
			<xsl:when test="$Nationality='MO'">CHN</xsl:when> <!--  中国      -->   
			<xsl:when test="$Nationality='MP'">MP</xsl:when> <!--  北马里亚纳群岛 -->
			<xsl:when test="$Nationality='MQ'">MQ</xsl:when> <!--  马提尼克   -->   
			<xsl:when test="$Nationality='MR'">MR</xsl:when> <!--  毛里塔尼亚 -->   
			<xsl:when test="$Nationality='MS'">MS</xsl:when> <!--  蒙特塞拉特 -->   
			<xsl:when test="$Nationality='MT'">MT</xsl:when> <!--  马耳他     -->   
			<xsl:when test="$Nationality='MU'">MU</xsl:when> <!--  毛里求斯   -->   
			<xsl:when test="$Nationality='MV'">MV</xsl:when> <!--  马尔代夫   -->   
			<xsl:when test="$Nationality='MW'">MW</xsl:when> <!--  马拉维     -->   
			<xsl:when test="$Nationality='MX'">MX</xsl:when> <!--  墨西哥     -->   
			<xsl:when test="$Nationality='MY'">MY</xsl:when> <!--  马来西亚   -->   
			<xsl:when test="$Nationality='MZ'">MZ</xsl:when> <!--  莫桑比克   -->   
			<xsl:when test="$Nationality='NA'">NA</xsl:when> <!--  纳米比亚   -->   
			<xsl:when test="$Nationality='NC'">NC</xsl:when> <!--  新喀里多尼亚-->  
			<xsl:when test="$Nationality='NE'">NE</xsl:when> <!--  尼日尔   -->     
			<xsl:when test="$Nationality='NF'">NF</xsl:when> <!--  诺福克岛 -->     
			<xsl:when test="$Nationality='NG'">NG</xsl:when> <!--  尼日利亚 -->     
			<xsl:when test="$Nationality='NI'">NI</xsl:when> <!--  尼加拉瓜 -->     
			<xsl:when test="$Nationality='NL'">NL</xsl:when> <!--  荷兰     -->     
			<xsl:when test="$Nationality='NO'">NO</xsl:when> <!--  挪威     -->     
			<xsl:when test="$Nationality='NP'">NP</xsl:when> <!--  尼泊尔   -->     
			<xsl:when test="$Nationality='NR'">NR</xsl:when> <!--  瑙鲁     -->     
			<xsl:when test="$Nationality='NU'">NU</xsl:when> <!--  纽埃     -->     
			<xsl:when test="$Nationality='NZ'">NZ</xsl:when> <!--  新西兰   -->     
			<xsl:when test="$Nationality='OM'">OM</xsl:when> <!--  阿曼     -->     
			<xsl:when test="$Nationality='PA'">PA</xsl:when> <!--  巴拿马   -->     
			<xsl:when test="$Nationality='PE'">PE</xsl:when> <!--  秘鲁     -->     
			<xsl:when test="$Nationality='PF'">PF</xsl:when> <!--  法属波利尼西亚 -->
			<xsl:when test="$Nationality='PG'">PG</xsl:when> <!--  巴布亚新几内亚 -->
			<xsl:when test="$Nationality='PH'">PH</xsl:when> <!--  菲律宾      -->  
			<xsl:when test="$Nationality='PK'">PK</xsl:when> <!--  巴基斯坦    -->  
			<xsl:when test="$Nationality='PL'">PL</xsl:when> <!--  波兰        -->  
			<xsl:when test="$Nationality='PM'">OTH</xsl:when> <!--  其他       -->  
			<xsl:when test="$Nationality='PN'">OTH</xsl:when> <!--  皮特凯       -->
			<xsl:when test="$Nationality='PR'">PR</xsl:when> <!--  波多黎各    -->  
			<xsl:when test="$Nationality='PS'">OTH</xsl:when> <!--  其他       -->  
			<xsl:when test="$Nationality='PT'">PT</xsl:when> <!--  葡萄牙      -->  
			<xsl:when test="$Nationality='PW'">PW</xsl:when> <!--  帕劳        -->  
			<xsl:when test="$Nationality='PY'">PY</xsl:when> <!--  巴拉圭      -->  
			<xsl:when test="$Nationality='QA'">QA</xsl:when> <!--  卡塔尔      -->  
			<xsl:when test="$Nationality='RE'">RE</xsl:when> <!--  留尼汪（法）-->  
			<xsl:when test="$Nationality='RO'">RO</xsl:when> <!--  罗马尼亚    -->  
			<xsl:when test="$Nationality='RS'">OTH</xsl:when> <!--  其他       -->  
			<xsl:when test="$Nationality='RU'">RU</xsl:when> <!--  俄罗斯      -->  
			<xsl:when test="$Nationality='RW'">RW</xsl:when> <!--  卢旺达      -->  
			<xsl:when test="$Nationality='SA'">SA</xsl:when> <!--  沙特阿拉伯 -->   
			<xsl:when test="$Nationality='SB'">SB</xsl:when> <!--  所罗门群岛 -->   
			<xsl:when test="$Nationality='SC'">SC</xsl:when> <!--  塞舌尔     -->   
			<xsl:when test="$Nationality='SD'">SD</xsl:when> <!--  苏丹       -->   
			<xsl:when test="$Nationality='SE'">SE</xsl:when> <!--  瑞典       -->   
			<xsl:when test="$Nationality='SG'">SG</xsl:when> <!--  新加坡     -->   
			<xsl:when test="$Nationality='SH'">OTH</xsl:when> <!--  其他      -->   
			<xsl:when test="$Nationality='SI'">SI</xsl:when> <!--  斯洛文尼亚 -->   
			<xsl:when test="$Nationality='SJ'">OTH</xsl:when> <!--  其他      -->   
			<xsl:when test="$Nationality='SK'">SK</xsl:when> <!--  斯洛伐克   -->   
			<xsl:when test="$Nationality='SL'">SL</xsl:when> <!--  塞拉利昂   -->   
			<xsl:when test="$Nationality='SM'">SM</xsl:when> <!--  圣马力诺   -->   
			<xsl:when test="$Nationality='SN'">SN</xsl:when> <!--  塞内加尔   -->   
			<xsl:when test="$Nationality='SO'">SO</xsl:when> <!--  索马里     -->   
			<xsl:when test="$Nationality='SR'">SR</xsl:when> <!--  苏里南           -->
			<xsl:when test="$Nationality='ST'">ST</xsl:when> <!--  圣多美和普林西比 -->
			<xsl:when test="$Nationality='SV'">SV</xsl:when> <!--  萨尔瓦多         -->
			<xsl:when test="$Nationality='SY'">SY</xsl:when> <!--  叙利亚           -->
			<xsl:when test="$Nationality='SZ'">SZ</xsl:when> <!--  斯威士兰         -->
			<xsl:when test="$Nationality='TC'">TC</xsl:when> <!--  特克斯和凯科斯群-->
			<xsl:when test="$Nationality='TD'">TD</xsl:when> <!--  乍得          -->
			<xsl:when test="$Nationality='TF'">OTH</xsl:when> <!--  其他         -->
			<xsl:when test="$Nationality='TG'">TG</xsl:when> <!--  多哥          -->
			<xsl:when test="$Nationality='TH'">TH</xsl:when> <!--  泰国          -->
			<xsl:when test="$Nationality='TJ'">TJ</xsl:when> <!--  塔吉克斯坦    -->
			<xsl:when test="$Nationality='TK'">OTH</xsl:when> <!--  其他         -->
			<xsl:when test="$Nationality='TL'">OTH</xsl:when> <!--  其他         -->
			<xsl:when test="$Nationality='TM'">TM</xsl:when> <!--  土库曼斯坦    -->
			<xsl:when test="$Nationality='TN'">TN</xsl:when> <!--  突尼斯        -->
			<xsl:when test="$Nationality='TO'">TO</xsl:when> <!--  汤加          -->
			<xsl:when test="$Nationality='TR'">TR</xsl:when> <!--  土耳其        -->
			<xsl:when test="$Nationality='TT'">TT</xsl:when> <!--  特立尼达和多巴哥--> 
			<xsl:when test="$Nationality='TV'">TV</xsl:when> <!--  图瓦卢       --> 
			<xsl:when test="$Nationality='TW'">CHN</xsl:when> <!--  中国        --> 
			<xsl:when test="$Nationality='TZ'">TZ</xsl:when> <!--  坦桑尼亚     --> 
			<xsl:when test="$Nationality='UA'">UA</xsl:when> <!--  乌克兰       --> 
			<xsl:when test="$Nationality='UG'">UG</xsl:when> <!--  乌干达       --> 
			<xsl:when test="$Nationality='UM'">OTH</xsl:when> <!--  其他        --> 
			<xsl:when test="$Nationality='US'">US</xsl:when> <!--  美国         --> 
			<xsl:when test="$Nationality='UY'">UY</xsl:when> <!--  乌拉圭       --> 
			<xsl:when test="$Nationality='UZ'">UZ</xsl:when> <!--  乌兹别克斯坦 --> 
			<xsl:when test="$Nationality='VA'">OTH</xsl:when> <!--  其他        --> 
			<xsl:when test="$Nationality='VC'">VC</xsl:when> <!--   圣文斯特    --> 
			<xsl:when test="$Nationality='VE'">VE</xsl:when> <!--  委内瑞拉        -->
			<xsl:when test="$Nationality='VG'">VG</xsl:when> <!--  英属维尔京群岛  -->
			<xsl:when test="$Nationality='VI'">VI</xsl:when> <!--  美属维尔京群岛  -->
			<xsl:when test="$Nationality='VN'">VN</xsl:when> <!--  越南       -->   
			<xsl:when test="$Nationality='VU'">VU</xsl:when> <!--  瓦努阿图   -->   
			<xsl:when test="$Nationality='WF'">OTH</xsl:when> <!--  其他      -->   
			<xsl:when test="$Nationality='WS'">WS</xsl:when> <!--  萨摩亚     -->   
			<xsl:when test="$Nationality='YE'">YE</xsl:when> <!--  也门       -->   
			<xsl:when test="$Nationality='YT'">YT</xsl:when> <!--  马约特     -->   
			<xsl:when test="$Nationality='YU'">YU</xsl:when> <!--  南斯拉夫   -->   
			<xsl:when test="$Nationality='ZA'">ZA</xsl:when> <!--  南非       -->   
			<xsl:when test="$Nationality='ZM'">ZM</xsl:when> <!--  赞比亚     -->   
			<xsl:when test="$Nationality='ZW'">ZW</xsl:when> <!--  津巴布韦   -->   
			<xsl:when test="$Nationality='ZZ'">OTH</xsl:when> <!--  其他      -->   
			<xsl:when test="$Nationality='01'">BG</xsl:when> <!--  保加利亚   -->   
			<xsl:when test="$Nationality='02'">BO</xsl:when> <!--  玻利维亚   -->   
			<xsl:when test="$Nationality='03'">MX</xsl:when> <!--  墨西哥     -->   
			<xsl:when test="$Nationality='05'">CL</xsl:when> <!--  智利       -->   
			<xsl:when test="$Nationality='06'">GW</xsl:when> <!--  几内亚比绍 -->   
			<xsl:when test="$Nationality='10'">OTH</xsl:when> <!--  其他      -->   
			<xsl:otherwise>OTH</xsl:otherwise><!--	其他          -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 婚姻状态？ -->
	
	<!-- 红利领取方式？ -->
	<xsl:template name="tran_bonusgetmode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 累计生息 -->
			<xsl:when test=".='2'">4</xsl:when><!-- 现金领取 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 抵缴保费 -->
			<xsl:when test=".='4'">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
    <!-- 自动垫交标志 ?-->
	<xsl:template name="tran_autoPayFlag" match="AutoPayFlag">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 不垫交 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 自动垫交 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- 居民来源 -->
	<xsl:template name="tran_livezone" match="ResiType">
		<xsl:choose>
			<xsl:when test=".=0">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".=1">2</xsl:when><!-- 农村 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- 产品组合代码 -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="Code" />
        <xsl:choose>
            <xsl:when test="$Code='L12079'">L12079</xsl:when>      <!-- 安邦盛世2号终身寿险（万能型） -->
            <xsl:when test="$Code='L12087'">L12087</xsl:when>      <!-- 东风5号两全保险（万能型） 主险 add by jbq -->
            <xsl:when test="$Code='L12085'">L12085</xsl:when>      <!-- 东风2号两全保险（万能型） 主险 -->
            <xsl:when test="$Code='50015'">50015</xsl:when>
            
            <xsl:when test="$Code='L12086'">L12086</xsl:when><!--安邦东风3号两全保险（万能型）-->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
