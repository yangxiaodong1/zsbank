<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Transaction_Body" match="Body">
		<MAIN>
		 	<!--投保单号-->
		 	<APPLNO>
		 		<xsl:value-of select="ProposalPrtNo" />
		 	</APPLNO>
		 	<!--投保日期-->
		 	<ACCEPT_DATE >
		 		<xsl:value-of select="Risk/PolApplyDate" />
		 	</ACCEPT_DATE >
		 	<!--代理网点代码-->
		 	<AGENT_CODE>
		 		<xsl:value-of select="AgentCom" />
		 	</AGENT_CODE>
		 	<!--专管员-->
		 	<AGENT_PSN_NAME>
		 		<xsl:value-of select="AgentCode" />
		 	</AGENT_PSN_NAME>
		 	<!--投保人姓名-->
		 	<TBR_NAME>
		 		<xsl:value-of select="Appnt/Name" />
		 	</TBR_NAME>
		 	<!--投保人客户号-->
		 	<TBRPATRON>
		 		<xsl:value-of select="Appnt/CustomerNo" />
		 	</TBRPATRON>
		 	<!--被保人姓名-->
		 	<BBR_NAME>
		 		<xsl:value-of select="Insured/Name" />
		 	</BBR_NAME>
		 	<!--被保人客户号-->
		 	<BBRPATRON>
		 		<xsl:value-of select="Insured/CustomerNo" />
		 	</BBRPATRON>
		 </MAIN>
	
		 <!--险种信息-->
		 <OLIFE>
		 	<HOLDING>
		 		<POLICYINFO>
		 			<!--保险合同号-->
		 			<POLICYNO>
		 				<xsl:value-of select="ContNo" />
		 			</POLICYNO>
		 			<!--保单状态-->
		 			<POLICYSTATUS></POLICYSTATUS>
		 			<!--首期保费-->
		 			<PREM><xsl:value-of select="Prem" /></PREM>
		 			<!--保单生效日期 -->
		 			<VALIDATE><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate" /></VALIDATE>
		 			<!--合同成立日期-->
		 			<CONTRACT_DATE><xsl:value-of select="Risk[RiskCode=MainRiskCode]/SignDate" /></CONTRACT_DATE>
		 			<LIFE>
			 			<!--险种循环次数-->
		 				<PRODUCT_COUNT><xsl:value-of select="count(Risk)" /></PRODUCT_COUNT>
		 				<xsl:for-each select="Risk">
				 			<!--险种节点-->
		 					<COVERAGE>
					 			<!--主副险类别 0-主险，1-附加险-->
					 			<xsl:choose>
					 				<xsl:when test="RiskCode=MainRiskCode">
					 					<MAINSUBFLG>0</MAINSUBFLG>
					 				</xsl:when>
					 				<xsl:otherwise>
					 					<MAINSUBFLG>1</MAINSUBFLG>
					 				</xsl:otherwise>
					 			</xsl:choose>
					 			<!--险种名称-->
					 			<INSURNAME><xsl:value-of select="RiskName" /></INSURNAME>
					 			<!-- 险种代码 -->
					 			<PRODUCTID><xsl:apply-templates select="RiskCode"/></PRODUCTID>
					 			<!-- 缴费方式 -->
		 						<PAYMETHOD><xsl:apply-templates select="PayIntv"/></PAYMETHOD>
		 						<!--险种保额-->
		 						<PRODUCT_AMT><xsl:value-of select="Amnt"/></PRODUCT_AMT>
		 						<!--险种保费-->
		 						<PREMIUM><xsl:value-of select="Prem"/></PREMIUM>
		 						<!--起保日期-->
		 						<POLICY_DATE><xsl:value-of select="CValiDate"/></POLICY_DATE>
		 						<!--险种类型 1:寿险-->
		 						<INSUR_TYPE_COD>1</INSUR_TYPE_COD>
		 						<!--投保分数-->
		 						<AMT_UNIT><xsl:value-of select="Mult"/></AMT_UNIT>
		 						<!--交费起始日期-->
		 						<START_PAY_DATE></START_PAY_DATE>
		 						<!--缴费终止日期-->
		 						<END_PAY_DATE></END_PAY_DATE>
		 						<OLIFE_EXTENSION>
		 							<!--缴费年期类型字段特殊处理-->
		 							<xsl:choose>
		 								<xsl:when	test="PayEndYearFlag='Y' and PayEndYear='1000'">
		 									<!--趸交-->
		 									<CHARGE_PERIOD>1</CHARGE_PERIOD>
		 									<CHARGE_YEAR>0</CHARGE_YEAR>
		 								</xsl:when>
		 								<xsl:otherwise>
		 									<!--其他缴费形式-->
		 									<CHARGE_PERIOD>
		 										<xsl:apply-templates	select="PayEndYearFlag" />
		 									</CHARGE_PERIOD>
		 									<CHARGE_YEAR>
		 										<xsl:value-of	select="PayEndYear" />
		 									</CHARGE_YEAR>
		 								</xsl:otherwise>
		 							</xsl:choose>
		 							
		 							<!--保险年期类型字段特殊处理-->
		 							<xsl:choose>
		 								<xsl:when	test="InsuYearFlag='A' and InsuYear='106'">
		 									<!--保终身-->
		 									<COVERAGE_PERIOD>1</COVERAGE_PERIOD>
		 									<COVERAGE_YEAR>999</COVERAGE_YEAR>
		 								</xsl:when>
		 								<xsl:otherwise>
		 									<!--其他保险年期-->
		 									<COVERAGE_PERIOD>
		 										<xsl:apply-templates	select="InsuYearFlag" />
		 									</COVERAGE_PERIOD>
		 									<COVERAGE_YEAR>
		 										<xsl:value-of	select="InsuYear" />
		 									</COVERAGE_YEAR>
		 								</xsl:otherwise>
		 							</xsl:choose>
		 						</OLIFE_EXTENSION>
		 					</COVERAGE>
		 				</xsl:for-each>
		 			</LIFE>
		 			<OLIFE_EXTENSION>
		 				<SPECIAL_CLAUSE></SPECIAL_CLAUSE>
		 				<TEL>95569</TEL>
		 			</OLIFE_EXTENSION>
		 		</POLICYINFO>
		 	</HOLDING>
		 </OLIFE>
		
		<!-- 打印信息 -->
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
		<PRINT>
		    <xsl:choose>
				<xsl:when test="$MainRisk/CashValues/CashValue/EndYear != ''">
					<VOUCHER_NUM>2</VOUCHER_NUM>
				</xsl:when>
				<xsl:otherwise>
					<VOUCHER_NUM>1</VOUCHER_NUM>
				</xsl:otherwise>
			</xsl:choose>
		    <SUB_VOUCHER>
			<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			<VOUCHER_TYPE>3</VOUCHER_TYPE>
		    <PAGE_TOTAL>1</PAGE_TOTAL>
		    <TEXT>
		    	<PAGE_NUM>1</PAGE_NUM>
		    	<ROW_TOTAL></ROW_TOTAL>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>
					<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
					<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
					<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>
					<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
					<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
					<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
				</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:if test="count(Bnf) = 0">
				<TEXT_ROW_CONTEXT><xsl:text>　　　身故受益人：法定                </xsl:text>
						   <xsl:text>受益顺序：1                   </xsl:text>
						   <xsl:text>受益比例：100%</xsl:text></TEXT_ROW_CONTEXT>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<TEXT_ROW_CONTEXT>
					<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</TEXT_ROW_CONTEXT>
				</xsl:for-each>
				</xsl:if>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　险种资料</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　　　　　　　　                                             基本保险金额\</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期    日津贴额\      保险费    交费频率</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　　　　　　　　                                               份数\档次</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
				<TEXT_ROW_CONTEXT><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 12)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 12)"/>
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
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
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
				</TEXT_ROW_CONTEXT>
				</xsl:for-each>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　保险费合计：<xsl:value-of select="PremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>元整）</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<TEXT_ROW_CONTEXT>　　　保险单特别约定：<xsl:choose>
										<xsl:when test="$SpecContent=''">
											<xsl:text>（无）</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$SpecContent"/>
										</xsl:otherwise>
									</xsl:choose></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　-------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy年MM月dd日')"/><xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy年MM月dd日')"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　客户服务热线：95569                                              网址：http://www.anbang-life.com</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT/>
				<TEXT_ROW_CONTEXT><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 0)"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></TEXT_ROW_CONTEXT>
			</TEXT>
	    </SUB_VOUCHER>
	    <xsl:if test="$MainRisk/CashValues/CashValue/EndYear != ''">
	    <SUB_VOUCHER>
	    <xsl:variable name="RiskCount" select="count(Risk)"/>
			<VOUCHER_TYPE>4</VOUCHER_TYPE>
		    <PAGE_TOTAL>1</PAGE_TOTAL>
	        <TEXT>
	        	<PAGE_NUM>1</PAGE_NUM>
	        	<ROW_TOTAL></ROW_TOTAL>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>　　　                                        </xsl:text>现金价值表</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></TEXT_ROW_CONTEXT>
			    <xsl:if test="$RiskCount=1">
				<TEXT_ROW_CONTEXT>
				    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
						   <xsl:text>现金价值</xsl:text></TEXT_ROW_CONTEXT>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <TEXT_ROW_CONTEXT><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</TEXT_ROW_CONTEXT>
			       </xsl:for-each>
			    </xsl:if>
			 
			    <xsl:if test="$RiskCount!=1">
			 	<TEXT_ROW_CONTEXT>
					<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
						   <xsl:text>现金价值</xsl:text></TEXT_ROW_CONTEXT>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <TEXT_ROW_CONTEXT>
							  <xsl:text/><xsl:text>　　　　　</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</TEXT_ROW_CONTEXT>
					</xsl:for-each>
			    </xsl:if>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　备注：</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>　　　------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			</TEXT>	
	    </SUB_VOUCHER>
	    </xsl:if>
    	</PRINT>
	</xsl:template>
 


	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<!-- 广发：1 身份证，2 军人证，3 护照，4 出生证，5 其它 -->
	<!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">身份证  </xsl:when>
			<xsl:when test=".='1'">护照    </xsl:when>
			<xsl:when test=".='2'">军官证  </xsl:when>
			<xsl:when test=".='3'">驾照    </xsl:when>
			<xsl:when test=".='4'">出生证明</xsl:when>
			<xsl:when test=".='5'">户口簿  </xsl:when>
			<xsl:otherwise>其他    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<!-- 广发：1 年交，2 半年交，3 季交，4 月交，5 趸交 -->
	<xsl:template match="PayIntv">
		<xsl:if test=".='12'">1</xsl:if><!-- 年缴 -->
		<xsl:if test=".='6'">2</xsl:if><!-- 半年交 -->
		<xsl:if test=".='3'">3</xsl:if><!-- 季交-->
		<xsl:if test=".='1'">4</xsl:if><!-- 月交 -->
		<xsl:if test=".='0'">5</xsl:if><!-- 趸交 -->
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<!-- 广发：0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when><!-- 按日 -->
			<xsl:when test=".='M'">4</xsl:when><!-- 按月 -->
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 保至某年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<!-- 广发：0 无关，1 趸交，2 按年限交，3 交至某确定年龄，4 终生交费，5 不定期交 -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".='L12089'">L12089</xsl:when>  <!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
