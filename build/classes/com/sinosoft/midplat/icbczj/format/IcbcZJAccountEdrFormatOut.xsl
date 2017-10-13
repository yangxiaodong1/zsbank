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
				<retcode><xsl:apply-templates select="Head/Flag" /></retcode>
				<retmsg><xsl:value-of select="Head/Desc" /></retmsg>
				<cmpdate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></cmpdate>
				<cmptime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></cmptime>
			</pub>  -->
			<ans>
				<!-- 保险公司交易日期 -->
				<transexedate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></transexedate>
				<!-- 保险公司交易时间 -->
				<transexetime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></transexetime>
				<!-- 交易流水号 -->
				<transrefguid></transrefguid>
				<!-- 处理标志 -->
				<transtype></transtype>
				<!-- 交易模式 -->
				<transmode></transmode>
				<!-- 银行账户  -->
				<accountnumber><xsl:value-of select="Body/PubContInfo/BankAccNo" /></accountnumber>
				
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

</xsl:stylesheet>
