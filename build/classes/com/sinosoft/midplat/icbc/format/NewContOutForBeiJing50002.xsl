<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head"/>
			<TXLifeResponse>
				<TransRefGUID/>
				<TransType>1013</TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	<xsl:template name="OLifE" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<OLifE>
			<Holding id="cont">
				<CurrencyTypeCode>001</CurrencyTypeCode>
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo"/>
					</PolNumber>
					<!--首期保费-->
					<PaymentAmt>
						<xsl:value-of select="ActSumPrem"/>
					</PaymentAmt>
					<!-- 本期保险费合计：根据PaymentAmt转化为汉字金额 （RMBPaymentAmt元） -->
					<Life>
						<CoverageCount>1</CoverageCount>
						<!--
						<CoverageCount>
							<xsl:value-of select="count(Risk)"/>
						</CoverageCount>
						 -->
						<xsl:apply-templates select="$MainRisk"/>
					</Life>
					<!--申请信息-->
					<ApplicationInfo>
						<!--投保书号-->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo"/>
						</HOAppFormNumber>
						<SubmissionDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/PolApplyDate)"/>
						</SubmissionDate>
					</ApplicationInfo>
					<OLifEExtension>
						<!-- 特别约定 -->
						<SpecialClause>
							<xsl:value-of select="$MainRisk/SpecContent"/>
						</SpecialClause>
						<!-- 旧保单印刷号 -->
						<OriginalPolicyFormNumber/>
						<!-- 保险公司服务电话 -->
						<InsurerDialNumber>95569</InsurerDialNumber>
						<!-- 贷款合同号 -->
						<ContractNo/>
						<!-- 贷款账号 -->
						<LoanAccountNo/>
						<!-- 贷款产品代码 -->
						<LoanProductCode/>
						<LoanAmount/>
						<!-- 借款金额 -->
						<FaceAmount/>
						<!-- 保险金额 -->
						<LoanStartDate/>
						<!-- 贷款起始日期 -->
						<LoanEndDate/>
						<!-- 贷款到期日期 -->
						<!-- 保险合同生效日期 -->
						<ContractEffDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/>
						</ContractEffDate>
						<!-- 保险合同到期日期 -->
						<ContractEndDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/InsuEndDate)"/>
						</ContractEndDate>
						<!-- 保险合同到期日期 -->
						<CovType/>
						<!-- 保障类型 -->
						<!-- 救援险保障信息 -->
						<CovArea/>
						<!-- 保障区域 -->
						<StartDate/>
						<!-- 保险起期 -->
						<EndDate/>
						<!-- 保险止期 -->
						<GrossPremAmt>
							<xsl:value-of select="//Body/ActSumPrem"/>
						</GrossPremAmt>
						<!-- 总保费 -->
						<CountryTo/>
						<!-- 前往国家 -->
						<!-- 试算信息 -->
						<CovPeriod/>
						<!-- 保险期限（天） -->
						<CalAmount/>
						<!-- 试算后总保费 -->
					</OLifEExtension>
				</Policy>
			</Holding>
		</OLifE>
		<!--保单逐行打印接口-->
		<Print>
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<SubVoucher>
				<!--凭证类型3保单-->
				<VoucherType>3</VoucherType>
				<!--总页数-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--页号-->
					<PageNum>1</PageNum>
					<!--一行打印的内容-->
					<xsl:variable name="Falseflag" select="java:java.lang.Boolean.parseBoolean('true')"/>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>保险单号码：<xsl:value-of select="ContNo"/>                                                    币值单位：人民币元</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>
							<xsl:text>投保人姓名：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 20)"/>
							<xsl:text>         证件类型：</xsl:text>
								<xsl:choose>
									<xsl:when test="Appnt/IDType = 0">
										<xsl:text>身份证    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 1">
										<xsl:text>护照      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 2">
										<xsl:text>军官证    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 3">
										<xsl:text>驾照      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 4">
										<xsl:text>出生证明  </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 5">
										<xsl:text>户口簿    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 8">
										<xsl:text>其他      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 9">
										<xsl:text>异常身份证</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose>
							<xsl:text>          证件号码：</xsl:text>
							<xsl:value-of select="Appnt/IDNo"/>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>
							<xsl:text>被保险人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 20)"/>
							<xsl:text>           证件类型：</xsl:text>
							<xsl:choose>
									<xsl:when test="Insured/IDType = 0">
										<xsl:text>身份证    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 1">
										<xsl:text>护照      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 2">
										<xsl:text>军官证    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 3">
										<xsl:text>驾照      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 4">
										<xsl:text>出生证明  </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 5">
										<xsl:text>户口簿    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 8">
										<xsl:text>其他      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 9">
										<xsl:text>异常身份证</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose> 
							<xsl:text>          证件号码：</xsl:text>
							<xsl:value-of select="Insured/IDNo"/>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>					
					<TextRowContent/>
					<xsl:variable name="BnfCount" select="count(Bnf)"/>
					<xsl:variable name="Ser1">
						<xsl:if test="$BnfCount = 0">
							<xsl:value-of select="1"/>
						</xsl:if>
						<xsl:if test="$BnfCount != 0">
							<xsl:value-of select="$BnfCount"/>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$BnfCount = 0">
						<TextContent>
							<TextRowContent>
								<xsl:text>身故受益人：法定                </xsl:text>
								<xsl:text>受益顺序：1                   </xsl:text>
								<xsl:text>受益比例：100%</xsl:text>
							</TextRowContent>
						</TextContent>
					</xsl:if>
					<xsl:if test="$BnfCount != 0">
						<xsl:variable name="flag" select="java:java.lang.Boolean.parseBoolean('false')"/>
						<xsl:for-each select="Bnf">
							<TextContent>
								<TextRowContent>
									<xsl:text/>身故受益人：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
									<xsl:text>受益顺序：</xsl:text>
									<xsl:value-of select="Grade"/>
									<xsl:text>               </xsl:text>
									<xsl:text> 受益比例：</xsl:text>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Lot, 3, $flag)"/>
									<xsl:text>%</xsl:text>
								</TextRowContent>
							</TextContent>
						</xsl:for-each>
					</xsl:if>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>险种资料</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>　　　　　　　                                             基本保险金额\</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>　　　　　　　险种名称              保险期间     交费年期    日津贴额\      保险费    交费频率</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>　　　　　　　                                               份数\档次</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<xsl:for-each select="Risk">
						<TextContent>
							<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
							<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
							<TextRowContent>
								<xsl:choose>
									<xsl:when test="RiskCode='122048'">
										<xsl:text/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
											</xsl:when>
											<xsl:when test="InsuYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 10)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
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
									</xsl:when>
									<xsl:otherwise>
										<xsl:text/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
											</xsl:when>
											<xsl:when test="InsuYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 10)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 10)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',15)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
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
									</xsl:otherwise>
								</xsl:choose>
							</TextRowContent>
						</TextContent>
					</xsl:for-each>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>保险费合计：<xsl:value-of select="ActSumPremText"/>（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>保险单特别约定：</xsl:text>
						</TextRowContent>
					</TextContent>
					<xsl:choose>
						<xsl:when test="SpecContent = ''">
							<TextContent>
								<TextRowContent><xsl:text>（无）</xsl:text></TextRowContent>
							</TextContent>
						</xsl:when>
						<xsl:otherwise>
							<TextContent>
								<TextRowContent>    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>现金价值。</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</TextRowContent>
							</TextContent>
						</xsl:otherwise>
					</xsl:choose>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>保险合同成立日期：<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/SignDate)"/>
							<xsl:text>                                       </xsl:text>保险合同生效日期：<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>营业机构：</xsl:text><xsl:value-of select="ComName" /></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>营业地址：</xsl:text><xsl:value-of select="ComLocation" /></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent>代理银行名称：中国工商银行</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>银行网点名称：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 53)"/>业务许可证编号：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 20)"/></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>银行销售人员：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,53)"/>从业资格证编号：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></TextRowContent>
					</TextContent>
				</Text>
			</SubVoucher>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''">
				<SubVoucher>
					<!--凭证类型 4 现价表-->
					<VoucherType>4</VoucherType>
					<!--总页数-->
					<PageTotal>1</PageTotal>
					<Text>
						<PageNum>1</PageNum>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>                                        现金价值表                     </TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
								<xsl:text/>被保险人姓名：<xsl:value-of select="Insured/Name"/></TextRowContent>
						</TextContent>
						<xsl:if test="$RiskCount = 1">
							<TextContent>
								<TextRowContent><xsl:text/>险种名称：<xsl:text>                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>
									<xsl:text/>保单年度末<xsl:text>                              </xsl:text>
									<xsl:text>现金价值</xsl:text></TextRowContent>
							</TextContent>
							<xsl:for-each select="$MainRisk/CashValues/CashValue">
								<TextContent>
									<TextRowContent>
										<xsl:text/><xsl:text>　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</TextRowContent>
								</TextContent>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="$RiskCount != 1">
							<TextContent>
								<TextRowContent><xsl:text/>险种名称：<xsl:text>              </xsl:text>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/>
									<xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>
									<xsl:text/>保单年度末<xsl:text>                       现金价值                               </xsl:text>
									<xsl:text>现金价值</xsl:text></TextRowContent>
							</TextContent>
							<xsl:for-each select="$MainRisk/CashValues/CashValue">
								<xsl:variable name="EndYear" select="EndYear"/>
								<TextContent>
									<TextRowContent>
										<xsl:text/><xsl:text>　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</TextRowContent>
								</TextContent>
							</xsl:for-each>
						</xsl:if>
						<xsl:variable name="CashCount" select="count($MainRisk/CashValues/CashValue)"/>
						<TextContent>
							<TextRowContent>
								<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text>备注：</xsl:text>
						</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text>所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </xsl:text></TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
								<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<!-- 
						<RowTotal><xsl:value-of select="18 + $CashCount"/></RowTotal>
						 -->
					</Text>
				</SubVoucher>
			</xsl:if>
		</Print>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="concat('risk_', string(position()))"/></xsl:attribute>
			<!-- 险种名称, 此处显示组合产品的名称 -->
			<PlanName><xsl:value-of select="../ContPlan/ContPlanName"/></PlanName>
			<!-- 险种代码 -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode"/>
			</ProductCode>
			<!-- 险种类型 LifeCovTypeCode-->
			<xsl:choose>
				<xsl:when test="RiskCode='122008'">
					<LifeCovTypeCode>1</LifeCovTypeCode>
					<!-- 非终身寿险 -->
				</xsl:when>
				<xsl:otherwise>
					<LifeCovTypeCode>9</LifeCovTypeCode>
					<!-- 终身寿险 -->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!-- 主副险标志 -->
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when>
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 缴费方式 频次 -->
			<PaymentMode>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="PayIntv">
						<xsl:value-of select="PayIntv"/>
					</xsl:with-param>
				</xsl:call-template>
			</PaymentMode>
			<!-- 投保金额 -->
			<InitCovAmt>
				<xsl:choose>
					<xsl:when test="Amnt>=0">
						<xsl:value-of select="Amnt"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</InitCovAmt>
			<!--  -->
			<FaceAmt>
				<xsl:choose>
					<xsl:when test="Amnt>=0">
						<xsl:value-of select="Amnt"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</FaceAmt>
			<!-- 投保份额 -->
			<IntialNumberOfUnits>
				<xsl:choose>
					<xsl:when test="../ContPlan/ContPlanMult>0">
						<xsl:value-of select="../ContPlan/ContPlanMult"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</IntialNumberOfUnits>
			<!-- 险种保费 -->
			<ModalPremAmt>
				<xsl:value-of select="../ActSumPrem"/>
			</ModalPremAmt>
			<!-- 起保日期 -->
			<EffDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)"/>
			</EffDate>
			<!-- 保单终止日期 -->
			<TermDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(InsuEndDate)"/>
			</TermDate>
			<!-- 交费起始日期 -->
			<FirstPaymentDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(SignDate)"/>
			</FirstPaymentDate>
			<!-- 缴费终止日期 -->
			<FinalPaymentDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(PayEndDate)"/>
			</FinalPaymentDate>
			<OLifEExtension>
				<xsl:choose>
					<!-- FIXME 这个地方有疑问，是否要调整？和接口文档“新契约应答_保单逐行打印接口文档.doc”中的描述有差异 -->
					<xsl:when test="(PayEndYear = 1) and (PayEndYearFlag = 'Y')">
						<PaymentDurationMode>5</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when>
					<xsl:otherwise>
						<PaymentDurationMode>
							<xsl:apply-templates select="PayEndYearFlag"/>
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear"/>
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- 保险期间：需要特殊转换,转成银行认可的保终身 -->
				<DurationMode>5</DurationMode>
				<Duration>0</Duration>
				<!-- 
				<xsl:choose>
					<xsl:when test="(InsuYear= 106) and (InsuYearFlag = 'A')">
						<DurationMode>5</DurationMode>
						<Duration>0</Duration>
					</xsl:when>
					<xsl:otherwise>
						<DurationMode>
							<xsl:apply-templates select="InsuYearFlag"/>
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear"/>
						</Duration>
					</xsl:otherwise>
				</xsl:choose>
				 -->
			</OLifEExtension>
		</Coverage>
	</xsl:template>
	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">男</xsl:when>
			<!-- 男 -->
			<xsl:when test=".=1">女</xsl:when>
			<!-- 女 -->
			<xsl:when test=".=2">其他</xsl:when>
			<!-- 其他 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template name="tran_GovtIDTC" match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>
			<!-- 身份证 -->
			<xsl:when test=".=1">1</xsl:when>
			<!-- 护照 -->
			<xsl:when test=".=2">2</xsl:when>
			<!-- 军官证 -->
			<xsl:when test=".=5">6</xsl:when>
			<!-- 户口本  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 关系 -->
	<xsl:template name="tran_RelationRoleCode" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>
			<!-- 配偶 -->
			<xsl:when test=".=03">2</xsl:when>
			<!-- 父母 -->
			<xsl:when test=".=04">3</xsl:when>
			<!-- 子女 -->
			<xsl:when test=".=21">4</xsl:when>
			<!-- 祖父祖母 -->
			<xsl:when test=".=31">5</xsl:when>
			<!-- 孙子女 -->
			<xsl:when test=".=12">6</xsl:when>
			<!-- 兄弟姐妹 -->
			<xsl:when test=".=25">7</xsl:when>
			<!-- 其他亲属 -->
			<xsl:when test=".=00">8</xsl:when>
			<!-- 本人 -->
			<xsl:when test=".=27">9</xsl:when>
			<!-- 朋友 -->
			<xsl:when test=".=25">99</xsl:when>
			<!-- 其他 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template name="tran_ProductCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".=122001">001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
			<xsl:when test=".=122002">002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
			<xsl:when test=".=122003">003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
			<xsl:when test=".=122004">101</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
			<xsl:when test=".=122006">004</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
			<xsl:when test=".=122008">005</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
			<xsl:when test=".=122009">006</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".=122010">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".=122011">007</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".=122012">008</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
			
			<xsl:when test=".=122010">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".=122029">010</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".=122020">011</xsl:when>	<!-- 安邦长寿6号两全保险（分红型）  -->
			<xsl:when test=".=122036">012</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			
			<!-- 组合产品: 50002-安邦长寿稳赢保险计划, 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成  -->
			<xsl:when test=".=122046">013</xsl:when>
			<xsl:when test=".=122048">013</xsl:when>
			<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成  -->
			<!-- 前五年50002这款产品的主险为122046，五年后这款主险的产品为122048,如果5年后做退保时核心传的主险险种便成了122048 -->
		      
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 缴费形式
<xsl:template name="tran_PaymentMethod" match="PayMode">
<xsl:choose>
	<xsl:when test=".=4">1</xsl:when>	
	
	<xsl:when test=".=3">2</xsl:when>	 
	<xsl:when test=".=1">3</xsl:when>	
	<xsl:when test=".=1">4</xsl:when>	
	<xsl:when test=".=1">5</xsl:when>	
	<xsl:when test=".=4">6</xsl:when>	 
	<xsl:when test=".=8">7</xsl:when>	
	<xsl:when test=".=9">9</xsl:when>	
	
	<xsl:otherwise></xsl:otherwise>
