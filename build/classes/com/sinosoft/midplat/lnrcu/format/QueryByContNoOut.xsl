<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<TXLife>
	<!-- 交易返回码 -->
	<ResultCode>
	     <xsl:if test="Head/Flag='0'">00</xsl:if>
	  	 <xsl:if test="Head/Flag='1'">68</xsl:if>
	</ResultCode>
	<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
	<!-- 如果交易成功，才返回下面的结点 -->
	<xsl:if test="Head/Flag='0'">
		<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
		<xsl:variable name="InsuredSex" select="Body/Insured/Sex"/>
		<!-- 保单号 -->
		<PolNumber><xsl:value-of select ="Body/ContNo"/></PolNumber>
		<!-- 查询密码-->
		<Passwd></Passwd>
		<!-- 保单状态 -->
		<PolicyStatus>承保</PolicyStatus>
		<!-- 缴费状态 -->
		<PayStatus>已缴</PayStatus>
		<!-- 险种代码-->
		<ProductCode>
			<xsl:call-template name="tran_riskcode">
				<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
			</xsl:call-template>
		</ProductCode>
		<!-- 险种名称-->
		<PlanName><xsl:value-of select="$MainRisk/RiskName"/></PlanName>
		<!-- 每份缴费标准 -->
		<FeeStd><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></FeeStd>
		<!-- 缴费折扣率,和银行计算确认暂不填写 -->
		<RatioStd></RatioStd>
		<!-- 每份综合加费,,和银行计算确认暂不填写 -->
		<FeeCon></FeeCon>
		<!-- 每份职业加费,,和银行计算确认暂不填写 -->
		<FeePro></FeePro>
		<!-- 缴费方式名称 -->
		<PaymentModeName>
		    <xsl:call-template name="tran_PayIntvCha">
		        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv" /></xsl:with-param>
		    </xsl:call-template>
	    </PaymentModeName>
		<!-- 缴费起始日期, 对应保单查询页面的"起始日期"，保单承保起始日期。需要和业务同事确认 -->
		<PaymentDueDate><xsl:value-of select="$MainRisk/CValiDate" /></PaymentDueDate>
		<!-- 
		<PaymentDueDate><xsl:value-of select="$MainRisk/SignDate" /></PaymentDueDate>
		 -->
		<!-- 缴费终止日期, 对应保单查询页面的"终止日期"，保单承保截止日期，需要和业务同事确认-->
		<FinalPaymentDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></FinalPaymentDate>
		<!-- 
		<FinalPaymentDate><xsl:value-of select ="$MainRisk/PayEndDate"/></FinalPaymentDate>
		 -->
		<!-- 责任终止日期 -->
		<TermDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></TermDate>
		
		<!-- 缴费年限 -->
		<PaymentDuration>
			<xsl:choose>
				<xsl:when test="$MainRisk/PayIntv=0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select ="$MainRisk/PayEndYear"/></xsl:otherwise>
			</xsl:choose>
		</PaymentDuration>
		<!-- 已缴期数, 需要和业务同事确认 -->
		<Yijiaoshu>1</Yijiaoshu>
		<!-- 累计缴费金额 -->
		<Pamount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></Pamount>
		
		<!-- 领取/给付方式名称 -->
		<BenefitModeName>
		    <xsl:call-template name="tran_GetIntvText">
		        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
		    </xsl:call-template>
		</BenefitModeName>
		<!-- 首期年金领取日期 -->
		<FirstPayOutDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/GetStartDate)" /></FirstPayOutDate>
		<!-- 投保金额：银行方单位万元 -->
		<IntialNumberOfUnits><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)"/>元</IntialNumberOfUnits>
		<!-- 投保年龄 -->
		<AgeTouBao><xsl:value-of select ="$MainRisk/GetYear"/></AgeTouBao>
		<!-- 投保日期 -->
		<SubmissionDate><xsl:value-of select ="$MainRisk/PolApplyDate"/></SubmissionDate>
		<!-- 红利领取方式名称:11-现金领取 12-累积生息 13-抵缴保费 14-缴清增额 -->
		<DivTypeName>无</DivTypeName>
		
		<!-- 预缴期数 -->
		<Yujiaoshu>0</Yujiaoshu>
		<!-- 预缴金额 -->
		<Yuamount>0.00</Yuamount>
		<!-- 应缴期数 -->
		<Yingqishu>1</Yingqishu>
		<!-- 应缴金额 -->
		<Yingamount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></Yingamount>
		<!-- 应缴期间起期，此处为：保险起期，这个是不是应该是保险的缴费日期？因为是趸交，所以应缴期间起期、应缴期间止期同为保险的缴费日期（也就是签单日期）？ -->
		<Yingqdate><xsl:value-of select ="$MainRisk/SignDate"/></Yingqdate>
		<!-- 
		<Yingqdate><xsl:value-of select ="$MainRisk/CValiDate"/></Yingqdate>
		 -->
		<!-- 应缴期间止期，此处为：保险止期，这个是不是应该是保险的缴费日期？因为是趸交，所以应缴期间起期、应缴期间止期同为保险的缴费日期（也就是签单日期）？ -->
		<Yingzdate><xsl:value-of select ="$MainRisk/PayEndDate"/></Yingzdate>
		<!-- 
		<Yingzdate><xsl:value-of select ="$MainRisk/InsuEndDate"/></Yingzdate>
		 -->
		<!-- 备用 -->
		<BeiYong></BeiYong>
		
		<PolicyHolder>
			<!-- 投保人证件号码 -->
			<GovtID><xsl:value-of select ="Body/Appnt/IDNo"/></GovtID>
			<!-- 投保人证件类型 -->
			<GovtIDTC>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Body/Appnt/IDType" />
				</xsl:call-template>
			</GovtIDTC>
			<!-- 投保人出生日期 -->
			<BirthDate><xsl:value-of select ="Body/Appnt/Birthday"/></BirthDate>
			<!-- 投保人姓名 -->
			<FullName><xsl:value-of select ="Body/Appnt/Name"/></FullName>
			<!-- 缴费地址 -->
			<Line1><xsl:value-of select ="Body/Appnt/Address"/></Line1>
			<!-- 缴费电话 -->
			<DialNumber><xsl:value-of select ="Body/Appnt/Mobile"/></DialNumber>
			<!-- 缴费邮编 -->
			<Zip><xsl:value-of select ="Body/Appnt/ZipCode"/></Zip>
			<!-- 与被保人关系 -->
			<RelatedToInsuredRoleCode>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="Body/Appnt/RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Body/Appnt/Sex"/></xsl:with-param>
				</xsl:call-template>
			</RelatedToInsuredRoleCode>
			<!-- 与被保人关系名称-->
			<RelatedToInsuredRoleName>
				<xsl:call-template name="tran_RelationRoleCodeText">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="Body/Appnt/RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Body/Appnt/Sex"/></xsl:with-param>
				</xsl:call-template>
	        </RelatedToInsuredRoleName>
		</PolicyHolder>
		<!-- 被保人信息 -->
		<Insured>
			<!-- 被保人证件号码 -->
			<GovtID><xsl:value-of select ="Body/Insured/IDNo"/></GovtID>
			<!-- 被保人证件类型 -->
			<GovtIDTC>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Body/Insured/IDType" />
				</xsl:call-template>
			</GovtIDTC>
			<!-- 被保人姓名 -->
			<FullName><xsl:value-of select="Body/Insured/Name"/></FullName>
			<!-- 被保人性别 -->
			<Gender>
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex" select="$InsuredSex" />
				</xsl:call-template>
			</Gender>
			<!-- 被保人出生日期 -->
			<BirthDate><xsl:value-of select="Body/Insured/Birthday"/></BirthDate>
			<!-- 被保人职业类别 -->
			<OccupationType><xsl:value-of select="Body/Insured/JobType"/></OccupationType>
			<!-- 被保人居住地址 -->
			<Line1><xsl:value-of select="Body/Insured/Address"/></Line1>
			<!-- 被保人居住邮编 -->
			<Zip><xsl:value-of select="Body/Insured/ZipCode"/></Zip>
			<!-- 被保人电话 -->
			<DialNumber><xsl:value-of select="Body/Insured/Mobile"/></DialNumber>
		</Insured>

		<!--受益人是否为法定标志,此处写死，5：本人 -->
		<BeneficiaryIndicator>5</BeneficiaryIndicator>
		<!--  
		<xsl:if test="count(Body/Bnf)=0"><BeneficiaryIndicator>是</BeneficiaryIndicator></xsl:if>
		<xsl:if test="count(Body/Bnf)!=0"><BeneficiaryIndicator>否</BeneficiaryIndicator></xsl:if>
		-->
		<!-- 受益人个数 -->
		<BeneficiaryCount><xsl:value-of select ="count(Body/Bnf)"/></BeneficiaryCount>
		<xsl:for-each select="Body/Bnf">
		    <!-- 受益分配约定 -->
			<Beneficiary>
				<!-- 分配方式 -->
				<BeneficiaryMethodName>
					<xsl:call-template name="tran_BeneficiaryMethodName">
						<xsl:with-param name="beneficiaryMethod" select="Grade" />
					</xsl:call-template>
				</BeneficiaryMethodName>
				<!-- 
				<BeneficiaryMethod>3</BeneficiaryMethod>
				 -->
				<!-- 受益人号 -->
				<GovtID><xsl:value-of select ="IDNo"/></GovtID>
				<!-- 受益人姓名 -->
				<FullName><xsl:value-of select ="Name"/></FullName>
				<!-- 受益人性别 -->
				<Gender>
					<xsl:call-template name="tran_sex">
						<xsl:with-param name="sex" select="Sex" />
					</xsl:call-template>
				</Gender>
				<!-- 与被保人关系 -->
				<RelatedToInsuredRoleName>
					<xsl:call-template name="tran_RelationRoleCodeText">
					    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
						<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
						<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
					</xsl:call-template>
				</RelatedToInsuredRoleName>
				<!-- 
				<RelatedToInsuredRoleCode>
					<xsl:call-template name="tran_RelationRoleCode">
					    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
						<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
						<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
					</xsl:call-template>
				</RelatedToInsuredRoleCode>
				 -->
				<InterestPercent><xsl:value-of select="Lot" /></InterestPercent>
		    </Beneficiary>
		</xsl:for-each>
	
		<!-- 附加险个数 -->
		<CoverageCount><xsl:value-of select ="count(Body/Risk[RiskCode != MainRiskCode])"/></CoverageCount>
		<!-- 附加险费用结构 -->
		<Extension1>
			<!-- 险种代码 -->
			<ProductCode></ProductCode>
			<!--附加险保费=(附加险的缴费标准＋职业加费＋综合加费)*附加险份数 -->
			<ModalPremAmt></ModalPremAmt>
			<!-- 险种代码名称 -->
			<PlanName></PlanName>
			<!-- 附加险份数 -->
			<IntialNumberOfUnits>0</IntialNumberOfUnits>
			<!-- 附加险每份缴费标准 -->
			<FeeStd></FeeStd>
			<!-- 附加险每份综合加费 -->
			<FeeCon></FeeCon>
			<!-- 附加险每份职业加费 -->
			<FeePro></FeePro>
			<!-- 附加险基础保额 -->
			<BasePremAmt></BasePremAmt>
			<!-- 附加险缴费终止年龄 -->
			<PaymentEndAge></PaymentEndAge>
			<!-- 附加险缴费终止日期 -->
			<FinalPaymentDate></FinalPaymentDate>
			<!-- 附加险责任终止日期 -->
			<TermDate></TermDate>
			<!-- 缴费方式代码 -->
			<PaymentMode></PaymentMode>
			<!-- 缴费方式名称 -->
			<PaymentModeName></PaymentModeName>
			<!-- 缴费年限 -->
			<PayoutDuration></PayoutDuration>
			<!-- 领取/给付方式代码 -->
			<BenefitMode></BenefitMode>
			<!-- 领取/给付方式名称 -->
			<BenefitModeName></BenefitModeName>
			<!-- 红利领取方式代码 -->
			<DivType></DivType>
			<!-- 红利领取方式名称 -->
			<DivTypeName></DivTypeName>
			<!-- 领取日期 -->
			<PayOutDate></PayOutDate>
			<!--附加险领取年龄 -->
			<PayoutStart></PayoutStart> 
		</Extension1>
	
	</xsl:if> <!-- 如果交易成功，才返回上面的结点 -->
