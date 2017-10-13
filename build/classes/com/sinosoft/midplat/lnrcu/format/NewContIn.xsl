<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TXLife">
<TranData>
	<Head>
	    <TranDate><xsl:value-of select="TransExeDate"/></TranDate>
	    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
	    <TellerNo><xsl:value-of select="Teller"/></TellerNo>
	    <TranNo><xsl:value-of select="TransNo"/></TranNo>
	    <NodeNo><xsl:value-of select="BankCode"/><xsl:value-of select="Branch"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
	
	<Body>
		<!-- lnrcu 投保单号和单证号是一样的 -->
		<ProposalPrtNo><xsl:value-of select="HOAppFormNumber" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="HOAppFormNumber" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ApplicationInfo/SubmissionDate)" /></PolApplyDate>
		<!-- 
		<HealthNotice><xsl:value-of select="HealthIndicator" /></HealthNotice>
		 -->
		<HealthNotice>
			<xsl:call-template name="tran_HealthNotice">
				<xsl:with-param name="healthNotice" select="HealthIndicator" />
			</xsl:call-template>
		</HealthNotice>
	    <SocialInsure></SocialInsure>
	    <FreeMedical></FreeMedical>
	    <OtherMedical></OtherMedical>
	    <ContractNo><xsl:value-of select="ContractInfo/LoanContractNo" /></ContractNo>  				        <!--贷款合同号 -->  <!--必填项-->
	    <LoanSetComName><xsl:value-of select="PolicyHolder/FullName" /></LoanSetComName>								<!--贷款发放机构名称 -->  <!--必填项-->
	    <LoanMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(IntialNumberOfUnits*10000)" /></LoanMoney>										<!--贷款金额,单位：分 -->  <!--必填项-->
	    <LoanStartDate><xsl:value-of select="ContractInfo/LoanStartDate" /></LoanStartDate>						        <!--贷款起期[YYYY-MM-dd] -->  <!--必填项-->
	    <LoanEndDate><xsl:value-of select="ContractInfo/LoanEndDate" /></LoanEndDate>								    <!--贷款止期[YYYY-MM-dd] -->  <!--必填项-->
	    <LoanName><xsl:value-of select="PolicyHolder/FullName" /></LoanName>												<!--贷款人姓名 -->
	    <VoucherNo><xsl:value-of select="ContractInfo/LoanInvoiceNo" /></VoucherNo>										<!--贷款凭证号 -->    	    	
	    <!-- 缴费账户名称 -->
	    <AccName><xsl:value-of select="PolicyHolder/FullName" /></AccName>
	    <!-- 缴费账户账号 -->
	    <AccNo><xsl:value-of select="Banking/AccountNumber" /></AccNo>
		<!-- 投保人 -->
		<xsl:apply-templates select="PolicyHolder" />	
		<!-- 被保人 -->
		<xsl:apply-templates select="Insured" />
		<!-- 受益人1 -->
		<xsl:apply-templates select="Beneficiary1" />
		<!-- 受益人2 -->
		<xsl:apply-templates select="Beneficiary2" />
		<!-- 受益人3 -->
		<xsl:apply-templates select="Beneficiary3" />
		<!-- 受益人4 -->
		<xsl:apply-templates select="Beneficiary4" />
		<!-- 受益人5 -->
		<xsl:apply-templates select="Beneficiary5" />
		<!-- 受益人6 -->
		<xsl:apply-templates select="Beneficiary6" />


		<xsl:variable name="MainRiskCode">
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="ProductCode" />
				</xsl:call-template>
		</xsl:variable>
		<Risk>
			<RiskCode><xsl:value-of select="$MainRiskCode" /></RiskCode>
			
			<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
			<!-- 银行传过来的保额单位是：万元；核心保额单位是：分 -->
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(IntialNumberOfUnits*10000)" /></Amnt>
			<Prem>0</Prem>
		    <Mult></Mult>
		    <PayMode>A</PayMode><!-- A:银保通银行转帐 -->
			<PayIntv><xsl:apply-templates select="PaymentMode" /></PayIntv>
			<!-- 目前借款人意外险，只有保险年期为一年的产品，没有其他类型 -->
			<InsuYearFlag></InsuYearFlag>
			<!-- 这个银行可能传，也可能不传，由根据保险起期和保险止期计算保险年期 -->
			<InsuYear><xsl:value-of select="PaymentDuration" /></InsuYear>
			<!-- 缴费年期 -->
			<PayEndYearFlag>Y</PayEndYearFlag>
			<!-- 缴费期间，趸交时为1000 -->
			<PayEndYear>1000</PayEndYear>
			<GetIntv>
				<xsl:call-template name="tran_GetIntv">
				    <xsl:with-param name="getIntv"><xsl:value-of select="BenefitMode" /></xsl:with-param>
				</xsl:call-template>
			</GetIntv>
			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
				    <xsl:with-param name="divtype"><xsl:value-of select="DivType" /></xsl:with-param>
				</xsl:call-template>
			</BonusGetMode>
		</Risk>
		<!-- 险种 -->
		<xsl:apply-templates select="Extension" />

	</Body>
