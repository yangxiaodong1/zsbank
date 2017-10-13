<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TXLife>
	</xsl:template>

	<!-- 主信息 -->
	<xsl:template name="MAIN" match="Body">
	    <xsl:variable name="CashValueCount" select="count(Risk[RiskCode=MainRiskCode]//CashValue)"/>
		<!--保单号-->
		<PolicyNo>
			<xsl:value-of select="ContNo" />
		</PolicyNo>
		<PlanCodeInfo>
			<GetBankInfo>
				<GetBankCode />
				<GetBankAccNo />
				<GetAccName />
			</GetBankInfo>
			<MCount>1</MCount>
			<PClist>
				<PCCategory>
					<xsl:apply-templates select="//Risk[RiskCode=MainRiskCode]" />
				</PCCategory>
			</PClist>
		</PlanCodeInfo>
		<SpecialAgreement />
		<PolBenefitCount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillWith0($CashValueCount,2)" /></PolBenefitCount>
		<xsl:if test="$CashValueCount > 0">
			<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]//CashValue" />
		</xsl:if>
		<!-- 没有现金价值表 -->
		<xsl:if test="$CashValueCount = 0">
			<PolBenefitInfoList>
				<YeadEnd />
				<CashValue />
			</PolBenefitInfoList>
		</xsl:if>
		<IsUseAutoDefPrtFmt>Y</IsUseAutoDefPrtFmt>
		<!-- 打印信息 -->
		<StrAutoDefPrtFmt>
		    <xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
			<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			
			<xsl:choose>
				<xsl:when test="$CashValueCount > 0">
					<SCount>2</SCount>
				</xsl:when>
				<xsl:otherwise>
					<SCount>1</SCount>
				</xsl:otherwise>
			</xsl:choose>
			<!--页数-->
			<SList>
				<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
				<!--按页循环-->
				<!--本行打印内容.该页可打印行数必须传满，空行本域将为空，如：该页可打60行，在该SList必须传60个Context-->
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				<xsl:text>                                      币值单位：人民币元</xsl:text></Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>
					<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
					<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
					<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</Context>
				<Context>
					<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
					<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
					<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
				</Context>
				<Context>　</Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<xsl:if test="count(Bnf) = 0">
				<Context><xsl:text>　　　身故受益人：法定                </xsl:text>
						   <xsl:text>受益顺序：1                   </xsl:text>
						   <xsl:text>受益比例：100%</xsl:text></Context>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<Context>
					<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</Context>
				</xsl:for-each>
				</xsl:if>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　</Context>
				<Context>　　　险种资料</Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context><xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text></Context>
				<Context><xsl:text>　　　　　　　　　　险种名称              保险期间    交费年期      日津贴额\    保险费      交费频率</xsl:text></Context>
				<Context><xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text></Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				
				<xsl:choose>
					<xsl:when test="RiskCode='L12081'">
						<Context><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 14)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 14)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
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
						<Context><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
								</xsl:when>
								<xsl:when test="InsuYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
									<xsl:text></xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="PayIntv = 0">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 14)"/>
								</xsl:when>
								<xsl:when test="PayEndYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 14)"/>
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',13)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,14)"/>
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
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　</Context>
				<Context>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Context>
				<Context>　</Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<Context>　　　保险单特别约定：</Context>
			
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<Context><xsl:text>（无）</xsl:text></Context>
					</xsl:when>
					<xsl:otherwise>
						<Context>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</Context>
						<Context>　　　现金价值。</Context>
						<Context>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</Context>
						<Context>　　　低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</Context>
						<Context>　　　的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</Context>
					</xsl:otherwise>
				</xsl:choose>
				<Context>　　　-------------------------------------------------------------------------------------------------</Context>
				<Context>
					<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Context>
				<Context><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></Context>
				<Context><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Context>
				<Context><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Context>
				<Context>　</Context>
				<Context><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Context>
				<Context><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Context>
				<Context>　</Context>
				<Context><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>业务许可证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Context>
				<Context><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Context>
			</SList>
			
			<xsl:if test="$CashValueCount > 0">
			
            <xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<SList>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context>　</Context>
				<Context><xsl:text>　　　                                        </xsl:text>现金价值表</Context>
				<Context>　</Context>
				<Context>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Context>
			    <xsl:if test="$RiskCount=1">
				<Context>
				    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Context>
				<Context><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
						   <xsl:text>现金价值</xsl:text></Context>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <Context><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Context>
			       </xsl:for-each>
			    </xsl:if>
			 
			    <xsl:if test="$RiskCount!=1">
			 	<Context>
					<xsl:text>　　　险种名称：              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Context>
				<Context><xsl:text/>　　　保单年度末<xsl:text>                      </xsl:text>
						   <xsl:text>现金价值                                现金价值</xsl:text></Context>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <Context>
							  <xsl:text/><xsl:text>　　　　　</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Context>
					</xsl:for-each>
			    </xsl:if>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>
				<Context>　</Context>
				<Context>　　　备注：</Context>
				<Context>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </Context>
				<Context>　　　------------------------------------------------------------------------------------------------</Context>			
			</SList>
			</xsl:if>
		</StrAutoDefPrtFmt>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Risk" match="Risk">
		<PCInfo>
			<PCIsMajor>
				<xsl:if test="RiskCode != MainRiskCode">N</xsl:if>
				<xsl:if test="RiskCode = MainRiskCode">Y</xsl:if>
			</PCIsMajor>
			<BelongMajor>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="MainRiskCode" />
				</xsl:call-template>
			</BelongMajor>
			<PCCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</PCCode>
			<PCType>
			    <xsl:call-template name="tran_riskType">
					<xsl:with-param name="pcType" select="RiskType" />
				</xsl:call-template>
			</PCType>
			<PCNumber>
				<xsl:value-of select="..//ContPlan/ContPlanMult" />
			</PCNumber>
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</Amnt>
			<Premium>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
			</Premium>
			<OthAmnt></OthAmnt>
			<OthPremium></OthPremium>
			<StableBenifit></StableBenifit>
			<InitFeeRate></InitFeeRate>
			<Rate></Rate>
			<BonusPayMode></BonusPayMode>
			<BonusAmnt></BonusAmnt>
			<!-- 缴费年期类型 -->
			<xsl:choose>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
					<!-- 趸交或交终身 -->
					<PayTermType>1</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear != 1000)">
					<!-- 年缴 -->
					<PayTermType>2</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- 缴至某确定年龄 -->
					<PayTermType>3</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- 终身 -->
					<PayTermType>4</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
			</xsl:choose>
			<PayPeriodType></PayPeriodType>
			<LoanTerm></LoanTerm>
			<InsuranceTerm></InsuranceTerm>
			<!-- 保险年期类型 -->
			<xsl:if test = "..//ContPlan/ContPlanCode = '50015'">
			    <CovPeriodType>1</CovPeriodType>			
			</xsl:if>
			<xsl:if test = "..//ContPlan/ContPlanCode != '50015'">
			    <xsl:choose>
				   <xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					  <!-- 终身 -->
					  <CovPeriodType>1</CovPeriodType>
				   </xsl:when>
				   <xsl:otherwise>
					  <!-- 其他保险年期 -->
					  <CovPeriodType><xsl:apply-templates  select ="InsuYearFlag"/></CovPeriodType>
				   </xsl:otherwise>
			    </xsl:choose>			
			</xsl:if>
			<InsuYear></InsuYear>
			<FullBonusGetFlag></FullBonusGetFlag>
			<FullBonusGetMode></FullBonusGetMode>
			<FullBonusPeriod></FullBonusPeriod>
			<RenteGetMode></RenteGetMode>
			<RentePeriod></RentePeriod>
			<SurBnGetMode></SurBnGetMode>
			<SurBnPeriod></SurBnPeriod>
			<AutoPayFlag></AutoPayFlag>
			<SubFlag></SubFlag>
		</PCInfo>
	</xsl:template>

	<!-- 现金价值信息 -->
	<xsl:template name="CashValue" match="CashValue">
		<PolBenefitInfoList>
			<YeadEnd><xsl:value-of select="EndYear" /></YeadEnd>
			<CashValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" /></CashValue>
		</PolBenefitInfoList>
	</xsl:template>
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">身份证</xsl:when>
		<xsl:when test=".=1">护照  </xsl:when>
		<xsl:when test=".=2">军官证</xsl:when>
		<xsl:when test=".=3">驾照  </xsl:when>
		<xsl:when test=".=5">户口簿</xsl:when>
		<xsl:when test=".=6">港澳台通行证</xsl:when>
		<xsl:when test=".=9">临时身份证</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122046'">LNABZX02</xsl:when>
			<!-- 50002(50015)-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种类型 -->
	<xsl:template name="tran_riskType">
		<xsl:param name="pcType" />
		<xsl:choose>
			<xsl:when test="$pcType='1'">0</xsl:when><!-- 传统险 -->
			<xsl:when test="$pcType='2'">1</xsl:when><!-- 分红 -->
			<xsl:when test="$pcType='3'">2</xsl:when><!-- 投连 -->
			<xsl:when test="$pcType='4'">3</xsl:when><!-- 万能 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保障年期类型0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年限保 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='M'">4</xsl:when><!-- 按月保 -->
			<xsl:when test=".='D'">5</xsl:when><!-- 按天保 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