</TXLife>
</xsl:template>
<!-- +++++++++++++++++++++++++++++++++++++++++模板区++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- 缴费频次 
 银行: 01：趸交         10：月交     11：季交    12：半年交    13：年交          02：不定期
    核心:  0：一次交清/趸交 1:  月交     3:季交      6:半年交	  12：年交          -1:不定期交 -->
<xsl:template name="tran_PayIntv">
	<xsl:param name="payIntv">0</xsl:param>
	<xsl:if test="$payIntv = '0'">01</xsl:if>
	<xsl:if test="$payIntv = '1'">10</xsl:if>
	<xsl:if test="$payIntv = '3'">11</xsl:if>
	<xsl:if test="$payIntv = '6'">12</xsl:if>
	<xsl:if test="$payIntv = '12'">13</xsl:if>
	<xsl:if test="$payIntv = '-1'">02</xsl:if>
</xsl:template>

   <xsl:template name="tran_PayIntvCha">
	<xsl:param name="payIntv">0</xsl:param>
	<xsl:if test="$payIntv = '0'">趸交</xsl:if>
	<xsl:if test="$payIntv = '1'">月交</xsl:if>
	<xsl:if test="$payIntv = '3'">季交</xsl:if>
	<xsl:if test="$payIntv = '6'">半年交</xsl:if>
	<xsl:if test="$payIntv = '12'">年交</xsl:if>
	<xsl:if test="$payIntv = '-1'">不定期交</xsl:if>
