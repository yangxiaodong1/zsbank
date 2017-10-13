<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<TradeData>
			 	<BaseInfo>
			 		<xsl:apply-templates select="TX/Head"/>
			 	</BaseInfo>
			 	<ContInfo>	
			 		<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
			 	</ContInfo>
			</TradeData>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="BaseInfo" match="Head">
	<TradeCode>PremAppCal</TradeCode>
	<TradekSelNo><xsl:value-of select="TranNo" /></TradekSelNo>
	<RequestDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCurDateTime()"/></RequestDate>
	<ResponseDate></ResponseDate>
</xsl:template>

<xsl:template name="ContInfo" match="APP_ENTITY">
	<LCCont>
		<ContNo></ContNo><!---保单号-->
		<PrtNo></PrtNo><!---投保单号-->
		<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></PolApplyDate> <!---投保日期-->
		<CvaliDate></CvaliDate> <!---生效日期-->
		<EndDate></EndDate> <!---终止日期-->
		<ManageCom></ManageCom> <!---管理机构-->
		<PackageFlag></PackageFlag> 
	</LCCont>
    <ContPlan>
         <xsl:choose>
            <xsl:when test="Life_List/Life_Detail/Cvr_ID='50002'">
                 <ContPlanCode>50015</ContPlanCode>
                 <ContPlanMult><xsl:value-of select="format-number(Life_List/Life_Detail//Ins_Cps, '#')" /></ContPlanMult>
            </xsl:when>
            <xsl:otherwise>
                 <ContPlanCode></ContPlanCode>
                 <ContPlanMult></ContPlanMult>
            </xsl:otherwise>
         </xsl:choose>      
    </ContPlan>
	<LCInsureds>
		<LCInsuredCount>1</LCInsuredCount> <!---被保人数目-->
		<LCInsured>
				<InsuredSelNo>1</InsuredSelNo> <!---被保人序号-->
				<!---被保人性别-->
				<Sex>
					<xsl:call-template name="tran_Sex">
						<xsl:with-param name="sex" select="Rcgn_Gnd_Cd" />
					</xsl:call-template>
				</Sex> 
				<Birthday><xsl:value-of select="Rcgn_Brth_Dt" /></Birthday> <!---被保人出生日期-->
				<InsuredAppAge></InsuredAppAge> <!---被保人投保年龄-->
				<Marriage></Marriage> <!---是否结婚-->
				<!---国籍-->
				<NativePlace>
					<xsl:call-template name="tran_Nationality">
						<xsl:with-param name="nationality" select="Rcgn_Nat_Cd" />
					</xsl:call-template>
				</NativePlace> 
				<OccupationType></OccupationType> <!---职业类型-->
				 <!---职业编码-->
				<OccupationCode>
					<xsl:call-template name="tran_JobCode">
						<xsl:with-param name="jobcode" select="Rcgn_Ocp_Cd" />
					</xsl:call-template>
				</OccupationCode>
				<SocietyFlag></SocietyFlag> 
				<PeakLine></PeakLine>
				<Risks>
					<RiskCount>1</RiskCount> <!---险种数目-->
					<xsl:variable name="Life_Detail" select="Life_List/Life_Detail" />
						<Risk>
							<RiskSelNo>1</RiskSelNo> <!---险种序号-->
							<!---险种编码-->
							<RiskCode>
								<xsl:call-template name="tran_Riskcode">
									<xsl:with-param name="riskcode" select="$Life_Detail/Cvr_ID" />
								</xsl:call-template>
							</RiskCode> 
							<!---主险编码-->
							<MainRiskCode>
								<xsl:call-template name="tran_Riskcode">
									<xsl:with-param name="riskcode" select="$Life_Detail/Cvr_ID" />
								</xsl:call-template>
							</MainRiskCode> 
							<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/Ins_Cvr)" /></Amnt> <!---保额-->
							<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/InsPrem_Amt)" /></Prem> <!---保费-->
							<AddFee>0</AddFee> <!---健康加费-->
							<JobAddPrem>0</JobAddPrem> <!---职业加费-->
							<Mult><xsl:value-of select="format-number($Life_Detail/Ins_Cps, '#')" /></Mult> <!---份数-->
							<!---交费方式-->
							<PayIntv>
								<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
									<xsl:with-param name="payIntv" select="$Life_Detail/InsPrem_PyF_MtdCd" />
									<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
								</xsl:call-template>
							</PayIntv>
							<!-- 保险期间单位 -->
							<InsuYearFlag>				
								<xsl:call-template name="tran_Ins_Yr_Prd_CgyCd">
									<xsl:with-param name="insuYearType" select="$Life_Detail/Ins_Yr_Prd_CgyCd" />
									<xsl:with-param name="insuYearFlag" select="$Life_Detail/Ins_Cyc_Cd" />
								</xsl:call-template>
							</InsuYearFlag>
							<!---保险期间-->
							<InsuYear>
								<xsl:if test="$Life_Detail/Ins_Yr_Prd_CgyCd='05'">106</xsl:if>
								<xsl:if test="$Life_Detail/Ins_Yr_Prd_CgyCd!='05'"><xsl:value-of select="$Life_Detail/Ins_Ddln" /></xsl:if>
							</InsuYear>
							<!-- 交费期间单位 -->
							<PayEndYearFlag>
								<xsl:call-template name="tran_InsPrem_PyF_Cyc_Cd">
									<xsl:with-param name="payIntv" select="$Life_Detail/nsPrem_PyF_MtdCd" />
									<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
								</xsl:call-template>
							</PayEndYearFlag>
							<xsl:choose>
								<xsl:when test="$Life_Detail/InsPrem_PyF_MtdCd='02'">
									<PayEndYear>1000</PayEndYear>
								</xsl:when>
								<xsl:otherwise>
									<PayEndYear><xsl:value-of select="$Life_Detail/InsPrem_PyF_Prd_Num" /></PayEndYear>
								</xsl:otherwise>
							</xsl:choose>
							<NeedDuty>1</NeedDuty>
							<BuildCalType></BuildCalType>
							<BuildArea></BuildArea>
							<BuildCost></BuildCost>
							<BuildHeigth></BuildHeigth>
							<Dutys>
								<DutyCount>1</DutyCount> <!---责任数目-->
								<Duty>
									<DutyCode></DutyCode> <!-- 责任编码 -->
									<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/InsPrem_Amt)" /></Prem> <!---保费-->
									<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/Ins_Cvr)" /></Amnt> <!---保额-->
									 <!---交费方式-->
									<PayIntv>
										<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
											<xsl:with-param name="payIntv" select="$Life_Detail/InsPrem_PyF_MtdCd" />
											<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
										</xsl:call-template>
									</PayIntv>
									<GetIntv></GetIntv> <!---领取方式-->
									<GetDutyKind></GetDutyKind>
									<GetLimit></GetLimit> <!---免赔额-->
									<GetRate></GetRate> <!---赔付比例-->
									<GetYear></GetYear> 
									<GetYearFlag></GetYearFlag> 
									<StandbyFlag1></StandbyFlag1>
									<StandbyFlag2></StandbyFlag2>
									<StandbyFlag3></StandbyFlag3>
								</Duty>
							</Dutys>
							<InputMode></InputMode>
							<InsuAccs>
								<InsuAccCount>1</InsuAccCount>
								<InsuAcc>
									<InsuAccNo></InsuAccNo>
									<InvestRate></InvestRate>
								</InsuAcc>
							</InsuAccs>
						</Risk>
				</Risks>
				<SSFlag></SSFlag>
			</LCInsured>
		</LCInsureds>
