<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<package>
			<xsl:copy-of select="Head" />

			<ans>
				<!-- 保险公司交易日期 -->
				<transexedate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></transexedate>
				<!-- 保险公司交易时间 -->
				<transexetime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></transexetime>
				<!-- 交易流水号 -->
				<transrefguid></transrefguid>
				<!-- 银行账户 -->
				<accountnumber><xsl:value-of select="Body/PubContInfo/BankAccNo" /></accountnumber>
				<!-- 提款金额,核心金额的单位是分，银行的金额单位是元 -->
				<amount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/PubContInfo/FinActivityGrossAmt)" /></amount>
				<!-- 批单号 -->
				<bachidno><xsl:value-of select="Body/PubEdorConfirm/FormNumber" /></bachidno>
				
			</ans>
		</package>
	</xsl:template>

</xsl:stylesheet>
