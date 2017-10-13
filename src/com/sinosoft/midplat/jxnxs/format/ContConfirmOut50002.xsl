<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:variable name ="flag" select ="Head/Flag"/>
			<MAIN>
			<TRANSRNO></TRANSRNO>
			<!-- 保险公司1失败，0成功 -->
			<RESULTCODE><xsl:apply-templates select="Head/Flag" /></RESULTCODE><!-- 1 成功，0 失败 -->
			<ERR_INFO><xsl:value-of select ="Head/Desc"/></ERR_INFO>
				<xsl:choose>
					<!-- 保险公司1失败，0成功 -->
					<xsl:when test="$flag=0">
						<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
						<ACC_CODE><xsl:value-of select ="Body/AccNo"/></ACC_CODE>
						<APPLNO><xsl:value-of select ="Body/ProposalPrtNo"/></APPLNO>
						<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
						<ACCEPT><xsl:value-of select ="$MainRisk/SignDate"/></ACCEPT>
						<AGENT_PSN_NAME><xsl:value-of select ="Body/AgentName"/></AGENT_PSN_NAME>
						<SALES_NO><xsl:value-of select ="Body/AgentCode"/></SALES_NO>
						<AGENT_CODE><xsl:value-of select ="Body/AgentCom"/></AGENT_CODE>
						<PREM><xsl:value-of select ="Body/ActSumPrem"/></PREM>
						<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
						<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE><!-- 保单生效日期 -->
						<CONTRACT_DATE><xsl:value-of select ="$MainRisk/PolApplyDate"/></CONTRACT_DATE><!-- 合同成立日期 -->
						<TBR_NAME><xsl:value-of select ="Body/Appnt/Name"/></TBR_NAME>
						<TBRPATRON><xsl:value-of select ="Body/Appnt/CustomerNo"/></TBRPATRON>
						<BBR_NAME><xsl:value-of select ="Body/Insured/Name"/></BBR_NAME>
						<BBRPATRON><xsl:value-of select ="Body/Insured/CustomerNo"/></BBRPATRON>
						<!-- 受益人就一个？ -->
						<xsl:choose>
							<xsl:when test="Body/Bnf/Name != ''">
								<SERNAME><xsl:value-of select ="Body/Bnf/Name"/></SERNAME>
								<SERRELATION><xsl:apply-templates select ="Body/Bnf/RelaToInsured"/></SERRELATION>
								<SERORDER><xsl:value-of select ="Body/Bnf/Grade"/></SERORDER>
							</xsl:when>
							<xsl:otherwise>
								<SERNAME><xsl:text>法定</xsl:text></SERNAME>
								<SERRELATION><xsl:text>5</xsl:text></SERRELATION>
								<SERORDER><xsl:text>1</xsl:text></SERORDER>
								
							</xsl:otherwise>
						</xsl:choose>
						
						<PAYMETHOD><xsl:apply-templates select ="$MainRisk/PayIntv"/></PAYMETHOD>
						<PAYDATE><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/StartPayDate)"/></PAYDATE>																<!-- 缴费日期该如何给？ -->
						<RECEIPT_NO></RECEIPT_NO>														<!-- 收据编号该如何给？ -->
						<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
						<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
						<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
						<ASSUM></ASSUM>																		<!-- 特别约定打印标志该如何给？ -->
						<TBR_OAC_DATE></TBR_OAC_DATE><!-- 投保人客户号生成日期 -->
						<BBR_OAC_DATE></BBR_OAC_DATE><!-- 被保人客户号生成日期 -->
						<PAYDATECHN></PAYDATECHN><!-- 续期缴费日期（汉字描述） -->
						<PAYSEDATECHN></PAYSEDATECHN><!-- 缴费起止日期（汉字描述） -->
						<!-- 缴费间隔  -->
						<PAY_METHOD>
							<xsl:choose>
									<xsl:when test="$MainRisk/PayIntv = 0">
										<xsl:text>趸缴</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 12">
										<xsl:text>年缴</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 6">
										<xsl:text>半年缴</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 3">
										<xsl:text>季缴</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 1">
										<xsl:text>月缴</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = -1">
										<xsl:text>不定期缴</xsl:text>
									</xsl:when>
								</xsl:choose>
						</PAY_METHOD><!-- 缴费方式(汉字)银行代码：1 年交，2 半年交，3 季交，4 月交，5 趸交  -->
						<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR><!-- 缴费年期/交费期间 -->
						<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
					</xsl:when>
				</xsl:choose>
			</MAIN>
			<xsl:choose>
				<xsl:when test="$flag=0">
					<!-- 险种信息 -->
					<PTS>
						<xsl:apply-templates select="Body/Risk"/>
					</PTS>
					<!-- 现金价值信息 -->
					<VT>
						<!--主、附险标志-->
						<MAINSUBFLG>0</MAINSUBFLG>
						<!--首年退保比例-->
						<FIRST_RETPCT></FIRST_RETPCT>
						<!--第二年退保比例-->
						<SECOND_RETPCT></SECOND_RETPCT>
						<xsl:apply-templates select="Body/Risk/CashValues/CashValue"/>
					</VT>
				</xsl:when>
			</xsl:choose>
		</RETURN>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="PT" match="Risk">
		<PT>
		<xsl:variable name="MainRisk" select="MainRiskCode" />
		<xsl:variable name="Risk" select="RiskCode" />
		<!-- L12081险种的显示信息有区别 -->
		<xsl:choose>
			<xsl:when test="$Risk='L12081'">
				<!-- 险种代码 -->
				<POL_CODE><xsl:apply-templates select ="RiskCode"/></POL_CODE>
				<!--保险单号-->
				<POLICY><xsl:value-of select ="../ContNo"/></POLICY>
				<!--投保份数-->
				<UNIT><xsl:value-of select ="Mult"/></UNIT>
				<!--主、附险标志-->
				<xsl:choose>
					<xsl:when test="$MainRisk = $Risk">
						<MAINSUBFLG>0</MAINSUBFLG><!-- 主险 -->
					</xsl:when>
					<xsl:otherwise>
						<MAINSUBFLG>1</MAINSUBFLG><!-- 附加险 -->
					</xsl:otherwise>
				</xsl:choose>
				<!--保费-->
				<PREM>-</PREM>
				<!--投保金额-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<AMT>-</AMT>
					</xsl:when>
					<xsl:otherwise>
						<AMT><xsl:value-of select="Amnt"/></AMT>
					</xsl:otherwise>
				</xsl:choose>
				<!--险种名称-->
				<NAME><xsl:value-of select="RiskName"/></NAME>
				<!--保障年期类型-->
				<xsl:choose>
					<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
						<!-- 终身 -->
						<PERIOD>1</PERIOD>
					</xsl:when>
					<xsl:otherwise>
						<!-- 其他保险年期 -->
						<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 保险期满日期(汉字) -->
				<xsl:choose>
					<xsl:when test="InsuEndDate != ''">
						<INSUENDDATE><xsl:value-of  select="substring(InsuEndDate,1,4)"/>年<xsl:value-of  select="substring(InsuEndDate,5,2)"/>月<xsl:value-of  select="substring(InsuEndDate,7,2)"/>日</INSUENDDATE>
					</xsl:when>
					<xsl:otherwise>
						<INSUENDDATE></INSUENDDATE>
					</xsl:otherwise>
				</xsl:choose>
				<!--保险期间-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<INSU_DUR>1000</INSU_DUR>
					</xsl:when>
					<xsl:otherwise>
						<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
					</xsl:otherwise>
				</xsl:choose>
				<!--缴费期满日期-->
				<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
				
				<!--缴费年期类型-->
				<xsl:choose>
					<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
						<!-- 趸交或交终身 -->
						<CHARGE_PERIOD>1</CHARGE_PERIOD>
						<CHARGE_YEAR>1000</CHARGE_YEAR>
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
					<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
						<!-- 终身 -->
						<CHARGE_PERIOD>4</CHARGE_PERIOD>
						<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- 非122048险种的显示信息 -->
			<xsl:otherwise>
				<!-- 险种代码 -->
				<POL_CODE><xsl:apply-templates select ="RiskCode"/></POL_CODE>
				<!--保险单号-->
				<POLICY><xsl:value-of select ="../ContNo"/></POLICY>
				<!--投保份数-->
				<UNIT><xsl:value-of select ="Mult"/></UNIT>
				<!--主、附险标志-->
				<xsl:choose>
					<xsl:when test="$MainRisk = $Risk">
						<MAINSUBFLG>0</MAINSUBFLG><!-- 主险 -->
					</xsl:when>
					<xsl:otherwise>
						<MAINSUBFLG>1</MAINSUBFLG><!-- 附加险 -->
					</xsl:otherwise>
				</xsl:choose>
				<!--保费-->
				<PREM><xsl:value-of select="ActPrem"/></PREM>
				<!--投保金额-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<AMT>保单帐户价值</AMT>
					</xsl:when>
					<xsl:otherwise>
						<AMT><xsl:value-of select="Amnt"/></AMT>
					</xsl:otherwise>
				</xsl:choose>
				<!--险种名称-->
				<NAME><xsl:value-of select="RiskName"/></NAME>
				<!--保障年期类型-->
				<xsl:choose>
					<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
						<!-- 终身 -->
						<PERIOD>1</PERIOD>
					</xsl:when>
					<xsl:otherwise>
						<!-- 其他保险年期 -->
						<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 保险期满日期(汉字) -->
				<xsl:choose>
					<xsl:when test="InsuEndDate != ''">
						<INSUENDDATE><xsl:value-of  select="substring(InsuEndDate,1,4)"/>年<xsl:value-of  select="substring(InsuEndDate,5,2)"/>月<xsl:value-of  select="substring(InsuEndDate,7,2)"/>日</INSUENDDATE>
					</xsl:when>
					<xsl:otherwise>
						<INSUENDDATE></INSUENDDATE>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--保险期间-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<INSU_DUR>1000</INSU_DUR>
					</xsl:when>
					<xsl:otherwise>
						<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
					</xsl:otherwise>
				</xsl:choose>
				<!--缴费期满日期-->
				<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
				
				<!--缴费年期类型-->
				<xsl:choose>
					<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
						<!-- 趸交或交终身 -->
						<CHARGE_PERIOD>1</CHARGE_PERIOD>
						<CHARGE_YEAR>1000</CHARGE_YEAR>
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
					<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
						<!-- 终身 -->
						<CHARGE_PERIOD>4</CHARGE_PERIOD>
						<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		</PT>
	</xsl:template>
	
	<!--  -->
	<!-- 险种信息 -->
	<xsl:template name="VTI" match="CashValue">
		<VTI>	
			
			<!--生存年金-->
			<LIVE></LIVE>                                                            
			<!--疾病身故保险金-->
			<ILL></ILL>                                                              
			<!--年度-->
			<YEAR></YEAR>                                                             
			<!--年度末（汉字描述）-->
			<END><xsl:value-of select ="EndYear"/></END>  
			<!--年度末现金价值-->
			<CASH><xsl:value-of select ="Cash"/></CASH>                                                             
			<!--意外身故保险金-->
			<ACI></ACI>
		</VTI>
	</xsl:template>
	<!-- 缴费间隔Y：年交，M：月交，W：趸交 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">M</xsl:when><!-- 月缴 -->
			<xsl:when test=".='0'">W</xsl:when><!-- 趸缴 -->
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
	
	<!-- 成功标志位 -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">0000</xsl:when><!-- 银行成功 -->
			<xsl:when test=".='1'">1111</xsl:when><!-- 银行失败 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 受益人与被保险人关系 -->
	<xsl:template match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='02'">1</xsl:when><!-- 配偶 -->
			<xsl:when test=".='01'">2</xsl:when><!-- 父母 -->
			<xsl:when test=".='03'">3</xsl:when><!-- 子女 -->
			<xsl:when test=".='00'">5</xsl:when><!-- 本人 -->
			<xsl:when test=".='04'">6</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template match="RiskCode" >
		<xsl:choose>
			<!-- 打印排版是由江西农商行自行处理，我司需要返回50015产品的三个险种列表 -->
			<xsl:when test=".='122046'">122046</xsl:when><!-- 安邦长寿稳赢1号两全保险-->
			<xsl:when test=".='122047'">122047</xsl:when><!-- 安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='L12081'">122048</xsl:when>	<!-- 安邦长寿添利终身寿险（万能型 -->
			
			<!-- guoxl 2016.6.15 开始 -->
			<xsl:when test=".='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
			<!-- guoxl 2016.6.15 结束 -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
