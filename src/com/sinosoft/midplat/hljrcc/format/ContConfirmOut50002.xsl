<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<!-- 保单主信息 -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- 保险单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- 投保单(印刷)号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- 保单合同印刷号 -->
			<Prem>
				<xsl:value-of select="ActSumPrem"/>
			</Prem>
			<!-- 总保费 -->
			<PremText>
				<xsl:value-of select="ActSumPremText"/>
			</PremText>
			<!-- 总保费大写 -->
			<AgentCode>
				<xsl:value-of select="AgentCode"/>
			</AgentCode>
			<!-- 代理人编码 -->
			<AgentName>
				<xsl:value-of select="AgentName"/>
			</AgentName>
			<!-- 代理人姓名 -->
			<AgentGrpCode>
				<xsl:value-of select="AgentGrpCode"/>
			</AgentGrpCode>
			<!-- 代理人组别编码 -->
			<AgentGrpName>
				<xsl:value-of select="AgentGrpName"/>
			</AgentGrpName>
			<!-- 代理人组别 -->
			<AgentCom>
				<xsl:value-of select="AgentCom"/>
			</AgentCom>
			<!-- 代理机构编码 -->
			<AgentComName>
				<xsl:value-of select="AgentComName"/>
			</AgentComName>
			<!-- 代理机构名称 -->
			<ComCode>
				<xsl:value-of select="ComCode"/>
			</ComCode>
			<!-- 承保公司编码 -->
			<ComLocation>
				<xsl:value-of select="ComLocation"/>
			</ComLocation>
			<!-- 承保公司地址 -->
			<ComName>
				<xsl:value-of select="ComName"/>
			</ComName>
			<!-- 承保公司名称 -->
			<ComZipCode>
				<xsl:value-of select="ComZipCode"/>
			</ComZipCode>
			<!-- 承保公司邮编 -->
			<ComPhone>95569</ComPhone>
			<!-- 承保公司电话 -->
			<CAppNme>
				<xsl:value-of select="Appnt/Name"/>
			</CAppNme>
			<!-- 投保人姓名 -->
			<CProdNme>
				<xsl:value-of select="ContPlan/ContPlanName"/>
			</CProdNme>
			<!-- 险种名称 -->
			<TInsrncBgnTm>
				<xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate"/>
			</TInsrncBgnTm>
			<!-- 保险起期(yyyyMMdd)  -->
			<TInsrncEndTm>
				<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate"/>
			</TInsrncEndTm>
			<!-- 保险止期(yyyyMMdd)  -->
			<PayToDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Risk[RiskCode=MainRiskCode]/PayToDate)"/>
			</PayToDate>
			<!-- 交至日期(yyyyMMdd)  -->
			<CBankSellerCode/>
			<!-- 银行柜员号 -->
			<PRINT_NUM/>
			<!-- 打印页数 -->
			
			<!-- 打印信息 -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			
			<PRINT>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
<xsl:text>                                     币值单位：人民币元</xsl:text></PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　投保人姓名：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRINT_LINE><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></PRINT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRINT_LINE>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRINT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　险种资料</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　　　　　　　　                                               基本保险金额</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期      日津贴额\    保险费    交费频率</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　　　　　　　　                                                 份数\档次</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
						<PRINT_LINE>
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 12)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
							<xsl:text>-</xsl:text>
						</PRINT_LINE>
						</xsl:when>
						<xsl:otherwise>
						<PRINT_LINE>
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 12)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
							<xsl:text>趸缴</xsl:text>
						</PRINT_LINE>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<PRINT_LINE>　　　保险单特别约定：</PRINT_LINE>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<xsl:text>（无）</xsl:text>
					</xsl:when>
					<xsl:otherwise>
					<PRINT_LINE><xsl:text>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>　　　现金价值。</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>　　　低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>　　　的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</xsl:text></PRINT_LINE>
					</xsl:otherwise>
				</xsl:choose>
				<PRINT_LINE/>
				<PRINT_LINE>　　　-------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/></PRINT_LINE>
				<PRINT_LINE><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></PRINT_LINE>
			</PRINT>
			
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<PRINT>
			    <PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE><xsl:text>　　　                                        </xsl:text>现金价值表</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></PRINT_LINE>
                <xsl:if test="$RiskCount=1">
		        <PRINT_LINE>
			    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
		        <PRINT_LINE><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
				   <xsl:text>现金价值</xsl:text></PRINT_LINE>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRINT_LINE><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</PRINT_LINE>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <PRINT_LINE>
			    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
		        <PRINT_LINE><xsl:text/>　　　保单年度末<xsl:text>               </xsl:text>
				   <xsl:text>现金价值</xsl:text><xsl:text>                                </xsl:text><xsl:text>现金价值</xsl:text></PRINT_LINE>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRINT_LINE>
					 <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,21)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PRINT_LINE>
			    </xsl:for-each>
	            </xsl:if>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>　　　备注：</PRINT_LINE>
				<PRINT_LINE>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
			</PRINT>
			</xsl:if>
		</Body>
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
</xsl:stylesheet>
