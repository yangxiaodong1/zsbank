<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<xsl:apply-templates select="//OLifE/Holding/Policy" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="OLifEExtension/BankCode" />
			</BankCode>
			 
		</Head>
	</xsl:template>



	<!--  保单信息 -->
	<xsl:template name="Body" match="Policy">

		<!-- 悔单信息 -->
		<ContNo>
			<xsl:value-of select="PolNumber" />
		</ContNo>
		<EdorAppDate>
			<xsl:value-of
				select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		</EdorAppDate>
		<EdorAppNo></EdorAppNo>
		<!-- 总保费/交易金额  -->
		<TranMoney>
			<xsl:value-of select="//Life/GrossPremAmtITD" />
		</TranMoney>
		<EdorType></EdorType>
		<OldLogNo>
			<xsl:value-of select="//OLifEExtension/Cortransrno" />
		</OldLogNo>


	</xsl:template>



</xsl:stylesheet>





