<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<xsl:apply-templates select="TranData/Body" />
</Transaction>
</xsl:template>

<xsl:template name="Body" match="Body">
	<TransBody>
			<DetailList>
				<xsl:for-each select="Cont[ContState='00']">
					<Detail>
						<CPlyNo><xsl:value-of select ="ContNo"/></CPlyNo><!--保单号 -->
						<CPlySts><xsl:apply-templates select ="MortStatu"/></CPlySts><!--保单状态 -->
						<NCurAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)"/></NCurAmt><!--保单现金价值 -->
						<NSavingAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></NSavingAmt><!--保费 -->
						<NAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></NAmt><!--保额 -->
						<CPrmCur>01</CPrmCur><!--保费币种 -->
						<TAppTm><xsl:value-of select ="PolApplyDate"/></TAppTm><!--投保日期 -->
						<TInsrncBgnTm><xsl:value-of select ="CValiDate"/></TInsrncBgnTm><!--保险起期 -->
						<TInsrncEndTm><xsl:value-of select ="InsuEndDate"/></TInsrncEndTm><!--保险止期 -->
						<xsl:choose>
							<xsl:when test="ContPlan/ContPlanCode !=''">
								<!-- <CprodNo>
									<xsl:call-template name="tran_riskcode">
										<xsl:with-param name="riskcode">
											<xsl:value-of select="ContPlan/ContPlanCode"/>
										</xsl:with-param>
									</xsl:call-template>
								</CprodNo> --><!--产品代码 -->
								<CprodNo><xsl:value-of select="ContPlan/ContPlanCode"/></CprodNo><!-- 由于存在非银保通出单的质押保单，先不做映射处理 -->
								<CProdNme><xsl:value-of select ="ContPlan/ContPlanName"/></CProdNme><!--产品名称 -->
							</xsl:when>
							<xsl:otherwise>
								<!-- <CprodNo>
								<xsl:call-template name="tran_riskcode">
										<xsl:with-param name="riskcode">
											<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode"/>
										</xsl:with-param>
									</xsl:call-template>
								</CprodNo> --><!--产品代码 -->
								<CprodNo><xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode"/></CprodNo>
								<CProdNme><xsl:value-of select ="Risk[RiskCode=MainRiskCode]/RiskName"/></CProdNme><!--产品名称 -->
							</xsl:otherwise>
						</xsl:choose>
						<CCvrgNo></CCvrgNo><!--险别代码 -->
						<CCustCvrgNme></CCustCvrgNme><!--险别名称 -->
						<CAppNme><xsl:value-of select ="Appnt/Name"/></CAppNme><!--投保人姓名 -->
						<CAppMobile><xsl:value-of select ="Appnt/Mobile"/></CAppMobile><!--投保人手机号码 -->
						<CAppClntAddr><xsl:value-of select ="Appnt/Address"/></CAppClntAddr><!--投保人通讯地址 -->
						<CInsuredNme><xsl:value-of select ="Insured/Name"/></CInsuredNme><!--被保人姓名 -->
						<CInsuredCertfCls><xsl:apply-templates select ="Insured/IDType"/></CInsuredCertfCls><!--被保人证件类型 -->
						<CInsuredCertfCde><xsl:value-of select ="Insured/IDNo"/></CInsuredCertfCde><!--被保人证件号码 -->
						<CInsuredMobile><xsl:value-of select ="Insured/Mobile"/></CInsuredMobile><!--被保人电话 -->
						<BeneficiaryList>
							<xsl:for-each select="Bnf">
								 <BeneficiaryInfo>
								 	<CBnfcNme><xsl:value-of select ="Name"/></CBnfcNme><!--受益人姓名 -->
									<CBnfcCertfCls><xsl:apply-templates select ="IDType"/></CBnfcCertfCls><!--受益人证件类型 -->
									<CBnfcCertfCde><xsl:value-of select ="IDNo"/></CBnfcCertfCde><!--受益人证件号码 -->
								 </BeneficiaryInfo>
							</xsl:for-each>
						</BeneficiaryList>
						<InsurCorpNo>14226510</InsurCorpNo><!--保险公司编号 -->
						<CInsurType>02</CInsurType><!--保险公司类型 -->
					</Detail>
				</xsl:for-each>
			</DetailList>
	</TransBody>
</xsl:template>
<!-- 保单质押状态： 0未质押，1质押 -->
<xsl:template match="MortStatu">
	<xsl:choose>
		<xsl:when test=".='0'">2</xsl:when><!--	正常 -->
		<xsl:when test=".='1'">1</xsl:when><!--	已质押（冻结） -->
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<!-- 即使银行和我司险种代码相同也要转换，为了限制某个银行只能卖的险种 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122006">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122008">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢1号两全保险组合 -->
	<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12078'">L12078</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 证件类型：核心**银行 -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".='0'">0</xsl:when><!--居民身份证**身份证 -->
		<xsl:when test=".='1'">2</xsl:when><!--护照**护照-->
		<xsl:when test=".='2'">3</xsl:when><!--军官证**军官证 -->
		<xsl:when test=".='3'">X</xsl:when><!--驾照**其他个人证件 -->
		<xsl:when test=".='4'">X</xsl:when><!--出生证明**其他个人证件 -->
		<xsl:when test=".='5'">1</xsl:when><!--户口簿**户口簿 -->
		<xsl:when test=".='6'">5</xsl:when><!--港澳居民来往内地通行证**港澳居民来往内地通行证-->
		<xsl:when test=".='7'">6</xsl:when><!--台湾居民来往大陆通行证**台湾居民来往大陆通行证-->
		<xsl:when test=".='8'">X</xsl:when><!--其他**其他个人证件 -->
		<xsl:when test=".='9'">X</xsl:when><!--异常身份证**其他个人证件 -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>