<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
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
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>


	<xsl:template name="Body" match="Policy">
		<ContNo>
			<xsl:value-of select="PolNumber" />
		</ContNo><!-- 保险单号码 --><!--必填项 -->
		<ContNoPSW></ContNoPSW><!-- 保单密码 -->
		<RiskCode>
			<xsl:apply-templates select="ProductCode" /><!-- 产品代码 -->
		</RiskCode><!-- 保险产品代码 （主险） -->
		<EdorAppDate>
			<xsl:value-of
				select="java:com.sinosoft.midplat.common.DateUtil.date10to8(../../../TransExeDate)" />
		</EdorAppDate><!-- 申请日期[yyyyMMdd] --><!--必填项 -->
		<CertifyCode></CertifyCode><!-- 批单印刷号 --><!-- 非必填项 -->
		<!-- 投保人 -->
		<xsl:variable name="AppntPartyID"
			select="../../Relation[RelationRoleCode='80']/@RelatedObjectID" />
		<xsl:variable name="AppntPartyNode" select="../../Party[@id=$AppntPartyID]" />
		<AppntIDType>
			<xsl:apply-templates select="$AppntPartyNode/GovtIDTC" />
		</AppntIDType>
		<AppntIDNo>
			<xsl:value-of select="$AppntPartyNode/GovtID" />
		</AppntIDNo>
		<AppntName>
			<xsl:value-of select="$AppntPartyNode/FullName" />
		</AppntName>
		<!-- 投保人 -->
		<xsl:variable name="InsuredPartyID"
			select="../../Relation[RelationRoleCode='81']/@RelatedObjectID" />
		<xsl:variable name="InsuredPartyNode" select="../../Party[@id=$InsuredPartyID]" />
		<InsuredIDType>
			<xsl:apply-templates select="$InsuredPartyNode/GovtIDTC" />
		</InsuredIDType>
		<InsuredIDNo>
			<xsl:value-of select="$InsuredPartyNode/GovtID" />
		</InsuredIDNo>
		<InsuredName>
			<xsl:value-of select="$InsuredPartyNode/FullName" />
		</InsuredName>
	</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_RiskCode" match="ProductCode">
<xsl:choose>
	<xsl:when test=".=001">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
	<xsl:when test=".=002">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test=".=101">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test=".=003">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	<xsl:when test=".=004">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test=".=005">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test=".=006">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
	<xsl:when test=".=007">122011</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）  -->
	<xsl:when test=".=008">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
	<xsl:when test=".=009">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 证件类型 -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=0">0</xsl:when>	<!-- 身份证 -->
	<xsl:when test=".=1">1</xsl:when>	<!-- 护照 -->
	<xsl:when test=".=2">2</xsl:when>	<!-- 军官证 -->
	<xsl:when test=".=3">2</xsl:when>	<!-- 士兵证 -->
	<xsl:when test=".=5">0</xsl:when>	<!-- 临时身份证 -->
	<xsl:when test=".=6">5</xsl:when>	<!-- 户口本  -->
	<xsl:when test=".=9">2</xsl:when>	<!-- 警官证  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>


	

