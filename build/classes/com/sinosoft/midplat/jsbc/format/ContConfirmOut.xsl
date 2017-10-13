<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
<xsl:template match="/TranData">
		<RETURN>
			<xsl:copy-of select="Head" />
			<MAIN>
				<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
				<!-- 账号代码 -->
				<ACC_CODE></ACC_CODE>
				<!-- 投保单号 -->
				<APPLNO><xsl:value-of select ="Body/ProposalPrtNo"/></APPLNO>
				<!-- 保险单号 -->
				<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
				<!-- 投保日期 -->
				<ACCEPT><xsl:value-of select ="$MainRisk/PolApplyDate"/></ACCEPT>
				<!-- 首期保费大写 -->
				<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
				<!-- 首期保费 -->
				<PREM><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/></PREM>
				<!-- 保单生效日期 -->
				<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE>
				<!-- 投保人姓名 -->
				<TBR_NAME><xsl:value-of select ="Body/Appnt/Name"/></TBR_NAME>
				<!-- 被保人客户号 -->
				<TBRPATRON />
				<!-- 被保人姓名 -->
				<BBR_NAME><xsl:value-of select ="Body/Insured/Name"/></BBR_NAME>
				<!-- 被保人客户号 -->
				<BBRPATRON></BBRPATRON>
				<!-- 交费方式 -->
				<PAYMETHOD><xsl:apply-templates select ="$MainRisk/PayIntv"/></PAYMETHOD>
				<!-- 交费方式汉字描述 -->
				<PAY_METHOD>
					<xsl:call-template name="tran_PayIntv">
						 <xsl:with-param name="payIntv">
						 	<xsl:value-of select="$MainRisk/PayIntv"/>
					     </xsl:with-param>
					 </xsl:call-template>
				</PAY_METHOD>
				<!-- 交费日期 -->
				<PAYDATE><xsl:value-of select ="$MainRisk/PolApplyDate"/></PAYDATE>
				<!-- 承保公司名称 -->
				<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
				<!-- 承保公司地址 -->
				<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
				<!-- 承保公司地址 -->
				<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
				<!-- 0：不打印特别约定，5：红色加粗数字部分打印5，10：红色加粗数字部分打印10 -->
				<ASSUM>0</ASSUM>
				<!-- 承保公司机构号 -->
				<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
				<!-- 续期交费日期汉字描述 -->
				<PAYDATECHN></PAYDATECHN>
				<!-- 交费起止日期汉字描述 -->
				<PAYSEDATECHN></PAYSEDATECHN>
				<!-- 交费期间 -->
				<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR>
				<!-- 代理网点代码 -->
				<AGENT_CODE></AGENT_CODE>
				<!-- 专管员 -->
				<AGENT_PSN_NAME></AGENT_PSN_NAME>
			</MAIN>
			
			<!-- 险种信息 -->
			<PTS>
				<xsl:apply-templates select="Body/Risk[RiskCode=MainRiskCode]"/>
			</PTS>
			<!-- 打印信息列表 -->
			<xsl:apply-templates select="Body"/>
			
		</RETURN>
	</xsl:template>
	
	
	<!-- 险种信息 -->
	<xsl:template name="PT" match="Risk">
		<xsl:variable name="Prem" select="../ActSumPrem"/>
		<xsl:variable name="Amnt" select="../Amnt"/>
		<PT>
			<!-- 保单号 -->
			<POLICY><xsl:value-of select ="//Body/ContNo"/></POLICY>
			<UNIT><xsl:value-of select ="Mult"/></UNIT>
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<MAINSUBFLG>1</MAINSUBFLG>
				</xsl:when>
				<xsl:otherwise>
					<MAINSUBFLG>0</MAINSUBFLG>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- FIXME 和银行确认接口文档 保费 -->
			<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/></AMT>
			<!-- FIXME 和银行确认接口文档 保险金额 -->
			<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></PREM>
			<!-- 险种代码 -->
			<POL_CODE>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</POL_CODE>
			<!-- 险种名称 -->
			<NAME><xsl:value-of select ="RiskName"/></NAME>
			<!-- 保险期间类型 -->
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- 终身:0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保  -->
					<PERIOD>1</PERIOD>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 保险期间 -->
			<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
			<!-- 交费期满日期 -->
			<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
			<xsl:choose>
				<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'" >
					<!-- 趸交或交终身 -->
					<CHARGE_PERIOD>1</CHARGE_PERIOD>
					<CHARGE_YEAR>1000</CHARGE_YEAR>
				</xsl:when>
				<!-- 银行：0 无关，1 趸交，2 按年限交，3 交至某确定年龄，4 终生交费，5 不定期交  -->
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- 交费年期类型 -->
					<CHARGE_PERIOD>4</CHARGE_PERIOD>
					<!-- 交费期间 -->
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear != 1000)">
					<!-- 年缴 -->
					<CHARGE_PERIOD>2</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- 缴至某确定年龄 -->
					<CHARGE_PERIOD>3</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
			</xsl:choose>
		</PT>
	</xsl:template>
	
	<xsl:template name="PRTS" match="Body">
		<PRTS>
			<!-- 打印信息 -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<PRT_DETAIL>
				<PRT_LINE/>			
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　投保人姓名：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRT_LINE><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></PRT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRT_LINE>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>　　　险种资料</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
				</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					<PRT_LINE>
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
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 11)"/>
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
					</PRT_LINE>
				</xsl:for-each>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<PRT_LINE>　　　保险单特别约定：<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<xsl:text>（无）</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SpecContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE>　　　-------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></PRT_LINE>
				<PRT_LINE><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></PRT_LINE>
				<PRT_LINE><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/></PRT_LINE>
				<PRT_LINE><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,20)"/></PRT_LINE>
			</PRT_DETAIL>
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:choose>
				<xsl:when test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
					<PRT_DETAIL>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE><xsl:text>　　　                                        </xsl:text>现金价值表</PRT_LINE>
						<PRT_LINE/>
						<PRT_LINE>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </PRT_LINE>
						<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
						<PRT_LINE>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></PRT_LINE>
		                <xsl:if test="$RiskCount=1">
				        <PRT_LINE>
					    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRT_LINE>
				        <PRT_LINE><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
						   <xsl:text>现金价值</xsl:text></PRT_LINE>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PRT_LINE><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</PRT_LINE>
					    </xsl:for-each>
			            </xsl:if>
			 
			            <xsl:if test="$RiskCount!=1">
			 	        <PRT_LINE>
					    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRT_LINE>
				        <PRT_LINE><xsl:text/>　　　保单年度末<xsl:text>                 </xsl:text>
						   <xsl:text>现金价值                                现金价值</xsl:text></PRT_LINE>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PRT_LINE>
							 <xsl:text/><xsl:text>　　　　　</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PRT_LINE>
					    </xsl:for-each>
			            </xsl:if>
						<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
						<PRT_LINE/>
						<PRT_LINE>　　　备注：</PRT_LINE>
						<PRT_LINE>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</PRT_LINE>
						<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
					</PRT_DETAIL>
				</xsl:when>
			</xsl:choose>
			
		</PRTS>
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
	
	
	<!-- 保障年期类型:0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- 按年限保 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='M'">4</xsl:when><!-- 按月保 -->
			<xsl:when test=".='D'">5</xsl:when><!-- 按天保 -->
		</xsl:choose>
	</xsl:template>
	
	
	<!-- 缴费间隔1趸缴，5月缴，4季缴，3半年缴，2年缴 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='0'">5</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='12'">1</xsl:when><!-- 年缴 -->
			<xsl:when test=".='6'">2</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".='1'">4</xsl:when><!-- 月缴 -->
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payIntv" />
		<xsl:choose>
			<xsl:when test="$payIntv='0'">趸缴</xsl:when>
			<xsl:when test="$payIntv='12'">年缴</xsl:when>
			<xsl:when test="$payIntv='6'">半年缴</xsl:when>
			<xsl:when test="$payIntv='3'">季缴</xsl:when>
			<xsl:when test="$payIntv='1'">月缴</xsl:when>
			<xsl:otherwise>--</xsl:otherwise><!-- 不确定 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
