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
					<FreeAvailableAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></FreeAvailableAmt>
					<!--  应退保费/满期给付保费（数字类型，不能为空）  -->
					<AccountNumber><xsl:value-of select="PubContInfo/BankAccNo" /></AccountNumber>
					<!--  银行付款帐户  -->
					<AcctHolderName><xsl:value-of select="PubContInfo/BankAccName" /></AcctHolderName>
					<!--  户名  -->
				</Policy>
				<Life>
					<!--  累计红利金额（数字类型，不能为空）  -->
					<xsl:variable name="BonusAmnt" select="PubEdorQuery/BonusAmnt" />
					<xsl:choose>
						<xsl:when test="$BonusAmnt=''">
							<DivPaidInCash>0.00</DivPaidInCash>
						</xsl:when>
						<xsl:otherwise>
							<DivPaidInCash><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubEdorQuery/BonusAmnt)"/></DivPaidInCash>
						</xsl:otherwise>
					</xsl:choose>
					<Coverage id="Cov_1">
						<BenefitMode>0</BenefitMode><!-- 这里有问题，核心给的是汉字，而不是代码 -->
						<!--  年金领取方式 0：一次性领取，1：按月领取，3：按季度领取，6：按半年领取，12：按年领取  -->
					</Coverage>	
				</Life>
			</Holding>
		</OLife>
	</xsl:template>
</xsl:stylesheet>
