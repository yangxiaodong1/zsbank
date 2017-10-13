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
					<xsl:value-of select="count(//Detail[Column[9]='P'])" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[Column[9]='P']/Column[7]))" />
				</Prem>
				<xsl:for-each select="//Detail[Column[9]='P']">
					<!-- 对账文件格式：银行编号（比如24）＋交易日期（YYYYMMDD）＋分行代码（4位）＋交易机构（4位）
					 + 新单承保交易流水号（20位）＋保单号（20位）＋金额（12位，带小数点，以元为单位，2位小数）＋销售渠道（2位）+ 交易状态(正常件：P、撤单：R0) -->
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="Column[2]" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[5]" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="Column[6]" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[7])" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>