</xsl:template>	
	

<!-- 性别转换 -->
<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex='01'">0</xsl:when>	<!-- 男性 -->
		<xsl:when test="$sex='02'">1</xsl:when>	<!-- 女性 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 国籍代码转换 -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
	<xsl:choose>
		<xsl:when test="$nationality='392'">JP</xsl:when>	<!-- 日本 -->
		<xsl:when test="$nationality='410'">KR</xsl:when>	<!-- 韩国 -->
		<xsl:when test="$nationality='643'">RU</xsl:when>	<!-- 俄罗斯联邦 -->
		<xsl:when test="$nationality='826'">GB</xsl:when>	<!-- 英国 -->
		<xsl:when test="$nationality='840'">US</xsl:when>	<!-- 美国 -->
		<xsl:when test="$nationality='999'">OTH</xsl:when>	<!-- 其他国家和地区 -->
		<xsl:when test="$nationality='36'">AU</xsl:when>	<!-- 澳大利亚 -->
		<xsl:when test="$nationality='124'">CA</xsl:when>	<!-- 加拿大 -->
		<xsl:when test="$nationality='156'">CHN</xsl:when>	<!-- 中国 -->
		<xsl:otherwise>OTH</xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 职业代码转换 -->
<xsl:template name="tran_JobCode">
	<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='A0000'">1010106</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位负责人\国家行政机关及其工作机构负责人 -->
		<xsl:when test="$jobcode='C0000'">4040111</xsl:when>	<!-- 办事人员和有关人员\内勤工作人员 -->
		<xsl:when test="$jobcode='B0000'">2021904</xsl:when>	<!-- 专业技术人员\工程师 -->
		<xsl:when test="$jobcode='Y0000'">8010101</xsl:when>	<!-- 不便分类的其他从业人员\无固定职业人员（以收取各种租金维持生计的） -->
		<xsl:when test="$jobcode='D0000'">9210102</xsl:when>	<!-- 商业、服务业人员\从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
		<xsl:when test="$jobcode='E0000'">5050104</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员\农用机械操作或修理人员 -->
		<xsl:when test="$jobcode='F0000'">6240107</xsl:when>	<!-- 生产、运输设备操作人员及有关人员\自用货车司机、随车工人、搬家工人 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>


