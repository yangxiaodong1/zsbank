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
						select="count(//Detail[Column[5]='1013'])" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[Column[5]='1013']/Column[8]))" />
				</Prem>
				<xsl:for-each
					select="//Detail[Column[5]='1013']">
					<!-- 对账文件格式： 银行编号（10位）＋ 交易日期（10位）＋区域代码（10位）＋网点代码（10位）＋对账交易码（4位）
					      ＋ 应对账银行交易流水号（30位）＋保单号（20位）＋金额（12位，带小数点）＋销售渠道（2位） -->
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="Column[2]" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="concat(Column[3], Column[4])" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[6]" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="Column[7]" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[8])" />
						</Prem>
						<!--  核心：交易渠道：0-柜面，1-网银，8自助终端（目前工行有区分，其它银行暂未区分） -->
						<!-- 银行：销售渠道：枚举值：0-柜面 1-网银 -->
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[9]" />
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
			<xsl:when test="$sourceType='005'">0</xsl:when> <!-- 柜面 -->
			<xsl:when test="$sourceType='010'">1</xsl:when> <!-- 网银 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>