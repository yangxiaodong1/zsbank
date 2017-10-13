<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

	
	<MainIns_Cvr_ID>
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
		</xsl:call-template>
	</MainIns_Cvr_ID>
	<Cvr_ID>
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
		</xsl:call-template>
	</Cvr_ID>
	<!-- 代理保险套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- 保单失效日期 -->
	<InsPolcy_ExpDt><xsl:value-of select="$MainRisk/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- 保单领取日期 -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- 保单号码 -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- 保险缴费金额 -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- 投保人电子邮件地址 -->
	<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
	<!-- 保单投保日期 -->
	<InsPolcy_Ins_Dt><xsl:value-of select="$MainRisk/PolApplyDate" /></InsPolcy_Ins_Dt>
	<!-- 保单生效日期 -->
	<InsPolcy_EfDt><xsl:value-of select="$MainRisk/CValiDate" /></InsPolcy_EfDt>
	<!-- 代理保险期缴代扣账号 -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo" /></AgInsRgAutoDdcn_AccNo>
	<!-- 每期缴费金额信息 -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- 保费缴费方式代码 -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- 保费缴费期数 -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="$MainRisk/PayCount"/></InsPrem_PyF_Prd_Num>
	<!-- 保费缴费周期代码 -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
	<!-- 
	<InsPrem_PyF_Cyc_Cd>
		<xsl:choose>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear='106'" >99</xsl:when>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear!='106'" >98</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$MainRisk/PayIntv" />
			</xsl:otherwise>
		</xsl:choose>
	</InsPrem_PyF_Cyc_Cd>
	-->
	<!-- 保单犹豫期 -->
	<InsPolcy_HsitPrd><xsl:value-of select="$MainRisk/HsitPrd" /></InsPolcy_HsitPrd>
	
	<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- 如果有现金价值显示2页 -->
		<Ret_File_Num>2</Ret_File_Num>
		<Rvl_Rcrd_Num>2</Rvl_Rcrd_Num>
	</xsl:if>
	<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- 如果没有现金价值显示1页 -->
		<Ret_File_Num>1</Ret_File_Num>
		<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num>
	</xsl:if>
	
	
	<Detail_List>
		<Prmpt_Inf_Dsc>保单正面</Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd>1</AgIns_Vchr_TpCd>	<!-- 重空类型 1=保单,2=现金价值单,3=批单,4=发票,5=代理凭证,6=投保单,7=客户权益保障确认书 -->
		<Rvl_Rcrd_Num></Rvl_Rcrd_Num>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
		<Ins_IBVoch_ID><xsl:value-of select="ContPrtNo" /></Ins_IBVoch_ID>
		<Detail>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
			<xsl:text>                                     币值单位：人民币元</xsl:text></Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>
				<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
				<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
				<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
			</Ret_Inf>
			<Ret_Inf>
				<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
				<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
				<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
			</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:if test="count(Bnf) = 0">
			<Ret_Inf><xsl:text>　　　身故受益人：法定                </xsl:text>
					   <xsl:text>受益顺序：1                   </xsl:text>
					   <xsl:text>受益比例：100%</xsl:text></Ret_Inf>
			</xsl:if>
			<xsl:if test="count(Bnf)>0">
			<xsl:for-each select="Bnf">
			<Ret_Inf>
				<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
				<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
				<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
			</Ret_Inf>
			</xsl:for-each>
			</xsl:if>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　险种资料</Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf><xsl:text>　　　　　　　　　　                                              基本保险金额\</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>　　　　　　　　　　险种名称              保险期间    交费年期      日津贴额\     保险费    交费频率</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>　　　　　　　　　　                                                份数\档次</xsl:text></Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:for-each select="Risk">
			<xsl:variable name="PayIntv" select="PayIntv"/>
			<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
			<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
			<xsl:choose>
				<xsl:when test="(RiskCode='L12081') or (RiskCode='122048')">
					<Ret_Inf><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
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
					</Ret_Inf>
				</xsl:when>
				<xsl:otherwise>
					<Ret_Inf><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
					</Ret_Inf>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:variable name="SpecContent" select="SpecContent"/>
			<Ret_Inf>　　　保险单特别约定：</Ret_Inf>
			<xsl:choose>
				<xsl:when test="$SpecContent=''">
					<Ret_Inf><xsl:text>（无）</xsl:text></Ret_Inf>
				</xsl:when>
				<xsl:otherwise>
					<Ret_Inf><xsl:text>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>　　　现金价值。</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不低</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>　　　于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）的</xsl:text></Ret_Inf>
					<Ret_Inf><xsl:text>　　　个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</xsl:text></Ret_Inf>
				</xsl:otherwise>
			</xsl:choose>
			<Ret_Inf>　　　-------------------------------------------------------------------------------------------------</Ret_Inf>
			<xsl:if test="AppFlag='1'">
			<Ret_Inf>
				<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/SignDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Ret_Inf>
			</xsl:if>
			<xsl:if test="AppFlag='B' and AgentPayType='01'">
			<Ret_Inf>
				<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Ret_Inf>
			</xsl:if>
			<xsl:if test="AppFlag='B' and AgentPayType='02'">
			<xsl:variable name="tCurrDate" select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
			<xsl:variable name="tCurrDate4Next" select="java:com.sinosoft.midplat.common.DateTimeUtils.getNext8Day()" />
			<Ret_Inf>
				<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring($tCurrDate,1,4)"/>年<xsl:value-of  select="substring($tCurrDate,5,2)"/>月<xsl:value-of  select="substring($tCurrDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring($tCurrDate4Next,1,4)"/>年<xsl:value-of  select="substring($tCurrDate4Next,5,2)"/>月<xsl:value-of  select="substring($tCurrDate4Next,7,2)"/>日</Ret_Inf>
			</xsl:if>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></Ret_Inf>
			<Ret_Inf><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Ret_Inf>
			<Ret_Inf><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Ret_Inf>
			<Ret_Inf><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 40)"/><xsl:text>业务许可证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 0)"/></Ret_Inf>
			<Ret_Inf><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,40)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 0)"/></Ret_Inf>
			<Ret_Inf><xsl:text>　　　销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,40)"/></Ret_Inf>
	
		</Detail>
	</Detail_List>
	<xsl:if test="$MainRisk/CashValues/CashValue != ''">
	 <Detail_List>
	 	<xsl:variable name="RiskCount" select="count(Risk)"/>
	 	<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
	 	<Prmpt_Inf_Dsc>保单背面</Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd>1</AgIns_Vchr_TpCd>	<!-- 重空类型 1=保单,2=现金价值单,3=批单,4=发票,5=代理凭证,6=投保单,7=客户权益保障确认书 -->
		<Rvl_Rcrd_Num></Rvl_Rcrd_Num>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
		<Ins_IBVoch_ID><xsl:value-of select="ContPrtNo" /></Ins_IBVoch_ID>
		<Detail>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf><xsl:text>　　　                                        </xsl:text>现金价值表</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Ret_Inf>
		<xsl:if test="$RiskCount=1">
			<Ret_Inf>
				<xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Ret_Inf>
			<Ret_Inf><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
					   <xsl:text>现金价值</xsl:text></Ret_Inf>
			   	<xsl:variable name="EndYear" select="EndYear"/>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <Ret_Inf><xsl:text/><xsl:text>　　　　　</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Ret_Inf>
				</xsl:for-each>
		 </xsl:if>
		 <xsl:if test="$RiskCount!=1">
		 	<Ret_Inf>
				<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Ret_Inf>
			<Ret_Inf><xsl:text/>　　　保单年度末<xsl:text>                </xsl:text>
					   <xsl:text>现金价值                                现金价值</xsl:text></Ret_Inf>
			   	<xsl:variable name="EndYear" select="EndYear"/>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <Ret_Inf>
						  <xsl:text/><xsl:text>　　　</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,26)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Ret_Inf>
				</xsl:for-each>
		 </xsl:if>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
			<Ret_Inf>　</Ret_Inf>
			<Ret_Inf>　　　备注：</Ret_Inf>
			<Ret_Inf>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </Ret_Inf>
			<Ret_Inf>　　　------------------------------------------------------------------------------------------------</Ret_Inf>
	    </Detail>
	</Detail_List>
	</xsl:if>
	
	
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

<!-- 险种转换 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 套餐转换 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		
		<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
		<!-- 50015:(新升级产品) 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成 -->
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划（万能型） -->
		<xsl:when test="$contPlanCode=50002">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 缴费类型 -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- 实时投保缴费 -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- 非实时投保缴费 -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- 续期交费 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- FIXME 需要和核心，业务确认，银行缴费频次：01=不定期、02=一次、03=按周期、04=至某特定年龄、05=终身 -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	趸交 -->
		<xsl:when test=".='12'">03</xsl:when><!-- 年交 -->
		<xsl:when test=".='1'">03</xsl:when><!--	月交 -->
		<xsl:when test=".='3'">03</xsl:when><!--	季交 -->
		<xsl:when test=".='6'">03</xsl:when><!--	半年交 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- 不定期交 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	季缴 -->
		<xsl:when test=".='6'">0202</xsl:when><!--	半年缴 -->
		<xsl:when test=".='12'">0203</xsl:when><!--	年缴 -->
		<xsl:when test=".='1'">0204</xsl:when><!--	月缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

