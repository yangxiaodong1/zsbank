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
					<FreeAvailableAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></FreeAvailableAmt>
					<!--  Ӧ�˱���/���ڸ������ѣ��������ͣ�����Ϊ�գ�  -->
					<AccountNumber><xsl:value-of select="PubContInfo/BankAccNo" /></AccountNumber>
					<!--  ���и����ʻ�  -->
					<AcctHolderName><xsl:value-of select="PubContInfo/BankAccName" /></AcctHolderName>
					<!--  ����  -->
				</Policy>
				<Life>
					<!--  �ۼƺ������������ͣ�����Ϊ�գ�  -->
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
						<BenefitMode>0</BenefitMode><!-- ���������⣬���ĸ����Ǻ��֣������Ǵ��� -->
						<!--  �����ȡ��ʽ 0��һ������ȡ��1��������ȡ��3����������ȡ��6����������ȡ��12��������ȡ  -->
					</Coverage>	
				</Life>
			</Holding>
		</OLife>
	</xsl:template>
</xsl:stylesheet>
