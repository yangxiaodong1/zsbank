<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
    <NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
<ProposalPrtNo><xsl:value-of select="PbApplNo" /></ProposalPrtNo>
<ContPrtNo><xsl:value-of select="BkVchNo" /></ContPrtNo>
<PolApplyDate><xsl:value-of select="../Transaction_Header/BkPlatDate" /></PolApplyDate>	<!-- 中信银行不传投保日期，取交易日期 -->

<!--出单网点名称-->
<AgentComName><xsl:value-of select="BkBranName"/></AgentComName>
<!--银行销售人员工号-->
<SellerNo><xsl:value-of select="BkRckrNo"/></SellerNo>

<AccName><xsl:value-of select="PbHoldName" /></AccName>	<!-- 取投保人姓名 -->
<AccNo><xsl:value-of select="BkAcctNo1" /></AccNo>
<GetPolMode>2</GetPolMode>

<JobNotice>
	<xsl:call-template name="tran_JobNotice">
		<xsl:with-param name="JobNotice" select="PbRemark1" />
	</xsl:call-template>
</JobNotice> <!-- 职业告知(N/Y) -->
<HealthNotice>
	<xsl:call-template name="tran_healthnotice">
		<xsl:with-param name="healthnotice" select="LiHealthTag" />
	</xsl:call-template>
</HealthNotice> <!-- 健康告知(N/Y) -->
<PolicyIndicator>
    <xsl:if test="PiZxbe20=''">N</xsl:if>
    <xsl:if test="PiZxbe20!=''">Y</xsl:if>
</PolicyIndicator>
<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
<InsuredTotalFaceAmount><xsl:value-of select="PiZxbe20*0.01" /></InsuredTotalFaceAmount>
<!--累计未成年人投保身故保额-->

<xsl:call-template name="Appnt" />
<xsl:call-template name="Insured" />
<xsl:apply-templates select="Benf_List/Benf_Detail" />

<!-- 组合产品份数 -->
<xsl:variable name="ContPlanMult">
	<xsl:choose>
		<xsl:when test="PbSlipNumb=''">
			<xsl:value-of select="PbSlipNumb" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number(PbSlipNumb,'#')" />
		</xsl:otherwise>
	</xsl:choose>	
</xsl:variable>

<!-- 险种 -->
<xsl:variable name="MainRiskCode">
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- 组合产品编码 -->
<xsl:variable name="tContPlanCode">
	<xsl:call-template name="tran_ContPlanCode">
		<xsl:with-param name="contPlanCode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- 产品组合 -->
<ContPlan>
	<!-- 产品组合编码 -->
	<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
	<!-- 产品组合份数 -->
	<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
</ContPlan>

<xsl:variable name="PayIntv"><xsl:apply-templates select="PbPayPeriod" /></xsl:variable>
<xsl:variable name="InsuYearFlag"><xsl:apply-templates select="PbInsuYearFlag" /></xsl:variable>
<xsl:variable name="PayEndYearFlag"><xsl:apply-templates select="PbInsuYearFlag" /></xsl:variable>	<!-- 中信银行根据PbInsuYearFlag获取,建行不传标志，目前都按年缴处理，今后可能此处需调整  疑问点：中信银行是否和建行一样-->
<xsl:variable name="BonusGetMode"><xsl:apply-templates select="LiBonusGetMode" /></xsl:variable>
<xsl:variable name="PbInsuYearFlag" select="PbInsuYearFlag"></xsl:variable>

<Risk>	<!-- 主险 -->
	<RiskCode><xsl:value-of select="$MainRiskCode" /></RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuAmt)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuExp)" /></Prem>
	<Mult><xsl:value-of select="$ContPlanMult" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear><xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiInsuPeriod" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- 趸交 -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- 其他 -->
			<PayEndYear><xsl:value-of select="PbPayAgeTag" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
<xsl:for-each select="Appd_List/Appd_Detail">	<!-- 附加险 -->
<Risk>
	<RiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="LiAppdInsuType" />
		</xsl:call-template>
	</RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuAmot)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuExp)" /></Prem>
	<Mult><xsl:value-of select="format-number(LiAppdInsuNumb, '#')" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear>
	<xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiAppdInsuTerm" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- 趸交 -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- 其他 -->
			<PayEndYear><xsl:value-of select="LiAppdInsuPayTerm" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
