<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Insured/Sex"/>
	<xsl:template match="/TranData">
		<RETURN>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			
			<!-- 报文体 -->
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
		</RETURN>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="TRAN_BODY" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<MAIN>
				<!-- 保险单号 -->
				<POLICY><xsl:value-of select="ContNo" /></POLICY>
				<!-- 投保单号 -->
				<APP><xsl:value-of select="ProposalPrtNo" /></APP>
				<!-- 承保日期 -->
				<ACCEPT><xsl:value-of select="$MainRisk/SignDate" /></ACCEPT>
				<!-- 首期保费, 大写 -->
				<PREMC><xsl:value-of select="ActSumPremText" /></PREMC>
				<!-- 首期保费 -->
				<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PREM>
				<!-- 生效日期 -->
				<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
				<!-- 保险终止日期 -->
				<INVALIDATE><xsl:value-of select="$MainRisk/InsuEndDate" /></INVALIDATE>
				<!-- 缴费日期 -->
				<PAYDATECHN><xsl:value-of select="$MainRisk/PolApplyDate" /></PAYDATECHN>
				<!-- 首期缴费日期 -->
				<FIRSTPAYDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></FIRSTPAYDATE>
				<!-- 缴费起止日期 -->
				<PAYSEDATECHN><xsl:value-of select="$MainRisk/PayEndDate" /></PAYSEDATECHN>
				<!-- 缴费年度 -->
				<PAYYEAR></PAYYEAR>
				<!-- 承保公司 -->
				<ORGAN><xsl:value-of select="ComName" /></ORGAN>
				<!-- 营业单位代码 -->
				<ORGANCODE><xsl:value-of select="ComCode" /></ORGANCODE>
				<!-- 公司地址 -->
				<LOC><xsl:value-of select="ComLocation" /></LOC>
				<!-- 公司电话 -->
				<TEL>95569</TEL>
				<!-- 特别约定 -->
				<ASSUM><xsl:value-of select="SpecContent" /></ASSUM>
				<!-- 专管员号码 -->
				<ZGYNO></ZGYNO>
				<ZGYNAME></ZGYNAME>
				<REVMETHOD></REVMETHOD>
				<REVAGE></REVAGE>
				<CREDITNO></CREDITNO>
				<CREDITDATE></CREDITDATE>
				<CREDITENDDATE></CREDITENDDATE>
				<CREDITSUM></CREDITSUM>
			</MAIN>
		
		
		<!-- 投保人信息 -->
		<xsl:apply-templates select="Appnt" />
		<TBR_TELLERS>
			<TBR_TELLER>
				<TELLER_VER />
				<TELLER_CODE />
				<TELLER_CONT />
				<TELLER_REMARK />
			</TBR_TELLER>
		</TBR_TELLERS>
		
		<!-- 被保人信息 -->
		<xsl:apply-templates select="Insured" />
		<BBR_TELLERS>
			<BBR_TELLER>
				<TELLER_VER />
				<TELLER_CODE />
				<TELLER_CONT />
				<TELLER_REMARK />
			</BBR_TELLER>
		</BBR_TELLERS>
		
		<!-- 受益人 -->
		<SYRS>
			<xsl:for-each select="Bnf">
				<SYR>
					<SYR_NAME><xsl:value-of select="Name" /></SYR_NAME>
					<SYR_SEX><xsl:apply-templates select="Sex" /></SYR_SEX>
					<SYR_PCT><xsl:value-of select="Lot" /></SYR_PCT>
					<SYR_BBR_RELA>
						<xsl:call-template name="tran_RelationRoleCode">
						    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
							<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
							<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
						</xsl:call-template>
					</SYR_BBR_RELA>
					<SYR_BIRTH><xsl:value-of select="Birthday" /></SYR_BIRTH>
					<SYR_IDTYPE><xsl:apply-templates select="IDType" /></SYR_IDTYPE>
					<SYR_IDNO><xsl:value-of select="IDNo" /></SYR_IDNO>
					<SYR_IDEFFSTARTDATE />
					<SYR_IDEFFENDDATE />
					<SYR_NATIVEPLACE />
					<SYR_ORDER><xsl:value-of select="Grade" /></SYR_ORDER>
				</SYR>
			</xsl:for-each>
		</SYRS>
		
		<!-- 险种信息 -->
		<PTS>
			<xsl:variable name="RiskCode" select="ContPlan/ContPlanCode"/>
			<xsl:variable name="RiskName" select="ContPlan/ContPlanName"/>
			<xsl:variable name="RiskMult" select="ContPlan/ContPlanMult"/>
			<xsl:variable name="UpperPrem" select="ActSumPremText"/>
			<xsl:variable name="Prem" select="ActSumPrem"/>
			<xsl:variable name="AmntText" select="AmntText"/>
			<xsl:variable name="Amnt" select="Amnt"/>
			<xsl:for-each select="Risk[RiskCode=MainRiskCode]">
				<PT>
					<PAYENDDATE><xsl:value-of select="PayEndDate" /></PAYENDDATE>
					<UNIT><xsl:value-of select="$RiskMult" /></UNIT>
					<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Amnt)" /></AMT>
					<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Prem)" /></PREM>
					<ID>
						<xsl:call-template name="tran_risk">
							<xsl:with-param name="riskcode" select="$RiskCode" />
						</xsl:call-template>
					</ID>
					<MAINID>
						<xsl:call-template name="tran_risk">
							<xsl:with-param name="riskcode" select="$RiskCode" />
						</xsl:call-template>
					</MAINID>
					<NAME><xsl:value-of select="$RiskName" /></NAME>
					<COVERAGE_YEAR><xsl:value-of select="InsuYear" /></COVERAGE_YEAR>
					<COVERAGE_YEAR_DESC />
					<PAYMETHOD><xsl:apply-templates select="PayIntv" /></PAYMETHOD>
					<xsl:choose>
						<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'" >
							<CHARGE_PERIOD>5</CHARGE_PERIOD>
							<CHARGE_YEAR>0</CHARGE_YEAR>
						</xsl:when>
						<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'" >
							<CHARGE_PERIOD>8</CHARGE_PERIOD>
							<!-- FIXME 终身缴费是该字段的值是什么 -->
							<CHARGE_YEAR>999</CHARGE_YEAR>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="PayEndYearFlag" />
							<CHARGE_YEAR>
								<xsl:value-of select="PayEndYear" />
							</CHARGE_YEAR>
						</xsl:otherwise>
					</xsl:choose>
								
					<PAYTODATE></PAYTODATE>
					<MULTIYEARFLAG></MULTIYEARFLAG>
					<YEARTYPE></YEARTYPE>
					<MULTIYEARS></MULTIYEARS>
					
					<!-- 现金价值 -->
					<VT>
						<VTICOUNT><xsl:value-of select="count(CashValues/CashValue)" /></VTICOUNT>
						<FIRST_RETPCT></FIRST_RETPCT>
						<SECOND_RETPCT></SECOND_RETPCT>
						<xsl:for-each select="CashValues/CashValue">
							<VTI>
								<LIVE></LIVE>
								<ILL></ILL>
								<YEAR></YEAR>
								<END><xsl:value-of select="EndYear" /></END>
								<CASH><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" /></CASH>
								<ACI></ACI>
							</VTI>
						</xsl:for-each>
					</VT>
					<CONP>
						<CONICOUNT><xsl:value-of select="count(BonusValues/BonusValue)" /></CONICOUNT>
						<xsl:for-each select="BonusValues/BonusValue">
							<CONI>
								<END><xsl:value-of select="EndYear" /></END>
								<CON><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)" /></CON>
							</CONI>
						</xsl:for-each> 
					</CONP>
				</PT>
			</xsl:for-each>
		</PTS>
		
		<!-- 打印文件数量 -->
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- 如果有现金价值显示2页 -->
			<FILE_COUNT>2</FILE_COUNT>
		</xsl:if>
		<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- 如果没有现金价值显示1页 -->
			<FILE_COUNT>1</FILE_COUNT>
		</xsl:if>
		<FILE_REMARK></FILE_REMARK>
		<FILE_TEMP></FILE_TEMP>
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

		
		<FILE_LIST>
			<FILE_PAGE>1</FILE_PAGE>
			<FILE_NAME>保单打印信息</FILE_NAME>
			<FILE_REMARK />
			<FILE_TEMP />
			<PAGE_LIST>
				<DETAIL_COUNT />	<!-- 行数,在外面赋值 -->
				<DETAIL_REMARK />
				<DETAIL_TEMP />
				<Detail>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
					<xsl:text>                                      币值单位：人民币元</xsl:text></BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>
						<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
						<xsl:text>证件类型：</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Appnt/IDType" /></xsl:call-template>
						<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
					</BKDETAIL>
					<BKDETAIL>
						<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
						<xsl:text>证件类型：</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Insured/IDType" /></xsl:call-template>
						<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
					</BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<xsl:if test="count(Bnf) = 0">
					<BKDETAIL><xsl:text>　　　身故受益人：法定                </xsl:text>
							   <xsl:text>受益顺序：1                   </xsl:text>
							   <xsl:text>受益比例：100%</xsl:text></BKDETAIL>
					</xsl:if>
					<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
					<BKDETAIL>
						<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
						<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
						<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
					</BKDETAIL>
					</xsl:for-each>
					</xsl:if>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>　　　险种资料</BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL><xsl:text>　　　　　　　　　　                                             基本保险金额\</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期     日津贴额\      保险费    交费频率</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>　　　　　　　　　　                                               份数\档次</xsl:text></BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<BKDETAIL>
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
							</BKDETAIL>
						</xsl:when>
						<xsl:otherwise>
							<BKDETAIL>
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
							</BKDETAIL>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:for-each>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>　　　保险单特别约定：</BKDETAIL>										
					<BKDETAIL>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</BKDETAIL>
					<BKDETAIL>　　　现金价值。</BKDETAIL>
					<BKDETAIL>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</BKDETAIL>
					<BKDETAIL>　　　低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</BKDETAIL>
					<BKDETAIL>　　　的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</BKDETAIL>
					<BKDETAIL>　　　-------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy年MM月dd日')"/><xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy年MM月dd日')"/></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></BKDETAIL>
					<BKDETAIL/>
					<BKDETAIL><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></BKDETAIL>
					<BKDETAIL><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,48)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></BKDETAIL>
				</Detail>
			</PAGE_LIST>
		</FILE_LIST>
					
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
		<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
		<FILE_LIST>
			<FILE_PAGE>1</FILE_PAGE>
			<FILE_NAME>保单现金价值</FILE_NAME>
			<FILE_REMARK></FILE_REMARK>
			<FILE_TEMP></FILE_TEMP>
			<PAGE_LIST>
				<DETAIL_COUNT></DETAIL_COUNT>	<!-- 行数,在外面赋值 -->
				<DETAIL_REMARK></DETAIL_REMARK>
				<DETAIL_TEMP></DETAIL_TEMP>
				<Detail>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>　　　                                        </xsl:text>现金价值表</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></BKDETAIL>
					<xsl:if test="$RiskCount=1">
						<BKDETAIL>
							<xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></BKDETAIL>
						<BKDETAIL><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
								   <xsl:text>现金价值</xsl:text></BKDETAIL>
						   	<xsl:variable name="EndYear" select="EndYear"/>
						   <xsl:for-each select="$MainRisk/CashValues/CashValue">
							 <xsl:variable name="EndYear" select="EndYear"/>
							   <BKDETAIL><xsl:text/><xsl:text>　　　　　</xsl:text>
														<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
														<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</BKDETAIL>
							</xsl:for-each>
					 </xsl:if>
					<xsl:if test="$RiskCount!=1">
					 	<BKDETAIL>
							<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></BKDETAIL>
						<BKDETAIL><xsl:text/>　　　保单年度末<xsl:text>                 </xsl:text>
								   <xsl:text>现金价值                                现金价值</xsl:text></BKDETAIL>
						   	<xsl:variable name="EndYear" select="EndYear"/>
						   <xsl:for-each select="$MainRisk/CashValues/CashValue">
							 <xsl:variable name="EndYear" select="EndYear"/>
							   <BKDETAIL>
									 <xsl:text/><xsl:text>　　　　　</xsl:text>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</BKDETAIL>
							</xsl:for-each>
					 </xsl:if>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>　　　备注：</BKDETAIL>
					<BKDETAIL>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </BKDETAIL>
					<BKDETAIL>　　　------------------------------------------------------------------------------------------------</BKDETAIL>
				</Detail>
			</PAGE_LIST>
		</FILE_LIST>
		</xsl:if>
		<SPEC_CONTENT>
			<CONTENT><xsl:value-of select="SpecContent" /></CONTENT>
		</SPEC_CONTENT>
	</xsl:template>
	<!-- 投保人信息 -->
	<xsl:template name="TBR" match="Appnt">
		<TBR>
			<TBR_NAME><xsl:value-of select="Name" /></TBR_NAME>
			<TBR_SEX><xsl:apply-templates select="Sex" /></TBR_SEX>
			<TBR_BIRTH><xsl:value-of select="Birthday" /></TBR_BIRTH>
			<TBR_IDTYPE><xsl:apply-templates select="IDType" /></TBR_IDTYPE>
			<TBR_IDNO><xsl:value-of select="IDNo" /></TBR_IDNO>
			<TBR_IDEFFSTARTDATE></TBR_IDEFFSTARTDATE>
			<TBR_IDEFFENDDATE></TBR_IDEFFENDDATE>
			<TBR_ADDR><xsl:value-of select="Address" /></TBR_ADDR>
			<TBR_POSTCODE><xsl:value-of select="ZipCode" /></TBR_POSTCODE>
			<TBR_TEL><xsl:value-of select="Phone" /></TBR_TEL>
			<TBR_MOBILE><xsl:value-of select="Mobile" /></TBR_MOBILE>
			<TBR_EMAIL><xsl:value-of select="Email" /></TBR_EMAIL>
			<TBR_BBR_RELA>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
				</xsl:call-template>
			</TBR_BBR_RELA>
			<TBR_OCCUTYPE>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="JobCode" />
				</xsl:call-template>
			</TBR_OCCUTYPE>
			<TBR_NATIVEPLACE>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="Nationality" />
				</xsl:call-template>
			</TBR_NATIVEPLACE>
		</TBR>
	</xsl:template>
	
	<!-- 被保人信息 -->
	<xsl:template name="BBR" match="Insured">
		<BBR>
			<BBR_NAME><xsl:value-of select="Name" /></BBR_NAME>
			<BBR_SEX><xsl:apply-templates select="Sex" /></BBR_SEX>
			<BBR_BIRTH><xsl:value-of select="Birthday" /></BBR_BIRTH>
			<BBR_IDTYPE><xsl:apply-templates select="IDType" /></BBR_IDTYPE>
			<BBR_IDNO><xsl:value-of select="IDNo" /></BBR_IDNO>
			<BBR_IDEFFSTARTDATE></BBR_IDEFFSTARTDATE>
			<BBR_IDEFFENDDATE></BBR_IDEFFENDDATE>
			<BBR_ADDR><xsl:value-of select="Address" /></BBR_ADDR>
			<BBR_POSTCODE><xsl:value-of select="ZipCode" /></BBR_POSTCODE>
			<BBR_TEL><xsl:value-of select="Phone" /></BBR_TEL>
			<BBR_MOBILE><xsl:value-of select="Mobile" /></BBR_MOBILE>
			<BBR_EMAIL><xsl:value-of select="Email" /></BBR_EMAIL>
			<BBR_OCCUTYPE>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="JobCode" />
				</xsl:call-template>
			</BBR_OCCUTYPE>
			<BBR_AGE />
			<BBR_NATIVEPLACE>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="Nationality" />
				</xsl:call-template>
			</BBR_NATIVEPLACE>
		</BBR>
	</xsl:template>

	<!-- 垫交标志 银行：1 成功，0 失败；核心：0 成功，1 失败 -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when>
			<xsl:when test=".='1'">0</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 性别，核心：0=男性，1=女性；银行：1 男，2 女，3 不确定 -->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 男性 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 女性 -->
			<xsl:otherwise>3</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 银行证件类型：51居民身份证或临时身份证,52外国公民护照,53户口簿,54其他类个人身份有效证件,55港澳居民往来内地通行证,56军人或武警身份证件,57士兵证,58军官证,59文职干部证,60军官退休证,61文职干部退休证,62武警身份证件,63武警士兵证,64警官证,65武警文职干部证,66武警军官退休证,67武警文职干部退休证,98其他,99分行客户虚拟证件 -->
	<!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
	<xsl:template name="tran_IDName">
		<xsl:param name="idName" />
		<xsl:choose>
			<xsl:when test="$idName='0'">身份证  </xsl:when>
			<xsl:when test="$idName='1'">护照    </xsl:when>
			<xsl:when test="$idName='2'">军官证  </xsl:when>
			<xsl:when test="$idName='3'">驾照    </xsl:when>
			<xsl:when test="$idName='4'">出生证明</xsl:when>
			<xsl:when test="$idName='5'">户口簿  </xsl:when>
			<xsl:when test="$idName='8'">其他    </xsl:when>
			<xsl:otherwise>其他    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">51</xsl:when>
			<xsl:when test=".='1'">52</xsl:when>
			<xsl:when test=".='2'">56</xsl:when>
			<xsl:when test=".='3'">54</xsl:when>
			<xsl:when test=".='4'">54</xsl:when>
			<xsl:when test=".='5'">53</xsl:when>
			<xsl:when test=".='8'">98</xsl:when>
			<xsl:otherwise>98</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- 关系
	银行： 1本人,2丈夫,3	妻子 ,4	父亲 ,5	母亲,6	儿子,7	女儿,8	祖父,9	祖母,10	孙子,11	孙女,12	外祖父,
			13	外祖母,14	外孙,15	外孙女,16	哥哥,17	姐姐,18	弟弟,19	妹妹,20	公公,21	婆婆,22	儿媳,23	岳父 
			24	岳母,25	女婿,26	其它亲属,27	同事,28	朋友,29	雇主,30	其它 
	  
	核心；00本人 ，01父母，,02配偶，03子女,04其他,05雇佣,06抚养,07扶养,08赡养
	      0 男，1女
	 -->
	<xsl:template name="tran_RelationRoleCode">
	    <xsl:param name="relaToInsured"></xsl:param>
	    <xsl:param name="insuredSex"></xsl:param>
	    <xsl:param name="sex"></xsl:param>
		<xsl:choose>
			<!-- 本人 -->
			<xsl:when test="$relaToInsured='00'">1</xsl:when>
			
			<!-- 父母 -->
			<xsl:when test="$relaToInsured='01'">
			    <xsl:if test="$sex='0'">4</xsl:if>
			    <xsl:if test="$sex='1'">5</xsl:if>
	        </xsl:when>
	        <!-- 配偶 -->
			<xsl:when test="$relaToInsured='02'">
				<xsl:if test="$sex='0'">2</xsl:if>
			    <xsl:if test="$sex='1'">3</xsl:if>
			</xsl:when>
			<!-- 子女 -->
			<xsl:when test="$relaToInsured='03'">
			    <xsl:if test="$sex='0'">6</xsl:if>
			    <xsl:if test="$sex='1'">7</xsl:if>
	        </xsl:when>
			<!-- 其他 -->
			<xsl:when test="$relaToInsured='04'">30</xsl:when>
			<!-- 雇佣 -->
			<xsl:when test="$relaToInsured='05'">29</xsl:when>
			<!-- 其他 -->
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 职业代码 -->
	<xsl:template name="tran_jobcode">
		<xsl:param name="jobcode" />
		<xsl:choose>
			<xsl:when test="$jobcode='4030111'">A</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test="$jobcode='2050101'">B</xsl:when>	<!-- 卫生专业技术人员 -->
			<xsl:when test="$jobcode='2070109'">C</xsl:when>	<!-- 金融业务人员 -->
			<xsl:when test="$jobcode='2080103'">D</xsl:when>	<!-- 法律专业人员 -->
			<xsl:when test="$jobcode='2090104'">E</xsl:when>	<!-- 教学人员 -->
			<xsl:when test="$jobcode='2100106'">F</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
			<xsl:when test="$jobcode='2130101'">G</xsl:when>	<!-- 宗教职业者 -->
			<xsl:when test="$jobcode='3030101'">H</xsl:when>	<!-- 邮政和电信业务人员 -->
			<xsl:when test="$jobcode='4010101'">I</xsl:when>	<!-- 商业、服务业人员 -->
			<xsl:when test="$jobcode='5010107'">J</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
			<xsl:when test="$jobcode='6240105'">K</xsl:when>	<!-- 运输人员 -->
			<xsl:when test="$jobcode='2020103'">L</xsl:when>	<!-- 地址勘探人员 -->
			<xsl:when test="$jobcode='2020906'">M</xsl:when>	<!-- 工程施工人员 -->
			<xsl:when test="$jobcode='6050611'">N</xsl:when>	<!-- 加工制造、检验及计量人员 -->
			<xsl:when test="$jobcode='7010103'">O</xsl:when>	<!-- 军人 -->
			<xsl:when test="$jobcode='8010101'">P</xsl:when>	<!-- 无业 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 国籍代码 -->
	<xsl:template name="tran_nativeplace">
		<xsl:param name="nativeplace" />
		<xsl:choose>
			<xsl:when test="$nativeplace='CHN'">0156</xsl:when>	<!-- 中国 -->
			<xsl:when test="$nativeplace='CHN'">0344</xsl:when>	<!-- 中国香港 -->
			<xsl:when test="$nativeplace='CHN'">0158</xsl:when>	<!-- 中国台湾 -->
			<xsl:when test="$nativeplace='CHN'">0446</xsl:when>	<!-- 中国澳门 -->
			<xsl:when test="$nativeplace='JP'">0392</xsl:when>	<!-- 日本 -->
			<xsl:when test="$nativeplace='US'">0840</xsl:when>	<!-- 美国 -->
			<xsl:when test="$nativeplace='RU'">0643</xsl:when>	<!-- 俄罗斯 -->
			<xsl:when test="$nativeplace='GB'">0826</xsl:when>	<!-- 英国 -->
			<xsl:when test="$nativeplace='FR'">0250</xsl:when>	<!-- 法国 -->
			<xsl:when test="$nativeplace='DE'">0276</xsl:when>	<!-- 德国 -->
			<xsl:when test="$nativeplace='KR'">0410</xsl:when>	<!-- 韩国 -->
			<xsl:when test="$nativeplace='SG'">0702</xsl:when>	<!-- 新加坡 -->
			<xsl:when test="$nativeplace='ID'">0360</xsl:when>	<!-- 印度尼西亚 -->
			<xsl:when test="$nativeplace='IN'">0356</xsl:when>	<!-- 印度 -->
			<xsl:when test="$nativeplace='IT'">0380</xsl:when>	<!-- 意大利 -->
			<xsl:when test="$nativeplace='MY'">0458</xsl:when>	<!-- 马来西亚 -->
			<xsl:when test="$nativeplace='TH'">0764</xsl:when>	<!-- 泰国 -->
			<xsl:when test="$nativeplace='OTH'">0999</xsl:when>	<!-- 其他国家和地区 -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50002</xsl:when>
			<xsl:when test="$riskcode='122046'">122046</xsl:when><!-- 主险：122046 - 安邦长寿稳赢1号两全保险 -->
			<xsl:when test="$riskcode='122047'">122047</xsl:when><!-- 附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test="$riskcode='122048'">122048</xsl:when><!-- 附加险：122048 - 安邦长寿添利终身寿险（万能型） -->			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费频次 -->
	<!-- 银行：1 年交，2 半年交，3 季交，4 月交，5 趸交，6 不定期交，7 交至某确定年龄，8 终生缴费 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- 年缴 -->
			<xsl:when test=".='6'">2</xsl:when><!-- 半年交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交-->
			<xsl:when test=".='1'">4</xsl:when><!-- 月交 -->
			<xsl:when test=".='0'">5</xsl:when><!-- 趸交 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期年龄标志 -->
	<!-- 银行：1 年缴，2 半年缴，3 季缴，4 月缴，5 趸缴， 6 不定期缴， 7 缴至某确定年龄， 8 终生缴费 -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">1</xsl:when><!-- 按年限缴 -->
			<xsl:when test=".='M'">4</xsl:when><!-- 按月限缴 -->
			<xsl:when test=".='Y'">5</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='A'">7</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='A'">8</xsl:when><!-- 终生缴费 -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>