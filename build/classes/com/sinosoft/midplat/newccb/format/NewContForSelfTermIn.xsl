<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
			<SourceType>
				<xsl:apply-templates select="TX/TX_BODY/ENTITY/COM_ENTITY/TXN_ITT_CHNL_CGY_CODE" />
			</SourceType>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<ProposalPrtNo><xsl:value-of select="Ins_Bl_Prt_No" /></ProposalPrtNo>
	<ContPrtNo />
	<!-- 建行不传投保日期，取交易日期 -->
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></PolApplyDate>
	<!-- 
	<PolApplyDate><xsl:value-of select="../COM_ENTITY/OprgDay_Prd" /></PolApplyDate>
	-->
	<!--出单网点名称-->
	<AgentComName><xsl:value-of select="BO_Nm"/></AgentComName>
	<!--出单网点资格证-->
	<AgentComCertiCode><xsl:value-of select="BOInsPrAgnBsnLcns_ECD"/></AgentComCertiCode>
	<!-- 网点分管代理保险业务负责人编号 -->
	<ManagerNo><xsl:value-of select="BOIChOfAgInsBsnPnp_ID"/></ManagerNo>
	<!-- 网点分管代理保险业务负责人姓名 -->
	<ManagerName><xsl:value-of select="BOIChOfAgInsBsnPnp_Nm"/></ManagerName>
	<!--银行销售人员工号-->
	<SellerNo><xsl:value-of select="BO_Sale_Stff_ID"/></SellerNo>
	<!--银行销售人员名称-->
	<TellerName><xsl:value-of select="BO_Sale_Stff_Nm"/></TellerName>
	<!--银行销售人员资格证-->
	<TellerCertiCode><xsl:value-of select="Sale_Stff_AICSQCtf_ID"/></TellerCertiCode>
	
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName>	<!-- 取投保人姓名 -->
	<AccNo><xsl:value-of select="Plchd_PyF_AccNo" /></AccNo>
	<GetPolMode></GetPolMode> <!-- 保单递送方式 1=邮寄，2=柜面领取-->
	<!-- 保单递送类型1、纸制保单2、电子保单 -->
	<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
	     
	<JobNotice /><!-- 职业告知(N/Y) -->
	<HealthNotice><xsl:apply-templates select="Ntf_Itm_Ind" /></HealthNotice><!-- 健康告知(N/Y) -->
	<!-- add 为了解决获取保单详情返回必填项问题增加字段  begin -->
	<!-- 保费垫交标志 -->
	<AutoPayFlag>
	   <xsl:choose>
	        <xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/ApntInsPremPyAdvnInd=''"></xsl:when>
			<xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/ApntInsPremPyAdvnInd='0'">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</AutoPayFlag>
	<!-- 争议处理方式 -->
	<DisputedFag>
	    <xsl:choose>
			<xsl:when test="Dspt_Pcsg_MtdCd='03'">2</xsl:when>
			<xsl:when test="Dspt_Pcsg_MtdCd='04'">1</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</DisputedFag>
	<DisputedName><xsl:value-of select="Dspt_Arbtr_Inst_Nm" /></DisputedName><!-- 争议仲裁机构名 -->
	<!-- add 为了解决获取保单详情返回必填项问题增加字段  end -->
	<!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否 -->
	<PolicyIndicator>
		<xsl:choose>
			<xsl:when test="Minr_Acm_Cvr>0">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</PolicyIndicator>
	<!--累计未成年人投保身故保额 这个金额字段比较特殊，单位是百元-->
	<InsuredTotalFaceAmount><xsl:value-of select="Minr_Acm_Cvr*0.01" /></InsuredTotalFaceAmount>
	<!-- 建行一级联行号 -->
	<SubBankCode><xsl:value-of select="Lv1_Br_No" /></SubBankCode>
	
	<!-- 组合产品份数 -->
	<xsl:variable name="ContPlanMult">
		<xsl:choose>
			<xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps=''">
				<xsl:value-of select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps,'#')" />
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	<!-- 险种,FIXME 待确定主险标识MainAndAdlIns_Ind -->
	<xsl:variable name="MainRiskCode">
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- 组合产品编码, 待确定主险标识MainAndAdlIns_Ind  -->
	<xsl:variable name="tContPlanCode">
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- 产品组合 -->
	<ContPlan>
		<!-- 产品组合编码 -->
		<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
		<!-- 产品组合份数 -->
		<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
	</ContPlan>
	<!-- 投保人信息 -->
	<xsl:call-template name="Appnt" />
	<!-- 被保人信息 -->
	<xsl:call-template name="Insured" />		
	<!-- 受益人信息 -->
	<xsl:apply-templates select="Benf_List/Benf_Detail" />
		
	<xsl:for-each select="Busi_List/Busi_Detail">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="Cvr_ID" />
				</xsl:call-template>
			</RiskCode>
			<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Ins_Cvr)" /></Amnt>
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsPrem_Amt)" /></Prem>
			<Mult><xsl:value-of select="format-number(Ins_Cps, '#')" /></Mult>
		    <PayMode></PayMode>
			<PayIntv>
				<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
					<xsl:with-param name="payIntv" select="InsPrem_PyF_MtdCd" />
					<xsl:with-param name="payEndYearFlag" select="InsPrem_PyF_Cyc_Cd" />
				</xsl:call-template>
			</PayIntv>
			<PayEndYearFlag>
				<xsl:call-template name="tran_InsPrem_PyF_Cyc_Cd">
					<xsl:with-param name="payIntv" select="InsPrem_PyF_MtdCd" />
					<xsl:with-param name="payEndYearFlag" select="InsPrem_PyF_Cyc_Cd" />
				</xsl:call-template>
			</PayEndYearFlag>
			<xsl:choose>
				<xsl:when test="InsPrem_PyF_MtdCd='02'">
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<PayEndYear><xsl:value-of select="InsPrem_PyF_Prd_Num" /></PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<InsuYearFlag>				
				<xsl:call-template name="tran_Ins_Yr_Prd_CgyCd">
					<xsl:with-param name="insuYearType" select="Ins_Yr_Prd_CgyCd" />
					<xsl:with-param name="insuYearFlag" select="Ins_Cyc_Cd" />
				</xsl:call-template>
			</InsuYearFlag>
			<InsuYear>
				<xsl:if test="Ins_Yr_Prd_CgyCd='05'">106</xsl:if>
				<xsl:if test="Ins_Yr_Prd_CgyCd!='05'"><xsl:value-of select="Ins_Ddln" /></xsl:if>
			</InsuYear>
			<BonusGetMode><xsl:apply-templates select="XtraDvdn_Pcsg_MtdCd" /></BonusGetMode>
		</Risk>
	</xsl:for-each>		
