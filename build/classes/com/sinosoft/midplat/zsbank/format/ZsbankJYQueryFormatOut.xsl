<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<Body>
			<xsl:apply-templates select="Body"/>
			</Body>
		</TranData>
	</xsl:template>
	<xsl:template name="Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">	
		
		<!-- 保险单号 -->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- 投保人姓名 -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- 投保人证件类型 -->
		<AppntIDType>
			<xsl:apply-templates select="AppntIDType"/>
		</AppntIDType>
  		<!-- 投保人证件号 -->
  		<AppntIDNo>
  			<xsl:value-of select="AppntIDNo"/>
  		</AppntIDNo>
  		<!-- 保费 -->
  		<ActSumPrem>
  			<xsl:value-of select="ActSumPrem"/>
  		</ActSumPrem>
  		<!-- 最大可贷款额 -->
  		<MaxLoanMoney>
  			<xsl:value-of select="MaxLoanMoney"/>
  		</MaxLoanMoney>
	</xsl:template>
	
	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="AppntIDType">
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
