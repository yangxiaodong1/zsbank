<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
			<SourceType>
				<xsl:apply-templates select="TX/TX_BODY/ENTITY/COM_ENTITY/TXN_ITT_CHNL_CGY_CODE" />
			</SourceType>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	<Name><xsl:value-of select="Plchd_Nm" /></Name> <!--- 客户姓名 必填--> 
	<IDType>
		<xsl:call-template name="tran_IDType">
			<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
		</xsl:call-template>
	</IDType> <!--- 客户证件类型 必填-->
	<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo> <!--- 证件号码必填--> 
	<ClientType>1</ClientType><!--- 1投保人, 2 被保人, 投保人或被保人 必填-->
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo><!--- 保单号 可空-->
	<!--- 两个时间必须在一年之内-->
	<QueryStartDate>
		<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(QRY_START_DT)" />
	</QueryStartDate> <!--- 查询开始时间-->
	<QueryEndDate>
		<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(QRY_END_DT)" />
	</QueryEndDate><!--- 查询截止时间-->
</xsl:template>


<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- 户口簿 -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- 异常身份证 -->
		<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>
<!-- 银行保单销售渠道: 10010003=企业网银，10010001=个人网银，10010002=私人银行网上银行 10030006：手机银行-->
	<xsl:template match="TXN_ITT_CHNL_CGY_CODE">
		<xsl:choose>
			<xsl:when test=".='10010003'">1</xsl:when><!-- 企业网银:网银 -->
			<xsl:when test=".='10010001'">1</xsl:when><!-- 个人网银:网银 -->
			<xsl:when test=".='10010002'">1</xsl:when><!-- 私人银行网上银行:网银 -->
			<xsl:when test=".='10030006'">17</xsl:when><!-- 手机银行 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
