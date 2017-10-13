<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="DAYCHECK">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*"/>
			</Head>
			<Body>
				<Count>
					<xsl:value-of
						select="count(DAYCHECK_DETAILS/DAYCHECK_DETAIL)" />
				</Count>
				<!-- 总保费（分） -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(DAYCHECK_DETAILS/DAYCHECK_DETAIL/PREMIUM))" />
				</Prem>           
				<xsl:for-each select="DAYCHECK_DETAILS/DAYCHECK_DETAIL">
					<Detail> 
						<TranDate>
							<xsl:value-of select="OREVDATE" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="ZONENO" /><xsl:value-of select="BRNO" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="TRANSRNO" />
						</TranNo>
						<!--  保险合同号/保单号，已确认，给保单号  -->
						<ContNo>
							<xsl:value-of select="INSURNO" />
						</ContNo>
						<!--   实交金额-->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" />
						</Prem>
						<!-- 销售渠道-->
						<SourceType>0</SourceType>
					</Detail>
				</xsl:for-each>
				
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>