</xsl:choose> 
</xsl:template>
 -->
	<!-- 返回缴费方式 -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="PayIntv"/>
		<xsl:choose>
			<xsl:when test="PayIntv =12">1</xsl:when>
			<xsl:when test="PayIntv =1">2</xsl:when>
			<xsl:when test="PayIntv =6">3</xsl:when>
			<xsl:when test="PayIntv =3">4</xsl:when>
			<xsl:when test="PayIntv =0">5</xsl:when>
			<xsl:when test="PayIntv =-1">6</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 缴费频次2 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=12">年缴</xsl:when>
			<!-- 年缴 -->
			<xsl:when test=".=1">月缴</xsl:when>
			<!-- 月缴 -->
			<xsl:when test=".=6">半年缴</xsl:when>
			<!-- 半年缴 -->
			<xsl:when test=".=3">季缴</xsl:when>
			<!-- 季缴 -->
			<xsl:when test=".=0">趸缴</xsl:when>
			<!-- 趸缴 -->
			<xsl:when test=".=-1">不定期缴</xsl:when>
			<!-- 不定期 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 终交年期标志的转换 -->
	<xsl:template name="tran_PaymentDurationMode" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when>
			<!-- 缴至某确定年龄 -->
			<xsl:when test=".='Y'">2</xsl:when>
			<!-- 年 -->
			<xsl:when test=".='M'">3</xsl:when>
			<!-- 月 -->
			<xsl:when test=".='D'">4</xsl:when>
			<!-- 日 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 保险年龄年期标志 -->
	<xsl:template name="tran_DurationMode" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when>
			<!-- 保至某确定年龄 -->
			<xsl:when test=".='Y'">2</xsl:when>
			<!-- 年保 -->
			<xsl:when test=".='M'">3</xsl:when>
			<!-- 月保 -->
			<xsl:when test=".='D'">4</xsl:when>
			<!-- 日保 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 红利领取方式的转换 -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">累积生息</xsl:when>
			<xsl:when test=".=2">领取现金</xsl:when>
			<xsl:when test=".=3">抵交保费</xsl:when>
			<xsl:when test=".=5">增额交清</xsl:when>
			<xsl:when test=".=''">无红利</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
