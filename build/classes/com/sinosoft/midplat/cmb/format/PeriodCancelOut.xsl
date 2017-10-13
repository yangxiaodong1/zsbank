<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	<xsl:template name="OLife" match="TranData/Body">
		<OLife>
			<Holding id="Holding_1">
				<Policy>
					<PolNumber><xsl:value-of select="PubContInfo/ContNo" /></PolNumber>
					<!--  保单号  -->
					<PaymentAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PaymentAmt>
					<!--  首期总保费（数字类型，不能为空）  -->
					<AccountNumber><xsl:value-of select="PubContInfo/BankAccNo" /></AccountNumber>
					<!--  银行付款帐户  -->
					<AcctHolderName></AcctHolderName>
					<!--  户名  -->
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>
</xsl:stylesheet>
