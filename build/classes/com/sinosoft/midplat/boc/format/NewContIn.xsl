<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
		    <TranDate><xsl:value-of select="TranDate"/></TranDate><!-- 交易日期[yyyyMMdd] -->
            <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TranTime)" /></TranTime><!-- 交易时间[hhmmss] -->
            <TranCom outcode="08"><xsl:value-of select="TranCom"/></TranCom><!-- 交易单位(银行/农信社/经代公司) -->            
            <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="NodeNo"/></NodeNo><!-- 地区代码 +银行网点 -->
            <TellerNo><xsl:value-of select="TellerNo"/></TellerNo><!-- 柜员代码 -->
            <TranNo><xsl:value-of select="TranNo"/></TranNo><!-- 交易流水号 -->
            <FuncFlag><xsl:value-of select="FuncFlag"/></FuncFlag><!-- 交易类型 -->
			<BankCode><xsl:value-of select="TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- 投保单(印刷)号 -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- 保单合同印刷号 -->
			<PolApplyDate>
				<xsl:value-of select="PolApplyDate"/>
			</PolApplyDate>
			<!-- 投保日期 -->
			<AccName>
				<xsl:value-of select="AccName"/>
			</AccName>
			<!-- 账户姓名 -->
			<AccNo>
				<xsl:value-of select="AccNo"/>
			</AccNo>
			<!-- 银行账户 -->
			<GetPolMode>
				<xsl:value-of select="GetPolMode"/>
			</GetPolMode>
			<!-- 保单递送方式 -->
			<JobNotice>
				<xsl:value-of select="GetPolMode"/>
			</JobNotice>
			<!-- 职业告知(N/Y) -->
			<HealthNotice>
				<xsl:value-of select="HealthNotice"/>
			</HealthNotice>
			<!-- 健康告知(N/Y)  -->
			<PolicyIndicator>
			    <xsl:value-of select="PolicyIndicator"/>
			</PolicyIndicator>
			<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
			<InsuredTotalFaceAmount>
			    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsuredTotalFaceAmount)" />
			</InsuredTotalFaceAmount>
			<!--累计未成年人投保身故保额-->
			<Appnt>
				<!-- 投保人信息  -->
				<Name>
					<xsl:value-of select="Appnt/Name"/>
				</Name>
				<!-- 姓名 -->
				<Sex>
					<xsl:value-of select="Appnt/Sex"/>
				</Sex>
				<!-- 性别 -->
				<Birthday>
					<xsl:value-of select="Appnt/Birthday"/>
				</Birthday>
				<!-- 出生日期(yyyyMMdd) -->
				<IDType>
					<xsl:value-of select="Appnt/IDType"/>
				</IDType>
				<!-- 证件类型 -->
				<IDNo>
					<xsl:value-of select="Appnt/IDNo"/>
				</IDNo>
				<!-- 证件号码 -->
				<IDTypeStartDate>
					<xsl:value-of select="Appnt/IDTypeStartDate"/>
				</IDTypeStartDate>
				<!-- 证件有效起期 -->
				<IDTypeEndDate>
					<xsl:value-of select="Appnt/IDTypeEndDate"/>
				</IDTypeEndDate>
				<!-- 证件有效止期 -->
				<JobCode>
					<xsl:value-of select="Appnt/JobCode"/>
				</JobCode>
				<!-- 职业代码 -->
				<Nationality>
		            <xsl:call-template name="tran_Nationality">
		                <xsl:with-param name="nationality">
		 	            <xsl:value-of select="Appnt/Nationality"/>
	                </xsl:with-param>
	            </xsl:call-template>
				</Nationality>
				<!-- 国籍 -->
				<Stature>
					<xsl:value-of select="Appnt/Stature"/>
				</Stature>
				<!-- 身高(cm) -->
				<Weight>
					<xsl:value-of select="Appnt/Weight"/>
				</Weight>
				<!-- 体重(g) -->
				<MaritalStatus>
					<xsl:value-of select="Appnt/MaritalStatus"/>
				</MaritalStatus>
				<!-- 婚否(N/Y) -->
				<Address>
					<xsl:value-of select="Appnt/Address"/>
				</Address>
				<!-- 地址 -->
				<ZipCode>
					<xsl:value-of select="Appnt/ZipCode"/>
				</ZipCode>
				<!-- 邮编 -->
				<Mobile>
					<xsl:value-of select="Appnt/Mobile"/>
				</Mobile>
				<!-- 移动电话 -->
				<Phone>
					<xsl:value-of select="Appnt/Phone"/>
				</Phone>
				<!-- 固定电话 -->
				<Email>
					<xsl:value-of select="Appnt/Email"/>
				</Email>
				<!-- 电子邮件-->
				<RelaToInsured>
					<xsl:value-of select="Appnt/RelaToInsured"/>
				</RelaToInsured>
				<!-- 与被保人关系 -->
			</Appnt>
			<Insured>
				<!-- 被保人信息  -->
				<Name>
					<xsl:value-of select="Insured/Name"/>
				</Name>
				<!-- 姓名 -->
				<Sex>
					<xsl:value-of select="Insured/Sex"/>
				</Sex>
				<!-- 性别 -->
				<Birthday>
					<xsl:value-of select="Insured/Birthday"/>
				</Birthday>
				<!-- 出生日期(yyyyMMdd) -->
				<IDType>
					<xsl:value-of select="Insured/IDType"/>
				</IDType>
				<!-- 证件类型 -->
				<IDNo>
					<xsl:value-of select="Insured/IDNo"/>
				</IDNo>
				<!-- 证件号码 -->
				<IDTypeStartDate>
					<xsl:value-of select="Insured/IDTypeStartDate"/>
				</IDTypeStartDate>
				<!-- 证件有效起期 -->
				<IDTypeEndDate>
					<xsl:value-of select="Insured/IDTypeEndDate"/>
				</IDTypeEndDate>
				<!-- 证件有效止期 -->
				<JobCode>
					<xsl:value-of select="Insured/JobCode"/>
				</JobCode>
				<!-- 职业代码 -->
				<Nationality>
		            <xsl:call-template name="tran_Nationality">
		                <xsl:with-param name="nationality">
		 	            <xsl:value-of select="Insured/Nationality"/>
	                </xsl:with-param>
	            </xsl:call-template>
				</Nationality>
				<!-- 国籍 -->
				<Stature>
					<xsl:value-of select="Insured/Stature"/>
				</Stature>
				<!-- 身高(cm) -->
				<Weight>
					<xsl:value-of select="Insured/Weight"/>
				</Weight>
				<!-- 体重(g) -->
				<MaritalStatus>
					<xsl:value-of select="Insured/MaritalStatus"/>
				</MaritalStatus>
				<!-- 婚否(N/Y) -->
				<Address>
					<xsl:value-of select="Insured/Address"/>
				</Address>
				<ZipCode>
					<xsl:value-of select="Insured/ZipCode"/>
				</ZipCode>
				<Mobile>
					<xsl:value-of select="Insured/Mobile"/>
				</Mobile>
				<Phone>
					<xsl:value-of select="Insured/Phone"/>
				</Phone>
				<Email>
					<xsl:value-of select="Insured/Email"/>
				</Email>
			</Insured>
			<!-- 受益人信息  -->
			<xsl:for-each select="Bnf">
				<xsl:choose>
					<xsl:when test="Name!=''">
						<Bnf>
							<Type>
								<xsl:value-of select="Type"/>
							</Type>
							<!-- 受益人类别 -->
							<Grade>
								<xsl:value-of select="Grade"/>
							</Grade>
							<!-- 受益顺序 -->
							<Name>
								<xsl:value-of select="Name"/>
							</Name>
							<!-- 姓名 -->
							<Sex>
								<xsl:value-of select="Sex"/>
							</Sex>
							<!-- 性别 -->
							<Birthday>
								<xsl:value-of select="Birthday"/>
							</Birthday>
							<!-- 出生日期(yyyyMMdd) -->
							<IDType>
								<xsl:value-of select="IDType"/>
							</IDType>
							<!-- 证件类型 -->
							<IDNo>
								<xsl:value-of select="IDNo"/>
							</IDNo>
							<!-- 证件号码 -->
							<IDTypeStartDate>
								<xsl:value-of select="IDTypeStartDate"/>
							</IDTypeStartDate>
							<!-- 证件有效起期 -->
							<IDTypeEndDate>
								<xsl:value-of select="IDTypeEndDate"/>
							</IDTypeEndDate>
							<!-- 证件有效止期 -->
							<RelaToInsured>
								<xsl:value-of select="RelationToInsured"/>
							</RelaToInsured>
							<!-- 与被保人关系 -->
							<Lot>
								<xsl:value-of select="Lot"/>
							</Lot>
							<!-- 受益比例(整数，百分比) -->
						</Bnf>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
			<!-- 险种信息  -->
			<xsl:for-each select="Risk">
				<xsl:choose>
					<xsl:when test="RiskCode!=''">
						<Risk>
							<RiskCode>
								<xsl:value-of select="RiskCode"/>
							</RiskCode>
							<!-- 险种代码 -->
							<MainRiskCode>
								<xsl:value-of select="MainRiskCode"/>
							</MainRiskCode>
							<!-- 主险险种代码 -->
							<RiskType>
								<xsl:value-of select="RiskType"/>
							</RiskType>
							<!-- 险种类型 -->
							<Amnt>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)"/>
							</Amnt>
							<!-- 保额(分) -->
							<Prem>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)"/>
							</Prem>
							<!-- 保险费(分) -->
							<Mult>
								<xsl:value-of select="Mult"/>
							</Mult>
							<!-- 投保份数 -->
							<PayMode>
								<xsl:value-of select="PayMode"/>
							</PayMode>
							<!-- 缴费形式 -->
							<PayIntv>
								<xsl:value-of select="PayIntv"/>
							</PayIntv>
							<!-- 缴费频次 -->
							<CostIntv/>
							<CostDate/>
							<Years>
								<xsl:value-of select="Years"/>
							</Years>
							<InsuYearFlag>
								<xsl:value-of select="InsuYearFlag"/>
							</InsuYearFlag>
							<!-- 保险年期年龄标志 -->
							<InsuYear>
								<!-- 保终身 -->
								<xsl:if test="InsuYearFlag=A">106</xsl:if>
								<xsl:if test="InsuYearFlag!=A">
									<xsl:value-of select="InsuYear"/>
								</xsl:if>
							</InsuYear>
							<!-- 保险年期年龄 -->
							<xsl:if test="PayIntv = 0">
								<PayEndYearFlag>Y</PayEndYearFlag>
								<PayEndYear>1000</PayEndYear>
							</xsl:if>
							<xsl:if test="PayIntv != 0">
								<PayEndYearFlag>
									<xsl:value-of select="PayEndYearFlag"/>
								</PayEndYearFlag>
								<!-- 缴费年期年龄标志 -->
								<PayEndYear>
									<xsl:value-of select="PayEndYear"/>
								</PayEndYear>
								<!-- 缴费年期年龄 -->
							</xsl:if>
							<BonusGetMode>
								<xsl:value-of select="BonusGetMode"/>
							</BonusGetMode>
							<!-- 红利领取方式 -->
							<FullBonusGetMode>
								<xsl:value-of select="FullBonusGetMode"/>
							</FullBonusGetMode>
							<!-- 满期领取金领取方式 -->
							<GetYearFlag>
								<xsl:value-of select="GetYearFlag"/>
							</GetYearFlag>
							<!-- 领取年龄年期标志 -->
							<GetYear>
								<xsl:value-of select="GetYear"/>
							</GetYear>
							<!-- 领取年龄 -->
							<GetIntv>
								<xsl:value-of select="GetIntv"/>
							</GetIntv>
							<!-- 领取方式 -->
							<GetBankCode>
								<xsl:value-of select="GetBankCode"/>
							</GetBankCode>
							<!-- 领取银行编码 -->
							<GetBankAccNo>
								<xsl:value-of select="GetBankAccNo"/>
							</GetBankAccNo>
							<!-- 领取银行账户 -->
							<GetAccName>
								<xsl:value-of select="GetAccName"/>
							</GetAccName>
							<!-- 领取银行户名 -->
							<AutoPayFlag>
								<xsl:value-of select="AutoPayFlag"/>
							</AutoPayFlag>
							<!-- 自动垫交标志 -->
						</Risk>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</Body>
	</xsl:template>
	
	
<!-- 国籍转换 -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$nationality = 'AUS'">AU</xsl:when>  <!-- 澳大利亚 -->
		<xsl:when test="$nationality = 'CHN'">CHN</xsl:when> <!-- 中国  -->
		<xsl:when test="$nationality = 'ENG'">GB</xsl:when>  <!-- 英国  -->
		<xsl:when test="$nationality = 'JAN'">JP</xsl:when>  <!-- 日本  -->
		<xsl:when test="$nationality = 'RUS'">RU</xsl:when>  <!-- 俄罗斯  -->
		<xsl:when test="$nationality = 'USA'">US</xsl:when>  <!-- 美国  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
