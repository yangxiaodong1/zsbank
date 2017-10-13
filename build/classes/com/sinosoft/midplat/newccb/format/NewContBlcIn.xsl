<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- ����Լ���� -->
	<TranData>
		<!-- ����ͷ -->
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
			<!-- ֻӳ���µ���������ʵʱ���ɺ�������ʵʱ��ʵʱ���ı��� -->
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
		<!-- ����������0-���棬1-������8�����ն�,Ĭ��Ϊ0�����й����Ķ��˱��Ĳ����֣���Ҫ���� -->
		<SourceType>0</SourceType>
	</Detail>
</xsl:template>

</xsl:stylesheet>