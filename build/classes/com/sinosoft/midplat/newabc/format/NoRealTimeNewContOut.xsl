<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:output indent='yes' />

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<App>
			<Ret>
				<!-- 投保人 -->
				<Appl>
					<!-- 姓名 -->
					<Name>
						<xsl:value-of select="Appnt/Name" />
					</Name>
					<!-- 证件类型 -->
					<IDKind>
						<xsl:apply-templates select="Appnt/IDType" />
					</IDKind>
					<!-- 证件号码 -->
					<IDCode>
						<xsl:value-of select="Appnt/IDNo" />
					</IDCode>
				</Appl>
				<!-- 投保单(印刷)号 -->
				<PolicyApplyNo>
					<xsl:value-of select="ProposalPrtNo" />
				</PolicyApplyNo>
				<!-- 保险公司端险种号 -->
				<RiskCode>
					<xsl:if test="ContPlan/ContPlanCode!=''">
						<xsl:apply-templates select="ContPlan/ContPlanCode" />
					</xsl:if>
					<xsl:if test="ContPlan/ContPlanCode=''">
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/RiskCode" />
					</xsl:if>
				</RiskCode>
				<!-- 银行端险种编号 转换时取银行值 -->
				<ProdCode></ProdCode>
				<!-- 保费 -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Risk/Prem)" />
				</Prem>
			</Ret>
		</App>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='0'">110001</xsl:when><!--居民身份证                -->
			<xsl:when test=".='5'">110005</xsl:when><!--户口簿                    -->
			<xsl:when test=".='1'">110023</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test=".='2'">110027</xsl:when><!--军官证                    -->
			<xsl:otherwise>119999</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template match="RiskCode | ContPlanCode">
		<xsl:choose>
			<xsl:when test=".='50001'">122046</xsl:when><!-- 长寿稳赢1号套餐 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 长寿稳赢保险计划套餐 -->
			
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- 安邦白玉樽1号终身寿险(万能型)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- 安邦黄金鼎2号两全保险(分红型)A款  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- 安邦黄金鼎3号两全保险(分红型)A款  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- 长寿稳赢保险计划套餐 -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>