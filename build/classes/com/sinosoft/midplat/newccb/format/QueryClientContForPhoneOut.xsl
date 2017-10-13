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

	<!-- 保险公司名称 -->
	<Ins_Co_Nm>安邦人寿保险有限公司</Ins_Co_Nm>
	<!-- 保险公司编号 -->
	<Ins_Co_ID>010058</Ins_Co_ID>
	<!-- 循环记录条数 -->
	<Rvl_Rcrd_Num><xsl:value-of select="count(Detail)" /></Rvl_Rcrd_Num>
	<MyInsu_List>
		<xsl:for-each select="Detail">
			<MyInsu_Detail>
				<!-- 代理保险套餐编号 -->
				<AgIns_Pkg_ID></AgIns_Pkg_ID>
				<!-- 套餐名称 -->
				<Pkg_Nm></Pkg_Nm>
				<!-- 险种编号 -->
				<xsl:if test="ContPlanCode=''">
				   <Cvr_ID>
					  <xsl:call-template name="tran_Riskcode">
						 <xsl:with-param name="riskcode" select="RiskCode" />
					  </xsl:call-template>
				   </Cvr_ID>
				   <!-- 险种名称 -->
				   <Cvr_Nm><xsl:value-of select="RiskName" /></Cvr_Nm>				
				</xsl:if>
				<xsl:if test="ContPlanCode!=''">
				   <Cvr_ID>
					  <xsl:call-template name="tran_ContPlanCode">
						<xsl:with-param name="contPlanCode" select="ContPlanCode" />
					</xsl:call-template>
				   </Cvr_ID>
				   <!-- 险种名称 -->
				   <Cvr_Nm><xsl:value-of select="ContPlanName" /></Cvr_Nm>
				</xsl:if>
				<!-- 保单号码 -->
				<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
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
				
				<!-- 保单登记日期 -->
				<InsPolcy_RgDt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" />
				</InsPolcy_RgDt>
				
				<!-- 保费金额 -->
				<InsPrem_Amt>
					<xsl:value-of select="ActPrem" />
					<!-- 
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
					-->
				</InsPrem_Amt>
				<!-- 代理渠道代码 FIXME  -->
				<Agnc_Chnl_Cd>9999</Agnc_Chnl_Cd>
				<!-- 建行代理标志 0-否  1-是 -->
				<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
				<Rsrv_Fld_1></Rsrv_Fld_1>
				<Rsrv_Fld_2></Rsrv_Fld_2>
				<Rsrv_Fld_3></Rsrv_Fld_3>
			</MyInsu_Detail>
		</xsl:for-each>
	</MyInsu_List>
	
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

		
<!-- 险种代码 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）B -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）A -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode='50015'">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

