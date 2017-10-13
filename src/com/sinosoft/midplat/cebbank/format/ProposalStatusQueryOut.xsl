<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 文件的一条记录 -->
	<xsl:template match="Detail">
		<Detail>
			<!-- 暂时取当日日期 -->
			<QueryDate></QueryDate>
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<ContState>
				<xsl:apply-templates select="ContState" />
			</ContState>
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<SignDate>
				<xsl:value-of select="SignDate" />
			</SignDate>
			<AppntName>
				<xsl:value-of select="AppntName" />
			</AppntName>
			<ActPrem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
			</ActPrem>
			<Payintv>
				<xsl:apply-templates select="Payintv" />
			</Payintv>
			<PayEndYear>
				<xsl:choose>
					<xsl:when test="Payintv = 0">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
				</xsl:choose>
			</PayEndYear>
		</Detail>
	</xsl:template>


	<!-- 保单状态 -->
	<!-- 光大状态：0 未知 4 有效 A犹退  E正常退保 F期满 -->
	<!-- 核心状态：00:保单有效,01:满期终止,02:退保终止,04:理赔终止,WT:犹豫期退保终止,A:拒保,B:待签单, -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when>
			<xsl:when test=".='00'">4</xsl:when>
			<xsl:when test=".='WT'">A</xsl:when>
			<xsl:when test=".='02'">E</xsl:when>
			<xsl:when test=".='B'">0</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费间隔  -->
	<xsl:template match="Payintv">
		<xsl:choose>
			<xsl:when test=".='0'">5</xsl:when>
			<xsl:when test=".='12'">1</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
