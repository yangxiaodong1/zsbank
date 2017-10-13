<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:variable name ="flag" select ="Head/Flag"/>
			<MAIN>
				<xsl:choose>
					<xsl:when test="$flag=1">
						<!-- 保险公司1失败，0成功 -->
						<APP><xsl:value-of select ="Body/ProposalPrtNo"/></APP>
						<OKFLAG><xsl:apply-templates select="Head/Flag" /></OKFLAG><!-- 1 成功，0 失败 -->
						<!-- 新单重打，交易失败描述FAILDETAIL -->
						<FAILDETAIL><xsl:value-of select ="Head/Desc"/></FAILDETAIL>
						<!-- 新单打印，交易失败描述REJECTNO -->
						<REJECTNO><xsl:value-of select ="Head/Desc"/></REJECTNO>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
						<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
						<APP><xsl:value-of select ="Body/ProposalPrtNo"/></APP>
						<ACCEPT><xsl:value-of select ="$MainRisk/SignDate"/></ACCEPT>
						<OKFLAG><xsl:apply-templates select="Head/Flag" /></OKFLAG><!-- 1 成功，0 失败 -->
						<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
						<PREM><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/></PREM>
						<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE>
						<INVALIDATE><xsl:value-of select ="$MainRisk/InsuEndDate"/></INVALIDATE>
						<FIRSTPAYDATE></FIRSTPAYDATE>
						<PAYDATECHN><xsl:value-of select ="$MainRisk/PayEndDate"/></PAYDATECHN>
						<PAYSEDATECHN></PAYSEDATECHN>
						<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR>
						<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
						<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
						<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
						<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
						<INSU_SPEC><xsl:value-of select ="Body/SpecContent"/></INSU_SPEC>
						<ZGYNO><xsl:value-of select ="Body/SellerNo"/></ZGYNO>
						<ZGYNAME><xsl:value-of select ="Body/TellerName"/></ZGYNAME>
						<ACC_CODE><xsl:value-of select ="Body/AccNo"/></ACC_CODE>
						<REVMETHOD><xsl:value-of select ="$MainRisk/GetIntv"/></REVMETHOD>
						<REVAGE><xsl:value-of select ="$MainRisk/GetYear"/></REVAGE>
						<TEMP></TEMP>
						<REMARK></REMARK>
					</xsl:otherwise>
				</xsl:choose>
			</MAIN>
			<!-- 投保人信息 -->
			<xsl:apply-templates select="Body/Appnt"/>
			<!-- 被保险人信息 -->
			<xsl:apply-templates select="Body/Insured"/>
			
			<xsl:choose>
				<xsl:when test="$flag=0">
					<!-- 受益人信息 -->
					<SYRS>
						<xsl:apply-templates select="Body/Bnf"/>
					</SYRS>
					
					<!-- 险种信息 -->
					<PTS>
						<xsl:apply-templates select="Body/Risk[RiskCode=MainRiskCode]"/>
					</PTS>
				</xsl:when>
			</xsl:choose>
			<!-- 打印信息列表 -->
			<xsl:apply-templates select="Body"/>
		</RETURN>
	</xsl:template>
	<!-- 投保人信息 -->
	<xsl:template name="TBR" match="Appnt">
		<TBR>
			<TBR_NAME><xsl:value-of select ="Name"/></TBR_NAME>
			<TBR_SEX>
				<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_SEX>
			<TBR_BIRTH><xsl:value-of select ="Birthday"/></TBR_BIRTH>
			<TBR_IDTYPE>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="IDType"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_IDTYPE>
			<TBR_IDNO><xsl:value-of select ="IDNo"/></TBR_IDNO>
			<TBR_IDEFFSTARTDATE></TBR_IDEFFSTARTDATE>
			<TBR_IDEFFENDDATE></TBR_IDEFFENDDATE>
			<TBR_ADDR><xsl:value-of select ="Address"/></TBR_ADDR>
			<TBR_POSTCODE><xsl:value-of select ="ZipCode"/></TBR_POSTCODE>
			<TBR_TEL><xsl:value-of select ="Phone"/></TBR_TEL>
			<TBR_MOBILE><xsl:value-of select ="Mobile"/></TBR_MOBILE>
			<TBR_BBR_RELA>
				<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="RelaToInsured"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_BBR_RELA>
			<TBR_OCCUTYPE><xsl:value-of select ="JobCode"/></TBR_OCCUTYPE>
			<TBR_NATIVEPLACE><xsl:value-of select ="Nationality"/></TBR_NATIVEPLACE>
			<TBR_TEMP></TBR_TEMP>
			<TBR_REMARK></TBR_REMARK>		
		</TBR>
		<TBR_TELLERS>  <!--投保人告知-->       
		   <TBR_TELLER>
		      <TELLER_VER></TELLER_VER>             <!--告知版别-->
		      <TELLER_CODE></TELLER_CODE>           <!--告知编码-->
		      <TELLER_CONT></TELLER_CONT>           <!--告知内容-->
		      <TELLER_REMARK></TELLER_REMARK>       <!--告知备注-->
		    </TBR_TELLER>
		 </TBR_TELLERS>  
	</xsl:template>
	
	<!-- 被保险人信息 -->
	<xsl:template name="BBR" match="Insured">
		<BBR>
			<BBR_NAME><xsl:value-of select ="Name"/></BBR_NAME>
			<BBR_SEX>
				<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</BBR_SEX>
			<BBR_BIRTH><xsl:value-of select ="Birthday"/></BBR_BIRTH>
			<BBR_IDTYPE>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="IDType"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</BBR_IDTYPE>
			<BBR_IDNO><xsl:value-of select ="IDNo"/></BBR_IDNO>
			<BBR_IDEFFSTARTDATE></BBR_IDEFFSTARTDATE>
			<BBR_IDEFFENDDATE></BBR_IDEFFENDDATE>
			<BBR_ADDR><xsl:value-of select ="Address"/></BBR_ADDR>
			<BBR_POSTCODE><xsl:value-of select ="ZipCode"/></BBR_POSTCODE>
			<BBR_TEL><xsl:value-of select ="Phone"/></BBR_TEL>
			<BBR_MOBILE><xsl:value-of select ="Mobile"/></BBR_MOBILE>
			<BBR_OCCUTYPE><xsl:value-of select ="JobCode"/></BBR_OCCUTYPE>
			<BBR_AGE></BBR_AGE>
			<BBR_NATIVEPLACE><xsl:value-of select ="Nationality"/></BBR_NATIVEPLACE>
			<BBR_HEALTHINF></BBR_HEALTHINF>
			<BBR_METIERDANGERINF></BBR_METIERDANGERINF>
			<BBR_TEMP></BBR_TEMP>
			<BBR_REMARK></BBR_REMARK>	
		</BBR>	
		<BBR_TELLERS>  <!--被保人告知-->   
		    <BBR_TELLER>
		      <TELLER_VER></TELLER_VER>             <!--告知版别-->
		      <TELLER_CODE></TELLER_CODE>           <!--告知编码-->
		      <TELLER_CONT></TELLER_CONT>           <!--告知内容-->
		      <TELLER_REMARK></TELLER_REMARK>       <!--告知备注-->
		    </BBR_TELLER>
		 </BBR_TELLERS>	
	</xsl:template>
	<!-- 受益人信息 -->
	<xsl:template name="SYR" match="Bnf">
			<SYR>
				<SYR_NAME><xsl:value-of select ="Name"/></SYR_NAME>
				<SYR_SEX>
					<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
				</SYR_SEX>
				<SYR_PCT><xsl:value-of select ="Lot"/></SYR_PCT>
				<SYR_BBR_RELA>
					<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="RelaToInsured"/>
				     </xsl:with-param>
				 </xsl:call-template>
				</SYR_BBR_RELA>
				<SYR_BIRTH><xsl:value-of select ="Birthday"/></SYR_BIRTH>
				<SYR_IDTYPE>
					<xsl:call-template name="tran_IDType">
						 <xsl:with-param name="idtype">
						 	<xsl:value-of select="IDType"/>
					     </xsl:with-param>
					 </xsl:call-template>
				</SYR_IDTYPE>
				<SYR_IDNO><xsl:value-of select ="IDNo"/></SYR_IDNO>
				<SYR_IDEFFSTARTDATE></SYR_IDEFFSTARTDATE>
				<SYR_IDEFFENDDATE></SYR_IDEFFENDDATE>
				<SYR_NATIVEPLACE></SYR_NATIVEPLACE>
				<SYR_TEMP></SYR_TEMP>
				<SYR_REMARK></SYR_REMARK>
			</SYR>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="PT" match="Risk">
		<xsl:variable name="RiskCode" select="../ContPlan/ContPlanCode"/>
		<xsl:variable name="RiskName" select="../ContPlan/ContPlanName"/>
		<xsl:variable name="RiskMult" select="../ContPlan/ContPlanMult"/>
		<xsl:variable name="Prem" select="../ActSumPrem"/>
		<xsl:variable name="Amnt" select="../Amnt"/>
		
		<PT>
			<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
			<UNIT><xsl:value-of select ="$RiskMult"/></UNIT>
			<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Amnt)"/></AMT>
			<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Prem)"/></PREM>
			<ID>
				<xsl:call-template name="tran_RiskCode">
					 <xsl:with-param name="riskCode">
					 	<xsl:value-of select="$RiskCode"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</ID>
			<MAINID>
				<xsl:call-template name="tran_RiskCode">
					 <xsl:with-param name="riskCode">
					 	<xsl:value-of select="$RiskCode"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</MAINID>
			<NAME><xsl:value-of select ="$RiskName"/></NAME>
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- 终身 -->
					<PERIOD>1</PERIOD>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
				</xsl:otherwise>
			</xsl:choose>
			
			<COVERAGE_YEAR><xsl:value-of select ="InsuYear"/></COVERAGE_YEAR>
			<COVERAGE_YEAR_DESC></COVERAGE_YEAR_DESC>
			<PAYMETHOD><xsl:value-of select ="PayIntv"/></PAYMETHOD>
			
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
				<xsl:when test="(PayEndYearFlag = 'M')">
					<!-- 月缴 -->
					<CHARGE_PERIOD>5</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- 终身 -->
					<CHARGE_PERIOD>7</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- 缴至某确定年龄 -->
					<CHARGE_PERIOD>6</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<CHARGE_PERIOD>
						<xsl:value-of select="PayEndYearFlag" />
					</CHARGE_PERIOD>
					<CHARGE_YEAR>
						<xsl:value-of select="PayEndYear" />
					</CHARGE_YEAR>
				</xsl:otherwise>
			</xsl:choose>
			<PAYTODATE></PAYTODATE>
			<MULTIYEARFLAG></MULTIYEARFLAG>
			<YEARTYPE></YEARTYPE>
			<MULTIYEARS><xsl:value-of select ="PayNum"/></MULTIYEARS>
			<PT_TEMP></PT_TEMP>
			<PT_REMARK></PT_REMARK>
			<!-- 现金价值 -->
			<VT>
				<FIRST_RETPCT></FIRST_RETPCT>
				<SECOND_RETPCT></SECOND_RETPCT>
				<VTICOUNT><xsl:value-of select="count(CashValues/CashValue)"/></VTICOUNT>
				<xsl:for-each select="CashValues/CashValue">
					<VTI> 
						<LIVE></LIVE>
						<ILL></ILL>
						<YEAR><xsl:value-of select ="EndYear"/></YEAR>
						<END></END>
						<CASH><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/></CASH>
						<ACI></ACI>
					</VTI>
				</xsl:for-each>
			</VT>
			<!-- 红利保额保单年度末现金价值表 -->
			<CONP>
				<CONICOUNT><xsl:value-of select="count(BonusValues/BonusValue)"/></CONICOUNT>
				<xsl:for-each select="BonusValues/BonusValue">
					<CONI>
						<END><xsl:value-of select ="EndYear"/></END>
						<CON><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)"/></CON>
					</CONI>
				</xsl:for-each>
			</CONP>
		</PT>
	</xsl:template>
	<xsl:template name="DETAIL_LIST" match="Body">
		<DETAIL_LIST>
			<LIST_COUNT>1</LIST_COUNT>
			<LIST_REMARK></LIST_REMARK>
			<LIST_TEMP></LIST_TEMP>
			<!-- 打印信息 -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			<DETAIL>
				<PRNT_COUNT></PRNT_COUNT>	<!-- 该值在ContConfirm.java中动态计算 -->
				<DETAIL_TEMP/>			
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                      币值单位：人民币元</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>　　　投保人姓名：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:if test="count(Bnf) = 0">
				<DETAIL_PRNT><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></DETAIL_PRNT>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<DETAIL_PRNT>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</DETAIL_PRNT>
					</xsl:for-each>
				</xsl:if>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>　　　险种资料</DETAIL_PRNT>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<DETAIL_PRNT>
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
							</DETAIL_PRNT>
						</xsl:when>
						<xsl:otherwise>
							<DETAIL_PRNT>
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
							</DETAIL_PRNT>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>　　　保险费合计：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元（小写）</DETAIL_PRNT>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>　　　------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>　　　保险单特别约定：</DETAIL_PRNT>
					<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<DETAIL_PRNT><xsl:text>（无）</xsl:text></DETAIL_PRNT>
						</xsl:when>
						<xsl:otherwise>
							<DETAIL_PRNT>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</DETAIL_PRNT>
							<DETAIL_PRNT>　　　现金价值。</DETAIL_PRNT>
							<DETAIL_PRNT>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</DETAIL_PRNT>
							<DETAIL_PRNT>　　　低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</DETAIL_PRNT>
							<DETAIL_PRNT>　　　的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</DETAIL_PRNT>
						</xsl:otherwise>
					</xsl:choose>
				<DETAIL_PRNT>　　　-------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</DETAIL_PRNT>
				<DETAIL_PRNT></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/></DETAIL_PRNT>
			</DETAIL>
			<CLASS_COUNT>1</CLASS_COUNT>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<MSG>
				<MSG_COUNT></MSG_COUNT><!-- 该值在ContConfirm.java中动态计算 -->
				<DETAIL_TEMP/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG><xsl:text>　　　                                        </xsl:text>现金价值表</DETAIL_MSG>
				<DETAIL_MSG/>
				<DETAIL_MSG>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </DETAIL_MSG>
				<DETAIL_MSG>　　　------------------------------------------------------------------------------------------------</DETAIL_MSG>
				<DETAIL_MSG>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></DETAIL_MSG>
                <xsl:if test="$RiskCount=1">
		        <DETAIL_MSG>
			    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></DETAIL_MSG>
		        <DETAIL_MSG><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
				   <xsl:text>现金价值</xsl:text></DETAIL_MSG>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <DETAIL_MSG><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</DETAIL_MSG>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <DETAIL_MSG>
			    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></DETAIL_MSG>
		        <DETAIL_MSG><xsl:text/>　　　保单年度末<xsl:text>                 </xsl:text>
				   <xsl:text>现金价值                                现金价值</xsl:text></DETAIL_MSG>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <DETAIL_MSG>
					 <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</DETAIL_MSG>
			    </xsl:for-each>
	            </xsl:if>
				<DETAIL_MSG>　　　------------------------------------------------------------------------------------------------</DETAIL_MSG>
				<DETAIL_MSG/>
				<DETAIL_MSG>　　　备注：</DETAIL_MSG>
				<DETAIL_MSG>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</DETAIL_MSG>
				<DETAIL_MSG>　　　------------------------------------------------------------------------------------------------</DETAIL_MSG>
			</MSG>
			</xsl:if>
			<PRTS>
				<PRT_REC_NUM>0</PRT_REC_NUM>
			</PRTS>
			<TITLE>
				<PRT_TITLE_NUM/>
				<TITLE_DETAIL/>
			</TITLE>
		</DETAIL_LIST>
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
			<xsl:when test=".=6">港澳回乡证</xsl:when>
			<xsl:when test=".=7">台胞证    </xsl:when>
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
			<xsl:when test="$riskcode=50015">50002</xsl:when>
			<!-- 组合产品 50002-安邦长寿稳赢保险计划: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
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
	
	<!-- 成功标志位 -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 银行成功 -->
			<xsl:when test=".='1'">0</xsl:when><!-- 银行失败 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取方式 -->
	<xsl:template match="GetIntv">
		<xsl:choose>
			<xsl:when test=".='0'">3</xsl:when><!-- 趸领 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='3'"></xsl:when><!-- 季领 -->
			<xsl:when test=".='6'"></xsl:when><!-- 半年领 -->
			<xsl:when test=".='12'">2</xsl:when><!-- 年领 -->
			<xsl:when test=".='36'"></xsl:when><!-- 三年领 -->
			<xsl:when test=".='120'"></xsl:when><!-- 十年领 -->
		</xsl:choose>
	</xsl:template>
	<!-- 性别 -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='0'">1</xsl:when><!-- 男 -->
			<xsl:when test="$sex='1'">2</xsl:when><!-- 女 -->
			<xsl:otherwise>--</xsl:otherwise><!-- 不确定 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型 -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
		<xsl:choose>
			<xsl:when test="$idtype='0'">0</xsl:when><!-- 身份证 -->
			<xsl:when test="$idtype='1'">9</xsl:when><!-- 护照 -->
			<xsl:when test="$idtype='2'">4</xsl:when><!-- 军官证 -->
			<xsl:when test="$idtype='3'">8</xsl:when><!-- 驾照 -->
			<xsl:when test="$idtype='4'">8</xsl:when><!-- 出生证明 -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- 户口簿 -->
			<xsl:when test="$idtype='6'">A</xsl:when><!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idtype='7'">B</xsl:when><!-- 台湾居民来往大陆通行证 -->
			<xsl:when test="$idtype='8'">8</xsl:when><!-- 其他 -->
			<xsl:when test="$idtype='9'">8</xsl:when><!-- 异常身份证 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 与被保险人关系 -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='00'">1</xsl:when><!-- 本人 -->
			<xsl:when test="$relaToInsured='02'">2</xsl:when><!-- 配偶 -->
			<xsl:when test="$relaToInsured='01'">3</xsl:when><!-- 父母 -->
			<xsl:when test="$relaToInsured='03'">4</xsl:when><!-- 子女 -->
			<xsl:when test="$relaToInsured='04'">5</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 保障年期类型1 保终身（在前面判断），2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
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
			<xsl:when test=".='0'">1</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='12'">2</xsl:when><!-- 年缴 -->
			<xsl:when test=".='6'">3</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='3'">4</xsl:when><!-- 季缴 -->
			<xsl:when test=".='1'">5</xsl:when><!-- 月缴 -->
		</xsl:choose>
	</xsl:template>
 	<!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<!-- 50015-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,L12081 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$riskCode='50015'">50002</xsl:when><!-- 安邦长寿稳赢保险组合计划 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