</TranData>
</xsl:template>

<!-- 职业代码：银行给的报文里没有投保人的职业，所以投保人的职业类别共用被保人的职业类别 -->
<xsl:variable name="JobCode">
	<xsl:call-template name="tran_jobCode">
		<xsl:with-param name="jobCode" select="TXLife/Insured/OccupationType" />
	</xsl:call-template>
</xsl:variable>
		
		
<!-- 投保人 -->
<xsl:template name="Appnt" match="PolicyHolder">
<Appnt>
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	
	<!-- 职业类别转编码 -->	
	<!---->
	<JobCode><xsl:value-of select="$JobCode" /></JobCode>
	
	<Nationality></Nationality>
	<Address><xsl:value-of	select="Line1" /></Address>
    <ZipCode><xsl:value-of	select="Zip" /></ZipCode>
    <Mobile><xsl:value-of select="DialNumber" /></Mobile>
    <Phone><xsl:value-of select="DialNumber" /></Phone>
    <Email></Email>
    <RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Appnt>
</xsl:template>

<!-- 被保人 -->
<xsl:template name="Insured" match="Insured">
<Insured>
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<!-- 职业类别转编码 -->	
	<JobCode><xsl:value-of select="$JobCode" /></JobCode>
	
	<Nationality></Nationality>
	<Address><xsl:value-of	select="Line1" /></Address>
    <ZipCode><xsl:value-of	select="Zip" /></ZipCode>
    <Mobile><xsl:value-of select="DialNumber" /></Mobile>
    <Phone><xsl:value-of select="DialNumber" /></Phone>
    <Email></Email>
</Insured>
</xsl:template>

<!-- 受益人1 -->
<xsl:template name="Bnf1" match="Beneficiary1">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- 受益人2 -->
<xsl:template name="Bnf2" match="Beneficiary2">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- 受益人3 -->
<xsl:template name="Bnf3" match="Beneficiary3">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- 受益人4 -->
<xsl:template name="Bnf4" match="Beneficiary4">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- 受益人5 -->
<xsl:template name="Bnf5" match="Beneficiary5">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>
<xsl:template name="Bnf6" match="Beneficiary6">
<Bnf>
	<Type>1</Type>	<!-- 默认为“1-死亡受益人” -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- 受益人级别 -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	需要转换010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>


<!-- 险种,附加险 -->
<xsl:template name="Risk" match="Extension">
<Risk>
	<RiskCode><xsl:value-of select="../ProductCode" /></RiskCode>    <!-- 产品编码 -->
	<MainRiskCode><xsl:value-of select="../ProductCode" /></MainRiskCode>
	<Amnt></Amnt>
	<Prem>0</Prem>
    <Mult></Mult>
    <PayMode>7</PayMode>
	<PayIntv><xsl:apply-templates select="../PaymentMode" /></PayIntv>
	<!-- 目前借款人意外险，只有保险年期为一年的产品，没有其他类型 -->
	<InsuYearFlag>Y</InsuYearFlag>
	<InsuYear>1</InsuYear>
	<PayEndYearFlag>Y</PayEndYearFlag>
	<PayEndYear><xsl:value-of select="../PaymentDuration" /></PayEndYear>
	<GetIntv>
		<xsl:call-template name="tran_GetIntv">
		    <xsl:with-param name="getIntv"><xsl:value-of select="../BenefitMode" /></xsl:with-param>
		</xsl:call-template>
	</GetIntv>
	<BonusGetMode>
		<xsl:call-template name="tran_BonusGetMode">
		    <xsl:with-param name="divtype"><xsl:value-of select="../DivType" /></xsl:with-param>
		</xsl:call-template>
	</BonusGetMode>
</Risk>
<!-- 险种,附加险 -->

</xsl:template>


<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<!-- 安邦借款人意外伤害保险 -->
	<!-- 
	<xsl:when test="$riskcode='EL5612'">122015</xsl:when>
	 -->
	<xsl:when test="$riskcode='EL5612'">L12049</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 职业代码：银行给的报文里没有投保人的职业，所以投保人的职业类别共用被保人的职业类别，目前银行方没有录入职业代码的录入项，所以会传默认值:9999999 -->
<xsl:template name="tran_jobCode">
	<xsl:param name="jobCode" />
	<xsl:choose>
		<xsl:when test="$jobCode=9999999">000000</xsl:when>	<!-- 银行传递默认编码是，我方转换为6个0 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 健康告知：银行方：Y（1）-健康；N（0）-不健康。保险公司：Y-不健康；N-健康 -->
<xsl:template name="tran_HealthNotice">
	<xsl:param name="healthNotice" />
	<xsl:choose>
		<xsl:when test="$healthNotice='1'">N</xsl:when>
		<xsl:when test="$healthNotice='0'">Y</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 性别 -->
