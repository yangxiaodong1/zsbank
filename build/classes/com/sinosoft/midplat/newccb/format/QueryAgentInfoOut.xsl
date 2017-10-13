<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">
	<!-- 循环记录条数 -->
	<Rvl_Rcrd_Num><xsl:value-of select="count(ABAgent)" /></Rvl_Rcrd_Num>
	<InsCoAcrdtStff_List>
		<xsl:for-each select="ABAgent">
			<InsCoAcrdtStff_Detail>
				<Ins_Co_Acrdt_Stff_Nm><xsl:value-of select="Name" /></Ins_Co_Acrdt_Stff_Nm>
				<Crdt_TpCd>
					<xsl:call-template name="tran_IDType">
						<xsl:with-param name="idtype" select="IDType" />
					</xsl:call-template>
				</Crdt_TpCd>
				<Crdt_No><xsl:value-of select="IDNo" /></Crdt_No>
				<Move_TelNo><xsl:value-of select="Mobile" /></Move_TelNo>
				<Fix_TelNo><xsl:value-of select="Phone" /></Fix_TelNo>
				<Email_Adr><xsl:value-of select="Email " /></Email_Adr>
			</InsCoAcrdtStff_Detail>
		</xsl:for-each>
	</InsCoAcrdtStff_List>
	
</xsl:template>


<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- 户口簿 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

