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
						select="count(CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1'])" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of
						select="sum(CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1']/INSU_IN)" />
				</Prem>
				<xsl:for-each select="CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1']">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="TRSDATE" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="ZONE" /><xsl:value-of select="DEPT" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="TRANS" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
						    <xsl:value-of select="java:com.sinosoft.midplat.shbank.format.Shbank_TransForm.proPosalNOToPolicyNO(APPNO)" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of select="INSU_IN" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>