</xsl:template>

<!-- 证件类型
    银行:1身份证   4护照   8军官证  10驾照    11出生证    7户口簿    99其他       2失业证，3离休证，5签证，6学生证，9军官退休证，
    核心:0身份证   1护照   2军官证   3:驾照   4:出生证明  5:户口簿   8:其他 9:异常身份证
 -->
 <xsl:template name="tran_IDType">
	<xsl:param name="idtype"></xsl:param>
    <xsl:choose>
		<xsl:when test="$idtype = '0'">1</xsl:when>
		<xsl:when test="$idtype = '1'">4</xsl:when>
		<xsl:when test="$idtype = '2'">8</xsl:when>
		<xsl:when test="$idtype = '3'">10</xsl:when>
		<xsl:when test="$idtype = '4'">11</xsl:when>
		<xsl:when test="$idtype = '5'">7</xsl:when>
	    <xsl:otherwise>99</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 红利领取方式
00-无 11-现金领取 12-累积生息 13-抵缴保费 14-缴清增额 
4现金领取    1累积生息  3抵缴保费    5增额缴清    2预约转账 
 -->
<xsl:template name="tran_BonusGetMode">
    <xsl:param name="bonusGetMode">0</xsl:param>
    <xsl:if test="$bonusGetMode='4'">11</xsl:if>
    <xsl:if test="$bonusGetMode='1'">12</xsl:if>
    <xsl:if test="$bonusGetMode='3'">13</xsl:if>
    <xsl:if test="$bonusGetMode='5'">14</xsl:if>
    <xsl:if test="$bonusGetMode='0'">00</xsl:if>