</xsl:for-each>
</xsl:template>

<!-- 投保人 -->
<xsl:template name="Appnt">
<Appnt>
	<Name><xsl:value-of select="PbHoldName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbHoldSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbHoldBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbHoldIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbHoldId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="PbIdStartDate" /></IDTypeStartDate > <!-- 证件有效起期 -->
	<IDTypeEndDate><xsl:value-of select="PbIdEndDate" /></IDTypeEndDate > <!-- 证件有效止期 -->
	<JobCode>
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="PbHoldOccupCode" />
		</xsl:call-template>
	</JobCode>
	
	<!-- 投保人年收入 -->
	<Salary>
		<xsl:choose>
			<xsl:when test="PbIncome=''">
				<xsl:value-of select="PbIncome" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbIncome)*10000"/>
			</xsl:otherwise>
		</xsl:choose>
	</Salary>
	<!-- 1.城镇，2.农村 -->
	<LiveZone><xsl:value-of select="PbLiveZone"/></LiveZone>
	<!-- 风险测评结果是否适合投保 Y=具备资格，N=不具备 -->
	<RiskAssess><xsl:value-of select="RiskIdentFlag"/></RiskAssess>
	
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="PbNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- 国籍 -->
	<Address><xsl:value-of select="PbHoldHomeAddr" /></Address>
	<ZipCode><xsl:value-of select="PbHoldHomePost" /></ZipCode>
	<Mobile><xsl:value-of select="PbHoldMobl" /></Mobile>
	<Phone><xsl:value-of select="PbHoldHomeTele" /></Phone>
	<Email><xsl:value-of select="PbHoldEmail" /></Email>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbHoldRcgnRela" />
		</xsl:call-template>
	</RelaToInsured>
</Appnt>
</xsl:template>

<!-- 被保人 -->
<xsl:template name="Insured">
<Insured>
	<Name><xsl:value-of select="LiRcgnName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="LiRcgnSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="LiRcgnBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="LiRcgnIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="LiRcgnId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="LiIdStartDate" /></IDTypeStartDate > <!-- 证件有效起期 -->
	<IDTypeEndDate><xsl:value-of select="LiIdEndDate" /></IDTypeEndDate > <!-- 证件有效止期 -->
	<JobCode>
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="LiRcgnOccupCode" />
		</xsl:call-template>
	</JobCode>
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="LiNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- 国籍 -->
	<Address><xsl:value-of select="LiRcgnAddr" /></Address>
	<ZipCode><xsl:value-of select="LiRcgnPost" /></ZipCode>
	<Mobile><xsl:value-of select="LiRcgnMobl" /></Mobile>
	<Phone><xsl:value-of select="LiRcgnTele" /></Phone>
	<Email><xsl:value-of select="LiRcgnEmail" /></Email>
</Insured>
</xsl:template>

<!-- 受益人 -->
<xsl:template name="Bnf" match="Benf_Detail">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-身故受益人” -->
	<Grade><xsl:value-of select="PbBenfSequ" /></Grade>
	<Name><xsl:value-of select="PbBenfName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbBenfSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbBenfBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbBenfIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbBenfId" /></IDNo>
	<Lot><xsl:value-of select="PbBenfProp" /></Lot>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbBenfHoldRela" />
		</xsl:call-template>
    </RelaToInsured>
</Bnf>
</xsl:template>


<xsl:template name="MainRisk">

</xsl:template>

<!-- 健康告知 -->
<xsl:template name="tran_HealthNotice" match="LiHealthTag">
<xsl:choose>
	<xsl:when test=".=1">Y</xsl:when>
	<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 性别 -->
<xsl:template name="tran_sex">
<xsl:param name="sex" />
<xsl:choose>
	<xsl:when test="$sex=1">0</xsl:when>	<!-- 男 -->
	<xsl:when test="$sex=2">1</xsl:when>	<!-- 女 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 职业风险告知 -->
