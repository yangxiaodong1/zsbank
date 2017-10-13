<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<Body>
				<Detail>
					<!-- ���� -->
					<Column><xsl:value-of select="TranData/Body/Count"/></Column>
					<Column><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(TranData/Body/Detail/ActPrem))"/></Column>
					<!-- ���� -->
					<Column><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()"/></Column>
				</Detail>
				<xsl:for-each select="TranData/Body/Detail">
					<Detail>
						<!--Ͷ������-->
						<Column>
							<xsl:value-of select="ProposalPrtNo" />
						</Column>
						<!--�˱�����-->
						<Column>
							<xsl:apply-templates select="UWResult" mode="uwresult" />
						</Column>
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</Column>
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(Amnt))" />
						</Column>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<!-- �˱����� -->
	<xsl:template  match="UWResult" mode="uwresult">
		<xsl:choose>
			<xsl:when test=".='9'">A</xsl:when><!-- ����б� -->
			<xsl:when test=".='1'">B</xsl:when><!-- �ܱ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
