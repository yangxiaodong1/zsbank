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
	  	 <xsl:if test="Head/Flag='1'">99</xsl:if>
	</ResultCode>
	<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
	<!-- 如果交易成功，才返回下面的结点 -->
	<xsl:if test="Head/Flag='0'">
	<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
	<xsl:variable name="InsuredSex" select="Body/Insured/Sex"/>
	<!-- 投保单号 -->
	<HOAppFormNumber><xsl:value-of select ="Body/ProposalPrtNo"/></HOAppFormNumber>
	<!--合计保费(主险保费＋附加险保费) -->
	<PaymentAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/></PaymentAmt>
	<!-- 险种代码 -->
	<ProductCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</ProductCode>
	<!--主险保费=(主险的缴费标准＋职业加费＋综合加费)*主险份数 -->
	<ModalPremAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Prem)"/></ModalPremAmt>
	<!-- 险种名称 -->
	<PlanName><xsl:value-of select ="$MainRisk/RiskName"/></PlanName>
	<!-- 投保日期 -->
	<SubmissionDate><xsl:value-of select ="$MainRisk/PolApplyDate"/></SubmissionDate>
	<!-- 投保金额：银行方单位万元 -->
	<IntialNumberOfUnits><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)*0.0001"/></IntialNumberOfUnits>
	<!-- 投保年龄 -->
	<AgeTouBao></AgeTouBao>
	<!-- 缴费方式码 -->
	<PaymentMode>
	    <xsl:call-template name="tran_PayIntv">
	        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv"/></xsl:with-param>
	    </xsl:call-template>
    </PaymentMode>
	<!-- 缴费方式名称 -->
	<PaymentModeName>
	    <xsl:call-template name="tran_PayIntvCha">
	        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv" /></xsl:with-param>
	    </xsl:call-template>
	</PaymentModeName>
	<!-- 缴费年限 -->
	<PaymentDuration><xsl:value-of select ="$MainRisk/PayEndYear"/></PaymentDuration>
	<!-- 保险业务员代码 -->
	<CpicTeller><xsl:value-of select ="Body/AgentCode"/></CpicTeller>
	<!-- 领取年龄 -->
	<PayoutStart><xsl:value-of select ="$MainRisk/GetYear"/></PayoutStart>
	<!-- 红利领取方式代码 -->
	<DivType>
	    <xsl:call-template name="tran_BonusGetMode">
	        <xsl:with-param name="bonusGetMode"> <xsl:value-of select="$MainRisk/BonusGetMode" /></xsl:with-param>
	    </xsl:call-template>
	</DivType>
	<!-- 红利领取方式名称 -->
	<DivTypeName>
	    <xsl:call-template name="tran_BonusGetModeText">
	        <xsl:with-param name="bonusGetMode"><xsl:value-of select="$MainRisk/BonusGetMode" /></xsl:with-param>
	    </xsl:call-template>
	</DivTypeName>
	<!-- 领取/给付方式代码 -->
	<BenefitMode>
	    <xsl:call-template name="tran_GetIntv">
	        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
	    </xsl:call-template>
	</BenefitMode>
	<!-- 领取/给付方式名称 -->
	<BenefitModeName>
	    <xsl:call-template name="tran_GetIntvText">
	        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
	    </xsl:call-template>
	</BenefitModeName>
	<!-- 首期年金领取日期 -->
	<FirstPayOutDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/GetStartDate)" /></FirstPayOutDate>	 
	<!-- 缴费标准 -->
	<FeeStd><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></FeeStd>
	<!-- 综合加费标准 -->
	<FeeCon></FeeCon>
	<!-- 职业加费标准 -->
	<FeePro></FeePro>
	<!-- 缴费终止年龄 -->
	<PaymentEndAge><xsl:value-of select ="$MainRisk/PayEndYear"/></PaymentEndAge>
	<!-- 缴费起始日期,因试算时签单日期为空值，此处取投保日期 -->
	<PaymentDueDate><xsl:value-of select="$MainRisk/PolApplyDate" /></PaymentDueDate>
	<!-- 缴费终止日期 -->
	<FinalPaymentDate><xsl:value-of select ="$MainRisk/PayEndDate"/></FinalPaymentDate>
	<!-- 责任起始日期 -->
	<EffDate><xsl:value-of select="$MainRisk/CValiDate" /></EffDate>
	<!-- 责任终止日期 -->
	<TermDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></TermDate>	
	
	<!-- 处理结果说明 -->
	<ResultInfo></ResultInfo>	
	<!-- 备用 -->
	<BeiYong></BeiYong>
	
	
	<!-- 投保人信息 -->
	<PolicyHolder>
		<!-- 投保人证件号码 -->
		<GovtID><xsl:value-of select ="Body/Appnt/IDNo"/></GovtID>
		<!-- 投保人证件类型 -->
		<GovtIDTC>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Body/Appnt/IDType" />
			</xsl:call-template>
		</GovtIDTC>
		<!-- 投保人姓名 -->
		<FullName><xsl:value-of select ="Body/Appnt/Name"/></FullName>
		<!-- 投保人性别 -->
		<Gender>
			<xsl:call-template name="tran_sex">
				<xsl:with-param name="sex" select="Body/Appnt/Sex" />
			</xsl:call-template>
		</Gender>
		<!-- 
		<Gender><xsl:apply-templates select="Gender" /></Gender>
		-->
		<!-- 投保人出生日期 -->
		<BirthDate><xsl:value-of select ="Body/Appnt/Birthday"/></BirthDate>
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
		<!--被保人证件类型 -->
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

	<!--受益人是否为法定标志:银行传什么，保险公司返回什么，在newcont.java中处理
	<BeneficiaryIndicator></BeneficiaryIndicator>
	-->
	
	<!-- 受益人个数 -->
	<BeneficiaryCount><xsl:value-of select ="count(Body/Bnf)"/></BeneficiaryCount>
	<!-- 受益人信息，将银行传递的信息按照银行的标签再返回回去，在newcont.java的方法std2NoStd中处理 -->
	<xsl:for-each select="Body/Bnf">
	    <!-- 受益分配约定 -->
		<Beneficiary>
			<!-- 分配方式 -->
			<BeneficiaryMethod><xsl:value-of select="Grade" /></BeneficiaryMethod>
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
			<RelatedToInsuredRoleCode>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
				</xsl:call-template>
			</RelatedToInsuredRoleCode>
			<!-- 分配比例下面代表 -->
			<InterestPercent><xsl:value-of select="Lot" /></InterestPercent>
	    </Beneficiary>
	</xsl:for-each>
		
	<!-- 基础保额份数 -->
	<BasePreCount>0</BasePreCount>
	<!-- 基础保额结构 -->
	<BasePre1>
		<!-- 保额责任名称 -->
		<BasePerName></BasePerName>
		<!-- 保额数值 -->
		<BasePeramount><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)"/></BasePeramount>
	</BasePre1>
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
		<IntialNumberOfUnits></IntialNumberOfUnits>
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
	
	<!-- 保单现金价值表 -->
	<!-- 保单现金价值表 -->
		<CashValue1>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue1>
		
		<CashValue2>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue2>
		<CashValue3>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue3>
		<CashValue4>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue4>
		<CashValue5>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue5>
		<CashValue6>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue6>
		<CashValue7>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue7>
		<CashValue8>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue8>
		<CashValue9>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue9>
		<CashValue10>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue10>
		<CashValue11>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue11>
		<CashValue12>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue12>
		<CashValue13>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue13>
		<CashValue14>
			<!-- 年末现金价值 -->
			<Cash></Cash>
			<!-- 保单年度 -->
			<Year></Year>
		</CashValue14>
		<!--  
		<xsl:for-each select="Body/Risk/CashValues/CashValue">
			<CashValue1>
				<Cash><xsl:value-of select ="Cash"/></Cash>
				<Year><xsl:value-of select ="EndYear"/></Year>
			</CashValue1>
		</xsl:for-each>
		-->
	<LoanStartDate><xsl:value-of select ="java:com.sinosoft.midplat.common.DateUtil.date10to8(Body/LoanStartDate)"/></LoanStartDate>
	<LoanEndDate><xsl:value-of select ="java:com.sinosoft.midplat.common.DateUtil.date10to8(Body/LoanEndDate)"/></LoanEndDate>
	<!--合同信息-->
	<ContractInfo>
		<!--保单保险金额-->
		<RiskAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Risk/Amnt)"/></RiskAmt>
		<!--保单累计保险金额-->
		<TotalRiskAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Risk/Amnt)"/></TotalRiskAmt>
	</ContractInfo>
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
		<!-- 父母 -->
		<xsl:when test="$relaToInsured='01'">父母</xsl:when>
		<!-- 配偶 -->
		<xsl:when test="$relaToInsured='02'">配偶</xsl:when>
		<!-- 子女 -->
		<xsl:when test="$relaToInsured='03'">子女</xsl:when>
		<!-- 祖父祖母 -->
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