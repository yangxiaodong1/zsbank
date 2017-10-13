<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<Count>
					<xsl:value-of select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!--  交易日期（8位数字格式YYYYMMDD，不能为空） -->
						<TranDate>
							<xsl:value-of select="Column[1]" />
						</TranDate>
						<!--  银行网点代码  (省市代码+网点码)-->
						<NodeNo>
							<xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  试算申请流水号  -->
						<TranNo>
							<xsl:value-of select="Column[3]" />
						</TranNo>
						<!--  投保单号  -->
						<ProposalPrtNo>
							<xsl:value-of select="Column[7]" />
						</ProposalPrtNo>
						<!-- 首期保费账户 -->
						<AccNo>
							<xsl:value-of select="Column[5]" />
						</AccNo>
						<!-- 投保人姓名 -->
						<AppntName>
							<xsl:value-of select="Column[9]" />
						</AppntName>
						<!-- 投保人证件类型 -->
						<AppntIDType></AppntIDType>
						<!-- 证件号码 -->
						<AppntIDNo></AppntIDNo>
						<!-- 交易渠道（预留） -->
						<SourceType>0</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>