</xsl:template>

<!-- 投保人信息 -->
<xsl:template name="Appnt">
	<Appnt>
		<Name><xsl:value-of select="Plchd_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Plchd_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Plchd_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Plchd_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Plchd_Crdt_ExpDt" /></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				<xsl:with-param name="jobcode" select="Plchd_Ocp_Cd" />
			</xsl:call-template>
		</JobCode>
		<Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Plchd_Yr_IncmAm)" /></Salary>
		<FamilySalary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Fam_Yr_IncmAm)" /></FamilySalary>
		<LiveZone><xsl:apply-templates select="Rsdnt_TpCd" /></LiveZone>
		<RiskAssess></RiskAssess>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Plchd_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<Address><xsl:value-of select="Plchd_Comm_Adr" /></Address>
		<ZipCode><xsl:value-of select="Plchd_ZipECD" /></ZipCode>
		<Mobile><xsl:value-of select="Plchd_Move_TelNo" /></Mobile>
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		   <Phone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <Phone><xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<Email><xsl:value-of select="Plchd_Email_Adr" /></Email>
		<RelaToInsured><xsl:call-template name="tran_Relation">
				<xsl:with-param name="relation" select="Plchd_And_Rcgn_ReTpCd" />
			</xsl:call-template>
		</RelaToInsured>
		<!-- 增加保费预算金额，跟核心沟通，在该节点增加 -->
		<Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(//InsPrem_Bdgt_Amt)" /></Premiumbudget>
	</Appnt>
</xsl:template>

<!-- 被保人信息 -->
<xsl:template name="Insured">
	<Insured>
		<Name><xsl:value-of select="Rcgn_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Rcgn_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Rcgn_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Rcgn_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Rcgn_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Rcgn_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Rcgn_Crdt_ExpDt" /></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				<xsl:with-param name="jobcode" select="Rcgn_Ocp_Cd" />
			</xsl:call-template>
		</JobCode>
		<Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Rcgn_Yr_IncmAm)" /></Salary>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Rcgn_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<Address><xsl:value-of select="Rcgn_Comm_Adr" /></Address>
		<ZipCode><xsl:value-of select="Rcgn_ZipECD" /></ZipCode>
		<Mobile><xsl:value-of select="Rcgn_Move_TelNo" /></Mobile>
		<xsl:if test="RcgnFixTelDmst_DstcNo != '' " >
		    <Phone><xsl:value-of select="RcgnFixTelDmst_DstcNo" />-<xsl:value-of select="Rcgn_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="RcgnFixTelDmst_DstcNo = '' " >
		    <Phone><xsl:value-of select="Rcgn_Fix_TelNo" /></Phone>
		</xsl:if>
		<Email><xsl:value-of select="Rcgn_Email_Adr" /></Email>
	</Insured>
