<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<package>
			<xsl:copy-of select="Head" />
			<!-- 
			<pub>
				<workdate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></workdate>
				<retcode><xsl:apply-templates select="Head/Flag" /></retcode>
				<retmsg><xsl:value-of select="Head/Desc" /></retmsg>
			</pub>  -->
			<ans>
				<!-- 保险公司交易日期 -->
				<transexedate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></transexedate>
				<!-- 保险公司交易时间 -->
				<transexetime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" /></transexetime>
				<!-- 交易流水号 -->
				<transrefguid></transrefguid>
				<!-- 返回码 -->
				<resultcode><xsl:apply-templates select="Head/Flag" /></resultcode>
				<!-- 返回错误信息 -->
				<resultinfodesc><xsl:value-of select="Head/Desc" /></resultinfodesc>
				<!-- 当事人证件类型 -->
				<govtidtc><xsl:apply-templates select="Body/Appnt/IDType" /></govtidtc>
				<!-- 当事人证件号码 -->
				<govtid><xsl:value-of select="Body/Appnt/IDNo" /></govtid>
				<!-- 当事人名称 -->
				<fullname><xsl:value-of select="Body/Appnt/Name" /></fullname>
				<!-- 银行账户 20字节 -->
				<accountnumber><xsl:value-of select="Body/AccNo" /></accountnumber>
				<!-- 当事人电话号码 -->
				<dialnumber><xsl:value-of select="Body/Appnt/Mobile" /></dialnumber>
				<!-- 保单状态 -->
				<status><xsl:apply-templates select="Body/ContState" /></status>
				<!-- 投保金额 -->
				<amount><xsl:apply-templates select="Body/Amnt" /></amount>
				<!-- 现金价值 “amount，现金价值”，经过电话沟通，应该是返回原始保费（原始保障金）-->
				<cashvalue><xsl:apply-templates select="Body/ActSumPrem" /></cashvalue>
			</ans>
		</package>
	</xsl:template>

	<!-- 成功失败标志-->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">00000</xsl:when><!-- 成功 -->
			<xsl:when test=".='1'">B0002</xsl:when><!-- 系统错 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型-->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='5'">6</xsl:when><!-- 户口簿  -->
			<xsl:when test=".='8'">7</xsl:when><!-- 其他  -->
			<xsl:when test=".='9'">0</xsl:when><!-- 异常身份证  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保单状态 核心转給銀行（这个需要修改，银行还未提供）-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- 保单有效  -->
			<xsl:when test=".='01'">04</xsl:when><!-- 满期终止 -->
			<xsl:when test=".='02'">01</xsl:when><!-- 退保终止-->
			<xsl:when test=".='04'">07</xsl:when><!-- 理赔终止-->
			<xsl:when test=".='WT'">03</xsl:when><!-- 犹豫期内退保终止-->
			<xsl:when test=".='B'">08</xsl:when><!-- 待签单-->
			<xsl:when test=".='C'">02</xsl:when><!-- 当日撤单-->
			<xsl:otherwise>05</xsl:otherwise><!-- 对于银行是状态不明确 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
