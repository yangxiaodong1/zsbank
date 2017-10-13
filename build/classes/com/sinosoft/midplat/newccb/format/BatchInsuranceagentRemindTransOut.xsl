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
   <Ins_List>
        <!-- 续期缴费提醒 -->
		<xsl:for-each select="Detail/RenewReminds/RenewRemind">
		<Ins_Detail>
			<!-- 保险公司编号 -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- 险种编号 -->
            <xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>	
			<!-- 保单号码 -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- 代理保险提醒类型代码 1：退保金额到账提醒  2：续期缴费提醒  3：红利派发提醒  4：保单到期失效提醒-->
			<AgIns_Rmndr_TpCd>2</AgIns_Rmndr_TpCd>
			<!-- 投保人名称 -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- 投保人证件类型代码 -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- 投保人证件号码 -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #交易日期 -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- 保费金额 -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- 退保金额 -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- 续期缴费金额 -->
			<Rnew_PyF_Amt><xsl:value-of select="PayMoney" /></Rnew_PyF_Amt>
			<!-- 续期应缴日期 -->
			<Rnew_Pbl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayToDate)" /></Rnew_Pbl_Dt>
			<!-- 保单到期日期 -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- 本期红利金额 -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- 红利处理方式代码 -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- 投保人账号 -->
			<Plchd_AccNo></Plchd_AccNo>
			<!-- 保险产品类型代码 0：险种 1：套餐 2：附加险-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- 红利派发提醒 -->
		<xsl:for-each select="Detail/BonusReminds/BonusRemind">
		<Ins_Detail>
			<!-- 保险公司编号 -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- 险种编号 -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- 保单号码 -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- 代理保险提醒类型代码 1：退保金额到账提醒  2：续期缴费提醒  3：红利派发提醒  4：保单到期失效提醒-->
			<AgIns_Rmndr_TpCd>3</AgIns_Rmndr_TpCd>
			<!-- 投保人名称 -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- 投保人证件类型代码 -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- 投保人证件号码 -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #交易日期 -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- 保费金额 -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- 退保金额 -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- 续期缴费金额 -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- 续期应缴日期 -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- 保单到期日期 -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- 本期红利金额 -->
			<CrnPrd_XtDvdAmt><xsl:value-of select="CurrentBonus" /></CrnPrd_XtDvdAmt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt><xsl:value-of select="SumBonus" /></Acm_XtDvdAmt>
			<!-- 红利处理方式代码 -->
			<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="BonusGetMode" /></XtraDvdn_Pcsg_MtdCd>
			<!-- 投保人账号 -->
			<Plchd_AccNo><xsl:value-of select="AccNo" /></Plchd_AccNo>
			<!-- 保险产品类型代码 0：险种 1：套餐 2：附加险-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- 退保金额到账提醒 -->
		<xsl:for-each select="Detail/CTReminds/CTRemind">
		<Ins_Detail>
			<!-- 保险公司编号 -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- 险种编号 -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- 保单号码 -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- 代理保险提醒类型代码 1：退保金额到账提醒  2：续期缴费提醒  3：红利派发提醒  4：保单到期失效提醒-->
			<AgIns_Rmndr_TpCd>1</AgIns_Rmndr_TpCd>
			<!-- 投保人名称 -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- 投保人证件类型代码 -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- 投保人证件号码 -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #交易日期 -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- 保费金额 -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- 退保金额 -->
			<CnclIns_Amt><xsl:value-of select="CTGetMoney" /></CnclIns_Amt>
			<!-- 续期缴费金额 -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- 续期应缴日期 -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- 保单到期日期 -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- 本期红利金额 -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- 红利处理方式代码 -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- 投保人账号 -->
			<Plchd_AccNo><xsl:value-of select="AccNo" /></Plchd_AccNo>
			<!-- 保险产品类型代码 0：险种 1：套餐 2：附加险-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- 保单到期失效提醒 -->
		<xsl:for-each select="Detail/InvalidateReminds/InvalidateRemind">
		<Ins_Detail>
			<!-- 保险公司编号 -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- 险种编号 -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- 保单号码 -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- 代理保险提醒类型代码 1：退保金额到账提醒  2：续期缴费提醒  3：红利派发提醒  4：保单到期失效提醒-->
			<AgIns_Rmndr_TpCd>4</AgIns_Rmndr_TpCd>
			<!-- 投保人名称 -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- 投保人证件类型代码 -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- 投保人证件号码 -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #交易日期 -->
			<TXN_DT><xsl:value-of select="SignDate" /></TXN_DT>
			<!-- 保费金额 -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- 退保金额 -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- 续期缴费金额 -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- 续期应缴日期 -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- 保单到期日期 -->
			<InsPolcy_ExDat><xsl:value-of select="EndDate" /></InsPolcy_ExDat>
			<!-- 本期红利金额 -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- 红利处理方式代码 -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- 投保人账号 -->
			<Plchd_AccNo></Plchd_AccNo>
			<!-- 保险产品类型代码 0：险种 1：套餐 2：附加险-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
	</Ins_List>		
</xsl:template>
		
<!-- 险种代码 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
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

<!-- 红利领取方式 -->
<xsl:template match="BonusGetMode">
    <xsl:choose>
        <xsl:when test=".=2">0</xsl:when>   <!-- 直接给付 -->
        <xsl:when test=".=3">1</xsl:when>   <!-- 抵交保费 -->
        <xsl:when test=".=1">2</xsl:when>   <!-- 累计生息 -->
        <xsl:when test=".=5">3</xsl:when>   <!-- 增额交清  -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>
	
</xsl:stylesheet>

