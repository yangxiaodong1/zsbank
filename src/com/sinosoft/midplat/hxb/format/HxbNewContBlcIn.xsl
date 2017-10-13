<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/DOCUMENT">
		<TranData>
			<!-- 报文体 -->
			<Body>
				<!-- 成功的新契约交易 -->
				<Count>
					<xsl:value-of select="HEAD/TRANSCOUNTS" />
				</Count>
				<!-- 总保费，银行单位：元，核心单位：分 -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(HEAD/TRANSAMOUNTS)" />
				</Prem>
				<xsl:for-each select="BODY/DETAIL">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="TRANSACTIONDATE" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="ZONENO"/><xsl:value-of select="BRANCHCODE"/>
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="APPTRANSRNO"/>
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="INSURNO" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>