</xsl:template>
<xsl:template name="tran_BonusGetModeText">
    <xsl:param name="bonusGetMode">0</xsl:param>
    <xsl:if test="$bonusGetMode='4'">现金领取</xsl:if>
    <xsl:if test="$bonusGetMode='1'">累积生息</xsl:if>
    <xsl:if test="$bonusGetMode='3'">抵缴保费</xsl:if>
    <xsl:if test="$bonusGetMode='5'">增额缴清</xsl:if>
    <xsl:if test="$bonusGetMode='0'">无</xsl:if>
</xsl:template>	

<!--给付方式
1-一次给付 2-年给付  3-半年给付  4-季给付  5-月给付  6-其他
0-趸领     12年领    6半年领     3季领     1月领     36三年领  120十年领
 -->
<xsl:template name="tran_GetIntv">
    <xsl:param name="getIntv">0</xsl:param>
    <xsl:choose>
	    <xsl:when test="$getIntv='0'">1</xsl:when>
	    <xsl:when test="$getIntv='12'">2</xsl:when>
	    <xsl:when test="$getIntv='6'">3</xsl:when>
	    <xsl:when test="$getIntv='3'">4</xsl:when>
	    <xsl:when test="$getIntv='1'">5</xsl:when>
	    <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
</xsl:template>	
<xsl:template name="tran_GetIntvText">
    <xsl:param name="getIntv">0</xsl:param>
    <xsl:choose>
	    <xsl:when test="$getIntv='0'">一次给付</xsl:when>
	    <xsl:when test="$getIntv='12'">年给付</xsl:when>
	    <xsl:when test="$getIntv='6'">半年给付</xsl:when>
	    <xsl:when test="$getIntv='3'">季给付</xsl:when>
	    <xsl:when test="$getIntv='1'">月给付</xsl:when>
	    <xsl:otherwise>其他</xsl:otherwise>
    </xsl:choose>
</xsl:template>		

<!-- 关系
银行： 301本人 302法定 303母女 304父女 305祖孙 306母子 307兄弟 308姐妹 309父子 310夫妻 311岳婿 312雇佣 313侄儿
 314侄女 315姐弟 316朋友 317外甥女 318外甥 319兄妹 320婆媳 321姑嫂  323妯娌 324亲属 325抚养 399其他
 
