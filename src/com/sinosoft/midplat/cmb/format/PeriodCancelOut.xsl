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
					<!--  ������  -->
					<PaymentAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PaymentAmt>
					<!--  �����ܱ��ѣ��������ͣ�����Ϊ�գ�  -->
					<AccountNumber><xsl:value-of select="PubContInfo/BankAccNo" /></AccountNumber>
					<!--  ���и����ʻ�  -->
					<AcctHolderName></AcctHolderName>
					<!--  ����  -->
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>
</xsl:stylesheet>