<!-- 险种代码 -->
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
		<!-- 暂不上线盛2产品 -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<!-- <xsl:when test="$riskcode='L12079'">L12079</xsl:when> -->	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">L12074</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 建行上线安享5号产品   安享5号暂不上线 begin -->
		<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- 安邦长寿安享5号年金保险 -->
		<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- 安邦附加长寿添利5号两全保险（万能型） -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 建行上线安享5号产品   end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 银行缴费频次：-1：不定期缴；0：趸交；1：月交；3：季交；6：半年交；12年交；98 交至某确定年龄，99 终生交费 -->
<xsl:template name="tran_InsPrem_PyF_MtdCd">
	<xsl:param name="payIntv" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payIntv='01'">-1</xsl:when><!--	不定期缴 -->
		<xsl:when test="$payIntv='02'">0</xsl:when><!--	趸缴 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0201'">3</xsl:when><!--	季缴 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0202'">6</xsl:when><!--	半年缴 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0203'">12</xsl:when><!--	年缴 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0204'">1</xsl:when><!--	月缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 保险年期类型 -->
<xsl:template name="tran_Ins_Yr_Prd_CgyCd">
	<xsl:param name="insuYearType" />
	<xsl:param name="insuYearFlag" />
	<xsl:choose>
		<xsl:when test="$insuYearType='03' and $insuYearFlag='03'">Y</xsl:when><!--	按年 -->
		<xsl:when test="$insuYearType='03' and $insuYearFlag='04'">M</xsl:when><!--	按月 -->
		<xsl:when test="$insuYearType='04'">A</xsl:when><!--	到某确定年龄 -->
		<xsl:when test="$insuYearType='05'">A</xsl:when><!--	终身 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template name="tran_InsPrem_PyF_Cyc_Cd">
	<xsl:param name="payIntv" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payIntv='02'">Y</xsl:when><!--	趸缴 -->
		<xsl:when test="$payIntv='04'">A</xsl:when><!--	到某确定年龄 -->
		<xsl:when test="$payIntv='05'">A</xsl:when><!--	终身 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0203'">Y</xsl:when><!--	年缴 -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0204'">M</xsl:when><!--	月缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