核心；00本人 ，01父母，,02配偶，03子女,04其他,05雇佣,06抚养,07扶养,08赡养
      0 男，1女
 -->
<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
    <xsl:param name="sex"></xsl:param>
	<xsl:choose>
		<!-- 本人 -->
		<xsl:when test="$relaToInsured='00'">301</xsl:when>
		<!-- 配偶 -->
		<xsl:when test="$relaToInsured='02'">310</xsl:when>
		<!-- 父母 -->
		<xsl:when test="$relaToInsured='01'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">309</xsl:if>
		        <xsl:if test="$insuredSex='1'">304</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">306</xsl:if>
		        <xsl:if test="$insuredSex='1'">303</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- 子女 -->
		<xsl:when test="$relaToInsured='03'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">309</xsl:if>
		        <xsl:if test="$insuredSex='1'">304</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">306</xsl:if>
		        <xsl:if test="$insuredSex='1'">303</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- 其他 -->
		<xsl:when test="$relaToInsured='04'">399</xsl:when>
		<!-- 雇佣 -->
		<xsl:when test="$relaToInsured='05'">312</xsl:when>
		<!-- 兄弟姐妹 -->
		<xsl:when test="$relaToInsured='12'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">307</xsl:if>
		        <xsl:if test="$insuredSex='1'">319</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">319</xsl:if>
		        <xsl:if test="$insuredSex='1'">308</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- 其他亲属 -->
		<xsl:when test="$relaToInsured='25'">324</xsl:when>
		<!-- 朋友 -->
		<xsl:when test="$relaToInsured='27'">316</xsl:when>
		<!-- 其他 -->
		<xsl:otherwise>399</xsl:otherwise>
	</xsl:choose>
</xsl:template>	

<xsl:template name="tran_RelationRoleCodeText">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
    <xsl:param name="sex"></xsl:param>
	<xsl:choose>
		<!-- 本人 -->
		<xsl:when test="$relaToInsured='00'">本人</xsl:when>
		<!-- 配偶 -->
		<xsl:when test="$relaToInsured='02'">配偶</xsl:when>
		<!-- 父母 -->
		<xsl:when test="$relaToInsured='01'">父母</xsl:when>
		<!-- 子女 -->
		<xsl:when test="$relaToInsured='03'">子女</xsl:when>
		<!-- 其他 -->
		<xsl:when test="$relaToInsured='04'">其他</xsl:when>
		<!-- 雇佣 -->
		<xsl:when test="$relaToInsured='05'">雇佣</xsl:when>
		<!-- 兄弟姐妹 -->
		<xsl:when test="$relaToInsured='12'">兄弟姐妹</xsl:when>
		<!-- 其他亲属 -->
		<xsl:when test="$relaToInsured='25'">亲属</xsl:when>
		<!-- 朋友 -->
		<xsl:when test="$relaToInsured='27'">朋友</xsl:when>
		<!-- 其他 -->
		<xsl:otherwise>其他</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 性别 -->
<xsl:template name="tran_sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex=1">0</xsl:when>	<!-- 男 -->
		<xsl:when test="$sex=0">1</xsl:when>	<!-- 女 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 分配方式：1-顺位  2-均分  3-比例  4-法定  5-本人  6-其他 -->
<xsl:template name="tran_BeneficiaryMethodName">
	<xsl:param name="beneficiaryMethod" />
	<xsl:choose>
		<xsl:when test="$beneficiaryMethod=1">顺位</xsl:when>	<!-- 男 -->
		<xsl:when test="$beneficiaryMethod=2">均分</xsl:when>	<!-- 女 -->
		<xsl:when test="$beneficiaryMethod=3">比例</xsl:when>	<!-- 女 -->
		<xsl:when test="$beneficiaryMethod=4">法定</xsl:when>	<!-- 女 -->
		<xsl:when test="$beneficiaryMethod=5">本人</xsl:when>	<!-- 女 -->
		<xsl:when test="$beneficiaryMethod=6">其他</xsl:when>	<!-- 女 -->
		<xsl:otherwise>无</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<!-- 安邦借款人意外伤害保险 -->
	<!-- 
	<xsl:when test="$riskcode=122015">EL5612</xsl:when>
	 -->
	<xsl:when test="$riskcode='L12049'">EL5612</xsl:when>	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>