<xsl:template name="tran_JobNotice">
<xsl:param name="JobNotice"/>
<xsl:choose>
	<xsl:when test="$JobNotice=0">N</xsl:when>	<!-- 非危险职业 -->
	<xsl:when test="$JobNotice=1">Y</xsl:when>	<!-- 危险职业 -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 证件类型 -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype='A'">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test="$idtype='B'">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test="$idtype='F'">5</xsl:when>	<!-- 户口薄 -->
	<xsl:when test="$idtype='I'">1</xsl:when>	<!-- （外国） 护照-->
	<xsl:when test="$idtype='8'">7</xsl:when>	<!-- 台湾居民来往大陆通行证-->
	<xsl:when test="$idtype='G'">6</xsl:when>   <!-- 港澳回乡证 -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
	<xsl:when test="$jobcode='A'">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
	<xsl:when test="$jobcode='B'">2050101</xsl:when>	<!-- 卫生专业技术人员 -->
	<xsl:when test="$jobcode='C'">2070109</xsl:when>	<!-- 金融业务人员 -->
	<xsl:when test="$jobcode='D'">2080103</xsl:when>	<!-- 法律专业人员 -->
	<xsl:when test="$jobcode='E'">2090104</xsl:when>	<!-- 教学人员 -->
	<xsl:when test="$jobcode='F'">2100106</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
	<xsl:when test="$jobcode='G'">2130101</xsl:when>	<!-- 宗教职业者 -->
	<xsl:when test="$jobcode='H'">3030101</xsl:when>	<!-- 邮政和电信业务人员 -->
	<xsl:when test="$jobcode='I'">4010101</xsl:when>	<!-- 商业、服务业人员 -->
	<xsl:when test="$jobcode='J'">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
	<xsl:when test="$jobcode='K'">6240105</xsl:when>	<!-- 运输人员 -->
	<xsl:when test="$jobcode='L'">2020103</xsl:when>	<!-- 地址勘探人员 -->
	<xsl:when test="$jobcode='M'">2020906</xsl:when>	<!-- 工程施工人员 -->
	<xsl:when test="$jobcode='N'">6050611</xsl:when>	<!-- 加工制造、检验及计量人员 -->
	<xsl:when test="$jobcode='O'">7010103</xsl:when>	<!-- 军人 -->
	<xsl:when test="$jobcode='P'">8010101</xsl:when>	<!-- 无业 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 关系 -->
<xsl:template name="tran_relation">
<xsl:param name="relation" />
<xsl:choose>
	<xsl:when test="$relation=1">00</xsl:when>	<!-- 本人 -->
	<xsl:when test="$relation=2">02</xsl:when>	<!-- 配偶 -->
	<xsl:when test="$relation=3">02</xsl:when>	<!-- 配偶 -->
	<xsl:when test="$relation=4">01</xsl:when>	<!-- 父母 -->
	<xsl:when test="$relation=5">01</xsl:when>	<!-- 父母 -->
	<xsl:when test="$relation=6">03</xsl:when>	<!-- 儿女 -->
	<xsl:when test="$relation=7">03</xsl:when>	<!-- 儿女 -->
	<xsl:when test="$relation=30">04</xsl:when>
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_riskcode"><!-- 疑问点，中信银行没有提供险种代码表 -->
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122012">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122010">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122029">L12073</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型） -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122035">L12074</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	
	<xsl:when test="$riskcode=50006">50006</xsl:when>	<!-- 安邦长寿智赢1号年金保险计划 -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）-->
	<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）B款-->
	
	<!-- <xsl:when test="$riskcode='L12087'">L12087</xsl:when> -->	<!-- 安邦东风5号两全保险（万能型）-->
	<!-- <xsl:when test="$riskcode='L12086'">L12086</xsl:when> -->	<!-- 安邦东风3号两全保险（万能型）-->
	
	<!-- PBKINSR-1469 中信柜面东风9号 L12088 zx add 20160808 -->
	<!-- <xsl:when test="$riskcode='L12088'">L12088</xsl:when> -->
	<!-- PBKINSR-1458 中信柜面东风2号 L12085 zx add 20160808 -->
	<!-- <xsl:when test="$riskcode='L12085'">L12085</xsl:when> -->
	
	<!-- 安邦长寿6号两全保险（分红型） -->
	<!-- 
	<xsl:when test="$riskcode=122020">122020</xsl:when>
	 -->
	 <!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	 <!-- 
	 <xsl:when test="$riskcode=122003">122003</xsl:when>
	  -->
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 组合产品代码转换 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50006">50006</xsl:when>	<!-- 安邦长寿智赢1号年金保险计划 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 保单的缴费间隔/频次 -->
<xsl:template name="tran_payEndYearFlag" match="PbPayPeriod">
<xsl:choose>
    <xsl:when test=".=-1">-1</xsl:when>	  <!-- 不定期交 -->
    <xsl:when test=".=0">0</xsl:when>	  <!-- 趸交 -->
	<xsl:when test=".=1">1</xsl:when>	  <!-- 月交 -->
	<xsl:when test=".=3">3</xsl:when>	  <!-- 季交 -->
	<xsl:when test=".=6">6</xsl:when>	  <!-- 半年交 -->
	<xsl:when test=".=12">12</xsl:when>	  <!-- 年交 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 保险年期年龄标志 -->
