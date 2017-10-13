<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/DAYCHECK">
		<TranData>
			<!-- 报文体 -->
			<Body>
				<!-- 成功的新契约交易 -->
				<Count>
					<xsl:value-of
						select="sum(//DAYCHECK_TOTS/DAYCHECK_TOT/TOT_PIECE)" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of
						select="sum(//DAYCHECK_TOTS/DAYCHECK_TOT/TOT_PREMIUM)" />
				</Prem>
				<xsl:for-each
					select="//DAYCHECK_DETAILS/DAYCHECK_DETAIL">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="java:com.sinosoft.midplat.cgb.format.Cgb_TransForm.get8Date(OREVDATE)" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="concat(Column[3], Column[4])" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="TRANSRNO" />
						</TranNo>
						<!--  保险合同号/保单号  -->
						<ContNo>
							<xsl:value-of select="INSURNO" />
						</ContNo>
						<!--  交易实收金额 -->
						<Prem>
							<xsl:value-of select="PREMIUM" />
						</Prem>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>