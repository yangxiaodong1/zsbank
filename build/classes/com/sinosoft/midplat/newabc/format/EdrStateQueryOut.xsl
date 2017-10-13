<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">
		<xsl:output indent='yes' />
		
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<xsl:template match="Body">
		<App>
			<Ret>
				<!-- 险种代码 -->
				<RiskCode></RiskCode>
				<!-- 保单号 -->
				<PolicyNo><xsl:value-of select="ContNo" /></PolicyNo>
				<!-- 保单状态 -->
				<PolicyStatus><xsl:apply-templates select="ContState" /></PolicyStatus>
				<!-- 保全申请状态 -->
				<BQStatus><xsl:apply-templates select="EdorInfos/EdorInfo/EdorState" /></BQStatus>
				<!-- 申请日期 -->
				<ApplyDate><xsl:value-of select="EdorInfos/EdorInfo/EdorAppDate" /></ApplyDate>
				<!-- 生效日期,若保全申请状态为S-成功时必输 -->
				<ValidDate><xsl:value-of select="EdorInfos/EdorInfo/EdorValidDate" /></ValidDate>
				<!-- 业务类别 -->
				<BusinType><xsl:apply-templates select="EdorInfos/EdorInfo/EdorType" /></BusinType>
			</Ret>
		</App>
	</xsl:template>
	
	<!-- 保单状态 -->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- 有效 -->
			<xsl:when test=".='02'">01</xsl:when><!-- 退保 -->
			<xsl:when test=".='C'">02</xsl:when><!-- 当日撤单 -->
			<xsl:when test=".='WT'">03</xsl:when><!-- 犹撤 -->
			<xsl:when test=".='01'">04</xsl:when><!-- 满期给付 -->
			<xsl:when test=".='04'">07</xsl:when><!-- 理赔终止 -->
		</xsl:choose>	
	</xsl:template>

	<!-- 保全状态 -->
	<!-- 银行定义：S-成功：确认生效,F失败：逾期终止、复核终止、核保终止,D-处理中：其他的均为处理中 -->
	<!-- 寿险核心的保全状态字典如下：0 - 确认生效,1 - 录入完成,2 - 申请确认,3 - 等待录入,4 - 逾期终止,
	5 - 复核修改,6 - 确认未生效,7 - 保全撤销,8 - 核保终止,9 - 复核终止,a - 复核通过,b - 保全回退,	-->
	<xsl:template match="EdorState">
		<xsl:choose>
			<xsl:when test=".='0'">S</xsl:when><!-- 成功，已保全确认的保全 -->
			<xsl:when test=".='4'">F</xsl:when><!-- 失败 -->
			<xsl:when test=".='8'">F</xsl:when><!-- 失败 -->
			<xsl:when test=".='9'">F</xsl:when><!-- 失败 -->
			<xsl:otherwise>D</xsl:otherwise><!-- 处理中 -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EdorType">
		<xsl:choose>
			<xsl:when test=".='WT'">01</xsl:when>	<!-- 犹豫期退保 -->
			<xsl:when test=".='MQ'">02</xsl:when>	<!-- 满期给付 -->
			<xsl:when test=".='CT'">03</xsl:when>	<!-- 退保 -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

