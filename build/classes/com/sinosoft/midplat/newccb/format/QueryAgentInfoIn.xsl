<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TX">
	 <TranData>
		<Head>
			<xsl:copy-of select="Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="APP_ENTITY">
	<ABAgent> <!--- 非必填 -->
		<Name><xsl:value-of select="Ins_Co_Acrdt_Stff_Nm" /></Name> <!--- 驻点员姓名 非必填 -->
		<!--- 驻点员证件类型 0身份证 非必填 -->
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Crdt_No" /></IDNo> <!--- 驻点员证件号码 非必填 -->
	</ABAgent>
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

</xsl:stylesheet>
