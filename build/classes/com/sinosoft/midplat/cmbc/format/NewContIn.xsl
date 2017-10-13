<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/INSUREQ">
		<TranData>
			<!-- 请求报文头 -->
			<Head>
				<!-- 交易日期（yyyymmdd） -->
				<TranDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</TranDate>
				<!-- 交易时间 （hhmmss）-->
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(MAIN/TRANSRTIME)"/></TranTime>
				<!-- 柜员-->
				<TellerNo>
					<xsl:value-of select="MAIN/TELLERNO" />
				</TellerNo>
				<!-- 流水号-->
				<TranNo>
					<xsl:value-of select="MAIN/TRANSRNO" />
				</TranNo>
				<!-- 地区码+网点码-->
				<NodeNo>
					<xsl:value-of select="MAIN/BRNO1" />
					<xsl:value-of select="MAIN/BRNO" />
				</NodeNo>
				<!-- 银行编号（核心定义）-->
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<xsl:copy-of select="Head/*" />
			</Head>
			
			<!-- 请求报文体 -->
			<Body>

				<xsl:apply-templates select="MAIN" />
				
				<!-- 投保人 -->
				<xsl:apply-templates select="TBR" />
	
				<!-- 被保人 -->
				<xsl:apply-templates select="BBR" />
	
				<!-- 受益人 -->
				<xsl:if test="SYRS/SYS_COUNT!=''">
					<xsl:apply-templates select="SYRS/SYR" />
				</xsl:if>
	
				<!-- 险种信息 -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
				
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- MAIN_SUB_FLG  0:主险  1:附加险 -->
	<xsl:variable name="MainRisk" select="//PRODUCTS/PRODUCT[MAIN_SUB_FLG=0]" />
		
	<!-- Body根目录信息  -->
	<xsl:template name="Body" match="MAIN">
		
		<!-- 投保单(印刷)号 -->
		<ProposalPrtNo>
			<xsl:value-of select="APPLNO" />
		</ProposalPrtNo>
		<!-- 保单合同印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="PRINT_NO" />
		</ContPrtNo>
		<!-- 投保日期 -->
		<PolApplyDate>
			<xsl:value-of select="TB_DATE" />
		</PolApplyDate>
		<!-- 账户姓名 -->
		<AccName>
			<xsl:value-of select="BANKACC_NAME" />
		</AccName>
		<!-- 银行账户 -->
		<AccNo>
			<xsl:value-of select="BANKACC" />
		</AccNo>
		<!-- 保单递送方式 -->
		<GetPolMode>
			<xsl:apply-templates select="SENDMETHOD" />
		</GetPolMode>
		<!-- FIXME 和银行确认该标签 职业告知(N/Y) -->
		<JobNotice />
		<!-- FIXME 和银行确认该标签 健康告知(N/Y) -->
		<HealthNotice>
			<xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" />
		</HealthNotice>
		
		<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
		<PolicyIndicator />
		<!--累计投保身故保额 这个金额字段比较特殊，单位是百元-->
		<InsuredTotalFaceAmount />
		
		<!-- 销售员工号 -->
		<SellerNo><xsl:value-of select="SALESSTAFFID" /></SellerNo>
		<!-- 销售员工姓名 -->
		<TellerName><xsl:value-of select="SALESSTAFFNAME" /></TellerName>
		<!-- 银行销售人员资格证 -->
		<TellerCertiCode><xsl:value-of select="SALESSTAFFINTEL" /></TellerCertiCode>
		<!-- 出单网点资格证 -->
		<AgentComCertiCode><xsl:value-of select="BRNOINTEL" /></AgentComCertiCode>
		<!-- 网点名称 -->
		<AgentComName><xsl:value-of select="BANKNAME" /></AgentComName>
		
		<!-- 产品组合 -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="$MainRisk/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:if test="$MainRisk/PRODUCTID = 50002">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz 增加安邦长寿安享5号保险计划50012 begin -->
				<xsl:if test="$MainRisk/PRODUCTID = 50012">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz 增加安邦长寿安享5号保险计划50012 end -->
				<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享3号保险计划50011 begin -->
				<xsl:if test="$MainRisk/PRODUCTID = 50011">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享5号保险计划50011 end -->
			</ContPlanMult>
        </ContPlan>
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
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="TBR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- 证件有效起期 -->
			<IDTypeStartDate><xsl:value-of select="substring(TBR_IDVALIDATE,1,8)" /></IDTypeStartDate>	
			<!-- 证件有效止期 -->	
			<xsl:if test="substring(TBR_IDVALIDATE,10,8) = '99999999'"><IDTypeEndDate>99991231</IDTypeEndDate></xsl:if>
			<xsl:if test="substring(TBR_IDVALIDATE,10,8) != '99999999'"><IDTypeEndDate><xsl:value-of select="substring(TBR_IDVALIDATE,10,8)" /></IDTypeEndDate></xsl:if>		   	
			<!-- 职业代码 -->
			<JobCode><xsl:value-of select="TBR_JOB_CODE" /></JobCode>
			<!-- FIXME 确认银行的单位是什么? 年收入 -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_ANNUALINCOME)" />
			</Salary>
			<!-- FIXME 确认银行的单位是什么? 家庭年收入 -->
			<FamilySalary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVG_INCOME)" /></FamilySalary>
			<!-- 客户类型 -->
			<!-- 1.城镇，2.农村 -->
			<LiveZone><xsl:apply-templates select="TBR_RESIDENTS" /></LiveZone>
			<!--风险测评结果是否适合投保，保监会3号文增加该字段。Y是N否-->
			<RiskAssess><xsl:apply-templates select="RISKRATING" /></RiskAssess>
			<!-- 国籍 -->
			<Nationality><xsl:apply-templates select="TBR_COUNTRY_CODE" /></Nationality>
			<!-- FIXME TBR_HW 是否存的是身高和体重 ？  身高(cm) -->
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
			<!-- 保费预算金额 （分） -->
			<Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_PRM_BUDGET)" /></Premiumbudget>
		</Appnt>
	</xsl:template>
	
	<!-- 被保人信息 -->
	<xsl:template name="Insured" match="BBR">
		<Insured>
			<!-- 姓名 -->
			<Name><xsl:value-of select="BBR_NAME" /></Name>
			<!-- 性别 -->
			<Sex><xsl:apply-templates select="BBR_SEX" /></Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="BBR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
			
			<!-- 证件有效起期 -->
			<IDTypeStartDate><xsl:value-of select="substring(BBR_IDVALIDATE,1,8)" /></IDTypeStartDate>	
			<!-- 证件有效止期 -->
			<xsl:if test="substring(BBR_IDVALIDATE,10,8) = '99999999'"><IDTypeEndDate>99991231</IDTypeEndDate></xsl:if>
			<xsl:if test="substring(BBR_IDVALIDATE,10,8) != '99999999'"><IDTypeEndDate><xsl:value-of select="substring(BBR_IDVALIDATE,10,8)" /></IDTypeEndDate></xsl:if>		   		   
			<!-- 职业代码 -->
			<JobCode><xsl:value-of select="BBR_WORKCODE" /></JobCode>
			<!-- 身高(cm)-->
			<Stature />
			<!-- 国籍-->
			<Nationality><xsl:apply-templates select="BBR_COUNTRY_CODE" /></Nationality>
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
			<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
			<!-- 姓名 -->
			<Name><xsl:value-of select="SYR_NAME" /></Name>
			<!-- 性别 -->
			<Sex><xsl:apply-templates select="SYR_SEX" /></Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday><xsl:value-of select="SYR_BIRTHDAY" /></Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="SYR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- 证件号码 -->
			<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
			<!-- 与被保人关系 -->
			<RelaToInsured>
				<xsl:apply-templates select="SYR_BBR_RELA" />
			</RelaToInsured>
			<!-- 国籍-->
			<Nationality><xsl:apply-templates select="SYR_COUNTRY_CODE" /></Nationality>
			<!-- 受益比例(整数，百分比) -->
			<Lot><xsl:value-of select="SYR_BEN_RATE" /></Lot>
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
					<xsl:with-param name="riskcode" select="$MainRisk/PRODUCTID" />
				</xsl:call-template>
			</MainRiskCode>
			
			<!-- FIXME 确认银行的单位是什么？保额(分) -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMOUNT)" />
			</Amnt>
			<!-- FIXME 确认银行的单位是什么？保险费(分) -->
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
				<xsl:if test="COVERAGE_PERIOD='3'">106</xsl:if><!-- 保终身 -->
				<xsl:if test="COVERAGE_PERIOD!='3'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<!-- 缴费年期年龄标志 -->
			<xsl:choose>
				<xsl:when test="PAY_TYPE = '1'">
					<!-- 趸交 -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:when test="PAY_TYPE = '6'">
					<!-- 终身缴费 -->
					<PayEndYearFlag>A</PayEndYearFlag>
					<PayEndYear>106</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<PayEndYearFlag>
						<xsl:apply-templates select="PAY_TYPE" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="PAY_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>

			<!-- 红利领取方式 -->
			<BonusGetMode>
				<xsl:apply-templates select="../../MAIN/DVDMETHOD" />
			</BonusGetMode>
			<!-- 满期领取金领取方式 -->
			<FullBonusGetMode />
			<!-- 领取年龄年期标志 -->
			<GetYearFlag></GetYearFlag>
			<!-- 领取年龄 -->
			<GetYear>
				<xsl:value-of select="../../REC_YEAR_NO" />
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
				<xsl:apply-templates select="../../ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>
	
	
		
	<!-- 产品组合代码 -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<!-- add by duanjz 2015-6-17  增加安邦长寿安享5号保险计划50012  begin -->
			<!-- 50012-安邦长寿安享5号保险计划:主险：L12070 - 安邦长寿安享5号年金保险,附加险：L12071 - 安邦附加长寿添利5号两全保险（万能型） -->
			<xsl:when test="$contPlancode=50012">50012</xsl:when>
			<!-- add by duanjz 2015-6-17  增加安邦长寿安享5号保险计划50012  end -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享3号保险计划50011  begin -->
			<!-- 50011-安邦长寿安享3号保险计划:主险：L12068 - 安邦长寿安享3号年金保险,附加险：L12069 - 安邦附加长寿添利3号两全保险（万能型） -->
			<xsl:when test="$contPlancode=50011">50011</xsl:when>
			<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享3号保险计划50011  end -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122012'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
			<!-- 盛世3号产品代码变更start -->
			<!-- <xsl:when test="$riskcode='122010'">L12078</xsl:when> -->	<!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<!-- add by duanjz 2015-6-17  增加安邦长寿安享5号保险计划50012 begin -->
			<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- 安邦长寿安享5号年金保险 -->
			<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- 安邦附加长寿添利5号两全保险（万能型） -->
			<xsl:when test="$riskcode='50012'">50012</xsl:when>
			<!-- add by duanjz 2015-6-17  增加安邦长寿安享5号保险计划50012  end -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享3号保险计划50011 begin -->
			<xsl:when test="$riskcode='L12068'">L12068</xsl:when>	<!-- 安邦长寿安享3号年金保险 -->
			<xsl:when test="$riskcode='L12069'">L12069</xsl:when>	<!-- 安邦附加长寿添利3号两全保险（万能型） -->
			<xsl:when test="$riskcode='50011'">50011</xsl:when><!-- 安邦长寿安享3号保险计划 -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  增加安邦长寿安享3号保险计划50011 end -->
            <xsl:when test="$riskcode='L12087'">L12087</xsl:when>      <!-- 东风5号两全保险（万能型） 主险 -->
            <xsl:when test="$riskcode='L12085'">L12085</xsl:when>      <!-- 东风2号两全保险（万能型） 主险 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<!-- 银行：0 不定期，1 年交，2 半年交，3 季交，4 月交，5 趸交 -->
	<!-- <xsl:template match="PAYMETHOD"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='0'">-1</xsl:when> --><!-- 不定期缴 -->
	<!-- 		<xsl:when test=".='1'">12</xsl:when> --><!-- 年缴 -->
	<!-- 		<xsl:when test=".='2'">6</xsl:when> --><!-- 半年交 -->
	<!-- 		<xsl:when test=".='3'">3</xsl:when> --><!-- 季交-->
	<!-- 		<xsl:when test=".='4'">1</xsl:when> --><!-- 月交 -->
	<!-- 		<xsl:when test=".='5'">0</xsl:when> --><!-- 趸交 -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- 银行：6 不定期，2 年交，3 半年交，4 季交，5 月交，1 趸交 -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='6'">-1</xsl:when><!-- 不定期缴 -->
			<xsl:when test=".='2'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='3'">6</xsl:when><!-- 半年交 -->
			<xsl:when test=".='4'">3</xsl:when><!-- 季交-->
			<xsl:when test=".='5'">1</xsl:when><!-- 月交 -->
			<xsl:when test=".='1'">0</xsl:when><!-- 趸交 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保险年期类型 -->
	<!-- 银行：0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<!-- <xsl:template match="COVERAGE_PERIOD"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='1'">A</xsl:when> --><!-- 终身 -->
	<!-- 		<xsl:when test=".='2'">Y</xsl:when> --><!-- 按年 -->
	<!-- 		<xsl:when test=".='3'">A</xsl:when> --><!-- 保至某年龄 -->
	<!-- 		<xsl:when test=".='4'">M</xsl:when> --><!-- 按月 -->
	<!-- 		<xsl:when test=".='5'">D</xsl:when> --><!-- 按日 -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- 银行：6 无关，3 保终身，1 按年限保，2 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='3'">A</xsl:when><!-- 终身 -->
			<xsl:when test=".='1'">Y</xsl:when><!-- 按年 -->
			<xsl:when test=".='2'">A</xsl:when><!-- 保至某年龄 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月 -->
			<xsl:when test=".='5'">D</xsl:when><!-- 按日 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<!-- 银行：3 缴至某确定年龄，4 终生缴费，7 按月限缴， 8 按日限缴，9 年缴 10 趸缴 -->
	<!-- <xsl:template match="PAY_TYPE"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='3'">A</xsl:when> --><!-- 缴至某确定年龄 -->
	<!-- 		<xsl:when test=".='4'">A</xsl:when> --><!-- 终生缴费 -->
	<!-- 		<xsl:when test=".='7'">M</xsl:when> --><!-- 按月限缴 -->
	<!-- 		<xsl:when test=".='8'">D</xsl:when> --><!-- 按日限缴 -->
	<!-- 		<xsl:when test=".='9'">Y</xsl:when> --><!-- 年缴 -->
	<!-- 		<xsl:when test=".='10'">Y</xsl:when> --><!-- 趸缴 -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- 银行：0 缴至某确定年龄，6 终生缴费，5 按月限缴， 8 按日限缴，2 年缴 1 趸缴 -->
	<xsl:template match="PAY_TYPE">
		<xsl:choose>
			<xsl:when test=".='0'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='6'">A</xsl:when><!-- 终生缴费 -->
			<xsl:when test=".='5'">M</xsl:when><!-- 按月限缴 -->
			<xsl:when test=".='8'">D</xsl:when><!-- 按日限缴 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">Y</xsl:when><!-- 趸缴 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- FIXME 和需求确认一下 红利领取方式 -->
	<!-- 银行：1	累积生息,2 现金领取,3 抵缴保费,4	其他,5 增额交清,6 无红利 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 累计生息 -->
			<xsl:when test=".='2'">4</xsl:when><!-- 直接给付  -->
			<xsl:when test=".='3'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='5'">5</xsl:when><!-- 增额交清 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取方式 -->
	<!-- 银行：0	无关,1 年领,2 半年领,3	季领,4 月领,5 一次性领取,6 领至确定年龄,7	日领,8 不定期领,9 其他 -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='4'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='1'">12</xsl:when><!--年领 -->
			<xsl:when test=".='5'">0</xsl:when><!-- 趸领 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季领 -->
			<xsl:when test=".='2'">6</xsl:when><!-- 半年领 -->
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

   
	<!-- 性别，核心：0=男性，1=女性；银行：1 男，2 女，3 不确定 -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 男性 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 女性 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型转换 -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='01'">0</xsl:when><!-- 居民身份证 -->
			<xsl:when test="$idtype='02'">8</xsl:when><!-- 临时身份证 -->
			<xsl:when test="$idtype='03'">5</xsl:when><!-- 户口簿 -->
			<xsl:when test="$idtype='04'">2</xsl:when><!-- 军人身份证 -->
			<xsl:when test="$idtype='05'">8</xsl:when><!-- 武警证 -->
			<xsl:when test="$idtype='06'">8</xsl:when><!-- 士兵证 -->
			<xsl:when test="$idtype='07'">8</xsl:when><!-- 文职干部证 -->
			<xsl:when test="$idtype='08'">1</xsl:when><!-- 外国护照 -->
			<xsl:when test="$idtype='09'">6</xsl:when><!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idtype='10'">6</xsl:when><!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idtype='11'">7</xsl:when><!-- 台湾居民来往大陆通行证 -->
			<xsl:when test="$idtype='12'">8</xsl:when><!-- 军官退休证 -->
			<xsl:when test="$idtype='13'">1</xsl:when><!-- 中国护照 -->
			<xsl:when test="$idtype='14'">8</xsl:when><!-- 外国人永久居留证 -->
			<xsl:when test="$idtype='15'">8</xsl:when><!-- 军事学员证 -->
			<xsl:when test="$idtype='16'">8</xsl:when><!-- 军事学员证 -->
			<xsl:when test="$idtype='17'">8</xsl:when><!-- 边民出入境通行证 -->
			<xsl:when test="$idtype='18'">8</xsl:when><!-- 村民委员会证明 -->
			<xsl:when test="$idtype='19'">8</xsl:when><!-- 学生证 -->
			<xsl:when test="$idtype='20'">8</xsl:when><!-- 其它 -->
			<xsl:when test="$idtype='21'">1</xsl:when><!-- 护照 -->
			<xsl:when test="$idtype='22'">8</xsl:when><!-- 港澳台同胞回乡证 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 投保人居民类型 -->
	<xsl:template match="TBR_RESIDENTS">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 农村 -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="RISKRATING">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- 是 -->
			<xsl:when test=".='0'">N</xsl:when><!-- 否 -->
		</xsl:choose>
	</xsl:template>
	
	
	<!-- 国籍转换 -->
	<xsl:template match="TBR_COUNTRY_CODE | BBR_COUNTRY_CODE | SYR_COUNTRY_CODE">
		<xsl:choose>
			<xsl:when test=".='0'">OTH</xsl:when><!--	其他     -->
			<xsl:when test=".='1'">CHN</xsl:when><!--	中国     -->
			<xsl:when test=".='2'">CHN</xsl:when><!--	香港     -->
			<xsl:when test=".='3'">CHN</xsl:when><!--	澳门     -->
			<xsl:when test=".='4'">CHN</xsl:when><!--	台湾     -->
			<xsl:when test=".='5'">US</xsl:when><!--	美国     -->
			<xsl:when test=".='6'">GB</xsl:when><!--	英国     -->
			<xsl:when test=".='7'">FR</xsl:when><!--	法国     -->
			<xsl:when test=".='8'">DE</xsl:when><!--	德国     -->
			<xsl:when test=".='9'">JP</xsl:when><!--	日本     -->
			<xsl:when test=".='10'">KR</xsl:when><!--	韩国     -->
			<xsl:when test=".='11'">SG</xsl:when><!--	新加坡   -->
			<xsl:when test=".='12'">MY</xsl:when><!--	马来西亚 -->
			<xsl:when test=".='13'">CA</xsl:when><!--	加拿大   -->
			<xsl:when test=".='14'">AU</xsl:when><!--	澳大利亚 -->
			<xsl:when test=".='15'">IN</xsl:when><!--  印度      -->
			<xsl:when test=".='16'">TH</xsl:when><!--	泰国     -->
			<xsl:when test=".='17'">RU</xsl:when><!--	俄罗斯   -->
			<xsl:when test=".='18'">ID</xsl:when><!--	印度尼西亚 -->
			<xsl:when test=".='19'">IT</xsl:when><!--	意大利   -->
			<xsl:otherwise>OTH</xsl:otherwise><!--	其他     -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 投保人、被保人关系；受益人、被保人关系 -->
	<!-- 核心：00 本人,01 父母,02 配偶,03 子女,04 其他,05 雇佣,06 抚养,07 扶养,08 赡养 -->	
	<!--<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA"> -->
	<!--	<xsl:choose> -->
	<!--		<xsl:when test=".='01'">00</xsl:when> --><!-- 本人 -->
	<!--		<xsl:when test=".='02'">01</xsl:when> --><!-- 父亲 -->
	<!--		<xsl:when test=".='03'">01</xsl:when> --><!-- 母亲 -->
	<!--		<xsl:when test=".='06'">02</xsl:when> --><!-- 丈夫 -->
	<!--		<xsl:when test=".='07'">02</xsl:when> --><!-- 妻子 -->
	<!--		<xsl:when test=".='04'">03</xsl:when> --><!-- 儿子 -->
	<!--		<xsl:when test=".='05'">03</xsl:when> --><!-- 女儿 -->
	<!--		<xsl:when test=".='30'">04</xsl:when> --><!-- 其它 -->
	<!--		<xsl:when test=".='37'">04</xsl:when> --><!-- 其它亲属 -->
	
	<!--		<xsl:otherwise>04</xsl:otherwise> --><!-- 其它 -->
	<!--	</xsl:choose> -->
	<!--</xsl:template> -->
	<!-- 核心：00 本人,01 父母,02 配偶,03 子女,04 其他,05 雇佣,06 抚养,07 扶养,08 赡养 -->	
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='01'">00</xsl:when><!-- 本人 -->
			<xsl:when test=".='02'">01</xsl:when><!-- 父亲 -->
			<xsl:when test=".='03'">01</xsl:when><!-- 母亲 -->
			<xsl:when test=".='06'">02</xsl:when><!-- 丈夫 -->
			<xsl:when test=".='07'">02</xsl:when><!-- 妻子 -->
			<xsl:when test=".='04'">03</xsl:when><!-- 儿子 -->
			<xsl:when test=".='05'">03</xsl:when><!-- 女儿 -->
			<xsl:when test=".='30'">04</xsl:when><!-- 法定-其它 -->
			<xsl:when test=".='38'">04</xsl:when><!-- 同事-其它 -->
			<xsl:when test=".='44'">04</xsl:when><!-- 亲属-其它 -->
			<xsl:otherwise>04</xsl:otherwise><!-- 其它 -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

