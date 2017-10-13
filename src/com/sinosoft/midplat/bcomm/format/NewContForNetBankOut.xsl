<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />
			<xsl:if test="TranData/Head/Flag='0'">
				<xsl:apply-templates select="TranData/Body" />
			</xsl:if>
		</RMBP>
	</xsl:template>

	<xsl:template name="body" match="Body">
		<xsl:variable name="leftPadFlag"
			select="java:java.lang.Boolean.parseBoolean('true')" />
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />

		<K_TrList>
			<!--总保费			Dec(15,0)	非空-->
			<KR_TotalAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActSumPrem,15,$leftPadFlag)" />
			</KR_TotalAmt>
			<!--承保公司名称 可空-->
			<ManageCom>
				<xsl:value-of select="ComName" />
			</ManageCom>
			<!--承保公司地址		Char(60)		可空-->
			<ComLocation>
				<xsl:value-of select="ComLocation" />
			</ComLocation>
			<!--承保公司城市		Char(30)		可空-->
			<City />
			<!--承保公司电话		Char(20)		可空-->
			<Tel>
				<xsl:value-of select="ComPhone" />
			</Tel>
			<!--承保公司邮编		Char(6)		可空-->
			<Post>
				<xsl:value-of select="ComZipCode" />
			</Post>
			<!--营业单位代码		Char(20)		可空 -->
			<AgentCode />
			<!--专管员姓名		Char(20)		可空-->
			<AgentName></AgentName>
		</K_TrList>

		<K_BI>
			<xsl:for-each select="Risk">
				<xsl:choose>
					<!-- 投保信息 -->
					<xsl:when test="RiskCode=MainRiskCode">
						<Info>
							<!--主险期缴保费		Dec(15,0)	主险期缴保费与主险保额之一为必输项-->
							<Premium>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Premium>
							<!--主险保额			Dec(15,0)	主险期缴保费与主险保额之一为必输项-->
							<BaseAmt>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Amnt,15,$leftPadFlag)" />
							</BaseAmt>
							<!--首期保费			Dec(15,0)	可空-->
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Prem>
							<!--生效日期			Char(8)		可空	格式：YYYYMMDD-->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--终止日期			Char(8)		可空	格式：YYYYMMDD-->
							<InvaliDate>
								<xsl:value-of select="InsuEndDate" />
							</InvaliDate>
							<!--缴费日期			Char(80)		可空-->
							<PayDateChn></PayDateChn>
							<!--缴费终止日期		Char(8)		可空	格式：YYYYMMDD-->
							<PayEndDate>
								<xsl:value-of select="PayEndDate" />
							</PayEndDate>
							<!--缴费期间			Char(80)		可空-->
							<PaysDateChn />
							<!--私有节点-->
							<Private>
								<!--主险缴费标准		Dec(15,0)	可空-->
								<StdFee></StdFee>
								<!--主险综合加费		Dec(15,0)	可空-->
								<ColFee></ColFee>
								<!--主险职业加费		Dec(15,0)	可空-->
								<WorkFee></WorkFee>
								<!--附加险个数		Int(2)		非空 
								<xsl:variable name="addCount"
									select="count(//Risk[RiskCode!=MainRiskCode])" />
									-->
								<AddCount>0</AddCount>
								<!--附加额外保费		Dec(15,0)	可空-->
								<ExcPremAmt></ExcPremAmt>
								<!--附加额外保额		Dec(15,0)	可空-->
								<ExcBaseAmt></ExcBaseAmt>
								<!--缴费方式描述		Char(10)		可空-->
								<PremType />
								<!--特别约定			Char(256)	可空-->
								<SpecialClause>
									<xsl:value-of select="SpecContent" />
								</SpecialClause>
								<!--领取日期标志		Char(1)		可空	参见附录3.29-->
								<ReceiveMark />
							</Private>
						</Info>
					</xsl:when>
					<xsl:otherwise>
						<!-- 附加险信息不传递 -->	
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</K_BI>
	</xsl:template>

	<!-- ***************以下为枚举*************** -->
	<!-- 红利领取方式 -->
	<xsl:template name="tran_BonusGetMode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- 累积生息 -->
			<xsl:when test=".=3">1</xsl:when><!-- 抵缴保费 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期标志 -->
	<xsl:template name="tran_InsuYearFlag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when>
			<xsl:when test=".='M'">4</xsl:when>
			<xsl:when test=".='Y'">2</xsl:when>
			<xsl:when test=".='A'">3</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 领取年期类型 -->
	<xsl:template name="tran_GetYearFlag" match="GetYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'"></xsl:when>
			<xsl:when test=".='D'"></xsl:when>
			<xsl:when test=".='M'">2</xsl:when>
			<xsl:when test=".='Y'">5</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费方式 -->
	<xsl:template name="tran_PayIntv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=12">5</xsl:when><!-- 年缴 -->
			<xsl:when test=".=1">2</xsl:when><!-- 月缴 -->
			<xsl:when test=".=6">4</xsl:when><!-- 半年缴 -->
			<xsl:when test=".=3">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".=0">1</xsl:when><!-- 趸缴 -->
			<xsl:when test=".=-1">7</xsl:when><!-- 不定期 -->
			<xsl:otherwise>9</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期类型 -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'"></xsl:when><!-- 天 -->
			<xsl:when test=".='M'"></xsl:when><!-- 月 -->
			<xsl:when test=".='Y'">2</xsl:when><!-- 年 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
