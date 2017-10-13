<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head"/>
			<TXLifeResponse>
				<TransRefGUID/>
				<TransType>1003</TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	<xsl:template name="OLifE" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<OLifE>
			<Holding id="cont">
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo"/>
					</PolNumber>
						<!-- 保单状态 -->
					<PolicyStatus>
						<xsl:if test="ContState= 1">
							<xsl:text>有效</xsl:text>
						</xsl:if>
					</PolicyStatus>
					<!--领取金额/可退金额-->
					<FinActivityGrossAmt>
						<xsl:value-of select="GetMoney"/>
					</FinActivityGrossAmt>
					<!--给付方式-->
					<BenefitMode>
						<xsl:value-of select="GetType"/>
					</BenefitMode>
					<!--累计红利-->
					<BonusAmnt>
						<xsl:value-of select="BonusMoney"/>
					</BonusAmnt>
				</Policy>
			</Holding>
		</OLifE>
	
	</xsl:template>
</xsl:stylesheet>
