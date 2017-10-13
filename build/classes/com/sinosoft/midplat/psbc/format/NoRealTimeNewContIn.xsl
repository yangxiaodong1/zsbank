<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="MAIN" />

			<!-- 报文体 -->
			<Body>
			   <ProposalPrtNo><xsl:value-of select="MAIN/APPLNO" /></ProposalPrtNo><!-- 投保单(印刷)号 -->
			   <PolApplyDate>
				   <xsl:value-of select="MAIN/TB_DATE" />
			   </PolApplyDate><!-- 投保日期 -->
			   <AgentComName>
				   <xsl:value-of select="MAIN/BRNM" />
			   </AgentComName><!--出单网点名称-->
			   <AgentComCertiCode></AgentComCertiCode><!--出单网点资格证-->
			   <TellerName></TellerName><!--银行销售人员名称-->
			   <TellerCertiCode></TellerCertiCode><!--银行销售人员资格证-->
			   <AccName></AccName><!-- 账户姓名 -->
			   <AccNo>
				   <xsl:value-of select="TBR/PAYACC" />
			   </AccNo><!-- 银行账户 -->
			   <!-- 产品组合 -->
			   <ContPlan>
			 	   <!-- 产品组合编码 -->
				   <ContPlanCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="contplan" />
				   </ContPlanCode>
			   </ContPlan>
			   <!-- 投保人 -->
			   <xsl:apply-templates select="TBR" />
			   <!-- 险种 -->
			   <Risk>
				   <!-- 险种号 -->
				   <RiskCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="risk" />
				   </RiskCode>
				   <!-- 主险号 -->
				   <MainRiskCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="risk" />
				   </MainRiskCode>
				   <!-- 保费（单位 元?） -->
				   <Prem>
					  <xsl:value-of select="TBR/AMT_PREMIUM" />
				   </Prem>
				   <Amnt></Amnt>
				   <Mult></Mult><!-- 投保份数 -->
				   <PayIntv></PayIntv><!-- 缴费频次 -->
				   <InsuYearFlag></InsuYearFlag><!-- 保险年期年龄标志 -->
				   <InsuYear></InsuYear><!-- 保险年期年龄 保终身写死106-->
				   <PayEndYearFlag></PayEndYearFlag><!-- 缴费年期年龄标志 -->
				   <PayEndYear></PayEndYear><!-- 缴费年期年龄 趸交写死1000-->
			  </Risk>
		   </Body>

		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
		
	<!--投保人信息-->
	<xsl:template match="TBR">
		<Appnt>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="TBR_NAME" />
			</Name>
			<!-- 性别 -->
			<Sex></Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday></Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="TBR_IDTYPE" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- 投保人所属区域-->
			<LiveZone></LiveZone>
			<!-- 地址 -->
			<Address></Address>
			<!-- 邮编 -->
			<ZipCode></ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="TBR_MOBILE" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="TBR_TEL" />
			</Phone>
		</Appnt>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template match="TBR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='3'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='4'">4</xsl:when><!-- 出生证 -->
			<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（分红型） -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）-->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型）-->		
			<xsl:when test=".='50003'">50016</xsl:when><!-- 50003(50016)-安邦长寿利丰保险计划 -->	
			<xsl:when test=".='L12084'">L12084</xsl:when><!-- 安邦汇赢2号年金保险A款  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）-->
			<!--<xsl:when test=".='L12094'">L12094</xsl:when>--><!-- 安邦汇赢3号年金保险A款-->	
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template match="PRODUCTID" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='50003'">50016</xsl:when><!-- 50003(50016)-安邦长寿利丰保险计划 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>