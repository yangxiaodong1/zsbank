<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<Rsp>			
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
	 <Body>
	 	<CurType>CNY</CurType>
	 	<PrdList>	 
	 		<Count>1</Count>	
	 		<PrdItem>
	 			<xsl:variable name="MainRisk" select="PubContInfo/Risk[RiskCode=MainRiskCode]" />
				<!-- 险种代码 -->
				<PrdId>
					<xsl:choose>
						<xsl:when test="PubContInfo/ContPlanCode !=''">
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="PubContInfo/ContPlanCode" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="$MainRisk/RiskCode" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>	
				</PrdId>			
				<!-- 是否为主险 -->
				<IsMain>1</IsMain>
				<!-- 险种类型 -->
				<PrdType></PrdType>
				<!-- 风险等级 -->
				<RiskLevel></RiskLevel>
				<!-- 投保份数 -->
				<Units></Units>
				<!-- 首期缴费金额 -->
				<InitAmt></InitAmt>
				<!-- 每期缴费金额 -->
				<TermAmt></TermAmt>
				<!-- 续期总期数 -->
				<TermNum></TermNum>
				<!-- 缴费金额 -->
				<PayAmt></PayAmt>
				<!-- 缴费期数 -->
				<PayNum></PayNum>
				<!-- 已缴保费 -->
				<PaidAmt></PaidAmt>
				<!-- 已缴期数 -->
				<PaidNum></PaidNum>
				<!-- 总保费 -->
				<PremAmt></PremAmt>
				<!-- 总保额 -->
				<CovAmt></CovAmt>
				<!-- 缴费方式 趸缴-->
				<PremType>01</PremType>
				<!-- 缴费年期类型 趸缴 -->
				<PremTermType>01</PremTermType>
				<!-- 缴费年期 -->
				<PremTerm></PremTerm>
				<!-- 保险年期类型 按年限保 -->
				<CovTermType></CovTermType>
				<!-- 保险年期 -->
				<CovTerm></CovTerm>
				<!-- 领取年期类型 -->
				<DrawTermType></DrawTermType>
				<!-- 领取年期 -->
				<DrawTerm></DrawTerm>
				<!-- 领取起始年龄 -->
				<DrawStartAge></DrawStartAge>
				<!-- 领取终止年龄 -->
				<DrawEndAge></DrawEndAge>
				<!-- 生效日期 -->
				<ValiDate>
					<xsl:value-of select="PubContInfo/ContValidDate" />
				</ValiDate>
				<!-- 终止日期 -->
				<InvaliDate>
					<xsl:value-of select="PubContInfo/ContExpireDate" />
				</InvaliDate>
				<!-- 万能险特有项 -->
				<OmnPrdItem />
				<!-- 投连险特有项 -->
				<InvPrdItem />
				<!-- 财产险特有项 -->
				<PropPrdItem></PropPrdItem>
				<!-- 借意险特有项 -->
				<SudPrdItem />
				<!-- 险种共有扩展项 -->
				<ExtItem />
			</PrdItem>				
		 </PrdList>
		 <PolItem>
		 	<!-- 保单号 -->
			<PolNo><xsl:value-of select="PubContInfo/ContNo" /></PolNo>
			<!-- 退款金额 -->
			<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PayAmt>
			<!-- 已缴费金额 -->
			<PaidAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PaidAmt>
			<!-- 已缴期数 -->
			<PaidNum></PaidNum>
			<!-- 原付费方式 -->
			<PayMode><xsl:apply-templates select="PubContInfo/PayMode" /></PayMode>
			<CusActItem>
				<!-- 账号 -->
				<ActNo><xsl:value-of select="CDrawAccountNo" /></ActNo>
				<!-- 账号户名 -->
				<ActName><xsl:value-of select="CDrawAccountName" /></ActName>
				<!-- 开户证件类型 -->
				<IdType><xsl:apply-templates select="AppCCertfCls" /></IdType>
				<!-- 开户证件号码 -->
				<IdNo><xsl:value-of select="AppCCertfCde" /></IdNo>
			</CusActItem>
		 </PolItem>
      </Body>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50012'">50012</xsl:when> <!--安邦长寿安享5号保险计划-->
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when> <!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test="$riskCode='50001'">50001</xsl:when> <!--安邦长寿稳赢1号两全保险-->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when> <!-- 安邦东风3号两全保险（万能型） -->
		</xsl:choose>
	</xsl:template>
	<!-- 缴费形式 -->
	<xsl:template name="PayMode" match="PayMode">
		<xsl:choose>
			<xsl:when test=".=7">01</xsl:when>	<!-- 银行转账 -->
			<xsl:when test=".=1">02</xsl:when>	<!-- 现金 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>