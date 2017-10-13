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

	<!-- 续期缴费笔数 -->
	<Rnew_PyF_Dnum><xsl:value-of select="RenewInfos/Count"/></Rnew_PyF_Dnum>
	<!-- 续期缴费信息循环 -->
	<InsPyF_List>
		<xsl:for-each select="RenewInfos/RenewInfo">
			<InsPyF_Detail>
				<Ins_PyF_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayDate)"/></Ins_PyF_Dt>
				<!-- 单位：元 -->
				<Ins_PyF_Amt><xsl:value-of select="PayMoney"/></Ins_PyF_Amt>
			</InsPyF_Detail>		
		</xsl:for-each>
	</InsPyF_List>
	<!-- 分红次数 -->
	<Dvdn_Cnt><xsl:value-of select="BonusInfos/Count"/></Dvdn_Cnt>
	<!-- 分红信息循环 -->
	<XtraDvdn_List>
		<xsl:for-each select="BonusInfos/BonusInfo">
			<XtraDvdn_Detail>
			<!-- 红利实际发放日期 -->
			<XtraDvdn_Act_Dstr_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(GetDate)"/></XtraDvdn_Act_Dstr_Dt>
			<!-- 红利处理方式代码 -->
			<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="GetMode" /></XtraDvdn_Pcsg_MtdCd>
			<!-- 本期红利金额, 单位：元 -->
			<CrnPrd_XtDvdAmt><xsl:value-of select="BonusMoney"/></CrnPrd_XtDvdAmt>
			<!-- 终了红利金额 -->
			<ATEndOBns_Amt></ATEndOBns_Amt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
		</XtraDvdn_Detail>
		</xsl:for-each>
	</XtraDvdn_List>
	<!-- 保全业务笔数 -->
	<PsvBsn_Dnum><xsl:value-of select="EdorInfos/Count"/></PsvBsn_Dnum>
	<!-- 保全信息循环 -->
	<Prsrvt_List>
		<xsl:for-each select="EdorInfos/EdorInfo">
			<Prsrvt_Detail>
				<!-- 保全日期 -->
				<Prsrvt_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(EdorValiDate)"/></Prsrvt_Dt>
				<!-- 保全变动事项描述 -->
				<Prsrvt_Chg_Itm_Dsc><xsl:value-of select="EdorDes"/></Prsrvt_Chg_Itm_Dsc>
			</Prsrvt_Detail>
		</xsl:for-each>
	</Prsrvt_List>
	
	<!-- 保单生效复效次数 -->
	<InsPolcyEff_Rinst_Cnt><xsl:value-of select="AvaiInfos/Count"/></InsPolcyEff_Rinst_Cnt>
	<!-- 失效/复效信息循环 -->
	<InsPolcyDt_Lis>
		<xsl:for-each select="AvaiInfos/AvaiInfo">
			<!-- 保单失效日期 -->
			<InsPolcy_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ValiDate)"/></InsPolcy_ExpDt>
			<!-- 保单复效日期 -->
			<InsPolcy_Rinst_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(InValiDate)"/></InsPolcy_Rinst_Dt>
			<!-- 代理保险合约状态代码 -->
			<AcIsAR_StCd><xsl:apply-templates select="state" /></AcIsAR_StCd>
		</xsl:for-each>
	</InsPolcyDt_Lis>
	
	<!-- 保单保额变动次数 -->
	<InsPolcy_Cvr_Chg_Cnt><xsl:value-of select="AmntChgInfos/Count"/></InsPolcy_Cvr_Chg_Cnt>
	<!-- 增保/减保/退保信息 -->
	<InsPolcyAply_List>
		<xsl:for-each select="AmntChgInfos/BonusInfo">
			<InsPolcyAply_Detail>
				<!-- 保单申请业务类别代码 -->
				<InsPolcyAplyBsnCgyCd><xsl:apply-templates select="code" /></InsPolcyAplyBsnCgyCd>
				<!-- 业务申请日期 -->
				<Bapl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ValiDate)"/></Bapl_Dt>
			</InsPolcyAply_Detail>
		</xsl:for-each>
	</InsPolcyAply_List>
	
	<!-- 理赔记录数 -->
	<SetlOfClms_Rcrd_Num><xsl:value-of select="ClaimInfos/Count"/></SetlOfClms_Rcrd_Num>
	<!-- 理赔信息循环开始 -->
	<SetlOfClms_List>
		<xsl:for-each select="ClaimInfos/ClaimInfo">
			<SetlOfClms_Detail>
				<!-- 理赔记录日期 -->
				<SetlOfClms_Rcrd_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ClaimDate)"/></SetlOfClms_Rcrd_Dt>
				<!-- 理赔金额 -->
				<SetlOfClms_Amt><xsl:value-of select="ClaimMoney"/></SetlOfClms_Amt>
			</SetlOfClms_Detail>
		</xsl:for-each>
	</SetlOfClms_List>
	
	<!-- 净值日期 -->
	<NetVal_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(CashInfo/CashDate)"/></NetVal_Dt>
	<!-- 代理保险现金净值 -->
	<AgIns_Cash_NetVal><xsl:value-of select="(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(CashInfo/CashValue*100))"/></AgIns_Cash_NetVal>
</xsl:template>

<!-- 红利领取方式 -->
<xsl:template name="tran_GetMode" match="GetMode">
	<xsl:choose>
		<xsl:when test=".=1">2</xsl:when><!-- 累积生息 -->
		<xsl:when test=".=2">0</xsl:when><!-- 领取现金 -->
		<xsl:when test=".=3">1</xsl:when><!-- 抵缴保费 -->
		<xsl:when test=".=5">3</xsl:when><!-- 增额交清 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 代理保险合约状态代码 -->
<xsl:template name="tran_state" match="state">
	<xsl:choose>
		<xsl:when test=".=0">76034</xsl:when><!-- 失效 -->
		<xsl:when test=".=1">76035</xsl:when><!-- 复效 -->
	</xsl:choose>
</xsl:template>

<!-- 保单申请业务类别代码 -->
<xsl:template name="tran_code" match="code">
	<xsl:choose>
		<xsl:when test=".=0">2</xsl:when><!-- 减保 -->
		<xsl:when test=".=1">3</xsl:when><!-- 增保 -->
		<xsl:when test=".=2">4</xsl:when><!-- 退保 -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>