<xsl:template name="tran_insuyearflag" match="PbInsuYearFlag">
<xsl:choose>
	<xsl:when test=".=2">Y</xsl:when>	<!-- 按年 -->
	<xsl:when test=".=4">M</xsl:when>	<!-- 按月 -->
	<xsl:when test=".=5">D</xsl:when>	<!-- 按日 -->
	<xsl:when test=".=1">A</xsl:when>   <!-- 终身 -->
	<xsl:when test=".=6">A</xsl:when>   <!-- 到某一周岁 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取方式 -->
<xsl:template name="tran_bonusgetmode" match="LiBonusGetMode">
<xsl:choose>
	<xsl:when test=".=0">2</xsl:when>	<!-- 直接给付 -->
	<xsl:when test=".=1">3</xsl:when>	<!-- 抵交保费 -->
	<xsl:when test=".=2">1</xsl:when>	<!-- 累计生息 -->
	<xsl:when test=".=3">5</xsl:when>	<!-- 增额交清  -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 国籍转换 -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>		
		<xsl:when test="$nationality = '0156'">CHN</xsl:when> <!-- 中国  -->
		<xsl:when test="$nationality = '0344'">CHN</xsl:when> <!-- 中国香港  -->
		<xsl:when test="$nationality = '0158'">CHN</xsl:when> <!-- 中国台湾  -->
		<xsl:when test="$nationality = '0446'">CHN</xsl:when> <!-- 中国澳门  -->
		<xsl:when test="$nationality = '0392'">JP</xsl:when>  <!-- 日本  -->
		<xsl:when test="$nationality = '0840'">US</xsl:when>  <!-- 美国  -->
		<xsl:when test="$nationality = '0643'">RU</xsl:when>  <!-- 俄罗斯  -->
		<xsl:when test="$nationality = '0826'">GB</xsl:when>  <!-- 英国  -->
		<xsl:when test="$nationality = '0250'">FR</xsl:when>  <!-- 法国  -->
		<xsl:when test="$nationality = '0276'">DE</xsl:when>  <!-- 德国  -->
		<xsl:when test="$nationality = '0410'">KR</xsl:when>  <!-- 韩国  -->
		<xsl:when test="$nationality = '0702'">SG</xsl:when>  <!-- 新加坡  -->
		<xsl:when test="$nationality = '0360'">ID</xsl:when>  <!-- 印度尼西亚  -->
	    <xsl:when test="$nationality = '0356'">IN</xsl:when>  <!-- 印度  -->
	    <xsl:when test="$nationality = '0380'">IT</xsl:when>  <!-- 意大利  -->
		<xsl:when test="$nationality = '0458'">MY</xsl:when>  <!-- 马来西亚  -->
		<xsl:when test="$nationality = '0764'">TH</xsl:when>  <!-- 泰国  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 健康告知  -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice=0">N</xsl:when>	<!-- 无健康告知 -->
	<xsl:when test="$healthnotice=1">Y</xsl:when>	<!-- 有健康告知 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
