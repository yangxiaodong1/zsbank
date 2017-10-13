<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID />
				<TransType>1024</TransType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>
				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body" />
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<Holding id="cont">
				<Policy>
					<PolNumber>
						<xsl:value-of select="PubContInfo/ContNo" />
					</PolNumber>
					<PolicyStatus>有效</PolicyStatus>
					<BenefitMode>一次性给付</BenefitMode>
					<OLifEExtension VendorCode="10">
						<BonusAmnt>0</BonusAmnt>
					</OLifEExtension>
				</Policy>
				<FinancialActivity>
					<FinActivityGrossAmt>
						<xsl:value-of
							select="PubContInfo/FinActivityGrossAmt" />
					</FinActivityGrossAmt>
				</FinancialActivity>
			</Holding>
			<EntrustFlag>1</EntrustFlag>
		</OLifE>
	</xsl:template>
</xsl:stylesheet>