<xsl:template name="tran_sex" match="Gender">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- 男 -->
	<xsl:when test=".=0">1</xsl:when>	<!-- 女 -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 证件类型
    银行:1身份证   4护照   8军官证  10驾照    11出生证    7户口簿    99其他       2失业证，3离休证，5签证，6学生证，9军官退休证，
    核心:0身份证   1护照   2军官证   3:驾照   4:出生证明  5:户口簿   8:其他 9:异常身份证
 -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test=".=4">1</xsl:when>	<!-- 护照 -->
	<xsl:when test=".=8">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test=".=10">3</xsl:when>	<!-- 士兵证 -->
	<xsl:when test=".=11">4</xsl:when>	<!-- 临时身份证 -->
	<xsl:when test=".=7">5</xsl:when>	<!-- 户口本  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 关系
银行： 301本人 302法定 303母女 304父女 305祖孙 306母子 307兄弟 308姐妹 309父子 310夫妻 311岳婿 312雇佣 313侄儿
 314侄女 315姐弟 316朋友 317外甥女 318外甥 319兄妹 320婆媳 321姑嫂  323妯娌 324亲属 325抚养 399其他
 
核心；00本人 ，01父母，,02配偶，03子女,04其他,05雇佣,06抚养,07扶养,08赡养
      0 男，1女
 -->
<xsl:template name="tran_relation" match="RelatedToInsuredRoleCode">
<xsl:choose>
	<xsl:when test=".=301">00</xsl:when>	<!-- 本人 -->
	<xsl:when test=".=303">01</xsl:when>	<!-- 父母 -->
	<xsl:when test=".=304">01</xsl:when>	<!-- 父母 -->
	<xsl:when test=".=310">02</xsl:when>	<!-- 配偶 -->
	<xsl:when test=".=306">01</xsl:when>	<!-- 父母 -->
	<xsl:when test=".=309">01</xsl:when>	<!-- 父母 -->
	<xsl:when test=".=312">05</xsl:when>	<!-- 雇佣 -->
	<xsl:when test=".=325">06</xsl:when>	<!-- 抚养 -->
	<!-- 因辽宁农信社第一受益人为：发放机构，但与投保人关系只能是：399-其它 -->
	<xsl:when test=".=399">04</xsl:when>	<!-- 其他 -->
	<xsl:otherwise>04</xsl:otherwise>		<!-- 其他 -->
</xsl:choose>
</xsl:template>

<!-- 缴费频次 -->
<xsl:template name="tran_payintv" match="PaymentMode">
<xsl:choose>
	<xsl:when test=".=13">12</xsl:when>	<!-- 年缴 -->
	<xsl:when test=".=10">1</xsl:when>	<!-- 月缴 -->
	<xsl:when test=".=12">6</xsl:when>	<!-- 半年缴 -->
	<xsl:when test=".=11">3</xsl:when>	<!-- 季缴 -->
	<xsl:when test=".=01">0</xsl:when>	<!-- 趸缴 -->
	<xsl:when test=".=02">-1</xsl:when>	<!-- 不定期 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 终交年期标志的转换 -->
<xsl:template name="tran_payendyearflag" match="PaymentDurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- 缴至某确定年龄 -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- 年 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- 月 -->
	<xsl:when test=".=4">D</xsl:when>	<!-- 日 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 保险年龄年期标志 -->
<xsl:template name="tran_InsuYearFlag" match="DurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- 保至某确定年龄 -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- 年保 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- 月保 -->
	<xsl:when test=".=4">D</xsl:when>	<!-- 日保 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取方式的转换：银行方（11-现金领取 12-累积生息 13-抵缴保费 14-缴清增额） -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype=12">1</xsl:when>	<!-- 累积生息 -->
	<xsl:when test="$divtype=13">3</xsl:when>	<!-- 抵交保费 -->
	<xsl:when test="$divtype=11">4</xsl:when>	<!-- 现金领取 -->
	<xsl:when test="$divtype=14">5</xsl:when>	<!-- 增额缴清 -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>



<!--给付方式
1-一次给付 2-年给付  3-半年给付  4-季给付  5-月给付  6-其他
0-趸领     12年领    6半年领     3季领     1月领     36三年领  120十年领
 -->
<xsl:template name="tran_GetIntv">
    <xsl:param name="getIntv"/>
    <xsl:choose>
	    <xsl:when test="$getIntv='1'">0</xsl:when>
	    <xsl:when test="$getIntv='2'">12</xsl:when>
	    <xsl:when test="$getIntv='3'">6</xsl:when>
	    <xsl:when test="$getIntv='4'">3</xsl:when>
	    <xsl:when test="$getIntv='5'">1</xsl:when>
	    <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
</xsl:template>	
<xsl:template name="tran_GetIntvText">
    <xsl:param name="getIntv"/>
    <xsl:choose>
	    <xsl:when test="$getIntv='1'">一次给付</xsl:when>
	    <xsl:when test="$getIntv='2'">年给付</xsl:when>
	    <xsl:when test="$getIntv='3'">半年给付</xsl:when>
	    <xsl:when test="$getIntv='4'">季给付</xsl:when>
	    <xsl:when test="$getIntv='5'">月给付</xsl:when>
	    <xsl:otherwise>其他</xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
