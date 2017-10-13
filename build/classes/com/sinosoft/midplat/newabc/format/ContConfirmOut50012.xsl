<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>


	<xsl:template match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

		
		<App>
			<!-- 保单信息 -->
			<Ret>
				<!-- 保单号 -->
				<PolicyNo>
					<xsl:value-of select="ContNo" />
				</PolicyNo>
				<!-- 保单印刷号 -->
				<VchNo>
					<xsl:value-of select="ContPrtNo" />
				</VchNo>
				<!-- 签约日期 -->
				<AcceptDate>
					<xsl:value-of select="$MainRisk/SignDate" />
				</AcceptDate>
				<!-- 保险生效日期 -->
				<ValidDate>
					<xsl:value-of select="$MainRisk/CValiDate" />
				</ValidDate>
				<!-- 保险终止日期 -->
				<PolicyDuedate>
					<xsl:value-of select="$MainRisk/InsuEndDate" />
				</PolicyDuedate>
				<!-- 交费期限 -->
				<DueDate>
					<xsl:value-of select="$MainRisk/PayEndDate" />
				</DueDate>
				<!-- 业务员代码 -->
				<UserId></UserId>
				<!-- 缴费账户 -->
				<PayAccount></PayAccount>
				<!-- 缴费金额 -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
				</Prem>
				<!-- 主险信息 -->
				<Risks>
					<!-- 主险险种名称 -->
					<Name>
						<xsl:value-of select="ContPlan/ContPlanName" />
					</Name>
					<!-- 投保份数 -->
					<Share>
						<xsl:value-of select="ContPlan/ContPlanMult" />
					</Share>
					<!-- 保费 -->
					<Prem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)" />
					</Prem>
					<!-- 缴费年期 -->
					<PayDueDate>1</PayDueDate>
					<!-- 缴费方式 -->
					<PayType>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
					</PayType>
				</Risks>
				<!-- 险种打印列表 -->
        		<Prnts>
        			<Count></Count>
 					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>
						<xsl:text>　　　投保人姓名：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Appnt/IDType"/>
						<xsl:text>        证件号码：</xsl:text>
						<xsl:value-of select="Appnt/IDNo"/>
					</Prnt>
					<Prnt>
						<xsl:text>　　　被保险人：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Insured/IDType"/>
						<xsl:text>        证件号码：</xsl:text>
						<xsl:value-of select="Insured/IDNo"/>
					</Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<xsl:if test="count(Bnf) = 0">
					<Prnt><xsl:text>　　　身故受益人：法定                </xsl:text>
					   <xsl:text>受益顺序：1                   </xsl:text>
					   <xsl:text>受益比例：100%</xsl:text></Prnt>
			        </xsl:if>
					<xsl:if test="count(Bnf)>0">
						<xsl:for-each select="Bnf">
							<Prnt>
								<xsl:text>　　　身故受益人：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
								<xsl:text>受益顺序：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
								<xsl:text>受益比例：</xsl:text>
								<xsl:value-of select="Lot"/>
								<xsl:text>%</xsl:text>
							</Prnt>
						</xsl:for-each>
					</xsl:if>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>　　　险种资料</Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt><xsl:text>　　　　     　　　　　　                                        基本保险金额\</xsl:text></Prnt>
					<Prnt><xsl:text>　　　　　　　险种名称                     保险期间    交费年期    日津贴额\      保险费     交费频率</xsl:text></Prnt>
					<Prnt><xsl:text>　　　　　　　     　　　                                          份数\档次</xsl:text></Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<xsl:for-each select="Risk">
						<xsl:variable name="PayIntv" select="PayIntv"/>
						<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
						<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
						<Prnt>
							<xsl:text>　　　</xsl:text>
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
									<xsl:text/>
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
						</Prnt>
					</xsl:for-each>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>　　　保险费合计：<xsl:value-of select="ActSumPremText"/>（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Prnt>
					<Prnt/>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>　　　保险单特别约定：</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>　　　    《安邦长寿安享5号年金保险计划》由主险《安邦长寿安享5号年金保险》及附加险《安邦附加长寿</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>　　　添利5号两全保险（万能型）》组成。经生存年金受益人同意后，主险产品的生存年金，在年金给付日自动转</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>　　　入附加险万能账户中，享受日日复利，月月结息的资金增值服务。</xsl:text>
   		    		</Prnt>
					<Prnt>　　　-------------------------------------------------------------------------------------------------</Prnt>
					<Prnt><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring($MainRisk/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring($MainRisk/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring($MainRisk/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Prnt>
					<Prnt/>
					<Prnt><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></Prnt>
					<Prnt><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Prnt>
					<Prnt/>
					<Prnt><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Prnt>
					<Prnt/>
					<Prnt><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Prnt>
					<Prnt><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Prnt>
					<Prnt/>
					<Prnt><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/>业务许可证编号：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 20)"/></Prnt>
					<Prnt><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/>从业资格证编号：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Prnt>
				    <Prnt><xsl:text>　　　本保险单是银行根据保险公司的授权代理销售，相关合同责任由保险公司承担。</xsl:text></Prnt>
				</Prnts>

				<Messages>
					<Count></Count>
					<xsl:if test="$MainRisk/CashValues/CashValue != ''"> 
						<!-- 当有现金价值时，打印现金价值 -->	
						<xsl:variable name="RiskCount" select="count(Risk)"/>
					    <Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt/>
						<Prnt><xsl:text>　　　                                        </xsl:text>现金价值表</Prnt>
						<Prnt/>
						<Prnt>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </Prnt>
						<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
						<Prnt>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Prnt>
				        <Prnt>
					    <xsl:text>　　　险种名称：                          </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Prnt>
				        <Prnt><xsl:text/>　　　保单年度末                  <xsl:text>现金价值</xsl:text><xsl:text>                保单年度末            </xsl:text>
						   <xsl:text>现金价值</xsl:text></Prnt>
						<xsl:variable name="EndYear" select="EndYear"/>
						<Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('1',24)"/>
										<xsl:variable name="Cash1" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[1]/Cash)"/>
										<xsl:variable name="Cash1a" select="concat($Cash1,'元')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash1a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 9',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[9]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('2',24)"/>
												<xsl:variable name="Cash2" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[2]/Cash)"/>
												<xsl:variable name="Cash2a" select="concat($Cash2,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash2a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('10',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[10]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('3',24)"/>
												<xsl:variable name="Cash3" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[3]/Cash)"/>
												<xsl:variable name="Cash3a" select="concat($Cash3,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash3a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('11',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[11]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('4',24)"/>
												<xsl:variable name="Cash4" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[4]/Cash)"/>
												<xsl:variable name="Cash4a" select="concat($Cash4,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash4a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('12',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[12]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('5',24)"/>
												<xsl:variable name="Cash5" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[5]/Cash)"/>
												<xsl:variable name="Cash5a" select="concat($Cash5,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash5a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('13',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[13]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('6',24)"/>
												<xsl:variable name="Cash6" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[6]/Cash)"/>
												<xsl:variable name="Cash6a" select="concat($Cash6,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash6a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('14',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[14]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('7',24)"/>
												<xsl:variable name="Cash7" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[7]/Cash)"/>
												<xsl:variable name="Cash7a" select="concat($Cash7,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash7a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('15',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[15]/Cash)"/>元</Prnt>
					   <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('8',24)"/>
												<xsl:variable name="Cash8" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[8]/Cash)"/>
												<xsl:variable name="Cash8a" select="concat($Cash8,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash8a,10)"/></Prnt>
						<!--    
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,40)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Prnt>
					    </xsl:for-each>
					    -->
						<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
						<Prnt/>
						<Prnt>　　　备注：</Prnt>
						<Prnt>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Prnt>
						<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>		
					</xsl:if>
				</Messages>
			</Ret>
 		</App>
	</xsl:template>
	
	<!-- 缴费频次 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
		    <xsl:when test=".='-1'">0</xsl:when><!--  不定期 -->
		    <xsl:when test=".='0'">1</xsl:when><!--  趸交 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 月交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交 -->
			<xsl:when test=".='6'">4</xsl:when><!-- 半年交 -->
			<xsl:when test=".='12'">5</xsl:when><!-- 年交 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">身份证</xsl:when>
		<xsl:when test=".=1">护照  </xsl:when>
		<xsl:when test=".=2">军官证</xsl:when>
		<xsl:when test=".=3">驾照  </xsl:when>
		<xsl:when test=".=5">户口簿</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>