</xsl:template>

<!-- 受益人信息 -->
<xsl:template match="Benf_Detail">
	<Bnf>
		<Type>1</Type>	<!-- 默认为“1-身故受益人” -->
		<Grade><xsl:value-of select="Benf_Bnft_Seq" /></Grade>
		<Name><xsl:value-of select="Benf_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Benf_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Benf_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Benf_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Benf_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Benf_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Benf_Crdt_ExpDt" /></IDTypeEndDate>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Benf_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<!-- 受益比例(整数，百分比) -->
		<Lot><xsl:value-of select="Bnft_Pct*100" /></Lot>
		<RelaToInsured>
			<xsl:call-template name="tran_Relation_benf">
				<xsl:with-param name="relation" select="Benf_And_Rcgn_ReTpCd" />
			</xsl:call-template>
		</RelaToInsured>
		<!-- FIXME  -->
		<Address><xsl:value-of select="Benf_Comm_Adr" /></Address>
	</Bnf>
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

<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- 户口簿 -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- 异常身份证 -->
		<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
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

<!-- 居民来源 -->
<xsl:template match="Rsdnt_TpCd">
	<xsl:choose>
		<xsl:when test=".='1'">1</xsl:when><!--	城镇 -->
		<xsl:when test=".='2'">2</xsl:when><!--	农村 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 健康告知 -->
<xsl:template match="Ntf_Itm_Ind">
	<xsl:choose>
		<xsl:when test=".=1">Y</xsl:when>
		<xsl:otherwise>N</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 人员关系代码转换  长度为7位，不足7位，首位补"0"
	代码中文名称	代码取值	我司代码
		法定代表人	132001	银保通校验不允许录入
		财务主管	132002	银保通校验不允许录入
		业务经办人	132003	银保通校验不允许录入
		一般雇员	132004	银保通校验不允许录入
		高管人员	132005	银保通校验不允许录入
		商业伙伴	133007	银保通校验不允许录入
		担保	133008	银保通校验不允许录入
		其他血亲	133009	04
		配偶	133010	02
		儿子	133011	03
		女儿	133012	03
		孙子	133013	04
		孙女	133014	04
		父亲	133015	01
		母亲	133016	01
		祖父	133017	04
		祖母	133018	04
		哥哥	133019	04
		姐姐	133020	04
		其他姻亲	133021	04
		外祖父	133031	04
		外祖母	133032	04
		外孙	133033	04
		外孙女	133034	04
		弟弟	133035	04
		妹妹	133036	04
		公公	133037	04
		婆婆	133038	04
		儿媳	133039	04
		岳父	133040	04
		岳母	133041	04
		女婿	133042	04
		本人	133043	00
		其他关系	133999	04
			
 -->

