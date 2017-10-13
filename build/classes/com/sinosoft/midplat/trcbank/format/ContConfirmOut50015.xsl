<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TXLife>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="./*"/>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- 保单号 -->
			<PolicyNo>
				<xsl:value-of select="ContNo"/>
			</PolicyNo>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<!-- 保险产品信息 -->	
			<PlanCodeInfo>	
				<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />			
			</PlanCodeInfo>
			<SpecialAgreement></SpecialAgreement><!-- 保险公司特别约定 -->
			<PolBenefitCount>00</PolBenefitCount>
			<PolBenefitInfoList>
				<YeadEnd></YeadEnd>
				<CashValue></CashValue>
			</PolBenefitInfoList>
			<IsUseAutoDefPrtFmt>Y</IsUseAutoDefPrtFmt><!-- Y/N 是否使用保险公司自定义打印模式 -->
			<DesignPrtFmt></DesignPrtFmt><!-- 套打模块 -->
			
			
			<!-- 打印信息 -->
			
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			<StrAutoDefPrtFmt>
				<SCount>2</SCount><!-- 页数 -->
				<SList>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A<xsl:text>　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
	<xsl:text>               币值单位：人民币元</xsl:text></Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					<Context>A<xsl:text>　投保人姓名：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 19)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Appnt/IDType"/>
						<xsl:text>      证件号码：</xsl:text>
						<xsl:value-of select="Appnt/IDNo"/>
					</Context>
					<Context>A<xsl:text>　被保险人：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 21)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Insured/IDType"/>
						<xsl:text>      证件号码：</xsl:text>
						<xsl:value-of select="Insured/IDNo"/>
					</Context>
					<Context>A</Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					<xsl:if test="count(Bnf) = 0">
					<Context>A<xsl:text>　身故受益人：法定                </xsl:text>
					   <xsl:text>受益顺序：1                   </xsl:text>
					   <xsl:text>受益比例：100%</xsl:text></Context>
			        </xsl:if>
					<xsl:if test="count(Bnf)>0">
						<xsl:for-each select="Bnf">
							<Context>A
								<xsl:text>　身故受益人：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
								<xsl:text>受益顺序：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
								<xsl:text>受益比例：</xsl:text>
								<xsl:value-of select="Lot"/>
								<xsl:text>%</xsl:text>
							</Context>
						</xsl:for-each>
					</xsl:if>
					<Context>A</Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					
					<Context>A　险种资料</Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					<Context>
						<xsl:text>A　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
					</Context>
					<Context>
						<xsl:text>A　　　　险种名称               保险期间   交费年期    日津贴额\     保险费     交费频率</xsl:text>
					</Context>
					<Context>
						<xsl:text>A　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
					</Context>
					<Context>A　-------------------------------------------------------------------------------------</Context>
					<xsl:for-each select="Risk">
						<xsl:variable name="PayIntv" select="PayIntv"/>
						<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
						<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
						
						<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<Context>A<xsl:text>　</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 31)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
										<xsl:text/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 11)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 11)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>年缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>半年缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>季缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>月缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>不定期缴</xsl:text>
									</xsl:when>
								</xsl:choose>
							</Context>
					</xsl:when>
				   <xsl:otherwise>
						<Context>A<xsl:text>　</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 31)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
							</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
										<xsl:text/>
								</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 11)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 11)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',14)"/>
							</xsl:when>
						    <xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:text>趸缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 12">
								<xsl:text>年缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 6">
								<xsl:text>半年缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 3">
								<xsl:text>季缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 1">
								<xsl:text>月缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = -1">
								<xsl:text>不定期缴</xsl:text>
							</xsl:when>
							</xsl:choose>
						</Context>
			    	</xsl:otherwise>
			   </xsl:choose>	
					</xsl:for-each>
					<Context>A　--------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A　--------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A　--------------------------------------------------------------------------------------</Context>
					<xsl:variable name="SpecContent" select="SpecContent"/>
					<Context>A　保险单特别约定：</Context>
						<xsl:choose>
							<xsl:when test="$SpecContent=''">
								<Context>A<xsl:text>（无）</xsl:text></Context>
							</xsl:when>
							<xsl:otherwise>
								<Context>A　　　  您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司</Context>
								<Context>A　仅退还主险的现金价值。</Context>
								<Context>A　　　  当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同</Context>
								<Context>A　同时终止。不低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦</Context>
								<Context>A　长寿添利终身寿险（万能型）的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</Context>
							</xsl:otherwise>
						</xsl:choose>
					<Context>A　---------------------------------------------------------------------------------------</Context>
					<Context>A<xsl:text>　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                    保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Context>
					<Context>A<xsl:text>　营业机构：</xsl:text><xsl:value-of select="ComName" /></Context>
				
					<Context>A<xsl:text>　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Context>					
					<Context>A<xsl:text>　客户服务热线：95569                                 网址：http://www.anbang-life.com</xsl:text></Context>
					<Context>A<xsl:text>　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对</xsl:text></Context>
					<Context>A<xsl:text>　于保险期限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Context>
					<Context>A</Context>
					<Context>A<xsl:text>　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 31)"/><xsl:text>银行销售人工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></Context>
					<Context>A<xsl:text>　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 31)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Context>
				</SList>
				
				<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
				<xsl:variable name="RiskCount" select="count(Risk)"/>
				<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
	 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
				<SList>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A<xsl:text>　　　                                      </xsl:text>现金价值表</Context>
					<Context>A</Context>
					<Context>A　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 50)"/>币值单位：人民币元 </Context>
					<Context>A　---------------------------------------------------------------------------------------</Context>
					<Context>A　被保险人姓名：<xsl:value-of select="Insured/Name"/></Context>
	                <xsl:if test="$RiskCount=1">
			        <Context>A<xsl:text>　险种名称：                 </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Context>
			        <Context>A<xsl:text/>　保单年度末<xsl:text>                              </xsl:text>
					   <xsl:text>现金价值</xsl:text></Context>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <Context>A<xsl:text/><xsl:text>　　　</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Context>
				    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
		 	        <Context>A<xsl:text>　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Context>
			        <Context>A<xsl:text/>　保单年度末<xsl:text>                 </xsl:text>
					   <xsl:text>现金价值                                现金价值</xsl:text></Context>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <Context>A<xsl:text/><xsl:text>　　　</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Context>
				    </xsl:for-each>
		            </xsl:if>
					<Context>A　---------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A　备注：</Context>
					<Context>A　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Context>
					<Context>A　---------------------------------------------------------------------------------------</Context>
				</SList>
				</xsl:if>
			</StrAutoDefPrtFmt>
		</Body>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">
		<GetBankInfo><!-- 满期领取信息 -->
			<GetBankCode><xsl:value-of select="GetBankCode "/></GetBankCode><!-- 满期领取银行机构号 -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo "/></GetBankAccNo><!-- 满期领取银行账户 -->
			<GetAccName><xsl:value-of select="GetAccName "/></GetAccName><!-- 满期领取账户名称 -->
			<!-- <InsureDate></InsureDate> 投保日期（只限保单查询交易用） -->
			<!-- <TotlePremium></TotlePremium> 基本保费（只限保单查询交易用） -->
			<!-- <TotleAmnt></TotleAmnt> 基本保额（只限保单查询交易用） -->
			<!-- <Assumpsit></Assumpsit> 特别约定?(只限保单查询交易用) -->
		</GetBankInfo>
		<MCount>1</MCount>
		<PClist>
			<PCCategory>
				<PCInfo>
					<PCIsMajor>Y</PCIsMajor><!-- 是否主险（Y/N） -->
					<xsl:choose>
						<xsl:when test="../ContPlan/ContPlanCode=''">
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- 所属主险代码 -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- 险种代码  -->
			                <PCName><xsl:value-of select="RiskName"/></PCName><!-- 险种名称 -->
			                <PCNumber><xsl:value-of select="Mult"/></PCNumber><!-- 投保份数 -->
						</xsl:when>
						<xsl:otherwise>
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- 所属主险代码 -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- 险种代码  -->
			                <PCName><xsl:value-of select="../ContPlan/ContPlanName"/></PCName><!-- 险种名称 -->
			                <PCNumber><xsl:value-of select="../ContPlan/ContPlanMult"/></PCNumber><!-- 投保份数 -->
						</xsl:otherwise>
					</xsl:choose>
					<PCType></PCType><!-- 险种类型 0 传统险 1 分红险 2 投连险 3 万能险 -->	
					<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)"/></Amnt><!-- 保险金额（保额） -->
					<Premium><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)"/></Premium><!-- 基本保费 -->
					<OthAmnt></OthAmnt><!-- 额外保额 -->
					<OthPremium></OthPremium><!-- 额外保费 -->
					<StableBenifit></StableBenifit><!-- 满期返回固定收益 -->
					<InitFeeRate></InitFeeRate><!-- 初始费用比例 -->
					<Rate></Rate><!-- 费率或缴费标准（精确到%号后两位） -->
					<BonusPayMode></BonusPayMode><!-- 红利分配方式 -->
					<BonusAmnt></BonusAmnt><!-- 累计红利 -->
					<xsl:choose>
						<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'">
							<PayTermType>1</PayTermType><!-- 缴费年期类型 -->
							<PayYear>0</PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:when>
						<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'">
							<PayTermType>4</PayTermType><!-- 缴费年期类型 -->
							<PayYear>0</PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:when>
						<xsl:otherwise>
							<PayTermType><xsl:apply-templates select="PayEndYearFlag"/></PayTermType><!-- 缴费年期类型 -->
							<PayYear><xsl:value-of select="PayEndYear"/></PayYear><!-- 缴费年期(趸交时候此字段送0) -->
						</xsl:otherwise>
					</xsl:choose>
					<PayPeriodType></PayPeriodType><!-- 缴费年限类型 -->
					<FIRST_PAYWAY></FIRST_PAYWAY><!-- 首期交费形式 -->
					<NEXT_PAYWAY></NEXT_PAYWAY><!-- 续期交费形式 -->
					<LoanTerm></LoanTerm><!-- 贷款期间 -->
					<InsuranceTerm></InsuranceTerm><!-- 保险期间 -->
					<xsl:choose>
						<xsl:when test="InsuYearFlag ='A' and InsuYear ='106'">
							<CovPeriodType>1</CovPeriodType><!-- 保险年龄年期标志 -->
							<InsuYear>0</InsuYear><!-- 保险年龄年期 -->
						</xsl:when>
						<xsl:otherwise>
							<CovPeriodType><xsl:apply-templates select="InsuYearFlag"/></CovPeriodType><!-- 保险年龄年期标志 -->
							<InsuYear><xsl:value-of select="InsuYear "/></InsuYear><!-- 保险年龄年期 -->
						</xsl:otherwise>
					</xsl:choose>
					<FullBonusGetFlag></FullBonusGetFlag><!-- 满期领取保险金标记（是否能够领取保险金，需同步）（Y/N） -->
					<FullBonusGetMode></FullBonusGetMode><!-- 满期领取金领取方式 -->
					<FullBonusPeriod></FullBonusPeriod><!-- 满期领取年期年龄(0-99) -->
					<RenteGetMode></RenteGetMode><!-- 年金领取方式 -->
					<RentePeriod></RentePeriod><!-- 年金领取年期年龄(0-99) -->
					<SurBnGetMode></SurBnGetMode><!-- 生存金领取方式 -->
					<SurBnPeriod></SurBnPeriod><!-- 生存金领取年期年领(0-99) -->
					<AutoPayFlag></AutoPayFlag><!-- 自动垫交标记（Y/N） -->
					<SubFlag></SubFlag><!-- 减额缴清标记（Y/N） -->
					<!-- <Address></Address> 保险财产坐落地址(只产险共赢3号产品火灾责任用) -->
					<!-- <PostCode></PostCode> 保险财产坐落地址邮编(只产险共赢3号产品火灾责任用) -->
					<!-- <HouseStru></HouseStru> 房屋结构(只产险共赢3号产品火灾责任用) -->
					<!-- <HousePurp></HousePurp> 房屋用途 -->
				</PCInfo>
			</PCCategory>
		</PClist>
	</xsl:template>
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 缴费间隔  -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=0">一次交清</xsl:when>
			<xsl:when test=".=1">月交</xsl:when>
			<xsl:when test=".=3">季交</xsl:when>
			<xsl:when test=".=6">半年交</xsl:when>
			<xsl:when test=".=12">年交</xsl:when>
			<xsl:when test=".=-1">不定期交</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">男</xsl:when>
			<xsl:when test=".=1">女</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode"/>
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50015</xsl:when>
			<!-- 组合产品 50015-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 红利领取  -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">累计生息</xsl:when>
			<xsl:when test=".=2">领取现金</xsl:when>
			<xsl:when test=".=3">抵缴保费</xsl:when>
			<xsl:when test=".=5">增额交清</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PayEndYearFlag缴费年期  -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 缴至某年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
