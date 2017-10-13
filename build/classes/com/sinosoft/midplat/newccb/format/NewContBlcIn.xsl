<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- 新契约对账 -->
	<TranData>
		<!-- 报文头 -->
		<xsl:copy-of select="TranData/Head" />
		
		<Body>
			<Count>
				<xsl:value-of select="count(//DetailList/Detail[ORG_TX_ID!='P53819144'])"/>
				<!--
				<xsl:value-of select="count(//DetailList/Detail)"/>
				-->
			</Count>
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//DetailList/Detail[ORG_TX_ID!='P53819144']/TxnAmt))"/>
			 	<!--
			 	<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//DetailList/Detail/TxnAmt))"/>
			 	-->
			</Prem>
			<!-- 只映射新单（包括非实时，由核心区分实时非实时）的保单 -->
			<xsl:apply-templates select="//DetailList/Detail[ORG_TX_ID!='P53819144']"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="Detail">
	<Detail>
		<!-- 
		<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Txn_Dt)"/></TranDate>
		-->
		<TranDate><xsl:value-of select="Txn_Dt"/></TranDate>
		<NodeNo><xsl:value-of select="CCBIns_ID" /></NodeNo>
		<TranNo><xsl:value-of select="RqPtTcNum"/></TranNo>
		<ContNo><xsl:value-of select="InsPolcy_No"/></ContNo>
		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TxnAmt)"/></Prem>
		<!-- 交易渠道：0-柜面，1-网银，8自助终端,默认为0，健行过来的对账报文不区分，需要处理 -->
		<SourceType>0</SourceType>
	</Detail>
</xsl:template>

</xsl:stylesheet>