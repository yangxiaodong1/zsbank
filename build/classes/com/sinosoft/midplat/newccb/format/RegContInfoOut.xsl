<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">
	<!-- 投保人名称 -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- 保险标的物名称 -->
	<Ins_Ulyg_Nm></Ins_Ulyg_Nm>
	<!-- 营销客户经理名称 -->
	<Cmpn_CstMgr_Nm><xsl:value-of select="TellerName" /></Cmpn_CstMgr_Nm> 
	<!-- 营销客户经理编号 -->
	<Cmpn_CstMgr_ID></Cmpn_CstMgr_ID>
	<!-- 第一受益人名称 -->
	<Fst_Benf_Nm></Fst_Benf_Nm>
	<!-- 投保保额 -->
	<Ins_Cvr></Ins_Cvr>
	<!-- 经办人名称 -->
	<RspbPsn_Nm></RspbPsn_Nm>
	<!-- 经办人证件类型代码 -->
	<RspbPsn_Crdt_TpCd></RspbPsn_Crdt_TpCd>
	<!-- 经办人证件号码 -->
	<RspbPsn_Crdt_No></RspbPsn_Crdt_No>
	<!-- 保单生效日期 -->
	<InsPolcy_EfDt><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate" /></InsPolcy_EfDt>
	<!-- 保单失效日期 -->
	<InsPolcy_ExpDt><xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- 代理保险客户条线类型代码 -->
	<AgIns_Cst_Line_TpCd></AgIns_Cst_Line_TpCd>
	<!-- 推荐人姓名 -->
	<Rcmm_Psn_Nm></Rcmm_Psn_Nm>
	<!-- 推荐人编号 -->
	<Rcmm_Psn_ID></Rcmm_Psn_ID>
	<!-- 代理保险合约状态代码 -->
	<AcIsAR_StCd>
		<xsl:if test="NonRTContState='-1' or NonRTContState='06'">
			<xsl:call-template name="tran_State">
				<xsl:with-param name="contState">
					<xsl:value-of select="ContState" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="NonRTContState!='-1' and NonRTContState!='06'">
			<xsl:call-template name="tran_nonRTContState">
				<xsl:with-param name="nonRTContState">
					<xsl:value-of select="NonRTContState" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!-- 
		<xsl:call-template name="tran_State">
			<xsl:with-param name="contState">
				<xsl:value-of select="ContState" />
			</xsl:with-param>
			<xsl:with-param name="nonRTContState">
				<xsl:value-of select="NonRTContState" />
			</xsl:with-param>
		</xsl:call-template>
		-->
	</AcIsAR_StCd>
	<!-- 被保人名称 -->
	<Rcgn_Nm><xsl:value-of select="Insured/Name" /></Rcgn_Nm>
	<!-- 投保份数 -->
	<Ins_Cps></Ins_Cps>

	
</xsl:template>


<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- 户口簿 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 保单合约状态 FIXME 这部分需要与核心沟通确认码表映射关系 -->
<xsl:template name="tran_State">
	<xsl:param name="contState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$contState='00'">076012</xsl:when>		<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$contState='A'">076016</xsl:when>		<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$contState='B'">076036</xsl:when>		<!-- 非实时保单已缴费待获取保单 -->
		<xsl:when test="$contState='C'">076023</xsl:when>		<!-- 当日撤单=当日撤单作废 -->
		<xsl:when test="$contState='WT'">076024</xsl:when>		<!-- 犹豫期内退保终止=犹豫期退保作废 -->
		<xsl:when test="$contState='02'">076025</xsl:when>		<!-- 退保终止=非犹豫期退保作废 -->
		<xsl:when test="$contState='01'">076030</xsl:when>		<!-- 满期终止=满期已给付 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="tran_nonRTContState">
	<xsl:param name="nonRTContState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$nonRTContState='08'">076011</xsl:when>	<!-- 签单未回执=保单已有效，客户未签收 -->
		<xsl:when test="$nonRTContState='06'">076012</xsl:when>	<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$nonRTContState='00'">076014</xsl:when>	<!-- 未处理=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='01'">076014</xsl:when>	<!-- 录入中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='02'">076014</xsl:when>	<!-- 核保中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='03'">076014</xsl:when>	<!-- 通知书待回复=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='07'">076015</xsl:when>	<!-- 契撤=银行契撤作废 -->
		<xsl:when test="$nonRTContState='05'">076016</xsl:when>	<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$nonRTContState='04'">076019</xsl:when>	<!-- 核保通过=非实时保单保险公司核保通过待缴费 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>