<xsl:template name="tran_Relation">
	<xsl:param name="relation" />
	<xsl:choose>
		<xsl:when test="$relation='0133043'">00</xsl:when>	<!-- 本人 -->
		<xsl:when test="$relation='0133015'">03</xsl:when>	<!-- 父母 -->
		<xsl:when test="$relation='0133016'">03</xsl:when>	<!-- 父母 -->
		<xsl:when test="$relation='0133010'">02</xsl:when>	<!-- 配偶 -->
		<xsl:when test="$relation='0133011'">01</xsl:when>	<!-- 儿女 -->
		<xsl:when test="$relation='0133012'">01</xsl:when>	<!-- 儿女 -->
		<xsl:otherwise>04</xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<xsl:template name="tran_Relation_benf">
	<xsl:param name="relation" />
	<xsl:choose>
		<xsl:when test="$relation='0133043'">00</xsl:when>	<!-- 本人 -->
		<xsl:when test="$relation='0133015'">01</xsl:when>	<!-- 父母 -->
		<xsl:when test="$relation='0133016'">01</xsl:when>	<!-- 父母 -->
		<xsl:when test="$relation='0133010'">02</xsl:when>	<!-- 配偶 -->
		<xsl:when test="$relation='0133011'">03</xsl:when>	<!-- 儿女 -->
		<xsl:when test="$relation='0133012'">03</xsl:when>	<!-- 儿女 -->
		<xsl:otherwise>04</xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>		
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）A -->	
		<xsl:when test="$riskcode='L12091'">L12091</xsl:when> 	<!-- 安邦汇赢1号年金保险A款 -->	
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 组合产品代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- <xsl:when test="$contPlanCode='50002'">50015</xsl:when>-->	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 银行缴费频次：-1：不定期交；0：趸交；1：月交；3：季交；6：半年交；12年交；98 交至某确定年龄，99 终生交费 -->
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

<!-- 红利领取方式 -->
<xsl:template match="XtraDvdn_Pcsg_MtdCd">
	<xsl:choose>
		<xsl:when test=".=0">2</xsl:when>	<!-- 直接给付 -->
		<xsl:when test=".=1">3</xsl:when>	<!-- 抵交保费 -->
		<xsl:when test=".=2">1</xsl:when>	<!-- 累计生息 -->
		<xsl:when test=".=3">5</xsl:when>	<!-- 增额交清  -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 满期金领取方式 -->
<xsl:template match="ExpPrmmRcvModCgyCd">
</xsl:template>

<!-- 银行保单销售渠道: 10010003=企业网银，10010001=个人网银，10010002=私人银行网上银行 10030006：手机银行-->
	<xsl:template match="TXN_ITT_CHNL_CGY_CODE">
		<xsl:choose>
			<xsl:when test=".='10010003'">1</xsl:when><!-- 企业网银:网银 -->
			<xsl:when test=".='10010001'">1</xsl:when><!-- 个人网银:网银 -->
			<xsl:when test=".='10010002'">1</xsl:when><!-- 私人银行网上银行:网银 -->
			<xsl:when test=".='10030006'">17</xsl:when><!-- 手机银行 -->
			<xsl:when test=".='10110109'">8</xsl:when><!-- 自助终端 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
