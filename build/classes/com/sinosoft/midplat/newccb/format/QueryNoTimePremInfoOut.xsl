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
	<!-- 投保单号 -->
	<Ins_BillNo><xsl:value-of select="ProposalPrtNo" /></Ins_BillNo>
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
	<!-- 投保人名称 -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- 保险缴费金额 -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- add 20150820 新一代2.2版本增加  保险年期类别代码 -->
	<xsl:if test="$MainRisk/MainRiskCode='122009'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
	<xsl:if test="$MainRisk/MainRiskCode='L12087'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
	<xsl:if test="$MainRisk/MainRiskCode!='122009' and $MainRisk/MainRiskCode!='L12087'" >
	  <Ins_Yr_Prd_CgyCd>					
	     <xsl:call-template name="tran_PayEndYearFlag">
			<xsl:with-param name="payEndYear" select="$MainRisk/PayEndYear" />
			<xsl:with-param name="payEndYearFlag" select="$MainRisk/PayEndYearFlag" />
	     </xsl:call-template>
	  </Ins_Yr_Prd_CgyCd>
	</xsl:if>
	<!-- add 20150820 新一代2.2版本增加  保险期限 -->
	<Ins_Ddln>
	    <xsl:if test="$MainRisk/MainRiskCode='122046'" >999</xsl:if>
	    <xsl:if test="$MainRisk/MainRiskCode!='122046'" >
			<xsl:if test="$MainRisk/InsuYearFlag='A'">999</xsl:if>
			<xsl:if test="$MainRisk/InsuYearFlag!='A'"><xsl:value-of select="$MainRisk/InsuYear" /></xsl:if>  
	    </xsl:if>
	</Ins_Ddln>
	<!-- add 20150820 新一代2.2版本增加  保险周期代码 -->
	<Ins_Cyc_Cd><xsl:apply-templates select="$MainRisk/InsuYearFlag" /></Ins_Cyc_Cd>
	<!-- add 20150820 新一代2.2版本增加  保费缴费方式代码 -->
	<InsPrem_PyF_MtdCd><xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/></InsPrem_PyF_MtdCd>
	<!-- add 20150820 新一代2.2版本增加  保费缴费期数 -->
	<InsPrem_PyF_Prd_Num>
		<xsl:if test="$MainRisk/InsuYearFlag!='A'">
		    <xsl:if test="$MainRisk/PayEndYear = '1000'">
				<xsl:if test="$MainRisk/PayIntv = '0'">1</xsl:if>
				<xsl:if test="$MainRisk/PayIntv != '0'"><xsl:value-of select="$MainRisk/PayEndYear" /></xsl:if>      
			</xsl:if>
			<xsl:if test="$MainRisk/PayEndYear != '1000'">
				<xsl:value-of select="$MainRisk/PayEndYear" />    
			</xsl:if>
			<!-- 
			<xsl:choose>
				<xsl:when test="PayEndYear = '1000'">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
			</xsl:choose>
			-->
		</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12078'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12100'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='122010'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12089'" >1</xsl:if>
	</InsPrem_PyF_Prd_Num>
	<!-- add 20150820 新一代2.2版本增加  保费缴费周期代码 -->
	<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
	<!-- 代理保险缴费业务细分代码 -->
	<AgInsPyFBsnSbdvsn_Cd>
	   <xsl:call-template name="tran_AgentPayType">
			<xsl:with-param name="agentPayType" select="AgentPayType" />
		</xsl:call-template>	
	</AgInsPyFBsnSbdvsn_Cd>
	
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
		
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- 长寿稳赢保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 begin -->
		<xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品转换 end -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	
		
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> <!-- 安邦东风5号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 代理保险缴费业务细分代码 01-实时投保缴费 02-非实时投保缴费 03-续期交费 -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- 实时投保缴费 -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- 非实时投保缴费 -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- 续期交费 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- 保单的缴费间隔/频次 -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	趸交 -->
		<xsl:when test=".='12'">03</xsl:when><!-- 年交 -->
		<xsl:when test=".='1'">03</xsl:when><!--	月交 -->
		<xsl:when test=".='3'">03</xsl:when><!--	季交 -->
		<xsl:when test=".='6'">03</xsl:when><!--	半年交 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- 不定期交 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<xsl:template name="tran_PayEndYearFlag">
	<xsl:param name="payEndYear" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear!='1000'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='M'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='D'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='A'">05</xsl:when><!--终身 -->
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear ='1000'">05</xsl:when><!--终身 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	季缴 -->
		<xsl:when test=".='6'">0202</xsl:when><!--	半年缴 -->
		<xsl:when test=".='12'">0203</xsl:when><!--	年缴 -->
		<xsl:when test=".='1'">0204</xsl:when><!--	月缴 -->
		<xsl:when test=".='0'">0100</xsl:when><!--	趸缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 保险年期类型 -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- 按年 -->
		<xsl:when test=".='M'">04</xsl:when><!-- 按月 -->
		<xsl:when test=".='D'">05</xsl:when><!-- 按天 -->
		<xsl:when test=".='A'">03</xsl:when><!-- 按年 -->
		<xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>