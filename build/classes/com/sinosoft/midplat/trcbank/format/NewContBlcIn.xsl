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
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[LineNum !='0']/Column[5]))" />
				</Prem>
				<!-- 去掉首行：首行为汇总行 -->
				<!-- 保单号（20位）|银行流水号（16位）|交易日期（8位）|交易时间（6位）|交易金额（算小数点精确到分16位）|地区代码（6位）|网点代码（4位）|备注（100位）| -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="Column[3]" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[6]" /><xsl:value-of select="Column[7]" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[2]" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="Column[1]" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[5])" />
						</Prem>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	
</xsl:stylesheet>