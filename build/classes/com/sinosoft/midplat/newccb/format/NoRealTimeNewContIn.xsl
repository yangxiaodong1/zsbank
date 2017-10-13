<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- 投保单号 -->
	<ProposalPrtNo><xsl:value-of select="Ins_Bl_Prt_No" /></ProposalPrtNo>
	<!-- 投保日期 -->
	<PolApplyDate><xsl:value-of select="InsPolcy_RgDt" /></PolApplyDate>
	 <!--出单网点名称-->
	<AgentComName><xsl:value-of select="BO_Nm" /></AgentComName>
	<!--银行销售人员工号-->
	<SellerNo><xsl:value-of select="BO_Sale_Stff_ID"/></SellerNo>
	<!--出单网点资格证-->
	<AgentComCertiCode><xsl:value-of select="BOInsPrAgnBsnLcns_ECD"/></AgentComCertiCode>
	<!--银行销售人员名称-->
	<TellerName><xsl:value-of select="BO_Sale_Stff_Nm"/></TellerName>
	<!--银行销售人员资格证-->
	<TellerCertiCode><xsl:value-of select="Sale_Stff_AICSQCtf_ID"/></TellerCertiCode>
	<!-- FIXME 银行还传3号文相关信息，核心是否保存？ -->
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName>	<!-- 取投保人姓名 -->
	<AccNo />
	<SubBankCode><xsl:value-of select="Lv1_Br_No" /></SubBankCode>
	
	
	<!-- 组合产品编码  -->
	<xsl:variable name="tContPlanCode">
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="Bu_List/Bu_Detail[position()=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- 产品组合 -->
	<ContPlan>
		<!-- 产品组合编码 -->
		<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
	</ContPlan>
	
	<!-- 投保人信息 -->
	<xsl:call-template name="Appnt" />
	
	<xsl:for-each select="Bu_List/Bu_Detail">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="Cvr_ID" />
				</xsl:call-template>
			</RiskCode>
			<MainRiskCode />
			<Amnt />
			<Prem />
			<Mult />
		    <PayMode />
			<PayIntv />
			<PayEndYearFlag />
			<PayEndYear />
			<InsuYearFlag />
			<InsuYear />
		</Risk>
	</xsl:for-each>
		
</xsl:template>

<!-- 投保人信息 -->
<xsl:template name="Appnt">
	<Appnt>
		<Name><xsl:value-of select="Plchd_Nm" /></Name>
		<Sex />
		<Birthday />
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo>
		<LiveZone />
		<Address />
		<Mobile><xsl:value-of select="Plchd_Move_TelNo" /></Mobile>
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		    <Phone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <Phone><xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
	</Appnt>
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


<!-- 险种代码 -->
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
		<!-- 暂不上线盛2产品 -->
		<!-- <xsl:when test="$riskcode='L12079'">L12079</xsl:when>  -->	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">L12074</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<!--<xsl:when test="$riskcode='50012'">50012</xsl:when>-->    <!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<!-- <xsl:when test="$riskcode='L12085'">L12085</xsl:when> -->	<!-- 安邦东风2号两全保险（万能型） -->
		<!-- <xsl:when test="$riskcode='L12086'">L12086</xsl:when> -->	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 组合产品代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50002">50015</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<!--<xsl:when test="$contPlanCode=50012">50012</xsl:when>-->	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
