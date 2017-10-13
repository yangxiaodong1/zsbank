<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<Head>
		<xsl:copy-of select="TranData/Head/*" />
	</Head>
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
	<Ins_Co_ID>010058</Ins_Co_ID> <!-- 保险公司编号 -->
	<Ins_Co_Nm>安邦人寿保险有限公司</Ins_Co_Nm> <!-- 保险公司名称 -->
	<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num> <!-- 循环记录条数 -->
	<!-- 试算结果 -->
	<xsl:variable name="Risk" select="TradeData/BackInfo/LCInsureds/LCInsured/Risks/Risk[RiskCode=MainRiskCode]" />
	
	<xsl:variable name="Risk2" select="TradeData/BackInfo/LCCont" />
	
	<Life_List>
		<!-- 险种试算信息 begin -->
		<Life_Detail>
			<!-- 险种编号 -->
			<Cvr_ID>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="$Risk/RiskCode" />
				</xsl:call-template>
			</Cvr_ID> 
			<!-- 险种名称 -->
			<Cvr_Nm>
				<xsl:call-template name="tran_Riskcode_to_RiskName">
					<xsl:with-param name="riskcode" select="$Risk/RiskCode" />
				</xsl:call-template>
			</Cvr_Nm> 
			<InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></InsPrem_Amt> <!-- 保费金额 -->
			<Ins_Cvr><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Amnt)" /></Ins_Cvr> <!-- 投保保额 -->
			<xsl:if test = "$Risk2/Mult = 'NaN'">
			   <Ins_Cps>0</Ins_Cps> <!-- 投保份数 -->
			</xsl:if>
			<xsl:if test = "$Risk2/Mult != 'NaN'">
			   <Ins_Cps><xsl:value-of select="$Risk2/Mult" /></Ins_Cps> <!-- 投保份数 -->
			</xsl:if>
		</Life_Detail>
		<!-- 险种试算信息 end -->
	</Life_List> 
	<!-- 试算结果 end -->
	<Tot_InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></Tot_InsPrem_Amt> <!-- 总保费金额 -->
	<Init_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></Init_PyF_Amt> <!-- 首期缴费金额 -->
	<Anulz_InsPrem_Amt></Anulz_InsPrem_Amt> <!-- 年化保费金额 -->
	<EcIst_PyF_Amt_Inf></EcIst_PyF_Amt_Inf> <!-- 每期缴费金额信息 -->
	<InsPrem_PyF_Prd_Num></InsPrem_PyF_Prd_Num> <!-- 保费缴费期数 -->
	<InsPrem_PyF_Cyc_Cd></InsPrem_PyF_Cyc_Cd> <!-- 保费缴费周期代码 -->
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
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<!-- 险种代码并存 -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码转换为险种名称 -->
<xsl:template name="tran_Riskcode_to_RiskName">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">安邦黄金鼎1号两全保险（分红型）A款</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122002'">安邦黄金鼎2号两全保险（分红型）A款</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122003'">安邦聚宝盆1号两全保险（分红型）A款</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122004'">安邦附加黄金鼎2号两全保险（分红型）A款</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122005'">安邦黄金鼎3号两全保险（分红型）A款</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122006'">安邦聚宝盆2号两全保险（分红型）A款</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122008'">安邦白玉樽1号终身寿险（万能型）</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122009'">安邦黄金鼎5号两全保险（分红型）A款</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='L12079'">安邦盛世2号终身寿险（万能型）</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">安邦盛世3号终身寿险（万能型）</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		
		<xsl:when test="$riskcode='L12074'">安邦盛世9号两全保险（万能型）</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">安邦长寿智赢1号年金保险</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		
		<!-- 险种代码并存 -->
		<xsl:when test="$riskcode='L12089'">安邦盛世1终身寿险（万能型）B款</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='122010'">安邦盛世3号终身寿险（万能型）</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">安邦盛世9号两全保险（万能型）</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12087'">安邦东风5号两全保险（万能型）</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">安邦东风2号两全保险（万能型）</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">安邦东风3号两全保险（万能型）</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:when test="$riskcode='50015'">安邦长寿稳赢保险计划</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>





