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

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<!-- 代理套餐编号 -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- 套餐名称 -->
	<Pkg_Nm></Pkg_Nm>
	<xsl:if test="ContPlan/ContPlanCode = ''">
	   <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- 险种名称 -->
	   <Cvr_Nm><xsl:value-of select="$MainRisk/RiskName" /></Cvr_Nm>
    </xsl:if>
    <xsl:if test="ContPlan/ContPlanCode != ''">
       <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="ContPlan/ContPlanCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- 险种名称 -->
	   <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>    
    </xsl:if>
	<!-- 保费金额 -->
	<InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)" /></InsPrem_Amt>
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
	</AcIsAR_StCd>
	<!-- 保单号码 -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- 保险产品类型代码 -->
	<Ins_PD_TpCd>0</Ins_PD_TpCd>
</xsl:template>


<!-- 险种转换 -->
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
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
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