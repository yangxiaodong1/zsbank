<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<RETURN>
	 <MAIN>
	 	<!--错误码-->
	 	<RESULTCODE>
	 		<xsl:apply-templates select="Head/Flag" />
	 	</RESULTCODE>
	 	<!--错误描述-->
	 	<ERR_INFO>
	 		<xsl:value-of select="Head/Desc" />
	 	</ERR_INFO>
	 	<!-- 如果交易成功，才返回下面的结点 -->
		<xsl:if test="Head/Flag='0'">
	 	<!--投保单号-->
	 	<APPLNO>
	 		<xsl:value-of select="Body/ProposalPrtNo" />
	 	</APPLNO>
	 	<!--保单号( 主险保险合同号)-->
	 	<POLICY>
	 		<xsl:value-of select="Body/ContNo" />
	 	</POLICY>
	 	<!--投保日期（CD01）-->
	 	<ACCEPT>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</ACCEPT>
	 	<!--首期保费（CD23）-->
	 	<PREM>
	 		<xsl:value-of select="Body/Prem" />
	 	</PREM>
	 	<!--首期保费大写-->
	 	<xsl:variable name="SumPremYuan"
	 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" />
	 	<PREMC>
	 		<xsl:value-of
	 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/Prem)" />
	 	</PREMC>
	 	<!--保单生效日期（CD01）-->
	 	<VALIDATE>
	 		<xsl:value-of select="Body/Risk/CValiDate" />
	 	</VALIDATE>
	 	<!--投保人姓名-->
	 	<TBR_NAME>
	 		<xsl:value-of select="Body/Appnt/Name" />
	 	</TBR_NAME>
	 	<!--投保人客户号-->
	 	<TBRPATRON>
	 		<xsl:value-of select="Body/Appnt/CustomerNo" />
	 	</TBRPATRON>
	 	<!--被保人姓名-->
	 	<BBR_NAME>
	 		<xsl:value-of select="Body/Insured/Name" />
	 	</BBR_NAME>
	 	<!--被保人客户号-->
	 	<BBRPATRON>
	 		<xsl:value-of select="Body/Insured/CustomerNo" />
	 	</BBRPATRON>
	 	<!--缴费方式（CD24）-->
	 	<xsl:variable name="PayIntv"
	 		select="Body/Risk[RiskCode=MainRiskCode]/PayIntv" />
	 	<PAYMETHOD>
	 		<xsl:call-template name="tran_PayIntv">
	 			<xsl:with-param name="PayIntv">
	 				<xsl:value-of select="$PayIntv" />
	 			</xsl:with-param>
	 		</xsl:call-template>
	 	</PAYMETHOD>
	 	<!--缴费方式(汉字)-->
	 	<PAY_METHOD>
	 		<xsl:apply-templates select="$PayIntv" />
	 	</PAY_METHOD>
	 	<!--缴费日期（CD01）-->
	 	<PAYDATE>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</PAYDATE>
	 	<!--承保公司名称-->
	 	<ORGAN>
	 		<xsl:value-of select="Body/ComName" />
	 	</ORGAN>
	 	<!--承保公司地址-->
	 	<LOC>
	 		<xsl:value-of select="Body/ComLocation" />
	 	</LOC>
	 	<!--承保公司电话-->
	 	<TEL>
	 		<xsl:value-of select="Body/ComPhone" />
	 	</TEL>
	 	<!--特别约定打印标志（CD25）-->
	 	<ASSUM>0</ASSUM>
	 	<!--投保人客户号生成日期（CD01）-->
	 	<TBR_OAC_DATE></TBR_OAC_DATE>
	 	<!--被保人客户号生成日期（CD01）-->
	 	<BBR_OAC_DATE></BBR_OAC_DATE>
	 	<!--承保公司代码-->
	 	<ORGANCODE>
	 		<xsl:value-of select="Body/ComCode" />
	 	</ORGANCODE>
	 	<!--续期缴费日期（汉字描述）-->
	 	<PAYDATECHN></PAYDATECHN>
	 	<!--缴费起止日期（汉字描述）-->
	 	<PAYSEDATECHN></PAYSEDATECHN>
	 	<!--缴费年期-->
	 	<PAYYEAR></PAYYEAR>
	 	</xsl:if>
	 </MAIN>
	<!-- 如果交易成功，才返回下面的结点 -->
	<xsl:if test="Head/Flag='0'">
	 <!--险种信息-->
	<PTS>
	    <PT_COUNT><xsl:value-of select="count(Body/Risk)"/></PT_COUNT>
	    <xsl:for-each select= "Body/Risk">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy年MM月dd日')"/>
	        <xsl:variable name="RiskCode" select="RiskCode"/>
	        <xsl:variable name="MainRiskCode" select="MainRiskCode"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <xsl:if test="$RiskCode = $MainRiskCode">
		        <MAINSUBFLG>1</MAINSUBFLG>
		    </xsl:if>
	        <xsl:if test="$RiskCode != $MainRiskCode">
		        <MAINSUBFLG>0</MAINSUBFLG>
			</xsl:if>
	        <AMT><xsl:value-of select="Amnt"/></AMT>
	        <PREM><xsl:value-of select="Prem"/></PREM>
	        <NAME><xsl:value-of select="RiskName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>
	        	<xsl:call-template name="tran_PayEndYearFlag">
	        		<xsl:with-param name="payendyearflag">
	        			<xsl:value-of select="PayEndYearFlag" />
	        		</xsl:with-param>
	        		<xsl:with-param name="payendyear">
	        			<xsl:value-of select="PayEndYear" />
	        		</xsl:with-param>
	        	</xsl:call-template>
	        </CHARGE_PERIOD>
	        <CHARGE_YEAR><xsl:value-of select="PayEndYear"/></CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	<PRT></PRT>
    </xsl:if>
</RETURN>
</xsl:template>


<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费间隔  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">趸缴</xsl:when>		
	<xsl:when test=".=1">月缴</xsl:when>
	<xsl:when test=".=3">季缴</xsl:when>
	<xsl:when test=".=6">半年缴</xsl:when>
	<xsl:when test=".=12">年缴</xsl:when>
	<xsl:when test=".=-1">不定期缴</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">男  </xsl:when>		
	<xsl:when test=".=1">女  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">累计生息</xsl:when>
	<xsl:when test=".=2">领取现金</xsl:when>
	<xsl:when test=".=3">抵缴保费</xsl:when>
	<xsl:when test=".=5">增额交清</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 返回缴费方式 -->
<xsl:template name="tran_PayIntv">
    <xsl:param name="PayIntv">0</xsl:param>
	<xsl:choose>
	    <xsl:when test="$PayIntv = 0">W</xsl:when>
		<xsl:when test="$PayIntv = 12">Y</xsl:when>
		<xsl:when test="$PayIntv = 1">M</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$PayIntv"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
 
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:param name="payendyear" />
		<xsl:choose>
			<xsl:when test="$payendyearflag='Y' and $payendyear=1000">1</xsl:when><!-- 趸交 -->
			<xsl:when test="$payendyearflag='Y'">2</xsl:when><!-- 按年 -->
			<xsl:when test="$payendyearflag='A'">4</xsl:when><!-- 终生缴费 -->
			<xsl:when test="$payendyearflag='A'">3</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
