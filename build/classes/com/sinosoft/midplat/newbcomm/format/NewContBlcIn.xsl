<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- 报文体 -->
			<Body>
				<!-- 成功的新契约交易 -->
				<Count>
					<xsl:value-of
						select="count(//Detail[LineNum !='0'])" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[LineNum !='0']/Column[23]))" />
				</Prem>
				<!-- 去掉首行：首行为汇总行 -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="Column[5]" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="Column[14]" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[23])" />
						</Prem>
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[24]" />
							</xsl:call-template>
						</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- 渠道 -->
	<xsl:template name="tran_sourceType">
		<xsl:param name="sourceType" />
		<xsl:choose>
			<xsl:when test="$sourceType='00'">0</xsl:when> <!-- 柜面 -->
			<xsl:when test="$sourceType='21'">1</xsl:when> <!-- 网银 -->
			<xsl:when test="$sourceType='51'">17</xsl:when> <!-- 手机银行 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>